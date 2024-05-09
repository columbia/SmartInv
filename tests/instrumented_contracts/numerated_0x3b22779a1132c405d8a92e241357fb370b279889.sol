1 /**
2 * ==========================================================
3 *
4 * XoXo Network
5 * FIRST EVER FULLY DECENTRALIZED GLOBAL POWERLINE AUTOPOOL
6 *
7 * Website  : https://xoxonetwork.io
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
20         uint referrerId;
21         uint earnedFromPool;
22         uint earnedFromRef;
23         uint earnedFromGlobal;
24         address[] referrals;
25     }
26     
27     struct UsersPool {
28         uint id;
29         uint referrerId;
30         uint reinvestCount;
31     }
32     
33     struct PoolSlots {
34         uint id;
35         address userAddress;
36         uint referrerId;
37         uint8 eventsCount;
38     }
39         
40     modifier validReferrerId(uint _referrerId) {
41         require((_referrerId > 0) && (_referrerId < newUserId), "Invalid referrer ID");
42         _;
43     }
44     
45     event RegisterUserEvent(uint _userid, address indexed _user, address indexed _referrerAddress, uint8 indexed _autopool, uint _amount, uint _time);
46     event ReinvestEvent(uint _userid, address indexed _user, address indexed _referrerAddress, uint8 indexed _autopool, uint _amount, uint _time);
47     event DistributeUplineEvent(uint amount, address indexed _sponsorAddress, address indexed _fromAddress, uint _level, uint8 _fromPool, uint _time);
48     event ReferralPaymentEvent(uint amount, address indexed _from, address indexed _to, uint8 indexed _fromPool, uint _time);
49 
50     mapping(address => User) public users;
51     mapping(address => UsersPool) public users_2;
52     mapping(uint => PoolSlots) public pool_slots_2;
53     mapping(address => UsersPool) public users_3;
54     mapping(uint => PoolSlots) public pool_slots_3;
55     mapping(address => UsersPool) public users_4;
56     mapping(uint => PoolSlots) public pool_slots_4;
57     mapping(address => UsersPool) public users_5;
58     mapping(uint => PoolSlots) public pool_slots_5;
59     mapping(address => UsersPool) public users_6;
60     mapping(uint => PoolSlots) public pool_slots_6;
61     mapping(address => UsersPool) public users_7;
62     mapping(uint => PoolSlots) public pool_slots_7;
63 
64     mapping(uint => address) public idToAddress;
65     mapping (uint8 => uint8) public uplineAmount;
66     
67     uint public newUserId = 1;
68     uint public newUserId_ap2 = 1;
69     uint public newUserId_ap3 = 1;
70     uint public newUserId_ap4 = 1;
71     uint public newUserId_ap5 = 1;
72     uint public newUserId_ap6 = 1;
73     uint public newUserId_ap7 = 1;
74 
75     uint public newSlotId_ap2 = 1;
76     uint public activeSlot_ap2 = 1;
77     uint public newSlotId_ap3 = 1;
78     uint public activeSlot_ap3 = 1;
79     uint public newSlotId_ap4 = 1;
80     uint public activeSlot_ap4 = 1;
81     uint public newSlotId_ap5 = 1;
82     uint public activeSlot_ap5 = 1;
83     uint public newSlotId_ap6 = 1;
84     uint public activeSlot_ap6 = 1;
85     uint public newSlotId_ap7 = 1;
86     uint public activeSlot_ap7 = 1;
87     
88     address public owner;
89     
90     constructor(address _ownerAddress) public {
91         
92         uplineAmount[1] = 50;
93         uplineAmount[2] = 25;
94         uplineAmount[3] = 15;
95         uplineAmount[4] = 10;
96         
97         owner = _ownerAddress;
98         
99         User memory user = User({
100             id: newUserId,
101             referrerCount: uint(0),
102             referrerId: uint(0),
103             earnedFromPool: uint(0),
104             earnedFromRef: uint(0),
105             earnedFromGlobal: uint(0),
106             referrals: new address[](0)
107         });
108         
109         users[_ownerAddress] = user;
110         idToAddress[newUserId] = _ownerAddress;
111         newUserId++;
112         
113         //////
114         
115         UsersPool memory user2 = UsersPool({
116             id: newSlotId_ap2,
117             referrerId: uint(0),
118             reinvestCount: uint(0)
119         });
120         
121         users_2[_ownerAddress] = user2;
122         
123         PoolSlots memory _newSlot2 = PoolSlots({
124             id: newSlotId_ap2,
125             userAddress: _ownerAddress,
126             referrerId: uint(0),
127             eventsCount: uint8(0)
128         });
129         
130         pool_slots_2[newSlotId_ap2] = _newSlot2;
131         newUserId_ap2++;
132         newSlotId_ap2++;
133         
134         ///////
135         
136         UsersPool memory user3 = UsersPool({
137             id: newSlotId_ap3,
138             referrerId: uint(0),
139             reinvestCount: uint(0)
140         });
141         
142         users_3[_ownerAddress] = user3;
143         
144         PoolSlots memory _newSlot3 = PoolSlots({
145             id: newSlotId_ap3,
146             userAddress: _ownerAddress,
147             referrerId: uint(0),
148             eventsCount: uint8(0)
149         });
150         
151         pool_slots_3[newSlotId_ap3] = _newSlot3;
152         newUserId_ap3++;
153         newSlotId_ap3++;
154         
155         ///////
156         
157         UsersPool memory user4 = UsersPool({
158             id: newSlotId_ap4,
159             referrerId: uint(0),
160             reinvestCount: uint(0)
161         });
162         
163         users_4[_ownerAddress] = user4;
164         
165         PoolSlots memory _newSlot4 = PoolSlots({
166             id: newSlotId_ap4,
167             userAddress: _ownerAddress,
168             referrerId: uint(0),
169             eventsCount: uint8(0)
170         });
171         
172         pool_slots_4[newSlotId_ap4] = _newSlot4;
173         newUserId_ap4++;
174         newSlotId_ap4++;
175         
176         ///////
177         
178         UsersPool memory user5 = UsersPool({
179             id: newSlotId_ap5,
180             referrerId: uint(0),
181             reinvestCount: uint(0)
182         });
183         
184         users_5[_ownerAddress] = user5;
185         
186         PoolSlots memory _newSlot5 = PoolSlots({
187             id: newSlotId_ap5,
188             userAddress: _ownerAddress,
189             referrerId: uint(0),
190             eventsCount: uint8(0)
191         });
192         
193         pool_slots_5[newSlotId_ap5] = _newSlot5;
194         newUserId_ap5++;
195         newSlotId_ap5++;
196         
197         ///////
198         
199         UsersPool memory user6 = UsersPool({
200             id: newSlotId_ap6,
201             referrerId: uint(0),
202             reinvestCount: uint(0)
203         });
204         
205         users_6[_ownerAddress] = user6;
206         
207         PoolSlots memory _newSlot6 = PoolSlots({
208             id: newSlotId_ap6,
209             userAddress: _ownerAddress,
210             referrerId: uint(0),
211             eventsCount: uint8(0)
212         });
213         
214         pool_slots_6[newSlotId_ap6] = _newSlot6;
215         newUserId_ap6++;
216         newSlotId_ap6++;
217         
218         ///////
219         
220         UsersPool memory user7 = UsersPool({
221             id: newSlotId_ap7,
222             referrerId: uint(0),
223             reinvestCount: uint(0)
224         });
225         
226         users_7[_ownerAddress] = user7;
227         
228         PoolSlots memory _newSlot7 = PoolSlots({
229             id: newSlotId_ap7,
230             userAddress: _ownerAddress,
231             referrerId: uint(0),
232             eventsCount: uint8(0)
233         });
234         
235         pool_slots_7[newSlotId_ap7] = _newSlot7;
236         newUserId_ap7++;
237         newSlotId_ap7++;
238     }
239     
240     function participatePool1(uint _referrerId) 
241       public 
242       payable 
243       validReferrerId(_referrerId) 
244     {
245         
246         require(msg.value == 0.1 ether, "Participation fee is 0.1 ETH");
247         require(!isUserExists(msg.sender, 1), "User already registered");
248 
249         address _userAddress = msg.sender;
250         address _referrerAddress = idToAddress[_referrerId];
251         
252         uint32 size;
253         assembly {
254             size := extcodesize(_userAddress)
255         }
256         require(size == 0, "cannot be a contract");
257         
258         users[_userAddress] = User({
259             id: newUserId,
260             referrerCount: uint(0),
261             referrerId: _referrerId,
262             earnedFromPool: uint(0),
263             earnedFromRef: uint(0),
264             earnedFromGlobal: uint(0),
265             referrals: new address[](0)
266         });
267         idToAddress[newUserId] = _userAddress;
268 
269         emit RegisterUserEvent(newUserId, msg.sender, _referrerAddress, 1, msg.value, now);
270         
271         newUserId++;
272         
273         users[_referrerAddress].referrals.push(_userAddress);
274         users[_referrerAddress].referrerCount++;
275         
276         uint amountToDistribute = msg.value;
277         address sponsorAddress = idToAddress[_referrerId];        
278         
279         for (uint8 i = 1; i <= 4; i++) {
280             
281             if ( isUserExists(sponsorAddress, 1) ) {
282                 uint paid = payUpline(sponsorAddress, i, 1);
283                 amountToDistribute -= paid;
284                 users[sponsorAddress].earnedFromPool += paid;
285                 address _nextSponsorAddress = idToAddress[users[sponsorAddress].referrerId];
286                 sponsorAddress = _nextSponsorAddress;
287             }
288             
289         }
290         
291         if (amountToDistribute > 0) {
292             payFirstLine(idToAddress[1], amountToDistribute, 1);
293             users[idToAddress[1]].earnedFromPool += amountToDistribute;
294         }
295         
296     }
297     
298     function participatePool2() 
299       public 
300       payable 
301     {
302         require(msg.value == 0.2 ether, "Participation fee in Autopool is 0.2 ETH");
303         require(isUserExists(msg.sender, 1), "User not present in AP1");
304         require(isUserQualified(msg.sender), "User not qualified in AP1");
305         require(!isUserExists(msg.sender, 2), "User already registered in AP2");
306 
307         uint eventCount = pool_slots_2[activeSlot_ap2].eventsCount;
308         uint newEventCount = eventCount + 1;
309 
310         if (newEventCount == 3) {
311             require(reinvestSlot(
312                 pool_slots_2[activeSlot_ap2].userAddress, 
313                 pool_slots_2[activeSlot_ap2].id, 
314                 idToAddress[users[pool_slots_2[activeSlot_ap2].userAddress].referrerId], 
315                 2
316             ));
317             pool_slots_2[activeSlot_ap2].eventsCount++;
318         }
319         
320         uint _referrerId = users[msg.sender].referrerId;
321 
322         UsersPool memory user2 = UsersPool({
323             id: newSlotId_ap2,
324             referrerId: _referrerId,
325             reinvestCount: uint(0)
326         });
327         users_2[msg.sender] = user2;
328         
329         PoolSlots memory _newSlot = PoolSlots({
330             id: newSlotId_ap2,
331             userAddress: msg.sender,
332             referrerId: _referrerId,
333             eventsCount: uint8(0)
334         });
335         
336         pool_slots_2[newSlotId_ap2] = _newSlot;
337         newUserId_ap2++;
338         emit RegisterUserEvent(newSlotId_ap2, msg.sender, idToAddress[_referrerId], 2, msg.value, now);
339         
340         if (_referrerId > 0) {
341             payUpline(idToAddress[_referrerId], 1, 2);
342             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
343         }
344         else{
345             payUpline(idToAddress[1], 1, 2);
346             users[idToAddress[1]].earnedFromRef += msg.value/2;
347         }
348 
349         newSlotId_ap2++;
350 
351         if (eventCount < 2) {
352             
353             if(eventCount == 0) {
354                 payUpline(pool_slots_2[activeSlot_ap2].userAddress, 1, 2);
355                 users[pool_slots_2[activeSlot_ap2].userAddress].earnedFromGlobal += msg.value/2;
356             }
357             if(eventCount == 1) {
358                 if (pool_slots_2[activeSlot_ap2].referrerId > 0) {
359                     payUpline(idToAddress[pool_slots_2[activeSlot_ap2].referrerId], 1, 2);
360                     users[idToAddress[pool_slots_2[activeSlot_ap2].referrerId]].earnedFromRef += msg.value/2;
361                 }
362                 else {
363                     payUpline(idToAddress[1], 1, 2);
364                     users[idToAddress[1]].earnedFromRef += msg.value/2;
365                 }
366             }
367 
368             pool_slots_2[activeSlot_ap2].eventsCount++;
369             
370         }
371         
372     }
373 
374     function participatePool3() 
375       public 
376       payable 
377     {
378         require(msg.value == 0.3 ether, "Participation fee in Autopool is 0.3 ETH");
379         require(isUserExists(msg.sender, 1), "User not present in AP1");
380         require(isUserQualified(msg.sender), "User not qualified in AP1");
381         require(!isUserExists(msg.sender, 3), "User already registered in AP3");
382 
383         uint eventCount = pool_slots_3[activeSlot_ap3].eventsCount;
384         uint newEventCount = eventCount + 1;
385 
386         if (newEventCount == 3) {
387             require(reinvestSlot(
388                 pool_slots_3[activeSlot_ap3].userAddress, 
389                 pool_slots_3[activeSlot_ap3].id, 
390                 idToAddress[users[pool_slots_3[activeSlot_ap3].userAddress].referrerId], 
391                 3
392             ));
393             pool_slots_3[activeSlot_ap3].eventsCount++;
394         }
395         
396         uint _referrerId = users[msg.sender].referrerId;
397 
398         UsersPool memory user3 = UsersPool({
399             id: newSlotId_ap3,
400             referrerId: _referrerId,
401             reinvestCount: uint(0)
402         });
403         users_3[msg.sender] = user3;
404         
405         PoolSlots memory _newSlot = PoolSlots({
406             id: newSlotId_ap3,
407             userAddress: msg.sender,
408             referrerId: _referrerId,
409             eventsCount: uint8(0)
410         });
411         
412         pool_slots_3[newSlotId_ap3] = _newSlot;
413         newUserId_ap3++;
414         emit RegisterUserEvent(newSlotId_ap3, msg.sender, idToAddress[_referrerId], 3, msg.value, now);
415         
416         if (_referrerId > 0) {
417             payUpline(idToAddress[_referrerId], 1, 3);
418             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
419         }
420         else{
421             payUpline(idToAddress[1], 1, 3);
422             users[idToAddress[1]].earnedFromRef += msg.value/2;
423         }
424 
425         newSlotId_ap3++;
426 
427         if (eventCount < 2) {
428             
429             if(eventCount == 0) {
430                 payUpline(pool_slots_3[activeSlot_ap3].userAddress, 1, 3);
431                 users[pool_slots_3[activeSlot_ap3].userAddress].earnedFromGlobal += msg.value/2;
432             }
433             if(eventCount == 1) {
434                 if (pool_slots_3[activeSlot_ap3].referrerId > 0) {
435                     payUpline(idToAddress[pool_slots_3[activeSlot_ap3].referrerId], 1, 3);
436                     users[idToAddress[pool_slots_3[activeSlot_ap3].referrerId]].earnedFromRef += msg.value/2;
437                 }
438                 else {
439                     payUpline(idToAddress[1], 1, 3);
440                     users[idToAddress[1]].earnedFromRef += msg.value/2;
441                 }
442             }
443 
444             pool_slots_3[activeSlot_ap3].eventsCount++;
445             
446         }
447         
448     }
449 
450     function participatePool4() 
451       public 
452       payable 
453     {
454         require(msg.value == 0.4 ether, "Participation fee in Autopool is 0.4 ETH");
455         require(isUserExists(msg.sender, 1), "User not present in AP1");
456         require(isUserQualified(msg.sender), "User not qualified in AP1");
457         require(!isUserExists(msg.sender, 4), "User already registered in AP4");
458 
459         uint eventCount = pool_slots_4[activeSlot_ap4].eventsCount;
460         uint newEventCount = eventCount + 1;
461 
462         if (newEventCount == 3) {
463             require(reinvestSlot(
464                 pool_slots_4[activeSlot_ap4].userAddress, 
465                 pool_slots_4[activeSlot_ap4].id, 
466                 idToAddress[users[pool_slots_4[activeSlot_ap4].userAddress].referrerId], 
467                 4
468             ));
469             pool_slots_4[activeSlot_ap4].eventsCount++;
470         }
471         
472         uint _referrerId = users[msg.sender].referrerId;
473 
474         UsersPool memory user4 = UsersPool({
475             id: newSlotId_ap4,
476             referrerId: _referrerId,
477             reinvestCount: uint(0)
478         });
479         users_4[msg.sender] = user4;
480         
481         PoolSlots memory _newSlot = PoolSlots({
482             id: newSlotId_ap4,
483             userAddress: msg.sender,
484             referrerId: _referrerId,
485             eventsCount: uint8(0)
486         });
487         
488         pool_slots_4[newSlotId_ap4] = _newSlot;
489         newUserId_ap4++;
490         emit RegisterUserEvent(newSlotId_ap4, msg.sender, idToAddress[_referrerId], 4, msg.value, now);
491         
492         if (_referrerId > 0) {
493             payUpline(idToAddress[_referrerId], 1, 4);
494             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
495         }
496         else{
497             payUpline(idToAddress[1], 1, 4);
498             users[idToAddress[1]].earnedFromRef += msg.value/2;
499         }
500 
501         newSlotId_ap4++;
502 
503         if (eventCount < 2) {
504             
505             if(eventCount == 0) {
506                 payUpline(pool_slots_4[activeSlot_ap4].userAddress, 1, 4);
507                 users[pool_slots_4[activeSlot_ap4].userAddress].earnedFromGlobal += msg.value/2;
508             }
509             if(eventCount == 1) {
510                 if (pool_slots_4[activeSlot_ap4].referrerId > 0) {
511                     payUpline(idToAddress[pool_slots_4[activeSlot_ap4].referrerId], 1, 4);
512                     users[idToAddress[pool_slots_4[activeSlot_ap4].referrerId]].earnedFromRef += msg.value/2;
513                 }
514                 else {
515                     payUpline(idToAddress[1], 1, 4);
516                     users[idToAddress[1]].earnedFromRef += msg.value/2;
517                 }
518             }
519 
520             pool_slots_4[activeSlot_ap4].eventsCount++;
521             
522         }
523         
524     }
525 
526     function participatePool5() 
527       public 
528       payable 
529     {
530         require(msg.value == 0.5 ether, "Participation fee in Autopool is 0.5 ETH");
531         require(isUserExists(msg.sender, 1), "User not present in AP1");
532         require(isUserQualified(msg.sender), "User not qualified in AP1");
533         require(!isUserExists(msg.sender, 5), "User already registered in AP5");
534 
535         uint eventCount = pool_slots_5[activeSlot_ap5].eventsCount;
536         uint newEventCount = eventCount + 1;
537 
538         if (newEventCount == 3) {
539             require(reinvestSlot(
540                 pool_slots_5[activeSlot_ap5].userAddress, 
541                 pool_slots_5[activeSlot_ap5].id, 
542                 idToAddress[users[pool_slots_5[activeSlot_ap5].userAddress].referrerId], 
543                 5
544             ));
545             pool_slots_5[activeSlot_ap5].eventsCount++;
546         }
547         
548         uint _referrerId = users[msg.sender].referrerId;
549 
550         UsersPool memory user5 = UsersPool({
551             id: newSlotId_ap5,
552             referrerId: _referrerId,
553             reinvestCount: uint(0)
554         });
555         users_5[msg.sender] = user5;
556         
557         PoolSlots memory _newSlot = PoolSlots({
558             id: newSlotId_ap5,
559             userAddress: msg.sender,
560             referrerId: _referrerId,
561             eventsCount: uint8(0)
562         });
563         
564         pool_slots_5[newSlotId_ap5] = _newSlot;
565         newUserId_ap5++;
566         emit RegisterUserEvent(newSlotId_ap5, msg.sender, idToAddress[_referrerId], 5, msg.value, now);
567         
568         if (_referrerId > 0) {
569             payUpline(idToAddress[_referrerId], 1, 5);
570             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
571         }
572         else{
573             payUpline(idToAddress[1], 1, 5);
574             users[idToAddress[1]].earnedFromRef += msg.value/2;
575         }
576 
577         newSlotId_ap5++;
578 
579         if (eventCount < 2) {
580             
581             if(eventCount == 0) {
582                 payUpline(pool_slots_5[activeSlot_ap5].userAddress, 1, 5);
583                 users[pool_slots_5[activeSlot_ap5].userAddress].earnedFromGlobal += msg.value/2;
584             }
585             if(eventCount == 1) {
586                 if (pool_slots_5[activeSlot_ap5].referrerId > 0) {
587                     payUpline(idToAddress[pool_slots_5[activeSlot_ap5].referrerId], 1, 5);
588                     users[idToAddress[pool_slots_5[activeSlot_ap5].referrerId]].earnedFromRef += msg.value/2;
589                 }
590                 else {
591                     payUpline(idToAddress[1], 1, 5);
592                     users[idToAddress[1]].earnedFromRef += msg.value/2;
593                 }
594             }
595 
596             pool_slots_5[activeSlot_ap5].eventsCount++;
597             
598         }
599         
600     }
601 
602     function participatePool6() 
603       public 
604       payable 
605     {
606         require(msg.value == 0.7 ether, "Participation fee in Autopool is 0.7 ETH");
607         require(isUserExists(msg.sender, 1), "User not present in AP1");
608         require(isUserQualified(msg.sender), "User not qualified in AP1");
609         require(!isUserExists(msg.sender, 6), "User already registered in AP6");
610 
611         uint eventCount = pool_slots_6[activeSlot_ap6].eventsCount;
612         uint newEventCount = eventCount + 1;
613 
614         if (newEventCount == 3) {
615             require(reinvestSlot(
616                 pool_slots_6[activeSlot_ap6].userAddress, 
617                 pool_slots_6[activeSlot_ap6].id, 
618                 idToAddress[users[pool_slots_6[activeSlot_ap6].userAddress].referrerId], 
619                 6
620             ));
621             pool_slots_6[activeSlot_ap6].eventsCount++;
622         }
623         
624         uint _referrerId = users[msg.sender].referrerId;
625 
626         UsersPool memory user6 = UsersPool({
627             id: newSlotId_ap6,
628             referrerId: _referrerId,
629             reinvestCount: uint(0)
630         });
631         users_6[msg.sender] = user6;
632         
633         PoolSlots memory _newSlot = PoolSlots({
634             id: newSlotId_ap6,
635             userAddress: msg.sender,
636             referrerId: _referrerId,
637             eventsCount: uint8(0)
638         });
639         
640         pool_slots_6[newSlotId_ap6] = _newSlot;
641         newUserId_ap6++;
642         emit RegisterUserEvent(newSlotId_ap6, msg.sender, idToAddress[_referrerId], 6, msg.value, now);
643         
644         if (_referrerId > 0) {
645             payUpline(idToAddress[_referrerId], 1, 6);
646             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
647         }
648         else{
649             payUpline(idToAddress[1], 1, 6);
650             users[idToAddress[1]].earnedFromRef += msg.value/2;
651         }
652 
653         newSlotId_ap6++;
654 
655         if (eventCount < 2) {
656             
657             if(eventCount == 0) {
658                 payUpline(pool_slots_6[activeSlot_ap6].userAddress, 1, 6);
659                 users[pool_slots_6[activeSlot_ap6].userAddress].earnedFromGlobal += msg.value/2;
660             }
661             if(eventCount == 1) {
662                 if (pool_slots_6[activeSlot_ap6].referrerId > 0) {
663                     payUpline(idToAddress[pool_slots_6[activeSlot_ap6].referrerId], 1, 6);
664                     users[idToAddress[pool_slots_6[activeSlot_ap6].referrerId]].earnedFromRef += msg.value/2;
665                 }
666                 else {
667                     payUpline(idToAddress[1], 1, 6);
668                     users[idToAddress[1]].earnedFromRef += msg.value/2;
669                 }
670             }
671 
672             pool_slots_6[activeSlot_ap6].eventsCount++;
673             
674         }
675         
676     }
677 
678     function participatePool7() 
679       public 
680       payable 
681     {
682         require(msg.value == 1 ether, "Participation fee in Autopool is 1 ETH");
683         require(isUserExists(msg.sender, 1), "User not present in AP1");
684         require(isUserQualified(msg.sender), "User not qualified in AP1");
685         require(!isUserExists(msg.sender, 7), "User already registered in AP7");
686 
687         uint eventCount = pool_slots_7[activeSlot_ap7].eventsCount;
688         uint newEventCount = eventCount + 1;
689 
690         if (newEventCount == 3) {
691             require(reinvestSlot(
692                 pool_slots_7[activeSlot_ap7].userAddress, 
693                 pool_slots_7[activeSlot_ap7].id, 
694                 idToAddress[users[pool_slots_7[activeSlot_ap7].userAddress].referrerId], 
695                 7
696             ));
697             pool_slots_7[activeSlot_ap7].eventsCount++;
698         }
699         
700         uint _referrerId = users[msg.sender].referrerId;
701 
702         UsersPool memory user7 = UsersPool({
703             id: newSlotId_ap7,
704             referrerId: _referrerId,
705             reinvestCount: uint(0)
706         });
707         users_7[msg.sender] = user7;
708         
709         PoolSlots memory _newSlot = PoolSlots({
710             id: newSlotId_ap7,
711             userAddress: msg.sender,
712             referrerId: _referrerId,
713             eventsCount: uint8(0)
714         });
715         
716         pool_slots_7[newSlotId_ap7] = _newSlot;
717         newUserId_ap7++;
718         emit RegisterUserEvent(newSlotId_ap7, msg.sender, idToAddress[_referrerId], 7, msg.value, now);
719 
720         if (_referrerId > 0) {
721             payUpline(idToAddress[_referrerId], 1, 7);
722             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
723         }
724         else{
725             payUpline(idToAddress[1], 1, 7);
726             users[idToAddress[1]].earnedFromRef += msg.value/2;
727         }
728         
729         newSlotId_ap7++;
730 
731         if (eventCount < 2) {
732             
733             if(eventCount == 0) {
734                 payUpline(pool_slots_7[activeSlot_ap7].userAddress, 1, 7);
735                 users[pool_slots_7[activeSlot_ap7].userAddress].earnedFromGlobal += msg.value/2;
736             }
737             if(eventCount == 1) {
738                 if (pool_slots_7[activeSlot_ap7].referrerId > 0) {
739                     payUpline(idToAddress[pool_slots_7[activeSlot_ap7].referrerId], 1, 7);
740                     users[idToAddress[pool_slots_7[activeSlot_ap7].referrerId]].earnedFromRef += msg.value/2;
741                 }
742                 else {
743                     payUpline(idToAddress[1], 1, 7);
744                     users[idToAddress[1]].earnedFromRef += msg.value/2;
745                 }
746             }
747 
748             pool_slots_7[activeSlot_ap7].eventsCount++;
749             
750         }
751         
752     }
753 
754     function reinvestSlot(address _userAddress, uint _userId, address _sponsorAddress, uint8 _fromPool) private returns (bool _isReinvested) {
755 
756         uint _referrerId = users[_userAddress].referrerId;
757 
758         PoolSlots memory _reinvestslot = PoolSlots({
759             id: _userId,
760             userAddress: _userAddress,
761             referrerId: _referrerId,
762             eventsCount: uint8(0)
763         });
764         
765         if (_fromPool == 2) {
766             users_2[pool_slots_2[activeSlot_ap2].userAddress].reinvestCount++;        
767             pool_slots_2[newSlotId_ap2] = _reinvestslot;
768             emit ReinvestEvent(newSlotId_ap2, _userAddress, _sponsorAddress, 2, msg.value, now);
769             newSlotId_ap2++;
770         }
771         if (_fromPool == 3) {
772             users_3[pool_slots_3[activeSlot_ap3].userAddress].reinvestCount++;        
773             pool_slots_3[newSlotId_ap3] = _reinvestslot;
774             emit ReinvestEvent(newSlotId_ap3, _userAddress, _sponsorAddress, 3, msg.value, now);
775             newSlotId_ap3++;
776         }
777         if (_fromPool == 4) {
778             users_4[pool_slots_4[activeSlot_ap4].userAddress].reinvestCount++;        
779             pool_slots_4[newSlotId_ap4] = _reinvestslot;
780             emit ReinvestEvent(newSlotId_ap4, _userAddress, _sponsorAddress, 4, msg.value, now);
781             newSlotId_ap4++;
782         }
783         if (_fromPool == 5) {
784             users_5[pool_slots_5[activeSlot_ap5].userAddress].reinvestCount++;        
785             pool_slots_5[newSlotId_ap5] = _reinvestslot;
786             emit ReinvestEvent(newSlotId_ap5, _userAddress, _sponsorAddress, 5, msg.value, now);
787             newSlotId_ap5++;
788         }
789         if (_fromPool == 6) {
790             users_6[pool_slots_6[activeSlot_ap6].userAddress].reinvestCount++;        
791             pool_slots_6[newSlotId_ap6] = _reinvestslot;
792             emit ReinvestEvent(newSlotId_ap6, _userAddress, _sponsorAddress, 6, msg.value, now);
793             newSlotId_ap6++;
794         }
795         if (_fromPool == 7) {
796             users_7[pool_slots_7[activeSlot_ap7].userAddress].reinvestCount++;        
797             pool_slots_7[newSlotId_ap7] = _reinvestslot;
798             emit ReinvestEvent(newSlotId_ap7, _userAddress, _sponsorAddress, 7, msg.value, now);
799             newSlotId_ap7++;
800         }
801         
802         if (_fromPool == 2) {
803             pool_slots_2[activeSlot_ap2].eventsCount = 3;
804             uint _nextActiveSlot = activeSlot_ap2+1;
805 
806             payUpline(pool_slots_2[_nextActiveSlot].userAddress, 1, 2);
807             users[pool_slots_2[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
808             activeSlot_ap2++;
809         }
810         if (_fromPool == 3) {
811             pool_slots_3[activeSlot_ap3].eventsCount = 3;
812             uint _nextActiveSlot = activeSlot_ap3+1;
813 
814             payUpline(pool_slots_3[_nextActiveSlot].userAddress, 1, 3);
815             users[pool_slots_3[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
816             activeSlot_ap3++;
817         }
818         if (_fromPool == 4) {
819             pool_slots_4[activeSlot_ap4].eventsCount = 3;
820             uint _nextActiveSlot = activeSlot_ap4+1;
821 
822             payUpline(pool_slots_4[_nextActiveSlot].userAddress, 1, 4);
823             users[pool_slots_4[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
824             activeSlot_ap4++;
825         }
826         if (_fromPool == 5) {
827             pool_slots_5[activeSlot_ap5].eventsCount = 3;
828             uint _nextActiveSlot = activeSlot_ap5+1;
829 
830             payUpline(pool_slots_5[_nextActiveSlot].userAddress, 1, 5);
831             users[pool_slots_5[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
832             activeSlot_ap5++;
833         }
834         if (_fromPool == 6) {
835             pool_slots_6[activeSlot_ap6].eventsCount = 3;
836             uint _nextActiveSlot = activeSlot_ap6+1;
837 
838             payUpline(pool_slots_6[_nextActiveSlot].userAddress, 1, 6);
839             users[pool_slots_6[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
840             activeSlot_ap6++;
841         }
842         if (_fromPool == 7) {
843             pool_slots_7[activeSlot_ap7].eventsCount = 3;
844             uint _nextActiveSlot = activeSlot_ap7+1;
845 
846             payUpline(pool_slots_7[_nextActiveSlot].userAddress, 1, 7);
847             users[pool_slots_7[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
848             activeSlot_ap7++;
849         }
850 
851         _isReinvested = true;
852 
853         return _isReinvested;
854 
855     }
856     
857     function payUpline(address _sponsorAddress, uint8 _refLevel, uint8 _fromPool) private returns (uint distributeAmount) {        
858         require( _refLevel <= 4);
859         distributeAmount = msg.value / 100 * uplineAmount[_refLevel];
860         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
861             if (_fromPool > 1) {
862                 emit ReferralPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, _fromPool, now);
863             } else
864                 emit DistributeUplineEvent(distributeAmount, _sponsorAddress, msg.sender, _refLevel, _fromPool, now);
865         }        
866         return distributeAmount;
867     }
868     
869     function payFirstLine(address _sponsorAddress, uint payAmount, uint8 _fromPool) private returns (uint distributeAmount) {        
870         distributeAmount = payAmount;
871         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
872             if (_fromPool > 1) {
873                 emit ReferralPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, _fromPool, now);
874             } else emit DistributeUplineEvent(distributeAmount, _sponsorAddress, msg.sender, 1, _fromPool, now);
875         }        
876         return distributeAmount;        
877     }
878     
879     function isUserQualified(address _userAddress) public view returns (bool) {
880         return (users[_userAddress].referrerCount > 0);
881     }
882     
883     function isUserExists(address _userAddress, uint8 _autopool) public view returns (bool) {
884         require((_autopool > 0) && (_autopool <= 7));
885         if (_autopool == 1) return (users[_userAddress].id != 0);
886         if (_autopool == 2) return (users_2[_userAddress].id != 0);
887         if (_autopool == 3) return (users_3[_userAddress].id != 0);
888         if (_autopool == 4) return (users_4[_userAddress].id != 0);
889         if (_autopool == 5) return (users_5[_userAddress].id != 0);
890         if (_autopool == 6) return (users_6[_userAddress].id != 0);
891         if (_autopool == 7) return (users_7[_userAddress].id != 0);
892     }
893     
894     function getUserReferrals(address _userAddress)
895         public
896         view
897         returns (address[] memory)
898       {
899         return users[_userAddress].referrals;
900       }
901     
902 }