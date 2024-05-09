1 /**
2 * ==========================================================
3 *
4 * XoXo Network
5 * FIRST EVER FULLY DECENTRALIZED GLOBAL POWERLINE AUTOPOOL
6 *
7 * Website  : https://xoxo.run
8 * Telegram : https://t.me/xoxonetwork_official
9 *
10 * ==========================================================
11 **/
12 
13 pragma solidity >=0.5.12 <0.7.0;
14 
15 contract XoXo {
16 
17     struct User {
18         uint id;
19         uint referrerCount;
20         uint referrerID;
21         address[] referrals;
22     }
23     
24     struct UsersPool2 {
25         uint id;
26         uint referrerID;
27         uint reinvestCount;
28     }
29     
30     struct Pool_2_Slots {
31         address userAddress;
32         uint referrerID;
33         uint eventsCount;
34     }
35     
36     struct UsersPool3 {
37         uint id;
38         uint referrerID;
39         uint reinvestCount;
40     }
41     
42     struct Pool_3_Slots {
43         address userAddress;
44         uint referrerID;
45         uint eventsCount;
46     }
47     
48     struct UsersPool4 {
49         uint id;
50         uint referrerID;
51         uint reinvestCount;
52     }
53     
54     struct Pool_4_Slots {
55         address userAddress;
56         uint referrerID;
57         uint eventsCount;
58     }
59     
60     struct UsersPool5 {
61         uint id;
62         uint referrerID;
63         uint reinvestCount;
64     }
65     
66     struct Pool_5_Slots {
67         address userAddress;
68         uint referrerID;
69         uint eventsCount;
70     }
71     
72     struct UsersPool6 {
73         uint id;
74         uint referrerID;
75         uint reinvestCount;
76     }
77     
78     struct Pool_6_Slots {
79         address userAddress;
80         uint referrerID;
81         uint eventsCount;
82     }
83     
84     struct UsersPool7 {
85         uint id;
86         uint referrerID;
87         uint reinvestCount;
88     }
89     
90     struct Pool_7_Slots {
91         address userAddress;
92         uint referrerID;
93         uint eventsCount;
94     }
95     
96     modifier validReferrerID(uint _referrerID) {
97         require(_referrerID > 0 && _referrerID < newUserId, 'Invalid referrer ID');
98         _;
99     }
100     
101     event RegisterUserEvent(uint userId, address indexed user, address indexed referrer, uint time, uint8 indexed autopool, uint amount);
102     event DistributeUplineEvent(uint amount, address indexed sponsor, uint level, uint time);
103 
104     mapping(address => User) public users;
105     
106     mapping(address => UsersPool2) public users_2;
107     mapping(uint => Pool_2_Slots) public pool_slots_2;
108     
109     mapping(address => UsersPool3) public users_3;
110     mapping(uint => Pool_3_Slots) public pool_slots_3;
111     
112     mapping(address => UsersPool4) public users_4;
113     mapping(uint => Pool_4_Slots) public pool_slots_4;
114     
115     mapping(address => UsersPool5) public users_5;
116     mapping(uint => Pool_5_Slots) public pool_slots_5;
117     
118     mapping(address => UsersPool6) public users_6;
119     mapping(uint => Pool_6_Slots) public pool_slots_6;
120     
121     mapping(address => UsersPool7) public users_7;
122     mapping(uint => Pool_7_Slots) public pool_slots_7;
123     
124     mapping(uint => address) public idToAddress;
125     mapping(address => uint) public balances;
126     
127     mapping (uint => uint) public uplineAmount;
128     
129     uint public newUserId = 1;
130     uint public newUserId_ap2 = 1;
131     uint public activeSlot_ap2 = 1;
132     uint public newUserId_ap3 = 1;
133     uint public activeSlot_ap3 = 1;
134     uint public newUserId_ap4 = 1;
135     uint public activeSlot_ap4 = 1;
136     uint public newUserId_ap5 = 1;
137     uint public activeSlot_ap5 = 1;
138     uint public newUserId_ap6 = 1;
139     uint public activeSlot_ap6 = 1;
140     uint public newUserId_ap7 = 1;
141     uint public activeSlot_ap7 = 1;
142     
143     address public owner;
144     
145     constructor(address _ownerAddress) public {
146         
147         uplineAmount[1] = 50;
148         uplineAmount[2] = 25;
149         uplineAmount[3] = 15;
150         uplineAmount[4] = 10;
151         
152         owner = _ownerAddress;
153         
154         User memory user = User({
155             id: newUserId,
156             referrerCount: uint(0),
157             referrerID: uint(0),
158             referrals: new address[](0)
159         });
160         
161         users[_ownerAddress] = user;
162         idToAddress[newUserId] = _ownerAddress;
163         newUserId++;
164         
165         //////
166         
167         UsersPool2 memory user2 = UsersPool2({
168             id: newUserId_ap2,
169             referrerID: uint(0),
170             reinvestCount: uint(0)
171         });
172         
173         users_2[_ownerAddress] = user2;
174         
175         Pool_2_Slots memory _newslot2 = Pool_2_Slots({
176             userAddress: _ownerAddress,
177             referrerID: uint(0),
178             eventsCount: uint(0)
179         });
180         
181         pool_slots_2[newUserId_ap2] = _newslot2;
182         
183         newUserId_ap2++;
184         
185         //////
186         
187         UsersPool3 memory user3 = UsersPool3({
188             id: newUserId_ap3,
189             referrerID: uint(0),
190             reinvestCount: uint(0)
191         });
192         
193         users_3[_ownerAddress] = user3;
194         
195         Pool_3_Slots memory _newslot3 = Pool_3_Slots({
196             userAddress: _ownerAddress,
197             referrerID: uint(0),
198             eventsCount: uint(0)
199         });
200         
201         pool_slots_3[newUserId_ap3] = _newslot3;
202         
203         newUserId_ap3++;
204         
205         //////
206         
207         UsersPool4 memory user4 = UsersPool4({
208             id: newUserId_ap4,
209             referrerID: uint(0),
210             reinvestCount: uint(0)
211         });
212         
213         users_4[_ownerAddress] = user4;
214         
215         Pool_4_Slots memory _newslot4 = Pool_4_Slots({
216             userAddress: _ownerAddress,
217             referrerID: uint(0),
218             eventsCount: uint(0)
219         });
220         
221         pool_slots_4[newUserId_ap4] = _newslot4;
222         
223         newUserId_ap4++;
224         
225         //////
226         
227         UsersPool5 memory user5 = UsersPool5({
228             id: newUserId_ap5,
229             referrerID: uint(0),
230             reinvestCount: uint(0)
231         });
232         
233         users_5[_ownerAddress] = user5;
234         
235         Pool_5_Slots memory _newslot5 = Pool_5_Slots({
236             userAddress: _ownerAddress,
237             referrerID: uint(0),
238             eventsCount: uint(0)
239         });
240         
241         pool_slots_5[newUserId_ap5] = _newslot5;
242         
243         newUserId_ap5++;
244         
245         //////
246         
247         UsersPool6 memory user6 = UsersPool6({
248             id: newUserId_ap6,
249             referrerID: uint(0),
250             reinvestCount: uint(0)
251         });
252         
253         users_6[_ownerAddress] = user6;
254         
255         Pool_6_Slots memory _newslot6 = Pool_6_Slots({
256             userAddress: _ownerAddress,
257             referrerID: uint(0),
258             eventsCount: uint(0)
259         });
260         
261         pool_slots_6[newUserId_ap6] = _newslot6;
262         
263         newUserId_ap6++;
264         
265         //////
266                 
267         UsersPool7 memory user7 = UsersPool7({
268             id: newUserId_ap7,
269             referrerID: uint(0),
270             reinvestCount: uint(0)
271         });
272         
273         users_7[_ownerAddress] = user7;
274         
275         Pool_7_Slots memory _newslot7 = Pool_7_Slots({
276             userAddress: _ownerAddress,
277             referrerID: uint(0),
278             eventsCount: uint(0)
279         });
280         
281         pool_slots_7[newUserId_ap7] = _newslot7;
282         
283         newUserId_ap7++;
284         
285     }
286     
287     function participatePool1(uint _referrerId) 
288       public 
289       payable 
290       validReferrerID(_referrerId) 
291     {
292         
293         require(msg.value == 0.1 ether, "Participation fee is 0.1 ETH");
294         require(!isUserExists(msg.sender), "User already registered");
295 
296         address _userAddress = msg.sender;
297         
298         uint32 size;
299         assembly {
300             size := extcodesize(_userAddress)
301         }
302         require(size == 0, "cannot be a contract");
303         
304         users[_userAddress] = User({
305             id: newUserId,
306             referrerCount: uint(0),
307             referrerID: _referrerId,
308             referrals: new address[](0)
309         });
310         idToAddress[newUserId] = _userAddress;
311         emit RegisterUserEvent(newUserId, msg.sender, idToAddress[_referrerId], now, 2, msg.value);
312         
313         newUserId++;
314         
315         users[idToAddress[_referrerId]].referrals.push(_userAddress);
316         users[idToAddress[_referrerId]].referrerCount++;
317         
318         uint amountToDistribute = msg.value;
319         address sponsorAddress = idToAddress[_referrerId];        
320         
321         for (uint32 i = 1; i <= 4; i++) {
322             
323             if ( isUserExists(sponsorAddress) ) {
324                 amountToDistribute -= payUpline(sponsorAddress, i);
325                 address _nextSponsorAddress = idToAddress[users[sponsorAddress].referrerID];
326                 sponsorAddress = _nextSponsorAddress;
327             }
328             
329         }
330         
331         if (amountToDistribute > 0) {
332             payFirstLine(idToAddress[1], amountToDistribute);
333         }
334         
335     }
336     
337     function participatePool2() 
338       public 
339       payable 
340     {
341         require(msg.value == 0.2 ether, "Participation fee in Autopool is 0.2 ETH");
342         require(isUserExists(msg.sender), "User not present in AP1");
343         require(isUserQualified(msg.sender), "User not qualified in AP1");
344         require(!isUserExists2(msg.sender), "User already registered in AP2");
345         
346         uint _referrerId = users[msg.sender].referrerID;
347         
348         UsersPool2 memory user2 = UsersPool2({
349             id: newUserId_ap2,
350             referrerID: _referrerId,
351             reinvestCount: uint(0)
352         });
353         users_2[msg.sender] = user2;
354         
355         Pool_2_Slots memory _newslot = Pool_2_Slots({
356             userAddress: msg.sender,
357             referrerID: _referrerId,
358             eventsCount: uint(0)
359         });
360         
361         pool_slots_2[newUserId_ap2] = _newslot;
362         emit RegisterUserEvent(newUserId_ap2, msg.sender, idToAddress[_referrerId], now, 2, msg.value);
363         
364         newUserId_ap2++;
365         
366         uint eventCount = pool_slots_2[activeSlot_ap2].eventsCount;
367         uint newEventCount = eventCount + 1;
368 
369         if (newEventCount == 3) {
370 
371             Pool_2_Slots memory _reinvestslot = Pool_2_Slots({
372                 userAddress: pool_slots_2[activeSlot_ap2].userAddress,
373                 referrerID: pool_slots_2[activeSlot_ap2].referrerID,
374                 eventsCount: uint(0)
375             });
376             
377             pool_slots_2[newUserId_ap2] = _reinvestslot;
378             emit RegisterUserEvent(newUserId_ap2, pool_slots_2[activeSlot_ap2].userAddress, idToAddress[pool_slots_2[activeSlot_ap2].referrerID], now, 2, msg.value);
379         
380             newUserId_ap2++;
381             activeSlot_ap2++;
382             
383             payUpline(idToAddress[_referrerId], 1);
384             
385             if (pool_slots_2[activeSlot_ap2].referrerID > 0)
386                 payUpline(idToAddress[pool_slots_2[activeSlot_ap2].referrerID], 1);
387             else 
388                 payUpline(idToAddress[1], 1);
389             
390         }
391         
392         if (eventCount < 3) {
393             
394             if(eventCount == 0) {
395                 payUpline(pool_slots_2[activeSlot_ap2].userAddress, 1);
396                 payUpline(idToAddress[_referrerId], 1);
397             }
398             if(eventCount == 1) {
399                 payUpline(idToAddress[_referrerId], 1);
400                 
401                 if (pool_slots_2[activeSlot_ap2].referrerID > 0)
402                     payUpline(idToAddress[pool_slots_2[activeSlot_ap2].referrerID], 1);
403                 else 
404                     payUpline(idToAddress[1], 1);
405             }
406 
407             pool_slots_2[activeSlot_ap2].eventsCount++;
408             
409         }
410         
411     }
412     
413     function participatePool3() 
414       public 
415       payable 
416     {
417         require(msg.value == 0.3 ether, "Participation fee in Autopool is 0.3 ETH");
418         require(isUserExists(msg.sender), "User not present in AP1");
419         require(isUserQualified(msg.sender), "User not qualified in AP1");
420         require(!isUserExists3(msg.sender), "User already registered in AP3");
421         
422         uint _referrerId = users[msg.sender].referrerID;
423         
424         UsersPool3 memory user3 = UsersPool3({
425             id: newUserId_ap3,
426             referrerID: _referrerId,
427             reinvestCount: uint(0)
428         });
429         users_3[msg.sender] = user3;
430         
431         Pool_3_Slots memory _newslot = Pool_3_Slots({
432             userAddress: msg.sender,
433             referrerID: _referrerId,
434             eventsCount: uint(0)
435         });
436         
437         pool_slots_3[newUserId_ap3] = _newslot;
438         emit RegisterUserEvent(newUserId_ap3, msg.sender, idToAddress[_referrerId], now, 3, msg.value);
439         
440         newUserId_ap3++;
441         
442         uint eventCount = pool_slots_3[activeSlot_ap3].eventsCount;
443         uint newEventCount = eventCount + 1;
444 
445         if (newEventCount == 3) {
446 
447             Pool_3_Slots memory _reinvestslot = Pool_3_Slots({
448                 userAddress: pool_slots_3[activeSlot_ap3].userAddress,
449                 referrerID: pool_slots_3[activeSlot_ap3].referrerID,
450                 eventsCount: uint(0)
451             });
452             
453             pool_slots_3[newUserId_ap3] = _reinvestslot;
454             emit RegisterUserEvent(newUserId_ap3, pool_slots_3[activeSlot_ap3].userAddress, idToAddress[pool_slots_3[activeSlot_ap3].referrerID], now, 3, msg.value);
455         
456             newUserId_ap3++;
457             activeSlot_ap3++;
458             
459             payUpline(idToAddress[_referrerId], 1);
460             
461             if (pool_slots_3[activeSlot_ap3].referrerID > 0)
462                 payUpline(idToAddress[pool_slots_3[activeSlot_ap3].referrerID], 1);
463             else 
464                 payUpline(idToAddress[1], 1);
465             
466         }
467         
468         if (eventCount < 3) {
469             
470             if(eventCount == 0) {
471                 payUpline(pool_slots_3[activeSlot_ap3].userAddress, 1);
472                 payUpline(idToAddress[_referrerId], 1);
473             }
474             if(eventCount == 1) {
475                 payUpline(idToAddress[_referrerId], 1);
476                 
477                 if (pool_slots_3[activeSlot_ap3].referrerID > 0)
478                     payUpline(idToAddress[pool_slots_3[activeSlot_ap3].referrerID], 1);
479                 else 
480                     payUpline(idToAddress[1], 1);
481             }
482 
483             pool_slots_3[activeSlot_ap3].eventsCount++;
484             
485         }
486         
487     }
488     
489     function participatePool4() 
490       public 
491       payable 
492     {
493         require(msg.value == 0.4 ether, "Participation fee in Autopool is 0.4 ETH");
494         require(isUserExists(msg.sender), "User not present in AP1");
495         require(isUserQualified(msg.sender), "User not qualified in AP1");
496         require(!isUserExists4(msg.sender), "User already registered in AP4");
497         
498         uint _referrerId = users[msg.sender].referrerID;
499         
500         UsersPool4 memory user4 = UsersPool4({
501             id: newUserId_ap4,
502             referrerID: _referrerId,
503             reinvestCount: uint(0)
504         });
505         users_4[msg.sender] = user4;
506         
507         Pool_4_Slots memory _newslot = Pool_4_Slots({
508             userAddress: msg.sender,
509             referrerID: _referrerId,
510             eventsCount: uint(0)
511         });
512         
513         pool_slots_4[newUserId_ap4] = _newslot;
514         emit RegisterUserEvent(newUserId_ap4, msg.sender, idToAddress[_referrerId], now, 4, msg.value);
515         
516         newUserId_ap4++;
517         
518         uint eventCount = pool_slots_4[activeSlot_ap4].eventsCount;
519         uint newEventCount = eventCount + 1;
520 
521         if (newEventCount == 3) {
522 
523             Pool_4_Slots memory _reinvestslot = Pool_4_Slots({
524                 userAddress: pool_slots_4[activeSlot_ap4].userAddress,
525                 referrerID: pool_slots_4[activeSlot_ap4].referrerID,
526                 eventsCount: uint(0)
527             });
528             
529             pool_slots_4[newUserId_ap4] = _reinvestslot;
530             emit RegisterUserEvent(newUserId_ap4, pool_slots_4[activeSlot_ap4].userAddress, idToAddress[pool_slots_4[activeSlot_ap4].referrerID], now, 4, msg.value);
531         
532             newUserId_ap4++;
533             activeSlot_ap4++;
534             
535             payUpline(idToAddress[_referrerId], 1);
536             
537             if (pool_slots_4[activeSlot_ap4].referrerID > 0)
538                 payUpline(idToAddress[pool_slots_4[activeSlot_ap4].referrerID], 1);
539             else 
540                 payUpline(idToAddress[1], 1);
541             
542         }
543         
544         if (eventCount < 3) {
545             
546             if(eventCount == 0) {
547                 payUpline(pool_slots_4[activeSlot_ap4].userAddress, 1);
548                 payUpline(idToAddress[_referrerId], 1);
549             }
550             if(eventCount == 1) {
551                 payUpline(idToAddress[_referrerId], 1);
552                 
553                 if (pool_slots_4[activeSlot_ap4].referrerID > 0)
554                     payUpline(idToAddress[pool_slots_4[activeSlot_ap4].referrerID], 1);
555                 else 
556                     payUpline(idToAddress[1], 1);
557             }
558 
559             pool_slots_4[activeSlot_ap4].eventsCount++;
560             
561         }
562         
563     }
564     
565     function participatePool5() 
566       public 
567       payable 
568     {
569         require(msg.value == 0.5 ether, "Participation fee in Autopool is 0.5 ETH");
570         require(isUserExists(msg.sender), "User not present in AP1");
571         require(isUserQualified(msg.sender), "User not qualified in AP1");
572         require(!isUserExists5(msg.sender), "User already registered in AP5");
573         
574         uint _referrerId = users[msg.sender].referrerID;
575         
576         UsersPool5 memory user5 = UsersPool5({
577             id: newUserId_ap5,
578             referrerID: _referrerId,
579             reinvestCount: uint(0)
580         });
581         users_5[msg.sender] = user5;
582         
583         Pool_5_Slots memory _newslot = Pool_5_Slots({
584             userAddress: msg.sender,
585             referrerID: _referrerId,
586             eventsCount: uint(0)
587         });
588         
589         pool_slots_5[newUserId_ap5] = _newslot;
590         emit RegisterUserEvent(newUserId_ap5, msg.sender, idToAddress[_referrerId], now, 5, msg.value);
591         
592         newUserId_ap5++;
593         
594         uint eventCount = pool_slots_5[activeSlot_ap5].eventsCount;
595         uint newEventCount = eventCount + 1;
596 
597         if (newEventCount == 3) {
598 
599             Pool_5_Slots memory _reinvestslot = Pool_5_Slots({
600                 userAddress: pool_slots_5[activeSlot_ap5].userAddress,
601                 referrerID: pool_slots_5[activeSlot_ap5].referrerID,
602                 eventsCount: uint(0)
603             });
604             
605             pool_slots_5[newUserId_ap5] = _reinvestslot;
606             emit RegisterUserEvent(newUserId_ap5, pool_slots_5[activeSlot_ap5].userAddress, idToAddress[pool_slots_5[activeSlot_ap5].referrerID], now, 5, msg.value);
607         
608             newUserId_ap5++;
609             activeSlot_ap5++;
610             
611             payUpline(idToAddress[_referrerId], 1);
612             
613             if (pool_slots_5[activeSlot_ap5].referrerID > 0)
614                 payUpline(idToAddress[pool_slots_5[activeSlot_ap5].referrerID], 1);
615             else 
616                 payUpline(idToAddress[1], 1);
617             
618         }
619         
620         if (eventCount < 3) {
621             
622             if(eventCount == 0) {
623                 payUpline(pool_slots_5[activeSlot_ap5].userAddress, 1);
624                 payUpline(idToAddress[_referrerId], 1);
625             }
626             if(eventCount == 1) {
627                 payUpline(idToAddress[_referrerId], 1);
628                 
629                 if (pool_slots_5[activeSlot_ap5].referrerID > 0)
630                     payUpline(idToAddress[pool_slots_5[activeSlot_ap5].referrerID], 1);
631                 else 
632                     payUpline(idToAddress[1], 1);
633             }
634 
635             pool_slots_5[activeSlot_ap5].eventsCount++;
636             
637         }
638         
639     }
640     
641     function participatePool6() 
642       public 
643       payable 
644     {
645         require(msg.value == 0.7 ether, "Participation fee in Autopool is 0.7 ETH");
646         require(isUserExists(msg.sender), "User not present in AP1");
647         require(isUserQualified(msg.sender), "User not qualified in AP1");
648         require(!isUserExists6(msg.sender), "User already registered in AP6");
649         
650         uint _referrerId = users[msg.sender].referrerID;
651         
652         UsersPool6 memory user6 = UsersPool6({
653             id: newUserId_ap6,
654             referrerID: _referrerId,
655             reinvestCount: uint(0)
656         });
657         users_6[msg.sender] = user6;
658         
659         Pool_6_Slots memory _newslot = Pool_6_Slots({
660             userAddress: msg.sender,
661             referrerID: _referrerId,
662             eventsCount: uint(0)
663         });
664         
665         pool_slots_6[newUserId_ap6] = _newslot;
666         emit RegisterUserEvent(newUserId_ap6, msg.sender, idToAddress[_referrerId], now, 6, msg.value);
667         
668         newUserId_ap6++;
669         
670         uint eventCount = pool_slots_6[activeSlot_ap6].eventsCount;
671         uint newEventCount = eventCount + 1;
672 
673         if (newEventCount == 3) {
674 
675             Pool_6_Slots memory _reinvestslot = Pool_6_Slots({
676                 userAddress: pool_slots_6[activeSlot_ap6].userAddress,
677                 referrerID: pool_slots_6[activeSlot_ap6].referrerID,
678                 eventsCount: uint(0)
679             });
680             
681             pool_slots_6[newUserId_ap6] = _reinvestslot;
682             emit RegisterUserEvent(newUserId_ap6, pool_slots_6[activeSlot_ap6].userAddress, idToAddress[pool_slots_6[activeSlot_ap6].referrerID], now, 6, msg.value);
683         
684             newUserId_ap6++;
685             activeSlot_ap6++;
686             
687             payUpline(idToAddress[_referrerId], 1);
688             
689             if (pool_slots_6[activeSlot_ap6].referrerID > 0)
690                 payUpline(idToAddress[pool_slots_6[activeSlot_ap6].referrerID], 1);
691             else 
692                 payUpline(idToAddress[1], 1);
693             
694         }
695         
696         if (eventCount < 3) {
697             
698             if(eventCount == 0) {
699                 payUpline(pool_slots_6[activeSlot_ap6].userAddress, 1);
700                 payUpline(idToAddress[_referrerId], 1);
701             }
702             if(eventCount == 1) {
703                 payUpline(idToAddress[_referrerId], 1);
704                 
705                 if (pool_slots_6[activeSlot_ap6].referrerID > 0)
706                     payUpline(idToAddress[pool_slots_6[activeSlot_ap6].referrerID], 1);
707                 else 
708                     payUpline(idToAddress[1], 1);
709             }
710 
711             pool_slots_6[activeSlot_ap6].eventsCount++;
712             
713         }
714         
715     }
716     
717     function participatePool7() 
718       public 
719       payable 
720     {
721         require(msg.value == 1 ether, "Participation fee in Autopool is 1 ETH");
722         require(isUserExists(msg.sender), "User not present in AP1");
723         require(isUserQualified(msg.sender), "User not qualified in AP1");
724         require(!isUserExists7(msg.sender), "User already registered in AP7");
725         
726         uint _referrerId = users[msg.sender].referrerID;
727         
728         UsersPool7 memory user7 = UsersPool7({
729             id: newUserId_ap7,
730             referrerID: _referrerId,
731             reinvestCount: uint(0)
732         });
733         users_7[msg.sender] = user7;
734         
735         Pool_7_Slots memory _newslot = Pool_7_Slots({
736             userAddress: msg.sender,
737             referrerID: _referrerId,
738             eventsCount: uint(0)
739         });
740         
741         pool_slots_7[newUserId_ap7] = _newslot;
742         emit RegisterUserEvent(newUserId_ap7, msg.sender, idToAddress[_referrerId], now, 7, msg.value);
743         
744         newUserId_ap7++;
745         
746         uint eventCount = pool_slots_7[activeSlot_ap7].eventsCount;
747         uint newEventCount = eventCount + 1;
748 
749         if (newEventCount == 3) {
750 
751             Pool_7_Slots memory _reinvestslot = Pool_7_Slots({
752                 userAddress: pool_slots_7[activeSlot_ap7].userAddress,
753                 referrerID: pool_slots_7[activeSlot_ap7].referrerID,
754                 eventsCount: uint(0)
755             });
756             
757             pool_slots_7[newUserId_ap7] = _reinvestslot;
758             emit RegisterUserEvent(newUserId_ap7, pool_slots_7[activeSlot_ap7].userAddress, idToAddress[pool_slots_7[activeSlot_ap7].referrerID], now, 7, msg.value);
759         
760             newUserId_ap7++;
761             activeSlot_ap7++;
762             
763             payUpline(idToAddress[_referrerId], 1);
764             
765             if (pool_slots_7[activeSlot_ap7].referrerID > 0)
766                 payUpline(idToAddress[pool_slots_7[activeSlot_ap7].referrerID], 1);
767             else 
768                 payUpline(idToAddress[1], 1);
769             
770         }
771         
772         if (eventCount < 3) {
773             
774             if(eventCount == 0) {
775                 payUpline(pool_slots_7[activeSlot_ap7].userAddress, 1);
776                 payUpline(idToAddress[_referrerId], 1);
777             }
778             if(eventCount == 1) {
779                 payUpline(idToAddress[_referrerId], 1);
780                 
781                 if (pool_slots_7[activeSlot_ap7].referrerID > 0)
782                     payUpline(idToAddress[pool_slots_7[activeSlot_ap7].referrerID], 1);
783                 else 
784                     payUpline(idToAddress[1], 1);
785             }
786 
787             pool_slots_7[activeSlot_ap7].eventsCount++;
788             
789         }
790         
791     }
792     
793     
794     function payUpline(address _sponsorAddress, uint _refLevel) private returns (uint distributeAmount) {
795         
796         require( _refLevel <= 4);
797         distributeAmount = msg.value / 100 * uplineAmount[_refLevel];
798         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
799             balances[_sponsorAddress] += distributeAmount;
800             emit DistributeUplineEvent(distributeAmount, _sponsorAddress, _refLevel, now);
801         }
802         
803         return distributeAmount;
804 
805     }
806     
807     function payFirstLine(address _sponsorAddress, uint payAmount) private returns (uint distributeAmount) {
808         
809         distributeAmount = payAmount;
810         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
811             balances[_sponsorAddress] += distributeAmount;
812             emit DistributeUplineEvent(distributeAmount, _sponsorAddress, 1, now);
813         }
814         
815         return distributeAmount;
816         
817     }
818     
819     function isUserQualified(address _userAddress) public view returns (bool) {
820         return (users[_userAddress].referrerCount > 0);
821     }
822     
823     function isUserExists(address _userAddress) public view returns (bool) {
824         return (users[_userAddress].id != 0);
825     }
826     
827     function isUserExists2(address _userAddress) public view returns (bool) {
828         return (users_2[_userAddress].id != 0);
829     }
830     
831     function isUserExists3(address _userAddress) public view returns (bool) {
832         return (users_3[_userAddress].id != 0);
833     }
834     
835     function isUserExists4(address _userAddress) public view returns (bool) {
836         return (users_4[_userAddress].id != 0);
837     }
838     
839     function isUserExists5(address _userAddress) public view returns (bool) {
840         return (users_5[_userAddress].id != 0);
841     }
842     
843     function isUserExists6(address _userAddress) public view returns (bool) {
844         return (users_6[_userAddress].id != 0);
845     }
846     
847     function isUserExists7(address _userAddress) public view returns (bool) {
848         return (users_7[_userAddress].id != 0);
849     }
850     
851     function getUserReferrals(address _userAddress)
852         public
853         view
854         returns (address[] memory)
855       {
856         return users[_userAddress].referrals;
857       }
858     
859 }