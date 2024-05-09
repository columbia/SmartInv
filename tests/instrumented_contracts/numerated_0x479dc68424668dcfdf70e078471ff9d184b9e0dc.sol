1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File hardhat/console.sol@v2.9.3
4 
5 pragma solidity >=0.4.22 <0.9.0;
6 
7 library console {
8     address constant CONSOLE_ADDRESS =
9         address(0x000000000000000000636F6e736F6c652e6c6f67);
10 
11     function _sendLogPayload(bytes memory payload) private view {
12         uint256 payloadLength = payload.length;
13         address consoleAddress = CONSOLE_ADDRESS;
14         assembly {
15             let payloadStart := add(payload, 32)
16             let r := staticcall(
17                 gas(),
18                 consoleAddress,
19                 payloadStart,
20                 payloadLength,
21                 0,
22                 0
23             )
24         }
25     }
26 
27     function log() internal view {
28         _sendLogPayload(abi.encodeWithSignature("log()"));
29     }
30 
31     function logInt(int256 p0) internal view {
32         _sendLogPayload(abi.encodeWithSignature("log(int)", p0));
33     }
34 
35     function logUint(uint256 p0) internal view {
36         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
37     }
38 
39     function logString(string memory p0) internal view {
40         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
41     }
42 
43     function logBool(bool p0) internal view {
44         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
45     }
46 
47     function logAddress(address p0) internal view {
48         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
49     }
50 
51     function logBytes(bytes memory p0) internal view {
52         _sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
53     }
54 
55     function logBytes1(bytes1 p0) internal view {
56         _sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
57     }
58 
59     function logBytes2(bytes2 p0) internal view {
60         _sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
61     }
62 
63     function logBytes3(bytes3 p0) internal view {
64         _sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
65     }
66 
67     function logBytes4(bytes4 p0) internal view {
68         _sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
69     }
70 
71     function logBytes5(bytes5 p0) internal view {
72         _sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
73     }
74 
75     function logBytes6(bytes6 p0) internal view {
76         _sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
77     }
78 
79     function logBytes7(bytes7 p0) internal view {
80         _sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
81     }
82 
83     function logBytes8(bytes8 p0) internal view {
84         _sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
85     }
86 
87     function logBytes9(bytes9 p0) internal view {
88         _sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
89     }
90 
91     function logBytes10(bytes10 p0) internal view {
92         _sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
93     }
94 
95     function logBytes11(bytes11 p0) internal view {
96         _sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
97     }
98 
99     function logBytes12(bytes12 p0) internal view {
100         _sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
101     }
102 
103     function logBytes13(bytes13 p0) internal view {
104         _sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
105     }
106 
107     function logBytes14(bytes14 p0) internal view {
108         _sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
109     }
110 
111     function logBytes15(bytes15 p0) internal view {
112         _sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
113     }
114 
115     function logBytes16(bytes16 p0) internal view {
116         _sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
117     }
118 
119     function logBytes17(bytes17 p0) internal view {
120         _sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
121     }
122 
123     function logBytes18(bytes18 p0) internal view {
124         _sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
125     }
126 
127     function logBytes19(bytes19 p0) internal view {
128         _sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
129     }
130 
131     function logBytes20(bytes20 p0) internal view {
132         _sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
133     }
134 
135     function logBytes21(bytes21 p0) internal view {
136         _sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
137     }
138 
139     function logBytes22(bytes22 p0) internal view {
140         _sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
141     }
142 
143     function logBytes23(bytes23 p0) internal view {
144         _sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
145     }
146 
147     function logBytes24(bytes24 p0) internal view {
148         _sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
149     }
150 
151     function logBytes25(bytes25 p0) internal view {
152         _sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
153     }
154 
155     function logBytes26(bytes26 p0) internal view {
156         _sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
157     }
158 
159     function logBytes27(bytes27 p0) internal view {
160         _sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
161     }
162 
163     function logBytes28(bytes28 p0) internal view {
164         _sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
165     }
166 
167     function logBytes29(bytes29 p0) internal view {
168         _sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
169     }
170 
171     function logBytes30(bytes30 p0) internal view {
172         _sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
173     }
174 
175     function logBytes31(bytes31 p0) internal view {
176         _sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
177     }
178 
179     function logBytes32(bytes32 p0) internal view {
180         _sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
181     }
182 
183     function log(uint256 p0) internal view {
184         _sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
185     }
186 
187     function log(string memory p0) internal view {
188         _sendLogPayload(abi.encodeWithSignature("log(string)", p0));
189     }
190 
191     function log(bool p0) internal view {
192         _sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
193     }
194 
195     function log(address p0) internal view {
196         _sendLogPayload(abi.encodeWithSignature("log(address)", p0));
197     }
198 
199     function log(uint256 p0, uint256 p1) internal view {
200         _sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
201     }
202 
203     function log(uint256 p0, string memory p1) internal view {
204         _sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
205     }
206 
207     function log(uint256 p0, bool p1) internal view {
208         _sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
209     }
210 
211     function log(uint256 p0, address p1) internal view {
212         _sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
213     }
214 
215     function log(string memory p0, uint256 p1) internal view {
216         _sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
217     }
218 
219     function log(string memory p0, string memory p1) internal view {
220         _sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
221     }
222 
223     function log(string memory p0, bool p1) internal view {
224         _sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
225     }
226 
227     function log(string memory p0, address p1) internal view {
228         _sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
229     }
230 
231     function log(bool p0, uint256 p1) internal view {
232         _sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
233     }
234 
235     function log(bool p0, string memory p1) internal view {
236         _sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
237     }
238 
239     function log(bool p0, bool p1) internal view {
240         _sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
241     }
242 
243     function log(bool p0, address p1) internal view {
244         _sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
245     }
246 
247     function log(address p0, uint256 p1) internal view {
248         _sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
249     }
250 
251     function log(address p0, string memory p1) internal view {
252         _sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
253     }
254 
255     function log(address p0, bool p1) internal view {
256         _sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
257     }
258 
259     function log(address p0, address p1) internal view {
260         _sendLogPayload(
261             abi.encodeWithSignature("log(address,address)", p0, p1)
262         );
263     }
264 
265     function log(
266         uint256 p0,
267         uint256 p1,
268         uint256 p2
269     ) internal view {
270         _sendLogPayload(
271             abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2)
272         );
273     }
274 
275     function log(
276         uint256 p0,
277         uint256 p1,
278         string memory p2
279     ) internal view {
280         _sendLogPayload(
281             abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2)
282         );
283     }
284 
285     function log(
286         uint256 p0,
287         uint256 p1,
288         bool p2
289     ) internal view {
290         _sendLogPayload(
291             abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2)
292         );
293     }
294 
295     function log(
296         uint256 p0,
297         uint256 p1,
298         address p2
299     ) internal view {
300         _sendLogPayload(
301             abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2)
302         );
303     }
304 
305     function log(
306         uint256 p0,
307         string memory p1,
308         uint256 p2
309     ) internal view {
310         _sendLogPayload(
311             abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2)
312         );
313     }
314 
315     function log(
316         uint256 p0,
317         string memory p1,
318         string memory p2
319     ) internal view {
320         _sendLogPayload(
321             abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2)
322         );
323     }
324 
325     function log(
326         uint256 p0,
327         string memory p1,
328         bool p2
329     ) internal view {
330         _sendLogPayload(
331             abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2)
332         );
333     }
334 
335     function log(
336         uint256 p0,
337         string memory p1,
338         address p2
339     ) internal view {
340         _sendLogPayload(
341             abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2)
342         );
343     }
344 
345     function log(
346         uint256 p0,
347         bool p1,
348         uint256 p2
349     ) internal view {
350         _sendLogPayload(
351             abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2)
352         );
353     }
354 
355     function log(
356         uint256 p0,
357         bool p1,
358         string memory p2
359     ) internal view {
360         _sendLogPayload(
361             abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2)
362         );
363     }
364 
365     function log(
366         uint256 p0,
367         bool p1,
368         bool p2
369     ) internal view {
370         _sendLogPayload(
371             abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2)
372         );
373     }
374 
375     function log(
376         uint256 p0,
377         bool p1,
378         address p2
379     ) internal view {
380         _sendLogPayload(
381             abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2)
382         );
383     }
384 
385     function log(
386         uint256 p0,
387         address p1,
388         uint256 p2
389     ) internal view {
390         _sendLogPayload(
391             abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2)
392         );
393     }
394 
395     function log(
396         uint256 p0,
397         address p1,
398         string memory p2
399     ) internal view {
400         _sendLogPayload(
401             abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2)
402         );
403     }
404 
405     function log(
406         uint256 p0,
407         address p1,
408         bool p2
409     ) internal view {
410         _sendLogPayload(
411             abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2)
412         );
413     }
414 
415     function log(
416         uint256 p0,
417         address p1,
418         address p2
419     ) internal view {
420         _sendLogPayload(
421             abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2)
422         );
423     }
424 
425     function log(
426         string memory p0,
427         uint256 p1,
428         uint256 p2
429     ) internal view {
430         _sendLogPayload(
431             abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2)
432         );
433     }
434 
435     function log(
436         string memory p0,
437         uint256 p1,
438         string memory p2
439     ) internal view {
440         _sendLogPayload(
441             abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2)
442         );
443     }
444 
445     function log(
446         string memory p0,
447         uint256 p1,
448         bool p2
449     ) internal view {
450         _sendLogPayload(
451             abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2)
452         );
453     }
454 
455     function log(
456         string memory p0,
457         uint256 p1,
458         address p2
459     ) internal view {
460         _sendLogPayload(
461             abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2)
462         );
463     }
464 
465     function log(
466         string memory p0,
467         string memory p1,
468         uint256 p2
469     ) internal view {
470         _sendLogPayload(
471             abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2)
472         );
473     }
474 
475     function log(
476         string memory p0,
477         string memory p1,
478         string memory p2
479     ) internal view {
480         _sendLogPayload(
481             abi.encodeWithSignature("log(string,string,string)", p0, p1, p2)
482         );
483     }
484 
485     function log(
486         string memory p0,
487         string memory p1,
488         bool p2
489     ) internal view {
490         _sendLogPayload(
491             abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2)
492         );
493     }
494 
495     function log(
496         string memory p0,
497         string memory p1,
498         address p2
499     ) internal view {
500         _sendLogPayload(
501             abi.encodeWithSignature("log(string,string,address)", p0, p1, p2)
502         );
503     }
504 
505     function log(
506         string memory p0,
507         bool p1,
508         uint256 p2
509     ) internal view {
510         _sendLogPayload(
511             abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2)
512         );
513     }
514 
515     function log(
516         string memory p0,
517         bool p1,
518         string memory p2
519     ) internal view {
520         _sendLogPayload(
521             abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2)
522         );
523     }
524 
525     function log(
526         string memory p0,
527         bool p1,
528         bool p2
529     ) internal view {
530         _sendLogPayload(
531             abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2)
532         );
533     }
534 
535     function log(
536         string memory p0,
537         bool p1,
538         address p2
539     ) internal view {
540         _sendLogPayload(
541             abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2)
542         );
543     }
544 
545     function log(
546         string memory p0,
547         address p1,
548         uint256 p2
549     ) internal view {
550         _sendLogPayload(
551             abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2)
552         );
553     }
554 
555     function log(
556         string memory p0,
557         address p1,
558         string memory p2
559     ) internal view {
560         _sendLogPayload(
561             abi.encodeWithSignature("log(string,address,string)", p0, p1, p2)
562         );
563     }
564 
565     function log(
566         string memory p0,
567         address p1,
568         bool p2
569     ) internal view {
570         _sendLogPayload(
571             abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2)
572         );
573     }
574 
575     function log(
576         string memory p0,
577         address p1,
578         address p2
579     ) internal view {
580         _sendLogPayload(
581             abi.encodeWithSignature("log(string,address,address)", p0, p1, p2)
582         );
583     }
584 
585     function log(
586         bool p0,
587         uint256 p1,
588         uint256 p2
589     ) internal view {
590         _sendLogPayload(
591             abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2)
592         );
593     }
594 
595     function log(
596         bool p0,
597         uint256 p1,
598         string memory p2
599     ) internal view {
600         _sendLogPayload(
601             abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2)
602         );
603     }
604 
605     function log(
606         bool p0,
607         uint256 p1,
608         bool p2
609     ) internal view {
610         _sendLogPayload(
611             abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2)
612         );
613     }
614 
615     function log(
616         bool p0,
617         uint256 p1,
618         address p2
619     ) internal view {
620         _sendLogPayload(
621             abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2)
622         );
623     }
624 
625     function log(
626         bool p0,
627         string memory p1,
628         uint256 p2
629     ) internal view {
630         _sendLogPayload(
631             abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2)
632         );
633     }
634 
635     function log(
636         bool p0,
637         string memory p1,
638         string memory p2
639     ) internal view {
640         _sendLogPayload(
641             abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2)
642         );
643     }
644 
645     function log(
646         bool p0,
647         string memory p1,
648         bool p2
649     ) internal view {
650         _sendLogPayload(
651             abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2)
652         );
653     }
654 
655     function log(
656         bool p0,
657         string memory p1,
658         address p2
659     ) internal view {
660         _sendLogPayload(
661             abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2)
662         );
663     }
664 
665     function log(
666         bool p0,
667         bool p1,
668         uint256 p2
669     ) internal view {
670         _sendLogPayload(
671             abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2)
672         );
673     }
674 
675     function log(
676         bool p0,
677         bool p1,
678         string memory p2
679     ) internal view {
680         _sendLogPayload(
681             abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2)
682         );
683     }
684 
685     function log(
686         bool p0,
687         bool p1,
688         bool p2
689     ) internal view {
690         _sendLogPayload(
691             abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2)
692         );
693     }
694 
695     function log(
696         bool p0,
697         bool p1,
698         address p2
699     ) internal view {
700         _sendLogPayload(
701             abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2)
702         );
703     }
704 
705     function log(
706         bool p0,
707         address p1,
708         uint256 p2
709     ) internal view {
710         _sendLogPayload(
711             abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2)
712         );
713     }
714 
715     function log(
716         bool p0,
717         address p1,
718         string memory p2
719     ) internal view {
720         _sendLogPayload(
721             abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2)
722         );
723     }
724 
725     function log(
726         bool p0,
727         address p1,
728         bool p2
729     ) internal view {
730         _sendLogPayload(
731             abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2)
732         );
733     }
734 
735     function log(
736         bool p0,
737         address p1,
738         address p2
739     ) internal view {
740         _sendLogPayload(
741             abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2)
742         );
743     }
744 
745     function log(
746         address p0,
747         uint256 p1,
748         uint256 p2
749     ) internal view {
750         _sendLogPayload(
751             abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2)
752         );
753     }
754 
755     function log(
756         address p0,
757         uint256 p1,
758         string memory p2
759     ) internal view {
760         _sendLogPayload(
761             abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2)
762         );
763     }
764 
765     function log(
766         address p0,
767         uint256 p1,
768         bool p2
769     ) internal view {
770         _sendLogPayload(
771             abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2)
772         );
773     }
774 
775     function log(
776         address p0,
777         uint256 p1,
778         address p2
779     ) internal view {
780         _sendLogPayload(
781             abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2)
782         );
783     }
784 
785     function log(
786         address p0,
787         string memory p1,
788         uint256 p2
789     ) internal view {
790         _sendLogPayload(
791             abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2)
792         );
793     }
794 
795     function log(
796         address p0,
797         string memory p1,
798         string memory p2
799     ) internal view {
800         _sendLogPayload(
801             abi.encodeWithSignature("log(address,string,string)", p0, p1, p2)
802         );
803     }
804 
805     function log(
806         address p0,
807         string memory p1,
808         bool p2
809     ) internal view {
810         _sendLogPayload(
811             abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2)
812         );
813     }
814 
815     function log(
816         address p0,
817         string memory p1,
818         address p2
819     ) internal view {
820         _sendLogPayload(
821             abi.encodeWithSignature("log(address,string,address)", p0, p1, p2)
822         );
823     }
824 
825     function log(
826         address p0,
827         bool p1,
828         uint256 p2
829     ) internal view {
830         _sendLogPayload(
831             abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2)
832         );
833     }
834 
835     function log(
836         address p0,
837         bool p1,
838         string memory p2
839     ) internal view {
840         _sendLogPayload(
841             abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2)
842         );
843     }
844 
845     function log(
846         address p0,
847         bool p1,
848         bool p2
849     ) internal view {
850         _sendLogPayload(
851             abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2)
852         );
853     }
854 
855     function log(
856         address p0,
857         bool p1,
858         address p2
859     ) internal view {
860         _sendLogPayload(
861             abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2)
862         );
863     }
864 
865     function log(
866         address p0,
867         address p1,
868         uint256 p2
869     ) internal view {
870         _sendLogPayload(
871             abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2)
872         );
873     }
874 
875     function log(
876         address p0,
877         address p1,
878         string memory p2
879     ) internal view {
880         _sendLogPayload(
881             abi.encodeWithSignature("log(address,address,string)", p0, p1, p2)
882         );
883     }
884 
885     function log(
886         address p0,
887         address p1,
888         bool p2
889     ) internal view {
890         _sendLogPayload(
891             abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2)
892         );
893     }
894 
895     function log(
896         address p0,
897         address p1,
898         address p2
899     ) internal view {
900         _sendLogPayload(
901             abi.encodeWithSignature("log(address,address,address)", p0, p1, p2)
902         );
903     }
904 
905     function log(
906         uint256 p0,
907         uint256 p1,
908         uint256 p2,
909         uint256 p3
910     ) internal view {
911         _sendLogPayload(
912             abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3)
913         );
914     }
915 
916     function log(
917         uint256 p0,
918         uint256 p1,
919         uint256 p2,
920         string memory p3
921     ) internal view {
922         _sendLogPayload(
923             abi.encodeWithSignature(
924                 "log(uint,uint,uint,string)",
925                 p0,
926                 p1,
927                 p2,
928                 p3
929             )
930         );
931     }
932 
933     function log(
934         uint256 p0,
935         uint256 p1,
936         uint256 p2,
937         bool p3
938     ) internal view {
939         _sendLogPayload(
940             abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3)
941         );
942     }
943 
944     function log(
945         uint256 p0,
946         uint256 p1,
947         uint256 p2,
948         address p3
949     ) internal view {
950         _sendLogPayload(
951             abi.encodeWithSignature(
952                 "log(uint,uint,uint,address)",
953                 p0,
954                 p1,
955                 p2,
956                 p3
957             )
958         );
959     }
960 
961     function log(
962         uint256 p0,
963         uint256 p1,
964         string memory p2,
965         uint256 p3
966     ) internal view {
967         _sendLogPayload(
968             abi.encodeWithSignature(
969                 "log(uint,uint,string,uint)",
970                 p0,
971                 p1,
972                 p2,
973                 p3
974             )
975         );
976     }
977 
978     function log(
979         uint256 p0,
980         uint256 p1,
981         string memory p2,
982         string memory p3
983     ) internal view {
984         _sendLogPayload(
985             abi.encodeWithSignature(
986                 "log(uint,uint,string,string)",
987                 p0,
988                 p1,
989                 p2,
990                 p3
991             )
992         );
993     }
994 
995     function log(
996         uint256 p0,
997         uint256 p1,
998         string memory p2,
999         bool p3
1000     ) internal view {
1001         _sendLogPayload(
1002             abi.encodeWithSignature(
1003                 "log(uint,uint,string,bool)",
1004                 p0,
1005                 p1,
1006                 p2,
1007                 p3
1008             )
1009         );
1010     }
1011 
1012     function log(
1013         uint256 p0,
1014         uint256 p1,
1015         string memory p2,
1016         address p3
1017     ) internal view {
1018         _sendLogPayload(
1019             abi.encodeWithSignature(
1020                 "log(uint,uint,string,address)",
1021                 p0,
1022                 p1,
1023                 p2,
1024                 p3
1025             )
1026         );
1027     }
1028 
1029     function log(
1030         uint256 p0,
1031         uint256 p1,
1032         bool p2,
1033         uint256 p3
1034     ) internal view {
1035         _sendLogPayload(
1036             abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3)
1037         );
1038     }
1039 
1040     function log(
1041         uint256 p0,
1042         uint256 p1,
1043         bool p2,
1044         string memory p3
1045     ) internal view {
1046         _sendLogPayload(
1047             abi.encodeWithSignature(
1048                 "log(uint,uint,bool,string)",
1049                 p0,
1050                 p1,
1051                 p2,
1052                 p3
1053             )
1054         );
1055     }
1056 
1057     function log(
1058         uint256 p0,
1059         uint256 p1,
1060         bool p2,
1061         bool p3
1062     ) internal view {
1063         _sendLogPayload(
1064             abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3)
1065         );
1066     }
1067 
1068     function log(
1069         uint256 p0,
1070         uint256 p1,
1071         bool p2,
1072         address p3
1073     ) internal view {
1074         _sendLogPayload(
1075             abi.encodeWithSignature(
1076                 "log(uint,uint,bool,address)",
1077                 p0,
1078                 p1,
1079                 p2,
1080                 p3
1081             )
1082         );
1083     }
1084 
1085     function log(
1086         uint256 p0,
1087         uint256 p1,
1088         address p2,
1089         uint256 p3
1090     ) internal view {
1091         _sendLogPayload(
1092             abi.encodeWithSignature(
1093                 "log(uint,uint,address,uint)",
1094                 p0,
1095                 p1,
1096                 p2,
1097                 p3
1098             )
1099         );
1100     }
1101 
1102     function log(
1103         uint256 p0,
1104         uint256 p1,
1105         address p2,
1106         string memory p3
1107     ) internal view {
1108         _sendLogPayload(
1109             abi.encodeWithSignature(
1110                 "log(uint,uint,address,string)",
1111                 p0,
1112                 p1,
1113                 p2,
1114                 p3
1115             )
1116         );
1117     }
1118 
1119     function log(
1120         uint256 p0,
1121         uint256 p1,
1122         address p2,
1123         bool p3
1124     ) internal view {
1125         _sendLogPayload(
1126             abi.encodeWithSignature(
1127                 "log(uint,uint,address,bool)",
1128                 p0,
1129                 p1,
1130                 p2,
1131                 p3
1132             )
1133         );
1134     }
1135 
1136     function log(
1137         uint256 p0,
1138         uint256 p1,
1139         address p2,
1140         address p3
1141     ) internal view {
1142         _sendLogPayload(
1143             abi.encodeWithSignature(
1144                 "log(uint,uint,address,address)",
1145                 p0,
1146                 p1,
1147                 p2,
1148                 p3
1149             )
1150         );
1151     }
1152 
1153     function log(
1154         uint256 p0,
1155         string memory p1,
1156         uint256 p2,
1157         uint256 p3
1158     ) internal view {
1159         _sendLogPayload(
1160             abi.encodeWithSignature(
1161                 "log(uint,string,uint,uint)",
1162                 p0,
1163                 p1,
1164                 p2,
1165                 p3
1166             )
1167         );
1168     }
1169 
1170     function log(
1171         uint256 p0,
1172         string memory p1,
1173         uint256 p2,
1174         string memory p3
1175     ) internal view {
1176         _sendLogPayload(
1177             abi.encodeWithSignature(
1178                 "log(uint,string,uint,string)",
1179                 p0,
1180                 p1,
1181                 p2,
1182                 p3
1183             )
1184         );
1185     }
1186 
1187     function log(
1188         uint256 p0,
1189         string memory p1,
1190         uint256 p2,
1191         bool p3
1192     ) internal view {
1193         _sendLogPayload(
1194             abi.encodeWithSignature(
1195                 "log(uint,string,uint,bool)",
1196                 p0,
1197                 p1,
1198                 p2,
1199                 p3
1200             )
1201         );
1202     }
1203 
1204     function log(
1205         uint256 p0,
1206         string memory p1,
1207         uint256 p2,
1208         address p3
1209     ) internal view {
1210         _sendLogPayload(
1211             abi.encodeWithSignature(
1212                 "log(uint,string,uint,address)",
1213                 p0,
1214                 p1,
1215                 p2,
1216                 p3
1217             )
1218         );
1219     }
1220 
1221     function log(
1222         uint256 p0,
1223         string memory p1,
1224         string memory p2,
1225         uint256 p3
1226     ) internal view {
1227         _sendLogPayload(
1228             abi.encodeWithSignature(
1229                 "log(uint,string,string,uint)",
1230                 p0,
1231                 p1,
1232                 p2,
1233                 p3
1234             )
1235         );
1236     }
1237 
1238     function log(
1239         uint256 p0,
1240         string memory p1,
1241         string memory p2,
1242         string memory p3
1243     ) internal view {
1244         _sendLogPayload(
1245             abi.encodeWithSignature(
1246                 "log(uint,string,string,string)",
1247                 p0,
1248                 p1,
1249                 p2,
1250                 p3
1251             )
1252         );
1253     }
1254 
1255     function log(
1256         uint256 p0,
1257         string memory p1,
1258         string memory p2,
1259         bool p3
1260     ) internal view {
1261         _sendLogPayload(
1262             abi.encodeWithSignature(
1263                 "log(uint,string,string,bool)",
1264                 p0,
1265                 p1,
1266                 p2,
1267                 p3
1268             )
1269         );
1270     }
1271 
1272     function log(
1273         uint256 p0,
1274         string memory p1,
1275         string memory p2,
1276         address p3
1277     ) internal view {
1278         _sendLogPayload(
1279             abi.encodeWithSignature(
1280                 "log(uint,string,string,address)",
1281                 p0,
1282                 p1,
1283                 p2,
1284                 p3
1285             )
1286         );
1287     }
1288 
1289     function log(
1290         uint256 p0,
1291         string memory p1,
1292         bool p2,
1293         uint256 p3
1294     ) internal view {
1295         _sendLogPayload(
1296             abi.encodeWithSignature(
1297                 "log(uint,string,bool,uint)",
1298                 p0,
1299                 p1,
1300                 p2,
1301                 p3
1302             )
1303         );
1304     }
1305 
1306     function log(
1307         uint256 p0,
1308         string memory p1,
1309         bool p2,
1310         string memory p3
1311     ) internal view {
1312         _sendLogPayload(
1313             abi.encodeWithSignature(
1314                 "log(uint,string,bool,string)",
1315                 p0,
1316                 p1,
1317                 p2,
1318                 p3
1319             )
1320         );
1321     }
1322 
1323     function log(
1324         uint256 p0,
1325         string memory p1,
1326         bool p2,
1327         bool p3
1328     ) internal view {
1329         _sendLogPayload(
1330             abi.encodeWithSignature(
1331                 "log(uint,string,bool,bool)",
1332                 p0,
1333                 p1,
1334                 p2,
1335                 p3
1336             )
1337         );
1338     }
1339 
1340     function log(
1341         uint256 p0,
1342         string memory p1,
1343         bool p2,
1344         address p3
1345     ) internal view {
1346         _sendLogPayload(
1347             abi.encodeWithSignature(
1348                 "log(uint,string,bool,address)",
1349                 p0,
1350                 p1,
1351                 p2,
1352                 p3
1353             )
1354         );
1355     }
1356 
1357     function log(
1358         uint256 p0,
1359         string memory p1,
1360         address p2,
1361         uint256 p3
1362     ) internal view {
1363         _sendLogPayload(
1364             abi.encodeWithSignature(
1365                 "log(uint,string,address,uint)",
1366                 p0,
1367                 p1,
1368                 p2,
1369                 p3
1370             )
1371         );
1372     }
1373 
1374     function log(
1375         uint256 p0,
1376         string memory p1,
1377         address p2,
1378         string memory p3
1379     ) internal view {
1380         _sendLogPayload(
1381             abi.encodeWithSignature(
1382                 "log(uint,string,address,string)",
1383                 p0,
1384                 p1,
1385                 p2,
1386                 p3
1387             )
1388         );
1389     }
1390 
1391     function log(
1392         uint256 p0,
1393         string memory p1,
1394         address p2,
1395         bool p3
1396     ) internal view {
1397         _sendLogPayload(
1398             abi.encodeWithSignature(
1399                 "log(uint,string,address,bool)",
1400                 p0,
1401                 p1,
1402                 p2,
1403                 p3
1404             )
1405         );
1406     }
1407 
1408     function log(
1409         uint256 p0,
1410         string memory p1,
1411         address p2,
1412         address p3
1413     ) internal view {
1414         _sendLogPayload(
1415             abi.encodeWithSignature(
1416                 "log(uint,string,address,address)",
1417                 p0,
1418                 p1,
1419                 p2,
1420                 p3
1421             )
1422         );
1423     }
1424 
1425     function log(
1426         uint256 p0,
1427         bool p1,
1428         uint256 p2,
1429         uint256 p3
1430     ) internal view {
1431         _sendLogPayload(
1432             abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3)
1433         );
1434     }
1435 
1436     function log(
1437         uint256 p0,
1438         bool p1,
1439         uint256 p2,
1440         string memory p3
1441     ) internal view {
1442         _sendLogPayload(
1443             abi.encodeWithSignature(
1444                 "log(uint,bool,uint,string)",
1445                 p0,
1446                 p1,
1447                 p2,
1448                 p3
1449             )
1450         );
1451     }
1452 
1453     function log(
1454         uint256 p0,
1455         bool p1,
1456         uint256 p2,
1457         bool p3
1458     ) internal view {
1459         _sendLogPayload(
1460             abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3)
1461         );
1462     }
1463 
1464     function log(
1465         uint256 p0,
1466         bool p1,
1467         uint256 p2,
1468         address p3
1469     ) internal view {
1470         _sendLogPayload(
1471             abi.encodeWithSignature(
1472                 "log(uint,bool,uint,address)",
1473                 p0,
1474                 p1,
1475                 p2,
1476                 p3
1477             )
1478         );
1479     }
1480 
1481     function log(
1482         uint256 p0,
1483         bool p1,
1484         string memory p2,
1485         uint256 p3
1486     ) internal view {
1487         _sendLogPayload(
1488             abi.encodeWithSignature(
1489                 "log(uint,bool,string,uint)",
1490                 p0,
1491                 p1,
1492                 p2,
1493                 p3
1494             )
1495         );
1496     }
1497 
1498     function log(
1499         uint256 p0,
1500         bool p1,
1501         string memory p2,
1502         string memory p3
1503     ) internal view {
1504         _sendLogPayload(
1505             abi.encodeWithSignature(
1506                 "log(uint,bool,string,string)",
1507                 p0,
1508                 p1,
1509                 p2,
1510                 p3
1511             )
1512         );
1513     }
1514 
1515     function log(
1516         uint256 p0,
1517         bool p1,
1518         string memory p2,
1519         bool p3
1520     ) internal view {
1521         _sendLogPayload(
1522             abi.encodeWithSignature(
1523                 "log(uint,bool,string,bool)",
1524                 p0,
1525                 p1,
1526                 p2,
1527                 p3
1528             )
1529         );
1530     }
1531 
1532     function log(
1533         uint256 p0,
1534         bool p1,
1535         string memory p2,
1536         address p3
1537     ) internal view {
1538         _sendLogPayload(
1539             abi.encodeWithSignature(
1540                 "log(uint,bool,string,address)",
1541                 p0,
1542                 p1,
1543                 p2,
1544                 p3
1545             )
1546         );
1547     }
1548 
1549     function log(
1550         uint256 p0,
1551         bool p1,
1552         bool p2,
1553         uint256 p3
1554     ) internal view {
1555         _sendLogPayload(
1556             abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3)
1557         );
1558     }
1559 
1560     function log(
1561         uint256 p0,
1562         bool p1,
1563         bool p2,
1564         string memory p3
1565     ) internal view {
1566         _sendLogPayload(
1567             abi.encodeWithSignature(
1568                 "log(uint,bool,bool,string)",
1569                 p0,
1570                 p1,
1571                 p2,
1572                 p3
1573             )
1574         );
1575     }
1576 
1577     function log(
1578         uint256 p0,
1579         bool p1,
1580         bool p2,
1581         bool p3
1582     ) internal view {
1583         _sendLogPayload(
1584             abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3)
1585         );
1586     }
1587 
1588     function log(
1589         uint256 p0,
1590         bool p1,
1591         bool p2,
1592         address p3
1593     ) internal view {
1594         _sendLogPayload(
1595             abi.encodeWithSignature(
1596                 "log(uint,bool,bool,address)",
1597                 p0,
1598                 p1,
1599                 p2,
1600                 p3
1601             )
1602         );
1603     }
1604 
1605     function log(
1606         uint256 p0,
1607         bool p1,
1608         address p2,
1609         uint256 p3
1610     ) internal view {
1611         _sendLogPayload(
1612             abi.encodeWithSignature(
1613                 "log(uint,bool,address,uint)",
1614                 p0,
1615                 p1,
1616                 p2,
1617                 p3
1618             )
1619         );
1620     }
1621 
1622     function log(
1623         uint256 p0,
1624         bool p1,
1625         address p2,
1626         string memory p3
1627     ) internal view {
1628         _sendLogPayload(
1629             abi.encodeWithSignature(
1630                 "log(uint,bool,address,string)",
1631                 p0,
1632                 p1,
1633                 p2,
1634                 p3
1635             )
1636         );
1637     }
1638 
1639     function log(
1640         uint256 p0,
1641         bool p1,
1642         address p2,
1643         bool p3
1644     ) internal view {
1645         _sendLogPayload(
1646             abi.encodeWithSignature(
1647                 "log(uint,bool,address,bool)",
1648                 p0,
1649                 p1,
1650                 p2,
1651                 p3
1652             )
1653         );
1654     }
1655 
1656     function log(
1657         uint256 p0,
1658         bool p1,
1659         address p2,
1660         address p3
1661     ) internal view {
1662         _sendLogPayload(
1663             abi.encodeWithSignature(
1664                 "log(uint,bool,address,address)",
1665                 p0,
1666                 p1,
1667                 p2,
1668                 p3
1669             )
1670         );
1671     }
1672 
1673     function log(
1674         uint256 p0,
1675         address p1,
1676         uint256 p2,
1677         uint256 p3
1678     ) internal view {
1679         _sendLogPayload(
1680             abi.encodeWithSignature(
1681                 "log(uint,address,uint,uint)",
1682                 p0,
1683                 p1,
1684                 p2,
1685                 p3
1686             )
1687         );
1688     }
1689 
1690     function log(
1691         uint256 p0,
1692         address p1,
1693         uint256 p2,
1694         string memory p3
1695     ) internal view {
1696         _sendLogPayload(
1697             abi.encodeWithSignature(
1698                 "log(uint,address,uint,string)",
1699                 p0,
1700                 p1,
1701                 p2,
1702                 p3
1703             )
1704         );
1705     }
1706 
1707     function log(
1708         uint256 p0,
1709         address p1,
1710         uint256 p2,
1711         bool p3
1712     ) internal view {
1713         _sendLogPayload(
1714             abi.encodeWithSignature(
1715                 "log(uint,address,uint,bool)",
1716                 p0,
1717                 p1,
1718                 p2,
1719                 p3
1720             )
1721         );
1722     }
1723 
1724     function log(
1725         uint256 p0,
1726         address p1,
1727         uint256 p2,
1728         address p3
1729     ) internal view {
1730         _sendLogPayload(
1731             abi.encodeWithSignature(
1732                 "log(uint,address,uint,address)",
1733                 p0,
1734                 p1,
1735                 p2,
1736                 p3
1737             )
1738         );
1739     }
1740 
1741     function log(
1742         uint256 p0,
1743         address p1,
1744         string memory p2,
1745         uint256 p3
1746     ) internal view {
1747         _sendLogPayload(
1748             abi.encodeWithSignature(
1749                 "log(uint,address,string,uint)",
1750                 p0,
1751                 p1,
1752                 p2,
1753                 p3
1754             )
1755         );
1756     }
1757 
1758     function log(
1759         uint256 p0,
1760         address p1,
1761         string memory p2,
1762         string memory p3
1763     ) internal view {
1764         _sendLogPayload(
1765             abi.encodeWithSignature(
1766                 "log(uint,address,string,string)",
1767                 p0,
1768                 p1,
1769                 p2,
1770                 p3
1771             )
1772         );
1773     }
1774 
1775     function log(
1776         uint256 p0,
1777         address p1,
1778         string memory p2,
1779         bool p3
1780     ) internal view {
1781         _sendLogPayload(
1782             abi.encodeWithSignature(
1783                 "log(uint,address,string,bool)",
1784                 p0,
1785                 p1,
1786                 p2,
1787                 p3
1788             )
1789         );
1790     }
1791 
1792     function log(
1793         uint256 p0,
1794         address p1,
1795         string memory p2,
1796         address p3
1797     ) internal view {
1798         _sendLogPayload(
1799             abi.encodeWithSignature(
1800                 "log(uint,address,string,address)",
1801                 p0,
1802                 p1,
1803                 p2,
1804                 p3
1805             )
1806         );
1807     }
1808 
1809     function log(
1810         uint256 p0,
1811         address p1,
1812         bool p2,
1813         uint256 p3
1814     ) internal view {
1815         _sendLogPayload(
1816             abi.encodeWithSignature(
1817                 "log(uint,address,bool,uint)",
1818                 p0,
1819                 p1,
1820                 p2,
1821                 p3
1822             )
1823         );
1824     }
1825 
1826     function log(
1827         uint256 p0,
1828         address p1,
1829         bool p2,
1830         string memory p3
1831     ) internal view {
1832         _sendLogPayload(
1833             abi.encodeWithSignature(
1834                 "log(uint,address,bool,string)",
1835                 p0,
1836                 p1,
1837                 p2,
1838                 p3
1839             )
1840         );
1841     }
1842 
1843     function log(
1844         uint256 p0,
1845         address p1,
1846         bool p2,
1847         bool p3
1848     ) internal view {
1849         _sendLogPayload(
1850             abi.encodeWithSignature(
1851                 "log(uint,address,bool,bool)",
1852                 p0,
1853                 p1,
1854                 p2,
1855                 p3
1856             )
1857         );
1858     }
1859 
1860     function log(
1861         uint256 p0,
1862         address p1,
1863         bool p2,
1864         address p3
1865     ) internal view {
1866         _sendLogPayload(
1867             abi.encodeWithSignature(
1868                 "log(uint,address,bool,address)",
1869                 p0,
1870                 p1,
1871                 p2,
1872                 p3
1873             )
1874         );
1875     }
1876 
1877     function log(
1878         uint256 p0,
1879         address p1,
1880         address p2,
1881         uint256 p3
1882     ) internal view {
1883         _sendLogPayload(
1884             abi.encodeWithSignature(
1885                 "log(uint,address,address,uint)",
1886                 p0,
1887                 p1,
1888                 p2,
1889                 p3
1890             )
1891         );
1892     }
1893 
1894     function log(
1895         uint256 p0,
1896         address p1,
1897         address p2,
1898         string memory p3
1899     ) internal view {
1900         _sendLogPayload(
1901             abi.encodeWithSignature(
1902                 "log(uint,address,address,string)",
1903                 p0,
1904                 p1,
1905                 p2,
1906                 p3
1907             )
1908         );
1909     }
1910 
1911     function log(
1912         uint256 p0,
1913         address p1,
1914         address p2,
1915         bool p3
1916     ) internal view {
1917         _sendLogPayload(
1918             abi.encodeWithSignature(
1919                 "log(uint,address,address,bool)",
1920                 p0,
1921                 p1,
1922                 p2,
1923                 p3
1924             )
1925         );
1926     }
1927 
1928     function log(
1929         uint256 p0,
1930         address p1,
1931         address p2,
1932         address p3
1933     ) internal view {
1934         _sendLogPayload(
1935             abi.encodeWithSignature(
1936                 "log(uint,address,address,address)",
1937                 p0,
1938                 p1,
1939                 p2,
1940                 p3
1941             )
1942         );
1943     }
1944 
1945     function log(
1946         string memory p0,
1947         uint256 p1,
1948         uint256 p2,
1949         uint256 p3
1950     ) internal view {
1951         _sendLogPayload(
1952             abi.encodeWithSignature(
1953                 "log(string,uint,uint,uint)",
1954                 p0,
1955                 p1,
1956                 p2,
1957                 p3
1958             )
1959         );
1960     }
1961 
1962     function log(
1963         string memory p0,
1964         uint256 p1,
1965         uint256 p2,
1966         string memory p3
1967     ) internal view {
1968         _sendLogPayload(
1969             abi.encodeWithSignature(
1970                 "log(string,uint,uint,string)",
1971                 p0,
1972                 p1,
1973                 p2,
1974                 p3
1975             )
1976         );
1977     }
1978 
1979     function log(
1980         string memory p0,
1981         uint256 p1,
1982         uint256 p2,
1983         bool p3
1984     ) internal view {
1985         _sendLogPayload(
1986             abi.encodeWithSignature(
1987                 "log(string,uint,uint,bool)",
1988                 p0,
1989                 p1,
1990                 p2,
1991                 p3
1992             )
1993         );
1994     }
1995 
1996     function log(
1997         string memory p0,
1998         uint256 p1,
1999         uint256 p2,
2000         address p3
2001     ) internal view {
2002         _sendLogPayload(
2003             abi.encodeWithSignature(
2004                 "log(string,uint,uint,address)",
2005                 p0,
2006                 p1,
2007                 p2,
2008                 p3
2009             )
2010         );
2011     }
2012 
2013     function log(
2014         string memory p0,
2015         uint256 p1,
2016         string memory p2,
2017         uint256 p3
2018     ) internal view {
2019         _sendLogPayload(
2020             abi.encodeWithSignature(
2021                 "log(string,uint,string,uint)",
2022                 p0,
2023                 p1,
2024                 p2,
2025                 p3
2026             )
2027         );
2028     }
2029 
2030     function log(
2031         string memory p0,
2032         uint256 p1,
2033         string memory p2,
2034         string memory p3
2035     ) internal view {
2036         _sendLogPayload(
2037             abi.encodeWithSignature(
2038                 "log(string,uint,string,string)",
2039                 p0,
2040                 p1,
2041                 p2,
2042                 p3
2043             )
2044         );
2045     }
2046 
2047     function log(
2048         string memory p0,
2049         uint256 p1,
2050         string memory p2,
2051         bool p3
2052     ) internal view {
2053         _sendLogPayload(
2054             abi.encodeWithSignature(
2055                 "log(string,uint,string,bool)",
2056                 p0,
2057                 p1,
2058                 p2,
2059                 p3
2060             )
2061         );
2062     }
2063 
2064     function log(
2065         string memory p0,
2066         uint256 p1,
2067         string memory p2,
2068         address p3
2069     ) internal view {
2070         _sendLogPayload(
2071             abi.encodeWithSignature(
2072                 "log(string,uint,string,address)",
2073                 p0,
2074                 p1,
2075                 p2,
2076                 p3
2077             )
2078         );
2079     }
2080 
2081     function log(
2082         string memory p0,
2083         uint256 p1,
2084         bool p2,
2085         uint256 p3
2086     ) internal view {
2087         _sendLogPayload(
2088             abi.encodeWithSignature(
2089                 "log(string,uint,bool,uint)",
2090                 p0,
2091                 p1,
2092                 p2,
2093                 p3
2094             )
2095         );
2096     }
2097 
2098     function log(
2099         string memory p0,
2100         uint256 p1,
2101         bool p2,
2102         string memory p3
2103     ) internal view {
2104         _sendLogPayload(
2105             abi.encodeWithSignature(
2106                 "log(string,uint,bool,string)",
2107                 p0,
2108                 p1,
2109                 p2,
2110                 p3
2111             )
2112         );
2113     }
2114 
2115     function log(
2116         string memory p0,
2117         uint256 p1,
2118         bool p2,
2119         bool p3
2120     ) internal view {
2121         _sendLogPayload(
2122             abi.encodeWithSignature(
2123                 "log(string,uint,bool,bool)",
2124                 p0,
2125                 p1,
2126                 p2,
2127                 p3
2128             )
2129         );
2130     }
2131 
2132     function log(
2133         string memory p0,
2134         uint256 p1,
2135         bool p2,
2136         address p3
2137     ) internal view {
2138         _sendLogPayload(
2139             abi.encodeWithSignature(
2140                 "log(string,uint,bool,address)",
2141                 p0,
2142                 p1,
2143                 p2,
2144                 p3
2145             )
2146         );
2147     }
2148 
2149     function log(
2150         string memory p0,
2151         uint256 p1,
2152         address p2,
2153         uint256 p3
2154     ) internal view {
2155         _sendLogPayload(
2156             abi.encodeWithSignature(
2157                 "log(string,uint,address,uint)",
2158                 p0,
2159                 p1,
2160                 p2,
2161                 p3
2162             )
2163         );
2164     }
2165 
2166     function log(
2167         string memory p0,
2168         uint256 p1,
2169         address p2,
2170         string memory p3
2171     ) internal view {
2172         _sendLogPayload(
2173             abi.encodeWithSignature(
2174                 "log(string,uint,address,string)",
2175                 p0,
2176                 p1,
2177                 p2,
2178                 p3
2179             )
2180         );
2181     }
2182 
2183     function log(
2184         string memory p0,
2185         uint256 p1,
2186         address p2,
2187         bool p3
2188     ) internal view {
2189         _sendLogPayload(
2190             abi.encodeWithSignature(
2191                 "log(string,uint,address,bool)",
2192                 p0,
2193                 p1,
2194                 p2,
2195                 p3
2196             )
2197         );
2198     }
2199 
2200     function log(
2201         string memory p0,
2202         uint256 p1,
2203         address p2,
2204         address p3
2205     ) internal view {
2206         _sendLogPayload(
2207             abi.encodeWithSignature(
2208                 "log(string,uint,address,address)",
2209                 p0,
2210                 p1,
2211                 p2,
2212                 p3
2213             )
2214         );
2215     }
2216 
2217     function log(
2218         string memory p0,
2219         string memory p1,
2220         uint256 p2,
2221         uint256 p3
2222     ) internal view {
2223         _sendLogPayload(
2224             abi.encodeWithSignature(
2225                 "log(string,string,uint,uint)",
2226                 p0,
2227                 p1,
2228                 p2,
2229                 p3
2230             )
2231         );
2232     }
2233 
2234     function log(
2235         string memory p0,
2236         string memory p1,
2237         uint256 p2,
2238         string memory p3
2239     ) internal view {
2240         _sendLogPayload(
2241             abi.encodeWithSignature(
2242                 "log(string,string,uint,string)",
2243                 p0,
2244                 p1,
2245                 p2,
2246                 p3
2247             )
2248         );
2249     }
2250 
2251     function log(
2252         string memory p0,
2253         string memory p1,
2254         uint256 p2,
2255         bool p3
2256     ) internal view {
2257         _sendLogPayload(
2258             abi.encodeWithSignature(
2259                 "log(string,string,uint,bool)",
2260                 p0,
2261                 p1,
2262                 p2,
2263                 p3
2264             )
2265         );
2266     }
2267 
2268     function log(
2269         string memory p0,
2270         string memory p1,
2271         uint256 p2,
2272         address p3
2273     ) internal view {
2274         _sendLogPayload(
2275             abi.encodeWithSignature(
2276                 "log(string,string,uint,address)",
2277                 p0,
2278                 p1,
2279                 p2,
2280                 p3
2281             )
2282         );
2283     }
2284 
2285     function log(
2286         string memory p0,
2287         string memory p1,
2288         string memory p2,
2289         uint256 p3
2290     ) internal view {
2291         _sendLogPayload(
2292             abi.encodeWithSignature(
2293                 "log(string,string,string,uint)",
2294                 p0,
2295                 p1,
2296                 p2,
2297                 p3
2298             )
2299         );
2300     }
2301 
2302     function log(
2303         string memory p0,
2304         string memory p1,
2305         string memory p2,
2306         string memory p3
2307     ) internal view {
2308         _sendLogPayload(
2309             abi.encodeWithSignature(
2310                 "log(string,string,string,string)",
2311                 p0,
2312                 p1,
2313                 p2,
2314                 p3
2315             )
2316         );
2317     }
2318 
2319     function log(
2320         string memory p0,
2321         string memory p1,
2322         string memory p2,
2323         bool p3
2324     ) internal view {
2325         _sendLogPayload(
2326             abi.encodeWithSignature(
2327                 "log(string,string,string,bool)",
2328                 p0,
2329                 p1,
2330                 p2,
2331                 p3
2332             )
2333         );
2334     }
2335 
2336     function log(
2337         string memory p0,
2338         string memory p1,
2339         string memory p2,
2340         address p3
2341     ) internal view {
2342         _sendLogPayload(
2343             abi.encodeWithSignature(
2344                 "log(string,string,string,address)",
2345                 p0,
2346                 p1,
2347                 p2,
2348                 p3
2349             )
2350         );
2351     }
2352 
2353     function log(
2354         string memory p0,
2355         string memory p1,
2356         bool p2,
2357         uint256 p3
2358     ) internal view {
2359         _sendLogPayload(
2360             abi.encodeWithSignature(
2361                 "log(string,string,bool,uint)",
2362                 p0,
2363                 p1,
2364                 p2,
2365                 p3
2366             )
2367         );
2368     }
2369 
2370     function log(
2371         string memory p0,
2372         string memory p1,
2373         bool p2,
2374         string memory p3
2375     ) internal view {
2376         _sendLogPayload(
2377             abi.encodeWithSignature(
2378                 "log(string,string,bool,string)",
2379                 p0,
2380                 p1,
2381                 p2,
2382                 p3
2383             )
2384         );
2385     }
2386 
2387     function log(
2388         string memory p0,
2389         string memory p1,
2390         bool p2,
2391         bool p3
2392     ) internal view {
2393         _sendLogPayload(
2394             abi.encodeWithSignature(
2395                 "log(string,string,bool,bool)",
2396                 p0,
2397                 p1,
2398                 p2,
2399                 p3
2400             )
2401         );
2402     }
2403 
2404     function log(
2405         string memory p0,
2406         string memory p1,
2407         bool p2,
2408         address p3
2409     ) internal view {
2410         _sendLogPayload(
2411             abi.encodeWithSignature(
2412                 "log(string,string,bool,address)",
2413                 p0,
2414                 p1,
2415                 p2,
2416                 p3
2417             )
2418         );
2419     }
2420 
2421     function log(
2422         string memory p0,
2423         string memory p1,
2424         address p2,
2425         uint256 p3
2426     ) internal view {
2427         _sendLogPayload(
2428             abi.encodeWithSignature(
2429                 "log(string,string,address,uint)",
2430                 p0,
2431                 p1,
2432                 p2,
2433                 p3
2434             )
2435         );
2436     }
2437 
2438     function log(
2439         string memory p0,
2440         string memory p1,
2441         address p2,
2442         string memory p3
2443     ) internal view {
2444         _sendLogPayload(
2445             abi.encodeWithSignature(
2446                 "log(string,string,address,string)",
2447                 p0,
2448                 p1,
2449                 p2,
2450                 p3
2451             )
2452         );
2453     }
2454 
2455     function log(
2456         string memory p0,
2457         string memory p1,
2458         address p2,
2459         bool p3
2460     ) internal view {
2461         _sendLogPayload(
2462             abi.encodeWithSignature(
2463                 "log(string,string,address,bool)",
2464                 p0,
2465                 p1,
2466                 p2,
2467                 p3
2468             )
2469         );
2470     }
2471 
2472     function log(
2473         string memory p0,
2474         string memory p1,
2475         address p2,
2476         address p3
2477     ) internal view {
2478         _sendLogPayload(
2479             abi.encodeWithSignature(
2480                 "log(string,string,address,address)",
2481                 p0,
2482                 p1,
2483                 p2,
2484                 p3
2485             )
2486         );
2487     }
2488 
2489     function log(
2490         string memory p0,
2491         bool p1,
2492         uint256 p2,
2493         uint256 p3
2494     ) internal view {
2495         _sendLogPayload(
2496             abi.encodeWithSignature(
2497                 "log(string,bool,uint,uint)",
2498                 p0,
2499                 p1,
2500                 p2,
2501                 p3
2502             )
2503         );
2504     }
2505 
2506     function log(
2507         string memory p0,
2508         bool p1,
2509         uint256 p2,
2510         string memory p3
2511     ) internal view {
2512         _sendLogPayload(
2513             abi.encodeWithSignature(
2514                 "log(string,bool,uint,string)",
2515                 p0,
2516                 p1,
2517                 p2,
2518                 p3
2519             )
2520         );
2521     }
2522 
2523     function log(
2524         string memory p0,
2525         bool p1,
2526         uint256 p2,
2527         bool p3
2528     ) internal view {
2529         _sendLogPayload(
2530             abi.encodeWithSignature(
2531                 "log(string,bool,uint,bool)",
2532                 p0,
2533                 p1,
2534                 p2,
2535                 p3
2536             )
2537         );
2538     }
2539 
2540     function log(
2541         string memory p0,
2542         bool p1,
2543         uint256 p2,
2544         address p3
2545     ) internal view {
2546         _sendLogPayload(
2547             abi.encodeWithSignature(
2548                 "log(string,bool,uint,address)",
2549                 p0,
2550                 p1,
2551                 p2,
2552                 p3
2553             )
2554         );
2555     }
2556 
2557     function log(
2558         string memory p0,
2559         bool p1,
2560         string memory p2,
2561         uint256 p3
2562     ) internal view {
2563         _sendLogPayload(
2564             abi.encodeWithSignature(
2565                 "log(string,bool,string,uint)",
2566                 p0,
2567                 p1,
2568                 p2,
2569                 p3
2570             )
2571         );
2572     }
2573 
2574     function log(
2575         string memory p0,
2576         bool p1,
2577         string memory p2,
2578         string memory p3
2579     ) internal view {
2580         _sendLogPayload(
2581             abi.encodeWithSignature(
2582                 "log(string,bool,string,string)",
2583                 p0,
2584                 p1,
2585                 p2,
2586                 p3
2587             )
2588         );
2589     }
2590 
2591     function log(
2592         string memory p0,
2593         bool p1,
2594         string memory p2,
2595         bool p3
2596     ) internal view {
2597         _sendLogPayload(
2598             abi.encodeWithSignature(
2599                 "log(string,bool,string,bool)",
2600                 p0,
2601                 p1,
2602                 p2,
2603                 p3
2604             )
2605         );
2606     }
2607 
2608     function log(
2609         string memory p0,
2610         bool p1,
2611         string memory p2,
2612         address p3
2613     ) internal view {
2614         _sendLogPayload(
2615             abi.encodeWithSignature(
2616                 "log(string,bool,string,address)",
2617                 p0,
2618                 p1,
2619                 p2,
2620                 p3
2621             )
2622         );
2623     }
2624 
2625     function log(
2626         string memory p0,
2627         bool p1,
2628         bool p2,
2629         uint256 p3
2630     ) internal view {
2631         _sendLogPayload(
2632             abi.encodeWithSignature(
2633                 "log(string,bool,bool,uint)",
2634                 p0,
2635                 p1,
2636                 p2,
2637                 p3
2638             )
2639         );
2640     }
2641 
2642     function log(
2643         string memory p0,
2644         bool p1,
2645         bool p2,
2646         string memory p3
2647     ) internal view {
2648         _sendLogPayload(
2649             abi.encodeWithSignature(
2650                 "log(string,bool,bool,string)",
2651                 p0,
2652                 p1,
2653                 p2,
2654                 p3
2655             )
2656         );
2657     }
2658 
2659     function log(
2660         string memory p0,
2661         bool p1,
2662         bool p2,
2663         bool p3
2664     ) internal view {
2665         _sendLogPayload(
2666             abi.encodeWithSignature(
2667                 "log(string,bool,bool,bool)",
2668                 p0,
2669                 p1,
2670                 p2,
2671                 p3
2672             )
2673         );
2674     }
2675 
2676     function log(
2677         string memory p0,
2678         bool p1,
2679         bool p2,
2680         address p3
2681     ) internal view {
2682         _sendLogPayload(
2683             abi.encodeWithSignature(
2684                 "log(string,bool,bool,address)",
2685                 p0,
2686                 p1,
2687                 p2,
2688                 p3
2689             )
2690         );
2691     }
2692 
2693     function log(
2694         string memory p0,
2695         bool p1,
2696         address p2,
2697         uint256 p3
2698     ) internal view {
2699         _sendLogPayload(
2700             abi.encodeWithSignature(
2701                 "log(string,bool,address,uint)",
2702                 p0,
2703                 p1,
2704                 p2,
2705                 p3
2706             )
2707         );
2708     }
2709 
2710     function log(
2711         string memory p0,
2712         bool p1,
2713         address p2,
2714         string memory p3
2715     ) internal view {
2716         _sendLogPayload(
2717             abi.encodeWithSignature(
2718                 "log(string,bool,address,string)",
2719                 p0,
2720                 p1,
2721                 p2,
2722                 p3
2723             )
2724         );
2725     }
2726 
2727     function log(
2728         string memory p0,
2729         bool p1,
2730         address p2,
2731         bool p3
2732     ) internal view {
2733         _sendLogPayload(
2734             abi.encodeWithSignature(
2735                 "log(string,bool,address,bool)",
2736                 p0,
2737                 p1,
2738                 p2,
2739                 p3
2740             )
2741         );
2742     }
2743 
2744     function log(
2745         string memory p0,
2746         bool p1,
2747         address p2,
2748         address p3
2749     ) internal view {
2750         _sendLogPayload(
2751             abi.encodeWithSignature(
2752                 "log(string,bool,address,address)",
2753                 p0,
2754                 p1,
2755                 p2,
2756                 p3
2757             )
2758         );
2759     }
2760 
2761     function log(
2762         string memory p0,
2763         address p1,
2764         uint256 p2,
2765         uint256 p3
2766     ) internal view {
2767         _sendLogPayload(
2768             abi.encodeWithSignature(
2769                 "log(string,address,uint,uint)",
2770                 p0,
2771                 p1,
2772                 p2,
2773                 p3
2774             )
2775         );
2776     }
2777 
2778     function log(
2779         string memory p0,
2780         address p1,
2781         uint256 p2,
2782         string memory p3
2783     ) internal view {
2784         _sendLogPayload(
2785             abi.encodeWithSignature(
2786                 "log(string,address,uint,string)",
2787                 p0,
2788                 p1,
2789                 p2,
2790                 p3
2791             )
2792         );
2793     }
2794 
2795     function log(
2796         string memory p0,
2797         address p1,
2798         uint256 p2,
2799         bool p3
2800     ) internal view {
2801         _sendLogPayload(
2802             abi.encodeWithSignature(
2803                 "log(string,address,uint,bool)",
2804                 p0,
2805                 p1,
2806                 p2,
2807                 p3
2808             )
2809         );
2810     }
2811 
2812     function log(
2813         string memory p0,
2814         address p1,
2815         uint256 p2,
2816         address p3
2817     ) internal view {
2818         _sendLogPayload(
2819             abi.encodeWithSignature(
2820                 "log(string,address,uint,address)",
2821                 p0,
2822                 p1,
2823                 p2,
2824                 p3
2825             )
2826         );
2827     }
2828 
2829     function log(
2830         string memory p0,
2831         address p1,
2832         string memory p2,
2833         uint256 p3
2834     ) internal view {
2835         _sendLogPayload(
2836             abi.encodeWithSignature(
2837                 "log(string,address,string,uint)",
2838                 p0,
2839                 p1,
2840                 p2,
2841                 p3
2842             )
2843         );
2844     }
2845 
2846     function log(
2847         string memory p0,
2848         address p1,
2849         string memory p2,
2850         string memory p3
2851     ) internal view {
2852         _sendLogPayload(
2853             abi.encodeWithSignature(
2854                 "log(string,address,string,string)",
2855                 p0,
2856                 p1,
2857                 p2,
2858                 p3
2859             )
2860         );
2861     }
2862 
2863     function log(
2864         string memory p0,
2865         address p1,
2866         string memory p2,
2867         bool p3
2868     ) internal view {
2869         _sendLogPayload(
2870             abi.encodeWithSignature(
2871                 "log(string,address,string,bool)",
2872                 p0,
2873                 p1,
2874                 p2,
2875                 p3
2876             )
2877         );
2878     }
2879 
2880     function log(
2881         string memory p0,
2882         address p1,
2883         string memory p2,
2884         address p3
2885     ) internal view {
2886         _sendLogPayload(
2887             abi.encodeWithSignature(
2888                 "log(string,address,string,address)",
2889                 p0,
2890                 p1,
2891                 p2,
2892                 p3
2893             )
2894         );
2895     }
2896 
2897     function log(
2898         string memory p0,
2899         address p1,
2900         bool p2,
2901         uint256 p3
2902     ) internal view {
2903         _sendLogPayload(
2904             abi.encodeWithSignature(
2905                 "log(string,address,bool,uint)",
2906                 p0,
2907                 p1,
2908                 p2,
2909                 p3
2910             )
2911         );
2912     }
2913 
2914     function log(
2915         string memory p0,
2916         address p1,
2917         bool p2,
2918         string memory p3
2919     ) internal view {
2920         _sendLogPayload(
2921             abi.encodeWithSignature(
2922                 "log(string,address,bool,string)",
2923                 p0,
2924                 p1,
2925                 p2,
2926                 p3
2927             )
2928         );
2929     }
2930 
2931     function log(
2932         string memory p0,
2933         address p1,
2934         bool p2,
2935         bool p3
2936     ) internal view {
2937         _sendLogPayload(
2938             abi.encodeWithSignature(
2939                 "log(string,address,bool,bool)",
2940                 p0,
2941                 p1,
2942                 p2,
2943                 p3
2944             )
2945         );
2946     }
2947 
2948     function log(
2949         string memory p0,
2950         address p1,
2951         bool p2,
2952         address p3
2953     ) internal view {
2954         _sendLogPayload(
2955             abi.encodeWithSignature(
2956                 "log(string,address,bool,address)",
2957                 p0,
2958                 p1,
2959                 p2,
2960                 p3
2961             )
2962         );
2963     }
2964 
2965     function log(
2966         string memory p0,
2967         address p1,
2968         address p2,
2969         uint256 p3
2970     ) internal view {
2971         _sendLogPayload(
2972             abi.encodeWithSignature(
2973                 "log(string,address,address,uint)",
2974                 p0,
2975                 p1,
2976                 p2,
2977                 p3
2978             )
2979         );
2980     }
2981 
2982     function log(
2983         string memory p0,
2984         address p1,
2985         address p2,
2986         string memory p3
2987     ) internal view {
2988         _sendLogPayload(
2989             abi.encodeWithSignature(
2990                 "log(string,address,address,string)",
2991                 p0,
2992                 p1,
2993                 p2,
2994                 p3
2995             )
2996         );
2997     }
2998 
2999     function log(
3000         string memory p0,
3001         address p1,
3002         address p2,
3003         bool p3
3004     ) internal view {
3005         _sendLogPayload(
3006             abi.encodeWithSignature(
3007                 "log(string,address,address,bool)",
3008                 p0,
3009                 p1,
3010                 p2,
3011                 p3
3012             )
3013         );
3014     }
3015 
3016     function log(
3017         string memory p0,
3018         address p1,
3019         address p2,
3020         address p3
3021     ) internal view {
3022         _sendLogPayload(
3023             abi.encodeWithSignature(
3024                 "log(string,address,address,address)",
3025                 p0,
3026                 p1,
3027                 p2,
3028                 p3
3029             )
3030         );
3031     }
3032 
3033     function log(
3034         bool p0,
3035         uint256 p1,
3036         uint256 p2,
3037         uint256 p3
3038     ) internal view {
3039         _sendLogPayload(
3040             abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3)
3041         );
3042     }
3043 
3044     function log(
3045         bool p0,
3046         uint256 p1,
3047         uint256 p2,
3048         string memory p3
3049     ) internal view {
3050         _sendLogPayload(
3051             abi.encodeWithSignature(
3052                 "log(bool,uint,uint,string)",
3053                 p0,
3054                 p1,
3055                 p2,
3056                 p3
3057             )
3058         );
3059     }
3060 
3061     function log(
3062         bool p0,
3063         uint256 p1,
3064         uint256 p2,
3065         bool p3
3066     ) internal view {
3067         _sendLogPayload(
3068             abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3)
3069         );
3070     }
3071 
3072     function log(
3073         bool p0,
3074         uint256 p1,
3075         uint256 p2,
3076         address p3
3077     ) internal view {
3078         _sendLogPayload(
3079             abi.encodeWithSignature(
3080                 "log(bool,uint,uint,address)",
3081                 p0,
3082                 p1,
3083                 p2,
3084                 p3
3085             )
3086         );
3087     }
3088 
3089     function log(
3090         bool p0,
3091         uint256 p1,
3092         string memory p2,
3093         uint256 p3
3094     ) internal view {
3095         _sendLogPayload(
3096             abi.encodeWithSignature(
3097                 "log(bool,uint,string,uint)",
3098                 p0,
3099                 p1,
3100                 p2,
3101                 p3
3102             )
3103         );
3104     }
3105 
3106     function log(
3107         bool p0,
3108         uint256 p1,
3109         string memory p2,
3110         string memory p3
3111     ) internal view {
3112         _sendLogPayload(
3113             abi.encodeWithSignature(
3114                 "log(bool,uint,string,string)",
3115                 p0,
3116                 p1,
3117                 p2,
3118                 p3
3119             )
3120         );
3121     }
3122 
3123     function log(
3124         bool p0,
3125         uint256 p1,
3126         string memory p2,
3127         bool p3
3128     ) internal view {
3129         _sendLogPayload(
3130             abi.encodeWithSignature(
3131                 "log(bool,uint,string,bool)",
3132                 p0,
3133                 p1,
3134                 p2,
3135                 p3
3136             )
3137         );
3138     }
3139 
3140     function log(
3141         bool p0,
3142         uint256 p1,
3143         string memory p2,
3144         address p3
3145     ) internal view {
3146         _sendLogPayload(
3147             abi.encodeWithSignature(
3148                 "log(bool,uint,string,address)",
3149                 p0,
3150                 p1,
3151                 p2,
3152                 p3
3153             )
3154         );
3155     }
3156 
3157     function log(
3158         bool p0,
3159         uint256 p1,
3160         bool p2,
3161         uint256 p3
3162     ) internal view {
3163         _sendLogPayload(
3164             abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3)
3165         );
3166     }
3167 
3168     function log(
3169         bool p0,
3170         uint256 p1,
3171         bool p2,
3172         string memory p3
3173     ) internal view {
3174         _sendLogPayload(
3175             abi.encodeWithSignature(
3176                 "log(bool,uint,bool,string)",
3177                 p0,
3178                 p1,
3179                 p2,
3180                 p3
3181             )
3182         );
3183     }
3184 
3185     function log(
3186         bool p0,
3187         uint256 p1,
3188         bool p2,
3189         bool p3
3190     ) internal view {
3191         _sendLogPayload(
3192             abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3)
3193         );
3194     }
3195 
3196     function log(
3197         bool p0,
3198         uint256 p1,
3199         bool p2,
3200         address p3
3201     ) internal view {
3202         _sendLogPayload(
3203             abi.encodeWithSignature(
3204                 "log(bool,uint,bool,address)",
3205                 p0,
3206                 p1,
3207                 p2,
3208                 p3
3209             )
3210         );
3211     }
3212 
3213     function log(
3214         bool p0,
3215         uint256 p1,
3216         address p2,
3217         uint256 p3
3218     ) internal view {
3219         _sendLogPayload(
3220             abi.encodeWithSignature(
3221                 "log(bool,uint,address,uint)",
3222                 p0,
3223                 p1,
3224                 p2,
3225                 p3
3226             )
3227         );
3228     }
3229 
3230     function log(
3231         bool p0,
3232         uint256 p1,
3233         address p2,
3234         string memory p3
3235     ) internal view {
3236         _sendLogPayload(
3237             abi.encodeWithSignature(
3238                 "log(bool,uint,address,string)",
3239                 p0,
3240                 p1,
3241                 p2,
3242                 p3
3243             )
3244         );
3245     }
3246 
3247     function log(
3248         bool p0,
3249         uint256 p1,
3250         address p2,
3251         bool p3
3252     ) internal view {
3253         _sendLogPayload(
3254             abi.encodeWithSignature(
3255                 "log(bool,uint,address,bool)",
3256                 p0,
3257                 p1,
3258                 p2,
3259                 p3
3260             )
3261         );
3262     }
3263 
3264     function log(
3265         bool p0,
3266         uint256 p1,
3267         address p2,
3268         address p3
3269     ) internal view {
3270         _sendLogPayload(
3271             abi.encodeWithSignature(
3272                 "log(bool,uint,address,address)",
3273                 p0,
3274                 p1,
3275                 p2,
3276                 p3
3277             )
3278         );
3279     }
3280 
3281     function log(
3282         bool p0,
3283         string memory p1,
3284         uint256 p2,
3285         uint256 p3
3286     ) internal view {
3287         _sendLogPayload(
3288             abi.encodeWithSignature(
3289                 "log(bool,string,uint,uint)",
3290                 p0,
3291                 p1,
3292                 p2,
3293                 p3
3294             )
3295         );
3296     }
3297 
3298     function log(
3299         bool p0,
3300         string memory p1,
3301         uint256 p2,
3302         string memory p3
3303     ) internal view {
3304         _sendLogPayload(
3305             abi.encodeWithSignature(
3306                 "log(bool,string,uint,string)",
3307                 p0,
3308                 p1,
3309                 p2,
3310                 p3
3311             )
3312         );
3313     }
3314 
3315     function log(
3316         bool p0,
3317         string memory p1,
3318         uint256 p2,
3319         bool p3
3320     ) internal view {
3321         _sendLogPayload(
3322             abi.encodeWithSignature(
3323                 "log(bool,string,uint,bool)",
3324                 p0,
3325                 p1,
3326                 p2,
3327                 p3
3328             )
3329         );
3330     }
3331 
3332     function log(
3333         bool p0,
3334         string memory p1,
3335         uint256 p2,
3336         address p3
3337     ) internal view {
3338         _sendLogPayload(
3339             abi.encodeWithSignature(
3340                 "log(bool,string,uint,address)",
3341                 p0,
3342                 p1,
3343                 p2,
3344                 p3
3345             )
3346         );
3347     }
3348 
3349     function log(
3350         bool p0,
3351         string memory p1,
3352         string memory p2,
3353         uint256 p3
3354     ) internal view {
3355         _sendLogPayload(
3356             abi.encodeWithSignature(
3357                 "log(bool,string,string,uint)",
3358                 p0,
3359                 p1,
3360                 p2,
3361                 p3
3362             )
3363         );
3364     }
3365 
3366     function log(
3367         bool p0,
3368         string memory p1,
3369         string memory p2,
3370         string memory p3
3371     ) internal view {
3372         _sendLogPayload(
3373             abi.encodeWithSignature(
3374                 "log(bool,string,string,string)",
3375                 p0,
3376                 p1,
3377                 p2,
3378                 p3
3379             )
3380         );
3381     }
3382 
3383     function log(
3384         bool p0,
3385         string memory p1,
3386         string memory p2,
3387         bool p3
3388     ) internal view {
3389         _sendLogPayload(
3390             abi.encodeWithSignature(
3391                 "log(bool,string,string,bool)",
3392                 p0,
3393                 p1,
3394                 p2,
3395                 p3
3396             )
3397         );
3398     }
3399 
3400     function log(
3401         bool p0,
3402         string memory p1,
3403         string memory p2,
3404         address p3
3405     ) internal view {
3406         _sendLogPayload(
3407             abi.encodeWithSignature(
3408                 "log(bool,string,string,address)",
3409                 p0,
3410                 p1,
3411                 p2,
3412                 p3
3413             )
3414         );
3415     }
3416 
3417     function log(
3418         bool p0,
3419         string memory p1,
3420         bool p2,
3421         uint256 p3
3422     ) internal view {
3423         _sendLogPayload(
3424             abi.encodeWithSignature(
3425                 "log(bool,string,bool,uint)",
3426                 p0,
3427                 p1,
3428                 p2,
3429                 p3
3430             )
3431         );
3432     }
3433 
3434     function log(
3435         bool p0,
3436         string memory p1,
3437         bool p2,
3438         string memory p3
3439     ) internal view {
3440         _sendLogPayload(
3441             abi.encodeWithSignature(
3442                 "log(bool,string,bool,string)",
3443                 p0,
3444                 p1,
3445                 p2,
3446                 p3
3447             )
3448         );
3449     }
3450 
3451     function log(
3452         bool p0,
3453         string memory p1,
3454         bool p2,
3455         bool p3
3456     ) internal view {
3457         _sendLogPayload(
3458             abi.encodeWithSignature(
3459                 "log(bool,string,bool,bool)",
3460                 p0,
3461                 p1,
3462                 p2,
3463                 p3
3464             )
3465         );
3466     }
3467 
3468     function log(
3469         bool p0,
3470         string memory p1,
3471         bool p2,
3472         address p3
3473     ) internal view {
3474         _sendLogPayload(
3475             abi.encodeWithSignature(
3476                 "log(bool,string,bool,address)",
3477                 p0,
3478                 p1,
3479                 p2,
3480                 p3
3481             )
3482         );
3483     }
3484 
3485     function log(
3486         bool p0,
3487         string memory p1,
3488         address p2,
3489         uint256 p3
3490     ) internal view {
3491         _sendLogPayload(
3492             abi.encodeWithSignature(
3493                 "log(bool,string,address,uint)",
3494                 p0,
3495                 p1,
3496                 p2,
3497                 p3
3498             )
3499         );
3500     }
3501 
3502     function log(
3503         bool p0,
3504         string memory p1,
3505         address p2,
3506         string memory p3
3507     ) internal view {
3508         _sendLogPayload(
3509             abi.encodeWithSignature(
3510                 "log(bool,string,address,string)",
3511                 p0,
3512                 p1,
3513                 p2,
3514                 p3
3515             )
3516         );
3517     }
3518 
3519     function log(
3520         bool p0,
3521         string memory p1,
3522         address p2,
3523         bool p3
3524     ) internal view {
3525         _sendLogPayload(
3526             abi.encodeWithSignature(
3527                 "log(bool,string,address,bool)",
3528                 p0,
3529                 p1,
3530                 p2,
3531                 p3
3532             )
3533         );
3534     }
3535 
3536     function log(
3537         bool p0,
3538         string memory p1,
3539         address p2,
3540         address p3
3541     ) internal view {
3542         _sendLogPayload(
3543             abi.encodeWithSignature(
3544                 "log(bool,string,address,address)",
3545                 p0,
3546                 p1,
3547                 p2,
3548                 p3
3549             )
3550         );
3551     }
3552 
3553     function log(
3554         bool p0,
3555         bool p1,
3556         uint256 p2,
3557         uint256 p3
3558     ) internal view {
3559         _sendLogPayload(
3560             abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3)
3561         );
3562     }
3563 
3564     function log(
3565         bool p0,
3566         bool p1,
3567         uint256 p2,
3568         string memory p3
3569     ) internal view {
3570         _sendLogPayload(
3571             abi.encodeWithSignature(
3572                 "log(bool,bool,uint,string)",
3573                 p0,
3574                 p1,
3575                 p2,
3576                 p3
3577             )
3578         );
3579     }
3580 
3581     function log(
3582         bool p0,
3583         bool p1,
3584         uint256 p2,
3585         bool p3
3586     ) internal view {
3587         _sendLogPayload(
3588             abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3)
3589         );
3590     }
3591 
3592     function log(
3593         bool p0,
3594         bool p1,
3595         uint256 p2,
3596         address p3
3597     ) internal view {
3598         _sendLogPayload(
3599             abi.encodeWithSignature(
3600                 "log(bool,bool,uint,address)",
3601                 p0,
3602                 p1,
3603                 p2,
3604                 p3
3605             )
3606         );
3607     }
3608 
3609     function log(
3610         bool p0,
3611         bool p1,
3612         string memory p2,
3613         uint256 p3
3614     ) internal view {
3615         _sendLogPayload(
3616             abi.encodeWithSignature(
3617                 "log(bool,bool,string,uint)",
3618                 p0,
3619                 p1,
3620                 p2,
3621                 p3
3622             )
3623         );
3624     }
3625 
3626     function log(
3627         bool p0,
3628         bool p1,
3629         string memory p2,
3630         string memory p3
3631     ) internal view {
3632         _sendLogPayload(
3633             abi.encodeWithSignature(
3634                 "log(bool,bool,string,string)",
3635                 p0,
3636                 p1,
3637                 p2,
3638                 p3
3639             )
3640         );
3641     }
3642 
3643     function log(
3644         bool p0,
3645         bool p1,
3646         string memory p2,
3647         bool p3
3648     ) internal view {
3649         _sendLogPayload(
3650             abi.encodeWithSignature(
3651                 "log(bool,bool,string,bool)",
3652                 p0,
3653                 p1,
3654                 p2,
3655                 p3
3656             )
3657         );
3658     }
3659 
3660     function log(
3661         bool p0,
3662         bool p1,
3663         string memory p2,
3664         address p3
3665     ) internal view {
3666         _sendLogPayload(
3667             abi.encodeWithSignature(
3668                 "log(bool,bool,string,address)",
3669                 p0,
3670                 p1,
3671                 p2,
3672                 p3
3673             )
3674         );
3675     }
3676 
3677     function log(
3678         bool p0,
3679         bool p1,
3680         bool p2,
3681         uint256 p3
3682     ) internal view {
3683         _sendLogPayload(
3684             abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3)
3685         );
3686     }
3687 
3688     function log(
3689         bool p0,
3690         bool p1,
3691         bool p2,
3692         string memory p3
3693     ) internal view {
3694         _sendLogPayload(
3695             abi.encodeWithSignature(
3696                 "log(bool,bool,bool,string)",
3697                 p0,
3698                 p1,
3699                 p2,
3700                 p3
3701             )
3702         );
3703     }
3704 
3705     function log(
3706         bool p0,
3707         bool p1,
3708         bool p2,
3709         bool p3
3710     ) internal view {
3711         _sendLogPayload(
3712             abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3)
3713         );
3714     }
3715 
3716     function log(
3717         bool p0,
3718         bool p1,
3719         bool p2,
3720         address p3
3721     ) internal view {
3722         _sendLogPayload(
3723             abi.encodeWithSignature(
3724                 "log(bool,bool,bool,address)",
3725                 p0,
3726                 p1,
3727                 p2,
3728                 p3
3729             )
3730         );
3731     }
3732 
3733     function log(
3734         bool p0,
3735         bool p1,
3736         address p2,
3737         uint256 p3
3738     ) internal view {
3739         _sendLogPayload(
3740             abi.encodeWithSignature(
3741                 "log(bool,bool,address,uint)",
3742                 p0,
3743                 p1,
3744                 p2,
3745                 p3
3746             )
3747         );
3748     }
3749 
3750     function log(
3751         bool p0,
3752         bool p1,
3753         address p2,
3754         string memory p3
3755     ) internal view {
3756         _sendLogPayload(
3757             abi.encodeWithSignature(
3758                 "log(bool,bool,address,string)",
3759                 p0,
3760                 p1,
3761                 p2,
3762                 p3
3763             )
3764         );
3765     }
3766 
3767     function log(
3768         bool p0,
3769         bool p1,
3770         address p2,
3771         bool p3
3772     ) internal view {
3773         _sendLogPayload(
3774             abi.encodeWithSignature(
3775                 "log(bool,bool,address,bool)",
3776                 p0,
3777                 p1,
3778                 p2,
3779                 p3
3780             )
3781         );
3782     }
3783 
3784     function log(
3785         bool p0,
3786         bool p1,
3787         address p2,
3788         address p3
3789     ) internal view {
3790         _sendLogPayload(
3791             abi.encodeWithSignature(
3792                 "log(bool,bool,address,address)",
3793                 p0,
3794                 p1,
3795                 p2,
3796                 p3
3797             )
3798         );
3799     }
3800 
3801     function log(
3802         bool p0,
3803         address p1,
3804         uint256 p2,
3805         uint256 p3
3806     ) internal view {
3807         _sendLogPayload(
3808             abi.encodeWithSignature(
3809                 "log(bool,address,uint,uint)",
3810                 p0,
3811                 p1,
3812                 p2,
3813                 p3
3814             )
3815         );
3816     }
3817 
3818     function log(
3819         bool p0,
3820         address p1,
3821         uint256 p2,
3822         string memory p3
3823     ) internal view {
3824         _sendLogPayload(
3825             abi.encodeWithSignature(
3826                 "log(bool,address,uint,string)",
3827                 p0,
3828                 p1,
3829                 p2,
3830                 p3
3831             )
3832         );
3833     }
3834 
3835     function log(
3836         bool p0,
3837         address p1,
3838         uint256 p2,
3839         bool p3
3840     ) internal view {
3841         _sendLogPayload(
3842             abi.encodeWithSignature(
3843                 "log(bool,address,uint,bool)",
3844                 p0,
3845                 p1,
3846                 p2,
3847                 p3
3848             )
3849         );
3850     }
3851 
3852     function log(
3853         bool p0,
3854         address p1,
3855         uint256 p2,
3856         address p3
3857     ) internal view {
3858         _sendLogPayload(
3859             abi.encodeWithSignature(
3860                 "log(bool,address,uint,address)",
3861                 p0,
3862                 p1,
3863                 p2,
3864                 p3
3865             )
3866         );
3867     }
3868 
3869     function log(
3870         bool p0,
3871         address p1,
3872         string memory p2,
3873         uint256 p3
3874     ) internal view {
3875         _sendLogPayload(
3876             abi.encodeWithSignature(
3877                 "log(bool,address,string,uint)",
3878                 p0,
3879                 p1,
3880                 p2,
3881                 p3
3882             )
3883         );
3884     }
3885 
3886     function log(
3887         bool p0,
3888         address p1,
3889         string memory p2,
3890         string memory p3
3891     ) internal view {
3892         _sendLogPayload(
3893             abi.encodeWithSignature(
3894                 "log(bool,address,string,string)",
3895                 p0,
3896                 p1,
3897                 p2,
3898                 p3
3899             )
3900         );
3901     }
3902 
3903     function log(
3904         bool p0,
3905         address p1,
3906         string memory p2,
3907         bool p3
3908     ) internal view {
3909         _sendLogPayload(
3910             abi.encodeWithSignature(
3911                 "log(bool,address,string,bool)",
3912                 p0,
3913                 p1,
3914                 p2,
3915                 p3
3916             )
3917         );
3918     }
3919 
3920     function log(
3921         bool p0,
3922         address p1,
3923         string memory p2,
3924         address p3
3925     ) internal view {
3926         _sendLogPayload(
3927             abi.encodeWithSignature(
3928                 "log(bool,address,string,address)",
3929                 p0,
3930                 p1,
3931                 p2,
3932                 p3
3933             )
3934         );
3935     }
3936 
3937     function log(
3938         bool p0,
3939         address p1,
3940         bool p2,
3941         uint256 p3
3942     ) internal view {
3943         _sendLogPayload(
3944             abi.encodeWithSignature(
3945                 "log(bool,address,bool,uint)",
3946                 p0,
3947                 p1,
3948                 p2,
3949                 p3
3950             )
3951         );
3952     }
3953 
3954     function log(
3955         bool p0,
3956         address p1,
3957         bool p2,
3958         string memory p3
3959     ) internal view {
3960         _sendLogPayload(
3961             abi.encodeWithSignature(
3962                 "log(bool,address,bool,string)",
3963                 p0,
3964                 p1,
3965                 p2,
3966                 p3
3967             )
3968         );
3969     }
3970 
3971     function log(
3972         bool p0,
3973         address p1,
3974         bool p2,
3975         bool p3
3976     ) internal view {
3977         _sendLogPayload(
3978             abi.encodeWithSignature(
3979                 "log(bool,address,bool,bool)",
3980                 p0,
3981                 p1,
3982                 p2,
3983                 p3
3984             )
3985         );
3986     }
3987 
3988     function log(
3989         bool p0,
3990         address p1,
3991         bool p2,
3992         address p3
3993     ) internal view {
3994         _sendLogPayload(
3995             abi.encodeWithSignature(
3996                 "log(bool,address,bool,address)",
3997                 p0,
3998                 p1,
3999                 p2,
4000                 p3
4001             )
4002         );
4003     }
4004 
4005     function log(
4006         bool p0,
4007         address p1,
4008         address p2,
4009         uint256 p3
4010     ) internal view {
4011         _sendLogPayload(
4012             abi.encodeWithSignature(
4013                 "log(bool,address,address,uint)",
4014                 p0,
4015                 p1,
4016                 p2,
4017                 p3
4018             )
4019         );
4020     }
4021 
4022     function log(
4023         bool p0,
4024         address p1,
4025         address p2,
4026         string memory p3
4027     ) internal view {
4028         _sendLogPayload(
4029             abi.encodeWithSignature(
4030                 "log(bool,address,address,string)",
4031                 p0,
4032                 p1,
4033                 p2,
4034                 p3
4035             )
4036         );
4037     }
4038 
4039     function log(
4040         bool p0,
4041         address p1,
4042         address p2,
4043         bool p3
4044     ) internal view {
4045         _sendLogPayload(
4046             abi.encodeWithSignature(
4047                 "log(bool,address,address,bool)",
4048                 p0,
4049                 p1,
4050                 p2,
4051                 p3
4052             )
4053         );
4054     }
4055 
4056     function log(
4057         bool p0,
4058         address p1,
4059         address p2,
4060         address p3
4061     ) internal view {
4062         _sendLogPayload(
4063             abi.encodeWithSignature(
4064                 "log(bool,address,address,address)",
4065                 p0,
4066                 p1,
4067                 p2,
4068                 p3
4069             )
4070         );
4071     }
4072 
4073     function log(
4074         address p0,
4075         uint256 p1,
4076         uint256 p2,
4077         uint256 p3
4078     ) internal view {
4079         _sendLogPayload(
4080             abi.encodeWithSignature(
4081                 "log(address,uint,uint,uint)",
4082                 p0,
4083                 p1,
4084                 p2,
4085                 p3
4086             )
4087         );
4088     }
4089 
4090     function log(
4091         address p0,
4092         uint256 p1,
4093         uint256 p2,
4094         string memory p3
4095     ) internal view {
4096         _sendLogPayload(
4097             abi.encodeWithSignature(
4098                 "log(address,uint,uint,string)",
4099                 p0,
4100                 p1,
4101                 p2,
4102                 p3
4103             )
4104         );
4105     }
4106 
4107     function log(
4108         address p0,
4109         uint256 p1,
4110         uint256 p2,
4111         bool p3
4112     ) internal view {
4113         _sendLogPayload(
4114             abi.encodeWithSignature(
4115                 "log(address,uint,uint,bool)",
4116                 p0,
4117                 p1,
4118                 p2,
4119                 p3
4120             )
4121         );
4122     }
4123 
4124     function log(
4125         address p0,
4126         uint256 p1,
4127         uint256 p2,
4128         address p3
4129     ) internal view {
4130         _sendLogPayload(
4131             abi.encodeWithSignature(
4132                 "log(address,uint,uint,address)",
4133                 p0,
4134                 p1,
4135                 p2,
4136                 p3
4137             )
4138         );
4139     }
4140 
4141     function log(
4142         address p0,
4143         uint256 p1,
4144         string memory p2,
4145         uint256 p3
4146     ) internal view {
4147         _sendLogPayload(
4148             abi.encodeWithSignature(
4149                 "log(address,uint,string,uint)",
4150                 p0,
4151                 p1,
4152                 p2,
4153                 p3
4154             )
4155         );
4156     }
4157 
4158     function log(
4159         address p0,
4160         uint256 p1,
4161         string memory p2,
4162         string memory p3
4163     ) internal view {
4164         _sendLogPayload(
4165             abi.encodeWithSignature(
4166                 "log(address,uint,string,string)",
4167                 p0,
4168                 p1,
4169                 p2,
4170                 p3
4171             )
4172         );
4173     }
4174 
4175     function log(
4176         address p0,
4177         uint256 p1,
4178         string memory p2,
4179         bool p3
4180     ) internal view {
4181         _sendLogPayload(
4182             abi.encodeWithSignature(
4183                 "log(address,uint,string,bool)",
4184                 p0,
4185                 p1,
4186                 p2,
4187                 p3
4188             )
4189         );
4190     }
4191 
4192     function log(
4193         address p0,
4194         uint256 p1,
4195         string memory p2,
4196         address p3
4197     ) internal view {
4198         _sendLogPayload(
4199             abi.encodeWithSignature(
4200                 "log(address,uint,string,address)",
4201                 p0,
4202                 p1,
4203                 p2,
4204                 p3
4205             )
4206         );
4207     }
4208 
4209     function log(
4210         address p0,
4211         uint256 p1,
4212         bool p2,
4213         uint256 p3
4214     ) internal view {
4215         _sendLogPayload(
4216             abi.encodeWithSignature(
4217                 "log(address,uint,bool,uint)",
4218                 p0,
4219                 p1,
4220                 p2,
4221                 p3
4222             )
4223         );
4224     }
4225 
4226     function log(
4227         address p0,
4228         uint256 p1,
4229         bool p2,
4230         string memory p3
4231     ) internal view {
4232         _sendLogPayload(
4233             abi.encodeWithSignature(
4234                 "log(address,uint,bool,string)",
4235                 p0,
4236                 p1,
4237                 p2,
4238                 p3
4239             )
4240         );
4241     }
4242 
4243     function log(
4244         address p0,
4245         uint256 p1,
4246         bool p2,
4247         bool p3
4248     ) internal view {
4249         _sendLogPayload(
4250             abi.encodeWithSignature(
4251                 "log(address,uint,bool,bool)",
4252                 p0,
4253                 p1,
4254                 p2,
4255                 p3
4256             )
4257         );
4258     }
4259 
4260     function log(
4261         address p0,
4262         uint256 p1,
4263         bool p2,
4264         address p3
4265     ) internal view {
4266         _sendLogPayload(
4267             abi.encodeWithSignature(
4268                 "log(address,uint,bool,address)",
4269                 p0,
4270                 p1,
4271                 p2,
4272                 p3
4273             )
4274         );
4275     }
4276 
4277     function log(
4278         address p0,
4279         uint256 p1,
4280         address p2,
4281         uint256 p3
4282     ) internal view {
4283         _sendLogPayload(
4284             abi.encodeWithSignature(
4285                 "log(address,uint,address,uint)",
4286                 p0,
4287                 p1,
4288                 p2,
4289                 p3
4290             )
4291         );
4292     }
4293 
4294     function log(
4295         address p0,
4296         uint256 p1,
4297         address p2,
4298         string memory p3
4299     ) internal view {
4300         _sendLogPayload(
4301             abi.encodeWithSignature(
4302                 "log(address,uint,address,string)",
4303                 p0,
4304                 p1,
4305                 p2,
4306                 p3
4307             )
4308         );
4309     }
4310 
4311     function log(
4312         address p0,
4313         uint256 p1,
4314         address p2,
4315         bool p3
4316     ) internal view {
4317         _sendLogPayload(
4318             abi.encodeWithSignature(
4319                 "log(address,uint,address,bool)",
4320                 p0,
4321                 p1,
4322                 p2,
4323                 p3
4324             )
4325         );
4326     }
4327 
4328     function log(
4329         address p0,
4330         uint256 p1,
4331         address p2,
4332         address p3
4333     ) internal view {
4334         _sendLogPayload(
4335             abi.encodeWithSignature(
4336                 "log(address,uint,address,address)",
4337                 p0,
4338                 p1,
4339                 p2,
4340                 p3
4341             )
4342         );
4343     }
4344 
4345     function log(
4346         address p0,
4347         string memory p1,
4348         uint256 p2,
4349         uint256 p3
4350     ) internal view {
4351         _sendLogPayload(
4352             abi.encodeWithSignature(
4353                 "log(address,string,uint,uint)",
4354                 p0,
4355                 p1,
4356                 p2,
4357                 p3
4358             )
4359         );
4360     }
4361 
4362     function log(
4363         address p0,
4364         string memory p1,
4365         uint256 p2,
4366         string memory p3
4367     ) internal view {
4368         _sendLogPayload(
4369             abi.encodeWithSignature(
4370                 "log(address,string,uint,string)",
4371                 p0,
4372                 p1,
4373                 p2,
4374                 p3
4375             )
4376         );
4377     }
4378 
4379     function log(
4380         address p0,
4381         string memory p1,
4382         uint256 p2,
4383         bool p3
4384     ) internal view {
4385         _sendLogPayload(
4386             abi.encodeWithSignature(
4387                 "log(address,string,uint,bool)",
4388                 p0,
4389                 p1,
4390                 p2,
4391                 p3
4392             )
4393         );
4394     }
4395 
4396     function log(
4397         address p0,
4398         string memory p1,
4399         uint256 p2,
4400         address p3
4401     ) internal view {
4402         _sendLogPayload(
4403             abi.encodeWithSignature(
4404                 "log(address,string,uint,address)",
4405                 p0,
4406                 p1,
4407                 p2,
4408                 p3
4409             )
4410         );
4411     }
4412 
4413     function log(
4414         address p0,
4415         string memory p1,
4416         string memory p2,
4417         uint256 p3
4418     ) internal view {
4419         _sendLogPayload(
4420             abi.encodeWithSignature(
4421                 "log(address,string,string,uint)",
4422                 p0,
4423                 p1,
4424                 p2,
4425                 p3
4426             )
4427         );
4428     }
4429 
4430     function log(
4431         address p0,
4432         string memory p1,
4433         string memory p2,
4434         string memory p3
4435     ) internal view {
4436         _sendLogPayload(
4437             abi.encodeWithSignature(
4438                 "log(address,string,string,string)",
4439                 p0,
4440                 p1,
4441                 p2,
4442                 p3
4443             )
4444         );
4445     }
4446 
4447     function log(
4448         address p0,
4449         string memory p1,
4450         string memory p2,
4451         bool p3
4452     ) internal view {
4453         _sendLogPayload(
4454             abi.encodeWithSignature(
4455                 "log(address,string,string,bool)",
4456                 p0,
4457                 p1,
4458                 p2,
4459                 p3
4460             )
4461         );
4462     }
4463 
4464     function log(
4465         address p0,
4466         string memory p1,
4467         string memory p2,
4468         address p3
4469     ) internal view {
4470         _sendLogPayload(
4471             abi.encodeWithSignature(
4472                 "log(address,string,string,address)",
4473                 p0,
4474                 p1,
4475                 p2,
4476                 p3
4477             )
4478         );
4479     }
4480 
4481     function log(
4482         address p0,
4483         string memory p1,
4484         bool p2,
4485         uint256 p3
4486     ) internal view {
4487         _sendLogPayload(
4488             abi.encodeWithSignature(
4489                 "log(address,string,bool,uint)",
4490                 p0,
4491                 p1,
4492                 p2,
4493                 p3
4494             )
4495         );
4496     }
4497 
4498     function log(
4499         address p0,
4500         string memory p1,
4501         bool p2,
4502         string memory p3
4503     ) internal view {
4504         _sendLogPayload(
4505             abi.encodeWithSignature(
4506                 "log(address,string,bool,string)",
4507                 p0,
4508                 p1,
4509                 p2,
4510                 p3
4511             )
4512         );
4513     }
4514 
4515     function log(
4516         address p0,
4517         string memory p1,
4518         bool p2,
4519         bool p3
4520     ) internal view {
4521         _sendLogPayload(
4522             abi.encodeWithSignature(
4523                 "log(address,string,bool,bool)",
4524                 p0,
4525                 p1,
4526                 p2,
4527                 p3
4528             )
4529         );
4530     }
4531 
4532     function log(
4533         address p0,
4534         string memory p1,
4535         bool p2,
4536         address p3
4537     ) internal view {
4538         _sendLogPayload(
4539             abi.encodeWithSignature(
4540                 "log(address,string,bool,address)",
4541                 p0,
4542                 p1,
4543                 p2,
4544                 p3
4545             )
4546         );
4547     }
4548 
4549     function log(
4550         address p0,
4551         string memory p1,
4552         address p2,
4553         uint256 p3
4554     ) internal view {
4555         _sendLogPayload(
4556             abi.encodeWithSignature(
4557                 "log(address,string,address,uint)",
4558                 p0,
4559                 p1,
4560                 p2,
4561                 p3
4562             )
4563         );
4564     }
4565 
4566     function log(
4567         address p0,
4568         string memory p1,
4569         address p2,
4570         string memory p3
4571     ) internal view {
4572         _sendLogPayload(
4573             abi.encodeWithSignature(
4574                 "log(address,string,address,string)",
4575                 p0,
4576                 p1,
4577                 p2,
4578                 p3
4579             )
4580         );
4581     }
4582 
4583     function log(
4584         address p0,
4585         string memory p1,
4586         address p2,
4587         bool p3
4588     ) internal view {
4589         _sendLogPayload(
4590             abi.encodeWithSignature(
4591                 "log(address,string,address,bool)",
4592                 p0,
4593                 p1,
4594                 p2,
4595                 p3
4596             )
4597         );
4598     }
4599 
4600     function log(
4601         address p0,
4602         string memory p1,
4603         address p2,
4604         address p3
4605     ) internal view {
4606         _sendLogPayload(
4607             abi.encodeWithSignature(
4608                 "log(address,string,address,address)",
4609                 p0,
4610                 p1,
4611                 p2,
4612                 p3
4613             )
4614         );
4615     }
4616 
4617     function log(
4618         address p0,
4619         bool p1,
4620         uint256 p2,
4621         uint256 p3
4622     ) internal view {
4623         _sendLogPayload(
4624             abi.encodeWithSignature(
4625                 "log(address,bool,uint,uint)",
4626                 p0,
4627                 p1,
4628                 p2,
4629                 p3
4630             )
4631         );
4632     }
4633 
4634     function log(
4635         address p0,
4636         bool p1,
4637         uint256 p2,
4638         string memory p3
4639     ) internal view {
4640         _sendLogPayload(
4641             abi.encodeWithSignature(
4642                 "log(address,bool,uint,string)",
4643                 p0,
4644                 p1,
4645                 p2,
4646                 p3
4647             )
4648         );
4649     }
4650 
4651     function log(
4652         address p0,
4653         bool p1,
4654         uint256 p2,
4655         bool p3
4656     ) internal view {
4657         _sendLogPayload(
4658             abi.encodeWithSignature(
4659                 "log(address,bool,uint,bool)",
4660                 p0,
4661                 p1,
4662                 p2,
4663                 p3
4664             )
4665         );
4666     }
4667 
4668     function log(
4669         address p0,
4670         bool p1,
4671         uint256 p2,
4672         address p3
4673     ) internal view {
4674         _sendLogPayload(
4675             abi.encodeWithSignature(
4676                 "log(address,bool,uint,address)",
4677                 p0,
4678                 p1,
4679                 p2,
4680                 p3
4681             )
4682         );
4683     }
4684 
4685     function log(
4686         address p0,
4687         bool p1,
4688         string memory p2,
4689         uint256 p3
4690     ) internal view {
4691         _sendLogPayload(
4692             abi.encodeWithSignature(
4693                 "log(address,bool,string,uint)",
4694                 p0,
4695                 p1,
4696                 p2,
4697                 p3
4698             )
4699         );
4700     }
4701 
4702     function log(
4703         address p0,
4704         bool p1,
4705         string memory p2,
4706         string memory p3
4707     ) internal view {
4708         _sendLogPayload(
4709             abi.encodeWithSignature(
4710                 "log(address,bool,string,string)",
4711                 p0,
4712                 p1,
4713                 p2,
4714                 p3
4715             )
4716         );
4717     }
4718 
4719     function log(
4720         address p0,
4721         bool p1,
4722         string memory p2,
4723         bool p3
4724     ) internal view {
4725         _sendLogPayload(
4726             abi.encodeWithSignature(
4727                 "log(address,bool,string,bool)",
4728                 p0,
4729                 p1,
4730                 p2,
4731                 p3
4732             )
4733         );
4734     }
4735 
4736     function log(
4737         address p0,
4738         bool p1,
4739         string memory p2,
4740         address p3
4741     ) internal view {
4742         _sendLogPayload(
4743             abi.encodeWithSignature(
4744                 "log(address,bool,string,address)",
4745                 p0,
4746                 p1,
4747                 p2,
4748                 p3
4749             )
4750         );
4751     }
4752 
4753     function log(
4754         address p0,
4755         bool p1,
4756         bool p2,
4757         uint256 p3
4758     ) internal view {
4759         _sendLogPayload(
4760             abi.encodeWithSignature(
4761                 "log(address,bool,bool,uint)",
4762                 p0,
4763                 p1,
4764                 p2,
4765                 p3
4766             )
4767         );
4768     }
4769 
4770     function log(
4771         address p0,
4772         bool p1,
4773         bool p2,
4774         string memory p3
4775     ) internal view {
4776         _sendLogPayload(
4777             abi.encodeWithSignature(
4778                 "log(address,bool,bool,string)",
4779                 p0,
4780                 p1,
4781                 p2,
4782                 p3
4783             )
4784         );
4785     }
4786 
4787     function log(
4788         address p0,
4789         bool p1,
4790         bool p2,
4791         bool p3
4792     ) internal view {
4793         _sendLogPayload(
4794             abi.encodeWithSignature(
4795                 "log(address,bool,bool,bool)",
4796                 p0,
4797                 p1,
4798                 p2,
4799                 p3
4800             )
4801         );
4802     }
4803 
4804     function log(
4805         address p0,
4806         bool p1,
4807         bool p2,
4808         address p3
4809     ) internal view {
4810         _sendLogPayload(
4811             abi.encodeWithSignature(
4812                 "log(address,bool,bool,address)",
4813                 p0,
4814                 p1,
4815                 p2,
4816                 p3
4817             )
4818         );
4819     }
4820 
4821     function log(
4822         address p0,
4823         bool p1,
4824         address p2,
4825         uint256 p3
4826     ) internal view {
4827         _sendLogPayload(
4828             abi.encodeWithSignature(
4829                 "log(address,bool,address,uint)",
4830                 p0,
4831                 p1,
4832                 p2,
4833                 p3
4834             )
4835         );
4836     }
4837 
4838     function log(
4839         address p0,
4840         bool p1,
4841         address p2,
4842         string memory p3
4843     ) internal view {
4844         _sendLogPayload(
4845             abi.encodeWithSignature(
4846                 "log(address,bool,address,string)",
4847                 p0,
4848                 p1,
4849                 p2,
4850                 p3
4851             )
4852         );
4853     }
4854 
4855     function log(
4856         address p0,
4857         bool p1,
4858         address p2,
4859         bool p3
4860     ) internal view {
4861         _sendLogPayload(
4862             abi.encodeWithSignature(
4863                 "log(address,bool,address,bool)",
4864                 p0,
4865                 p1,
4866                 p2,
4867                 p3
4868             )
4869         );
4870     }
4871 
4872     function log(
4873         address p0,
4874         bool p1,
4875         address p2,
4876         address p3
4877     ) internal view {
4878         _sendLogPayload(
4879             abi.encodeWithSignature(
4880                 "log(address,bool,address,address)",
4881                 p0,
4882                 p1,
4883                 p2,
4884                 p3
4885             )
4886         );
4887     }
4888 
4889     function log(
4890         address p0,
4891         address p1,
4892         uint256 p2,
4893         uint256 p3
4894     ) internal view {
4895         _sendLogPayload(
4896             abi.encodeWithSignature(
4897                 "log(address,address,uint,uint)",
4898                 p0,
4899                 p1,
4900                 p2,
4901                 p3
4902             )
4903         );
4904     }
4905 
4906     function log(
4907         address p0,
4908         address p1,
4909         uint256 p2,
4910         string memory p3
4911     ) internal view {
4912         _sendLogPayload(
4913             abi.encodeWithSignature(
4914                 "log(address,address,uint,string)",
4915                 p0,
4916                 p1,
4917                 p2,
4918                 p3
4919             )
4920         );
4921     }
4922 
4923     function log(
4924         address p0,
4925         address p1,
4926         uint256 p2,
4927         bool p3
4928     ) internal view {
4929         _sendLogPayload(
4930             abi.encodeWithSignature(
4931                 "log(address,address,uint,bool)",
4932                 p0,
4933                 p1,
4934                 p2,
4935                 p3
4936             )
4937         );
4938     }
4939 
4940     function log(
4941         address p0,
4942         address p1,
4943         uint256 p2,
4944         address p3
4945     ) internal view {
4946         _sendLogPayload(
4947             abi.encodeWithSignature(
4948                 "log(address,address,uint,address)",
4949                 p0,
4950                 p1,
4951                 p2,
4952                 p3
4953             )
4954         );
4955     }
4956 
4957     function log(
4958         address p0,
4959         address p1,
4960         string memory p2,
4961         uint256 p3
4962     ) internal view {
4963         _sendLogPayload(
4964             abi.encodeWithSignature(
4965                 "log(address,address,string,uint)",
4966                 p0,
4967                 p1,
4968                 p2,
4969                 p3
4970             )
4971         );
4972     }
4973 
4974     function log(
4975         address p0,
4976         address p1,
4977         string memory p2,
4978         string memory p3
4979     ) internal view {
4980         _sendLogPayload(
4981             abi.encodeWithSignature(
4982                 "log(address,address,string,string)",
4983                 p0,
4984                 p1,
4985                 p2,
4986                 p3
4987             )
4988         );
4989     }
4990 
4991     function log(
4992         address p0,
4993         address p1,
4994         string memory p2,
4995         bool p3
4996     ) internal view {
4997         _sendLogPayload(
4998             abi.encodeWithSignature(
4999                 "log(address,address,string,bool)",
5000                 p0,
5001                 p1,
5002                 p2,
5003                 p3
5004             )
5005         );
5006     }
5007 
5008     function log(
5009         address p0,
5010         address p1,
5011         string memory p2,
5012         address p3
5013     ) internal view {
5014         _sendLogPayload(
5015             abi.encodeWithSignature(
5016                 "log(address,address,string,address)",
5017                 p0,
5018                 p1,
5019                 p2,
5020                 p3
5021             )
5022         );
5023     }
5024 
5025     function log(
5026         address p0,
5027         address p1,
5028         bool p2,
5029         uint256 p3
5030     ) internal view {
5031         _sendLogPayload(
5032             abi.encodeWithSignature(
5033                 "log(address,address,bool,uint)",
5034                 p0,
5035                 p1,
5036                 p2,
5037                 p3
5038             )
5039         );
5040     }
5041 
5042     function log(
5043         address p0,
5044         address p1,
5045         bool p2,
5046         string memory p3
5047     ) internal view {
5048         _sendLogPayload(
5049             abi.encodeWithSignature(
5050                 "log(address,address,bool,string)",
5051                 p0,
5052                 p1,
5053                 p2,
5054                 p3
5055             )
5056         );
5057     }
5058 
5059     function log(
5060         address p0,
5061         address p1,
5062         bool p2,
5063         bool p3
5064     ) internal view {
5065         _sendLogPayload(
5066             abi.encodeWithSignature(
5067                 "log(address,address,bool,bool)",
5068                 p0,
5069                 p1,
5070                 p2,
5071                 p3
5072             )
5073         );
5074     }
5075 
5076     function log(
5077         address p0,
5078         address p1,
5079         bool p2,
5080         address p3
5081     ) internal view {
5082         _sendLogPayload(
5083             abi.encodeWithSignature(
5084                 "log(address,address,bool,address)",
5085                 p0,
5086                 p1,
5087                 p2,
5088                 p3
5089             )
5090         );
5091     }
5092 
5093     function log(
5094         address p0,
5095         address p1,
5096         address p2,
5097         uint256 p3
5098     ) internal view {
5099         _sendLogPayload(
5100             abi.encodeWithSignature(
5101                 "log(address,address,address,uint)",
5102                 p0,
5103                 p1,
5104                 p2,
5105                 p3
5106             )
5107         );
5108     }
5109 
5110     function log(
5111         address p0,
5112         address p1,
5113         address p2,
5114         string memory p3
5115     ) internal view {
5116         _sendLogPayload(
5117             abi.encodeWithSignature(
5118                 "log(address,address,address,string)",
5119                 p0,
5120                 p1,
5121                 p2,
5122                 p3
5123             )
5124         );
5125     }
5126 
5127     function log(
5128         address p0,
5129         address p1,
5130         address p2,
5131         bool p3
5132     ) internal view {
5133         _sendLogPayload(
5134             abi.encodeWithSignature(
5135                 "log(address,address,address,bool)",
5136                 p0,
5137                 p1,
5138                 p2,
5139                 p3
5140             )
5141         );
5142     }
5143 
5144     function log(
5145         address p0,
5146         address p1,
5147         address p2,
5148         address p3
5149     ) internal view {
5150         _sendLogPayload(
5151             abi.encodeWithSignature(
5152                 "log(address,address,address,address)",
5153                 p0,
5154                 p1,
5155                 p2,
5156                 p3
5157             )
5158         );
5159     }
5160 }
5161 
5162 // File contracts/openzeppelin/token/ERC20/IERC20.sol
5163 
5164 pragma solidity >=0.6.0 <0.8.0;
5165 
5166 /**
5167  * @dev Interface of the ERC20 standard as defined in the EIP.
5168  */
5169 interface IERC20 {
5170     /**
5171      * @dev Returns the amount of tokens in existence.
5172      */
5173     function totalSupply() external view returns (uint256);
5174 
5175     /**
5176      * @dev Returns the amount of tokens owned by `account`.
5177      */
5178     function balanceOf(address account) external view returns (uint256);
5179 
5180     /**
5181      * @dev Moves `amount` tokens from the caller's account to `recipient`.
5182      *
5183      * Returns a boolean value indicating whether the operation succeeded.
5184      *
5185      * Emits a {Transfer} event.
5186      */
5187     function transfer(address recipient, uint256 amount)
5188         external
5189         returns (bool);
5190 
5191     /**
5192      * @dev Returns the remaining number of tokens that `spender` will be
5193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
5194      * zero by default.
5195      *
5196      * This value changes when {approve} or {transferFrom} are called.
5197      */
5198     function allowance(address owner, address spender)
5199         external
5200         view
5201         returns (uint256);
5202 
5203     /**
5204      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
5205      *
5206      * Returns a boolean value indicating whether the operation succeeded.
5207      *
5208      * IMPORTANT: Beware that changing an allowance with this method brings the risk
5209      * that someone may use both the old and the new allowance by unfortunate
5210      * transaction ordering. One possible solution to mitigate this race
5211      * condition is to first reduce the spender's allowance to 0 and set the
5212      * desired value afterwards:
5213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
5214      *
5215      * Emits an {Approval} event.
5216      */
5217     function approve(address spender, uint256 amount) external returns (bool);
5218 
5219     /**
5220      * @dev Moves `amount` tokens from `sender` to `recipient` using the
5221      * allowance mechanism. `amount` is then deducted from the caller's
5222      * allowance.
5223      *
5224      * Returns a boolean value indicating whether the operation succeeded.
5225      *
5226      * Emits a {Transfer} event.
5227      */
5228     function transferFrom(
5229         address sender,
5230         address recipient,
5231         uint256 amount
5232     ) external returns (bool);
5233 
5234     /**
5235      * @dev Emitted when `value` tokens are moved from one account (`from`) to
5236      * another (`to`).
5237      *
5238      * Note that `value` may be zero.
5239      */
5240     event Transfer(address indexed from, address indexed to, uint256 value);
5241 
5242     /**
5243      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
5244      * a call to {approve}. `value` is the new allowance.
5245      */
5246     event Approval(
5247         address indexed owner,
5248         address indexed spender,
5249         uint256 value
5250     );
5251 }
5252 
5253 // File contracts/openzeppelin/math/SafeMath.sol
5254 
5255 pragma solidity >=0.6.0 <0.8.0;
5256 
5257 /**
5258  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5259  * checks.
5260  *
5261  * Arithmetic operations in Solidity wrap on overflow. This can easily result
5262  * in bugs, because programmers usually assume that an overflow raises an
5263  * error, which is the standard behavior in high level programming languages.
5264  * `SafeMath` restores this intuition by reverting the transaction when an
5265  * operation overflows.
5266  *
5267  * Using this library instead of the unchecked operations eliminates an entire
5268  * class of bugs, so it's recommended to use it always.
5269  */
5270 library SafeMath {
5271     /**
5272      * @dev Returns the addition of two unsigned integers, reverting on
5273      * overflow.
5274      *
5275      * Counterpart to Solidity's `+` operator.
5276      *
5277      * Requirements:
5278      *
5279      * - Addition cannot overflow.
5280      */
5281     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5282         uint256 c = a + b;
5283         require(c >= a, "SafeMath: addition overflow");
5284 
5285         return c;
5286     }
5287 
5288     /**
5289      * @dev Returns the subtraction of two unsigned integers, reverting on
5290      * overflow (when the result is negative).
5291      *
5292      * Counterpart to Solidity's `-` operator.
5293      *
5294      * Requirements:
5295      *
5296      * - Subtraction cannot overflow.
5297      */
5298     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5299         return sub(a, b, "SafeMath: subtraction overflow");
5300     }
5301 
5302     /**
5303      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
5304      * overflow (when the result is negative).
5305      *
5306      * Counterpart to Solidity's `-` operator.
5307      *
5308      * Requirements:
5309      *
5310      * - Subtraction cannot overflow.
5311      */
5312     function sub(
5313         uint256 a,
5314         uint256 b,
5315         string memory errorMessage
5316     ) internal pure returns (uint256) {
5317         require(b <= a, errorMessage);
5318         uint256 c = a - b;
5319 
5320         return c;
5321     }
5322 
5323     /**
5324      * @dev Returns the multiplication of two unsigned integers, reverting on
5325      * overflow.
5326      *
5327      * Counterpart to Solidity's `*` operator.
5328      *
5329      * Requirements:
5330      *
5331      * - Multiplication cannot overflow.
5332      */
5333     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5334         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
5335         // benefit is lost if 'b' is also tested.
5336         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
5337         if (a == 0) {
5338             return 0;
5339         }
5340 
5341         uint256 c = a * b;
5342         require(c / a == b, "SafeMath: multiplication overflow");
5343 
5344         return c;
5345     }
5346 
5347     /**
5348      * @dev Returns the integer division of two unsigned integers. Reverts on
5349      * division by zero. The result is rounded towards zero.
5350      *
5351      * Counterpart to Solidity's `/` operator. Note: this function uses a
5352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
5353      * uses an invalid opcode to revert (consuming all remaining gas).
5354      *
5355      * Requirements:
5356      *
5357      * - The divisor cannot be zero.
5358      */
5359     function div(uint256 a, uint256 b) internal pure returns (uint256) {
5360         return div(a, b, "SafeMath: division by zero");
5361     }
5362 
5363     /**
5364      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
5365      * division by zero. The result is rounded towards zero.
5366      *
5367      * Counterpart to Solidity's `/` operator. Note: this function uses a
5368      * `revert` opcode (which leaves remaining gas untouched) while Solidity
5369      * uses an invalid opcode to revert (consuming all remaining gas).
5370      *
5371      * Requirements:
5372      *
5373      * - The divisor cannot be zero.
5374      */
5375     function div(
5376         uint256 a,
5377         uint256 b,
5378         string memory errorMessage
5379     ) internal pure returns (uint256) {
5380         require(b > 0, errorMessage);
5381         uint256 c = a / b;
5382         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
5383 
5384         return c;
5385     }
5386 
5387     /**
5388      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
5389      * Reverts when dividing by zero.
5390      *
5391      * Counterpart to Solidity's `%` operator. This function uses a `revert`
5392      * opcode (which leaves remaining gas untouched) while Solidity uses an
5393      * invalid opcode to revert (consuming all remaining gas).
5394      *
5395      * Requirements:
5396      *
5397      * - The divisor cannot be zero.
5398      */
5399     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
5400         return mod(a, b, "SafeMath: modulo by zero");
5401     }
5402 
5403     /**
5404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
5405      * Reverts with custom message when dividing by zero.
5406      *
5407      * Counterpart to Solidity's `%` operator. This function uses a `revert`
5408      * opcode (which leaves remaining gas untouched) while Solidity uses an
5409      * invalid opcode to revert (consuming all remaining gas).
5410      *
5411      * Requirements:
5412      *
5413      * - The divisor cannot be zero.
5414      */
5415     function mod(
5416         uint256 a,
5417         uint256 b,
5418         string memory errorMessage
5419     ) internal pure returns (uint256) {
5420         require(b != 0, errorMessage);
5421         return a % b;
5422     }
5423 }
5424 
5425 // File contracts/openzeppelin/utils/Address.sol
5426 
5427 pragma solidity >=0.6.2 <0.8.0;
5428 
5429 /**
5430  * @dev Collection of functions related to the address type
5431  */
5432 library Address {
5433     /**
5434      * @dev Returns true if `account` is a contract.
5435      *
5436      * [IMPORTANT]
5437      * ====
5438      * It is unsafe to assume that an address for which this function returns
5439      * false is an externally-owned account (EOA) and not a contract.
5440      *
5441      * Among others, `isContract` will return false for the following
5442      * types of addresses:
5443      *
5444      *  - an externally-owned account
5445      *  - a contract in construction
5446      *  - an address where a contract will be created
5447      *  - an address where a contract lived, but was destroyed
5448      * ====
5449      */
5450     function isContract(address account) internal view returns (bool) {
5451         // This method relies on extcodesize, which returns 0 for contracts in
5452         // construction, since the code is only stored at the end of the
5453         // constructor execution.
5454 
5455         uint256 size;
5456         // solhint-disable-next-line no-inline-assembly
5457         assembly {
5458             size := extcodesize(account)
5459         }
5460         return size > 0;
5461     }
5462 
5463     /**
5464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
5465      * `recipient`, forwarding all available gas and reverting on errors.
5466      *
5467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
5468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
5469      * imposed by `transfer`, making them unable to receive funds via
5470      * `transfer`. {sendValue} removes this limitation.
5471      *
5472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
5473      *
5474      * IMPORTANT: because control is transferred to `recipient`, care must be
5475      * taken to not create reentrancy vulnerabilities. Consider using
5476      * {ReentrancyGuard} or the
5477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
5478      */
5479     function sendValue(address payable recipient, uint256 amount) internal {
5480         require(
5481             address(this).balance >= amount,
5482             "Address: insufficient balance"
5483         );
5484 
5485         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
5486         (bool success, ) = recipient.call{value: amount}("");
5487         require(
5488             success,
5489             "Address: unable to send value, recipient may have reverted"
5490         );
5491     }
5492 
5493     /**
5494      * @dev Performs a Solidity function call using a low level `call`. A
5495      * plain`call` is an unsafe replacement for a function call: use this
5496      * function instead.
5497      *
5498      * If `target` reverts with a revert reason, it is bubbled up by this
5499      * function (like regular Solidity function calls).
5500      *
5501      * Returns the raw returned data. To convert to the expected return value,
5502      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
5503      *
5504      * Requirements:
5505      *
5506      * - `target` must be a contract.
5507      * - calling `target` with `data` must not revert.
5508      *
5509      * _Available since v3.1._
5510      */
5511     function functionCall(address target, bytes memory data)
5512         internal
5513         returns (bytes memory)
5514     {
5515         return functionCall(target, data, "Address: low-level call failed");
5516     }
5517 
5518     /**
5519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
5520      * `errorMessage` as a fallback revert reason when `target` reverts.
5521      *
5522      * _Available since v3.1._
5523      */
5524     function functionCall(
5525         address target,
5526         bytes memory data,
5527         string memory errorMessage
5528     ) internal returns (bytes memory) {
5529         return functionCallWithValue(target, data, 0, errorMessage);
5530     }
5531 
5532     /**
5533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
5534      * but also transferring `value` wei to `target`.
5535      *
5536      * Requirements:
5537      *
5538      * - the calling contract must have an ETH balance of at least `value`.
5539      * - the called Solidity function must be `payable`.
5540      *
5541      * _Available since v3.1._
5542      */
5543     function functionCallWithValue(
5544         address target,
5545         bytes memory data,
5546         uint256 value
5547     ) internal returns (bytes memory) {
5548         return
5549             functionCallWithValue(
5550                 target,
5551                 data,
5552                 value,
5553                 "Address: low-level call with value failed"
5554             );
5555     }
5556 
5557     /**
5558      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
5559      * with `errorMessage` as a fallback revert reason when `target` reverts.
5560      *
5561      * _Available since v3.1._
5562      */
5563     function functionCallWithValue(
5564         address target,
5565         bytes memory data,
5566         uint256 value,
5567         string memory errorMessage
5568     ) internal returns (bytes memory) {
5569         require(
5570             address(this).balance >= value,
5571             "Address: insufficient balance for call"
5572         );
5573         require(isContract(target), "Address: call to non-contract");
5574 
5575         // solhint-disable-next-line avoid-low-level-calls
5576         (bool success, bytes memory returndata) = target.call{value: value}(
5577             data
5578         );
5579         return _verifyCallResult(success, returndata, errorMessage);
5580     }
5581 
5582     /**
5583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
5584      * but performing a static call.
5585      *
5586      * _Available since v3.3._
5587      */
5588     function functionStaticCall(address target, bytes memory data)
5589         internal
5590         view
5591         returns (bytes memory)
5592     {
5593         return
5594             functionStaticCall(
5595                 target,
5596                 data,
5597                 "Address: low-level static call failed"
5598             );
5599     }
5600 
5601     /**
5602      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
5603      * but performing a static call.
5604      *
5605      * _Available since v3.3._
5606      */
5607     function functionStaticCall(
5608         address target,
5609         bytes memory data,
5610         string memory errorMessage
5611     ) internal view returns (bytes memory) {
5612         require(isContract(target), "Address: static call to non-contract");
5613 
5614         // solhint-disable-next-line avoid-low-level-calls
5615         (bool success, bytes memory returndata) = target.staticcall(data);
5616         return _verifyCallResult(success, returndata, errorMessage);
5617     }
5618 
5619     /**
5620      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
5621      * but performing a delegate call.
5622      *
5623      * _Available since v3.3._
5624      */
5625     function functionDelegateCall(address target, bytes memory data)
5626         internal
5627         returns (bytes memory)
5628     {
5629         return
5630             functionDelegateCall(
5631                 target,
5632                 data,
5633                 "Address: low-level delegate call failed"
5634             );
5635     }
5636 
5637     /**
5638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
5639      * but performing a delegate call.
5640      *
5641      * _Available since v3.3._
5642      */
5643     function functionDelegateCall(
5644         address target,
5645         bytes memory data,
5646         string memory errorMessage
5647     ) internal returns (bytes memory) {
5648         require(isContract(target), "Address: delegate call to non-contract");
5649 
5650         // solhint-disable-next-line avoid-low-level-calls
5651         (bool success, bytes memory returndata) = target.delegatecall(data);
5652         return _verifyCallResult(success, returndata, errorMessage);
5653     }
5654 
5655     function _verifyCallResult(
5656         bool success,
5657         bytes memory returndata,
5658         string memory errorMessage
5659     ) private pure returns (bytes memory) {
5660         if (success) {
5661             return returndata;
5662         } else {
5663             // Look for revert reason and bubble it up if present
5664             if (returndata.length > 0) {
5665                 // The easiest way to bubble the revert reason is using memory via assembly
5666 
5667                 // solhint-disable-next-line no-inline-assembly
5668                 assembly {
5669                     let returndata_size := mload(returndata)
5670                     revert(add(32, returndata), returndata_size)
5671                 }
5672             } else {
5673                 revert(errorMessage);
5674             }
5675         }
5676     }
5677 }
5678 
5679 // File contracts/openzeppelin/token/ERC20/SafeERC20.sol
5680 
5681 pragma solidity >=0.6.0 <0.8.0;
5682 
5683 /**
5684  * @title SafeERC20
5685  * @dev Wrappers around ERC20 operations that throw on failure (when the token
5686  * contract returns false). Tokens that return no value (and instead revert or
5687  * throw on failure) are also supported, non-reverting calls are assumed to be
5688  * successful.
5689  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
5690  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
5691  */
5692 library SafeERC20 {
5693     using SafeMath for uint256;
5694     using Address for address;
5695 
5696     function safeTransfer(
5697         IERC20 token,
5698         address to,
5699         uint256 value
5700     ) internal {
5701         _callOptionalReturn(
5702             token,
5703             abi.encodeWithSelector(token.transfer.selector, to, value)
5704         );
5705     }
5706 
5707     function safeTransferFrom(
5708         IERC20 token,
5709         address from,
5710         address to,
5711         uint256 value
5712     ) internal {
5713         _callOptionalReturn(
5714             token,
5715             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
5716         );
5717     }
5718 
5719     /**
5720      * @dev Deprecated. This function has issues similar to the ones found in
5721      * {IERC20-approve}, and its usage is discouraged.
5722      *
5723      * Whenever possible, use {safeIncreaseAllowance} and
5724      * {safeDecreaseAllowance} instead.
5725      */
5726     function safeApprove(
5727         IERC20 token,
5728         address spender,
5729         uint256 value
5730     ) internal {
5731         // safeApprove should only be called when setting an initial allowance,
5732         // or when resetting it to zero. To increase and decrease it, use
5733         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
5734         // solhint-disable-next-line max-line-length
5735         require(
5736             (value == 0) || (token.allowance(address(this), spender) == 0),
5737             "SafeERC20: approve from non-zero to non-zero allowance"
5738         );
5739         _callOptionalReturn(
5740             token,
5741             abi.encodeWithSelector(token.approve.selector, spender, value)
5742         );
5743     }
5744 
5745     function safeIncreaseAllowance(
5746         IERC20 token,
5747         address spender,
5748         uint256 value
5749     ) internal {
5750         uint256 newAllowance = token.allowance(address(this), spender).add(
5751             value
5752         );
5753         _callOptionalReturn(
5754             token,
5755             abi.encodeWithSelector(
5756                 token.approve.selector,
5757                 spender,
5758                 newAllowance
5759             )
5760         );
5761     }
5762 
5763     function safeDecreaseAllowance(
5764         IERC20 token,
5765         address spender,
5766         uint256 value
5767     ) internal {
5768         uint256 newAllowance = token.allowance(address(this), spender).sub(
5769             value,
5770             "SafeERC20: decreased allowance below zero"
5771         );
5772         _callOptionalReturn(
5773             token,
5774             abi.encodeWithSelector(
5775                 token.approve.selector,
5776                 spender,
5777                 newAllowance
5778             )
5779         );
5780     }
5781 
5782     /**
5783      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
5784      * on the return value: the return value is optional (but if data is returned, it must not be false).
5785      * @param token The token targeted by the call.
5786      * @param data The call data (encoded using abi.encode or one of its variants).
5787      */
5788     function _callOptionalReturn(IERC20 token, bytes memory data) private {
5789         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
5790         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
5791         // the target address contains contract code and also asserts for success in the low-level call.
5792 
5793         bytes memory returndata = address(token).functionCall(
5794             data,
5795             "SafeERC20: low-level call failed"
5796         );
5797         if (returndata.length > 0) {
5798             // Return data is optional
5799             // solhint-disable-next-line max-line-length
5800             require(
5801                 abi.decode(returndata, (bool)),
5802                 "SafeERC20: ERC20 operation did not succeed"
5803             );
5804         }
5805     }
5806 }
5807 
5808 // File contracts/openzeppelin/utils/ReentrancyGuard.sol
5809 
5810 pragma solidity >=0.6.0 <0.8.0;
5811 
5812 /**
5813  * @dev Contract module that helps prevent reentrant calls to a function.
5814  *
5815  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
5816  * available, which can be applied to functions to make sure there are no nested
5817  * (reentrant) calls to them.
5818  *
5819  * Note that because there is a single `nonReentrant` guard, functions marked as
5820  * `nonReentrant` may not call one another. This can be worked around by making
5821  * those functions `private`, and then adding `external` `nonReentrant` entry
5822  * points to them.
5823  *
5824  * TIP: If you would like to learn more about reentrancy and alternative ways
5825  * to protect against it, check out our blog post
5826  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
5827  */
5828 abstract contract ReentrancyGuard {
5829     // Booleans are more expensive than uint256 or any type that takes up a full
5830     // word because each write operation emits an extra SLOAD to first read the
5831     // slot's contents, replace the bits taken up by the boolean, and then write
5832     // back. This is the compiler's defense against contract upgrades and
5833     // pointer aliasing, and it cannot be disabled.
5834 
5835     // The values being non-zero value makes deployment a bit more expensive,
5836     // but in exchange the refund on every call to nonReentrant will be lower in
5837     // amount. Since refunds are capped to a percentage of the total
5838     // transaction's gas, it is best to keep them low in cases like this one, to
5839     // increase the likelihood of the full refund coming into effect.
5840     uint256 private constant _NOT_ENTERED = 1;
5841     uint256 private constant _ENTERED = 2;
5842 
5843     uint256 private _status;
5844 
5845     constructor() internal {
5846         _status = _NOT_ENTERED;
5847     }
5848 
5849     /**
5850      * @dev Prevents a contract from calling itself, directly or indirectly.
5851      * Calling a `nonReentrant` function from another `nonReentrant`
5852      * function is not supported. It is possible to prevent this from happening
5853      * by making the `nonReentrant` function external, and make it call a
5854      * `private` function that does the actual work.
5855      */
5856     modifier nonReentrant() {
5857         // On the first call to nonReentrant, _notEntered will be true
5858         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
5859 
5860         // Any calls to nonReentrant after this point will fail
5861         _status = _ENTERED;
5862 
5863         _;
5864 
5865         // By storing the original value once again, a refund is triggered (see
5866         // https://eips.ethereum.org/EIPS/eip-2200)
5867         _status = _NOT_ENTERED;
5868     }
5869 }
5870 
5871 // File contracts/openzeppelin/GSN/Context.sol
5872 
5873 pragma solidity >=0.6.0 <0.8.0;
5874 
5875 /*
5876  * @dev Provides information about the current execution context, including the
5877  * sender of the transaction and its data. While these are generally available
5878  * via msg.sender and msg.data, they should not be accessed in such a direct
5879  * manner, since when dealing with GSN meta-transactions the account sending and
5880  * paying for execution may not be the actual sender (as far as an application
5881  * is concerned).
5882  *
5883  * This contract is only required for intermediate, library-like contracts.
5884  */
5885 abstract contract Context {
5886     function _msgSender() internal view virtual returns (address payable) {
5887         return msg.sender;
5888     }
5889 
5890     function _msgData() internal view virtual returns (bytes memory) {
5891         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
5892         return msg.data;
5893     }
5894 }
5895 
5896 // File contracts/openzeppelin/access/Ownable.sol
5897 
5898 pragma solidity >=0.6.0 <0.8.0;
5899 
5900 /**
5901  * @dev Contract module which provides a basic access control mechanism, where
5902  * there is an account (an owner) that can be granted exclusive access to
5903  * specific functions.
5904  *
5905  * By default, the owner account will be the one that deploys the contract. This
5906  * can later be changed with {transferOwnership}.
5907  *
5908  * This module is used through inheritance. It will make available the modifier
5909  * `onlyOwner`, which can be applied to your functions to restrict their use to
5910  * the owner.
5911  */
5912 abstract contract Ownable is Context {
5913     address private _owner;
5914 
5915     event OwnershipTransferred(
5916         address indexed previousOwner,
5917         address indexed newOwner
5918     );
5919 
5920     /**
5921      * @dev Initializes the contract setting the deployer as the initial owner.
5922      */
5923     constructor() internal {
5924         address msgSender = _msgSender();
5925         _owner = msgSender;
5926         emit OwnershipTransferred(address(0), msgSender);
5927     }
5928 
5929     /**
5930      * @dev Returns the address of the current owner.
5931      */
5932     function owner() public view returns (address) {
5933         return _owner;
5934     }
5935 
5936     /**
5937      * @dev Throws if called by any account other than the owner.
5938      */
5939     modifier onlyOwner() {
5940         require(_owner == _msgSender(), "Ownable: caller is not the owner");
5941         _;
5942     }
5943 
5944     /**
5945      * @dev Leaves the contract without owner. It will not be possible to call
5946      * `onlyOwner` functions anymore. Can only be called by the current owner.
5947      *
5948      * NOTE: Renouncing ownership will leave the contract without an owner,
5949      * thereby removing any functionality that is only available to the owner.
5950      */
5951     function renounceOwnership() public virtual onlyOwner {
5952         emit OwnershipTransferred(_owner, address(0));
5953         _owner = address(0);
5954     }
5955 
5956     /**
5957      * @dev Transfers ownership of the contract to a new account (`newOwner`).
5958      * Can only be called by the current owner.
5959      */
5960     function transferOwnership(address newOwner) public virtual onlyOwner {
5961         require(
5962             newOwner != address(0),
5963             "Ownable: new owner is the zero address"
5964         );
5965         emit OwnershipTransferred(_owner, newOwner);
5966         _owner = newOwner;
5967     }
5968 }
5969 
5970 // File contracts/ShopxStaking.sol
5971 
5972 //SPDX-License-Identifier: Unlicense
5973 pragma solidity ^0.6.11;
5974 
5975 contract ShopxStaking is ReentrancyGuard, Ownable {
5976     using SafeMath for uint256;
5977 
5978     IERC20 public token;
5979 
5980     bool public isControlingSplit = true;
5981     uint256 public globalStakerSplit = 100;
5982     uint256 public timeLock = 30 days;
5983     uint256 public contentCreatorFee = 0;
5984     uint256 public stakerFee = 1000;
5985 
5986     mapping(address => mapping(address => uint256)) public stakedTokens; // content creator to user
5987     mapping(address => mapping(address => uint256)) public minActionTime; // user to content creator to time
5988     mapping(address => mapping(address => uint256)) public userStake;
5989     mapping(address => uint256) public stakerSplit; //  Porportion of payout stakers recieve
5990     mapping(address => uint256) public creatorStaked; // amount of funds stakes for content creator
5991     mapping(address => uint256) public contentTotalPayout; // amount of payouts for users of a staking address
5992 
5993     event Reward(
5994         address indexed contentCreator,
5995         uint256 total,
5996         uint256 stakerReward,
5997         uint256 contentCreatorReward
5998     );
5999     event SplitUpdated(
6000         address indexed contentCreator,
6001         uint256 newStakerPortion
6002     );
6003     event UserDeposit(
6004         address indexed user,
6005         address indexed contentCreator,
6006         uint256 amountDeposited,
6007         uint256 payout
6008     );
6009     event UserWithdrawal(
6010         address indexed user,
6011         address indexed contentCreator,
6012         uint256 payout,
6013         uint256 amountReceived
6014     );
6015 
6016     constructor(IERC20 _token) public {
6017         token = _token;
6018     }
6019 
6020     function changeTimeLock(uint256 _timeLock) external onlyOwner {
6021         require(_timeLock <= 52 weeks, "not in bounds");
6022         timeLock = _timeLock;
6023     }
6024 
6025     /// @param _contentCreator an array of content creators to reward
6026     /// @param _amount an array of amounts to reward
6027     /// @notice rewards the content creators and bakers of the content creators
6028     function reward(address[] memory _contentCreator, uint256[] memory _amount)
6029         public
6030         nonReentrant
6031     {
6032         uint256 _stakerSplit = globalStakerSplit;
6033         for (uint256 i = 0; i < _contentCreator.length; i++) {
6034             if (!isControlingSplit) {
6035                 _stakerSplit = stakerSplit[_contentCreator[i]] == uint256(0)
6036                     ? uint256(50)
6037                     : stakerSplit[_contentCreator[i]];
6038             }
6039             uint256 stakerRewardBeforeFee = _amount[i].mul(_stakerSplit).div(
6040                 100
6041             );
6042             uint256 contentRewardBeforeFee = _amount[i].sub(
6043                 stakerRewardBeforeFee
6044             );
6045             uint256 stakerRewardAfterFee = stakerRewardBeforeFee
6046                 .mul(stakerFee)
6047                 .div(1000);
6048             uint256 contentRewardAfterFee = contentRewardBeforeFee
6049                 .mul(contentCreatorFee)
6050                 .div(1000);
6051 
6052             creatorStaked[_contentCreator[i]] = creatorStaked[
6053                 _contentCreator[i]
6054             ].add(stakerRewardAfterFee);
6055 
6056             token.transferFrom(msg.sender, address(this), stakerRewardAfterFee);
6057             emit Reward(
6058                 _contentCreator[i],
6059                 _amount[i],
6060                 stakerRewardAfterFee,
6061                 contentRewardAfterFee
6062             );
6063         }
6064     }
6065 
6066     /// @param _contentCreator content creator to baker to
6067     /// @param _amount amount to stake
6068     /// @notice stake to a pool
6069     function deposit(address _contentCreator, uint256 _amount)
6070         public
6071         nonReentrant
6072     {
6073         address payable sender = msg.sender;
6074         uint256 contractBalance = creatorStaked[_contentCreator];
6075         token.transferFrom(sender, address(this), _amount);
6076 
6077         uint256 payout;
6078         if (contentTotalPayout[_contentCreator] == 0) {
6079             payout = _amount;
6080         } else {
6081             payout = _amount.mul(contentTotalPayout[_contentCreator]).div(
6082                 contractBalance
6083             );
6084         }
6085         stakedTokens[_contentCreator][sender] = stakedTokens[_contentCreator][
6086             sender
6087         ].add(_amount);
6088         userStake[_contentCreator][sender] = userStake[_contentCreator][sender]
6089             .add(payout);
6090         contentTotalPayout[_contentCreator] = contentTotalPayout[
6091             _contentCreator
6092         ].add(payout);
6093         creatorStaked[_contentCreator] = creatorStaked[_contentCreator].add(
6094             _amount
6095         );
6096         minActionTime[sender][_contentCreator] = now.add(timeLock);
6097         emit UserDeposit(sender, _contentCreator, _amount, payout);
6098         // payoutIn / payoutTot = tokenAddedInd / total token (after paying)
6099     }
6100 
6101     /// @param _contentCreator content creator to baker to
6102     /// @param _userStake amount to unstake
6103     /// @notice unbake from a content creator
6104     function withdraw(address _contentCreator, uint256 _userStake)
6105         public
6106         nonReentrant
6107     {
6108         address payable sender = msg.sender;
6109         require(
6110             now >= minActionTime[sender][_contentCreator],
6111             "wait more time"
6112         );
6113         uint256 payout = withdrawPayout(_contentCreator, _userStake);
6114 
6115         token.approve(address(this), payout);
6116         token.transferFrom(address(this), sender, payout);
6117 
6118         userStake[_contentCreator][sender] = userStake[_contentCreator][sender]
6119             .sub(_userStake);
6120 
6121         assert(payout <= creatorStaked[_contentCreator]);
6122         assert(_userStake <= contentTotalPayout[_contentCreator]);
6123 
6124         stakedTokens[_contentCreator][sender] = 0;
6125         creatorStaked[_contentCreator] = creatorStaked[_contentCreator].sub(
6126             payout
6127         );
6128         contentTotalPayout[_contentCreator] = contentTotalPayout[
6129             _contentCreator
6130         ].sub(_userStake);
6131         emit UserWithdrawal(sender, _contentCreator, _userStake, payout);
6132     }
6133 
6134     /// @dev helper function to turn a stake into a token balance
6135     function withdrawPayout(address _contentCreator, uint256 _userStake)
6136         public
6137         view
6138         returns (uint256)
6139     {
6140         return
6141             _userStake.mul(creatorStaked[_contentCreator]).div(
6142                 contentTotalPayout[_contentCreator]
6143             );
6144     }
6145 
6146     /// @dev helper function to turn an array of stakes into a token balance
6147     function withdrawable(address[] memory _contentCreators, address _user)
6148         public
6149         view
6150         returns (uint256[] memory)
6151     {
6152         uint256[] memory withdrawableArray = new uint256[](
6153             _contentCreators.length
6154         );
6155         for (uint256 i = 0; i < _contentCreators.length; i++) {
6156             uint256 _userStake = userStake[_contentCreators[i]][_user];
6157             uint256 _withdrawable = contentTotalPayout[_contentCreators[i]] != 0
6158                 ? withdrawPayout(_contentCreators[i], _userStake)
6159                 : 0;
6160             withdrawableArray[i] = _withdrawable;
6161         }
6162         return withdrawableArray;
6163     }
6164 }