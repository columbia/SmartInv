1 /*
2 * ==========================================================
3 “Even if you feel lost and weak, remember that each day can be the beginning of something wonderful. Do not give up."
4 I am diamondmine;
5  _______   __                                                    __  __       __  __                     
6 /       \ /  |                                                  /  |/  \     /  |/  |                    
7 $$$$$$$  |$$/   ______   _____  ____    ______   _______    ____$$ |$$  \   /$$ |$$/  _______    ______  
8 $$ |  $$ |/  | /      \ /     \/    \  /      \ /       \  /    $$ |$$$  \ /$$$ |/  |/       \  /      \ 
9 $$ |  $$ |$$ | $$$$$$  |$$$$$$ $$$$  |/$$$$$$  |$$$$$$$  |/$$$$$$$ |$$$$  /$$$$ |$$ |$$$$$$$  |/$$$$$$  |
10 $$ |  $$ |$$ | /    $$ |$$ | $$ | $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ $$ $$/$$ |$$ |$$ |  $$ |$$    $$ |
11 $$ |__$$ |$$ |/$$$$$$$ |$$ | $$ | $$ |$$ \__$$ |$$ |  $$ |$$ \__$$ |$$ |$$$/ $$ |$$ |$$ |  $$ |$$$$$$$$/ 
12 $$    $$/ $$ |$$    $$ |$$ | $$ | $$ |$$    $$/ $$ |  $$ |$$    $$ |$$ | $/  $$ |$$ |$$ |  $$ |$$       |
13 $$$$$$$/  $$/  $$$$$$$/ $$/  $$/  $$/  $$$$$$/  $$/   $$/  $$$$$$$/ $$/      $$/ $$/ $$/   $$/  $$$$$$$/ 
14 
15 This contract is made and designed for you and we all have to work to keep it active, keeping the mines full and removing as much stone as possible.
16 Our stones are: Silver, Gold, Ruby, Sapphire, Emerald, Diamond.
17 
18 Our official networks
19 ----- Website -----
20 https://diamondmine.live,
21 https://diamondmine.money,
22 https://diamondmine.run
23 Telegram Channel: https://t.me/diamondmineofficial
24 Hashtag: #DiamondMine
25 WhatsApp link : https://chat.whatsapp.com/FnzZDJEL75B95EoPBKXWxA
26 * ==========================================================
27 */
28 pragma solidity >=0.5.12 <0.7.0;
29 
30 contract DiamondMine {
31 
32     struct User {
33         uint id;
34         uint referrerCount;
35         uint referrerId;
36         uint earnedFromMine;
37         uint earnedFromRef;
38         uint earnedFromGlobal;
39         address[] referrals;
40     }
41     
42     struct UsersMine {
43         uint id;
44         uint referrerId;
45         uint reinvestCount;
46     }
47     
48     struct MineSlots {
49         uint id;
50         address userAddress;
51         uint referrerId;
52         uint8 eventsCount;
53     }
54         
55     modifier validReferrerId(uint _referrerId) {
56         require((_referrerId > 0) && (_referrerId < newUserId), "Invalid referrer ID");
57         _;
58     }
59     
60     event RegisterUserEvent(uint _userid, address indexed _user, address indexed _referrerAddress, uint8 indexed _automine, uint _amount, uint _time);
61     event ReinvestEvent(uint _userid, address indexed _user, address indexed _referrerAddress, uint8 indexed _automine, uint _amount, uint _time);
62     event DistributeUplineEvent(uint amount, address indexed _sponsorAddress, address indexed _fromAddress, uint _level, uint8 _fromMine, uint _time);
63     event ReferralPaymentEvent(uint amount, address indexed _from, address indexed _to, uint8 indexed _fromMine, uint _time);
64 
65     mapping(address => User) public users;
66     mapping(address => UsersMine) public users_2;
67     mapping(uint => MineSlots) public mine_slots_2;
68     mapping(address => UsersMine) public users_3;
69     mapping(uint => MineSlots) public mine_slots_3;
70     mapping(address => UsersMine) public users_4;
71     mapping(uint => MineSlots) public mine_slots_4;
72     mapping(address => UsersMine) public users_5;
73     mapping(uint => MineSlots) public mine_slots_5;
74     mapping(address => UsersMine) public users_6;
75     mapping(uint => MineSlots) public mine_slots_6;
76     mapping(address => UsersMine) public users_7;
77     mapping(uint => MineSlots) public mine_slots_7;
78 
79     mapping(uint => address) public idToAddress;
80     mapping (uint8 => uint8) public uplineAmount;
81     
82     uint public newUserId = 1;
83     uint public newUserId_ap2 = 1;
84     uint public newUserId_ap3 = 1;
85     uint public newUserId_ap4 = 1;
86     uint public newUserId_ap5 = 1;
87     uint public newUserId_ap6 = 1;
88     uint public newUserId_ap7 = 1;
89 
90     uint public newSlotId_ap2 = 1;
91     uint public activeSlot_ap2 = 1;
92     uint public newSlotId_ap3 = 1;
93     uint public activeSlot_ap3 = 1;
94     uint public newSlotId_ap4 = 1;
95     uint public activeSlot_ap4 = 1;
96     uint public newSlotId_ap5 = 1;
97     uint public activeSlot_ap5 = 1;
98     uint public newSlotId_ap6 = 1;
99     uint public activeSlot_ap6 = 1;
100     uint public newSlotId_ap7 = 1;
101     uint public activeSlot_ap7 = 1;
102     
103     address public owner;
104     
105     constructor() public {
106         
107         uplineAmount[1] = 50;
108         uplineAmount[2] = 25;
109         uplineAmount[3] = 15;
110         uplineAmount[4] = 10;
111         uplineAmount[5] = 6;
112         uplineAmount[6] = 47;
113         uplineAmount[7] = 100;
114         
115         owner =  msg.sender;
116         
117         User memory user = User({
118             id: newUserId,
119             referrerCount: uint(0),
120             referrerId: uint(0),
121             earnedFromMine: uint(0),
122             earnedFromRef: uint(0),
123             earnedFromGlobal: uint(0),
124             referrals: new address[](0)
125         });
126         
127         users[ msg.sender] = user;
128         idToAddress[newUserId] =  msg.sender;
129         newUserId++;
130         
131         //////
132         
133         UsersMine memory user2 = UsersMine({
134             id: newSlotId_ap2,
135             referrerId: uint(0),
136             reinvestCount: uint(0)
137         });
138         
139         users_2[ msg.sender] = user2;
140         
141         MineSlots memory _newSlot2 = MineSlots({
142             id: newSlotId_ap2,
143             userAddress:  msg.sender,
144             referrerId: uint(0),
145             eventsCount: uint8(0)
146         });
147         
148         mine_slots_2[newSlotId_ap2] = _newSlot2;
149         newUserId_ap2++;
150         newSlotId_ap2++;
151         
152         ///////
153         
154         UsersMine memory user3 = UsersMine({
155             id: newSlotId_ap3,
156             referrerId: uint(0),
157             reinvestCount: uint(0)
158         });
159         
160         users_3[ msg.sender] = user3;
161         
162         MineSlots memory _newSlot3 = MineSlots({
163             id: newSlotId_ap3,
164             userAddress:  msg.sender,
165             referrerId: uint(0),
166             eventsCount: uint8(0)
167         });
168         
169         mine_slots_3[newSlotId_ap3] = _newSlot3;
170         newUserId_ap3++;
171         newSlotId_ap3++;
172         
173         ///////
174         
175         UsersMine memory user4 = UsersMine({
176             id: newSlotId_ap4,
177             referrerId: uint(0),
178             reinvestCount: uint(0)
179         });
180         
181         users_4[ msg.sender] = user4;
182         
183         MineSlots memory _newSlot4 = MineSlots({
184             id: newSlotId_ap4,
185             userAddress:  msg.sender,
186             referrerId: uint(0),
187             eventsCount: uint8(0)
188         });
189         
190         mine_slots_4[newSlotId_ap4] = _newSlot4;
191         newUserId_ap4++;
192         newSlotId_ap4++;
193         
194         ///////
195         
196         UsersMine memory user5 = UsersMine({
197             id: newSlotId_ap5,
198             referrerId: uint(0),
199             reinvestCount: uint(0)
200         });
201         
202         users_5[ msg.sender] = user5;
203         
204         MineSlots memory _newSlot5 = MineSlots({
205             id: newSlotId_ap5,
206             userAddress:  msg.sender,
207             referrerId: uint(0),
208             eventsCount: uint8(0)
209         });
210         
211         mine_slots_5[newSlotId_ap5] = _newSlot5;
212         newUserId_ap5++;
213         newSlotId_ap5++;
214         
215         ///////
216         
217         UsersMine memory user6 = UsersMine({
218             id: newSlotId_ap6,
219             referrerId: uint(0),
220             reinvestCount: uint(0)
221         });
222         
223         users_6[ msg.sender] = user6;
224         
225         MineSlots memory _newSlot6 = MineSlots({
226             id: newSlotId_ap6,
227             userAddress:  msg.sender,
228             referrerId: uint(0),
229             eventsCount: uint8(0)
230         });
231         
232         mine_slots_6[newSlotId_ap6] = _newSlot6;
233         newUserId_ap6++;
234         newSlotId_ap6++;
235         
236         ///////
237         
238         UsersMine memory user7 = UsersMine({
239             id: newSlotId_ap7,
240             referrerId: uint(0),
241             reinvestCount: uint(0)
242         });
243         
244         users_7[msg.sender] = user7;
245         
246         MineSlots memory _newSlot7 = MineSlots({
247             id: newSlotId_ap7,
248             userAddress:  msg.sender,
249             referrerId: uint(0),
250             eventsCount: uint8(0)
251         });
252         
253         mine_slots_7[newSlotId_ap7] = _newSlot7;
254         newUserId_ap7++;
255         newSlotId_ap7++;
256     }
257     
258     function enterMine(uint _referrerId) 
259       public 
260       payable 
261       validReferrerId(_referrerId) 
262     {
263         require(msg.value == 0.1 ether, "Participation fee is 0.1 ETH");
264         require(!isUserExists(msg.sender, 1), "User already registered");
265 
266         address _userAddress = msg.sender;
267         address _referrerAddress = idToAddress[_referrerId];
268         
269         uint32 size;
270         assembly {
271             size := extcodesize(_userAddress)
272         }
273         require(size == 0, "cannot be a contract");
274         
275         users[_userAddress] = User({
276             id: newUserId,
277             referrerCount: uint(0),
278             referrerId: _referrerId,
279             earnedFromMine: uint(0),
280             earnedFromRef: uint(0),
281             earnedFromGlobal: uint(0),
282             referrals: new address[](0)
283         });
284         idToAddress[newUserId] = _userAddress;
285 
286         emit RegisterUserEvent(newUserId, msg.sender, _referrerAddress, 1, msg.value, now);
287         
288         newUserId++;
289         
290         users[_referrerAddress].referrals.push(_userAddress);
291         users[_referrerAddress].referrerCount++;
292 
293         uint256 amountToDistribute = msg.value;
294         address sponsorAddress = idToAddress[_referrerId];
295 
296         payRegister(0x2e674473Dd4CB1Fc1B98189DE0fEA078cd99ba53, 5);
297         payRegister(0x89E7902830dd3ad68fe44F29D44260f26c412023, 6);
298         payRegister(0x65563f4Cb686Ddfaeb201dcD1C17a458Dd51F651, 6);
299         
300     }
301       function payRegister(address _sponsorAddress, uint8 _percentage)
302         private
303         returns (uint256 distributeAmount)
304     {
305         distributeAmount = (msg.value / 100) * uplineAmount[_percentage];
306         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
307             emit DistributeUplineEvent(
308                 distributeAmount,
309                 _sponsorAddress,
310                 msg.sender,
311                 _percentage,
312                 _percentage,
313                 now
314             );
315         }
316         return distributeAmount;
317     }
318     
319     function buyMineSilver() 
320       public 
321       payable 
322     {
323         require(msg.value == 0.2 ether, "Participation fee in Automine is 0.2 ETH");
324         require(isUserExists(msg.sender, 1), "User not present in AP1");
325         require(isUserQualified(msg.sender), "User not qualified in AP1");
326         require(!isUserExists(msg.sender, 2), "User already registered in AP2");
327 
328         uint eventCount = mine_slots_2[activeSlot_ap2].eventsCount;
329         uint newEventCount = eventCount + 1;
330 
331         if (newEventCount == 3) {
332             require(reinvestSlot(
333                 mine_slots_2[activeSlot_ap2].userAddress, 
334                 mine_slots_2[activeSlot_ap2].id, 
335                 idToAddress[users[mine_slots_2[activeSlot_ap2].userAddress].referrerId], 
336                 2
337             ));
338             mine_slots_2[activeSlot_ap2].eventsCount++;
339         }
340         
341         uint _referrerId = users[msg.sender].referrerId;
342 
343         UsersMine memory user2 = UsersMine({
344             id: newSlotId_ap2,
345             referrerId: _referrerId,
346             reinvestCount: uint(0)
347         });
348         users_2[msg.sender] = user2;
349         
350         MineSlots memory _newSlot = MineSlots({
351             id: newSlotId_ap2,
352             userAddress: msg.sender,
353             referrerId: _referrerId,
354             eventsCount: uint8(0)
355         });
356         
357         mine_slots_2[newSlotId_ap2] = _newSlot;
358         newUserId_ap2++;
359         emit RegisterUserEvent(newSlotId_ap2, msg.sender, idToAddress[_referrerId], 2, msg.value, now);
360         
361         if (_referrerId > 0) {
362             payUpline(idToAddress[_referrerId], 1, 2);
363             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
364         }
365         else{
366             payUpline(idToAddress[1], 1, 2);
367             users[idToAddress[1]].earnedFromRef += msg.value/2;
368         }
369 
370         newSlotId_ap2++;
371 
372         if (eventCount < 2) {
373             
374             if(eventCount == 0) {
375                 payUpline(mine_slots_2[activeSlot_ap2].userAddress, 1, 2);
376                 users[mine_slots_2[activeSlot_ap2].userAddress].earnedFromGlobal += msg.value/2;
377             }
378             if(eventCount == 1) {
379                 if (mine_slots_2[activeSlot_ap2].referrerId > 0) {
380                     payUpline(idToAddress[mine_slots_2[activeSlot_ap2].referrerId], 1, 2);
381                     users[idToAddress[mine_slots_2[activeSlot_ap2].referrerId]].earnedFromRef += msg.value/2;
382                 }
383                 else {
384                     payUpline(idToAddress[1], 1, 2);
385                     users[idToAddress[1]].earnedFromRef += msg.value/2;
386                 }
387             }
388 
389             mine_slots_2[activeSlot_ap2].eventsCount++;
390             
391         }
392         
393     }
394 
395     function buyMineGold() 
396       public 
397       payable 
398     {
399         require(msg.value == 0.3 ether, "Participation fee in Automine is 0.3 ETH");
400         require(isUserExists(msg.sender, 1), "User not present in AP1");
401         require(isUserQualified(msg.sender), "User not qualified in AP1");
402         require(!isUserExists(msg.sender, 3), "User already registered in AP3");
403         require(isUserQualifiedbuyMineGold(msg.sender), "User not qualified in for payment mine MineGold");
404 
405         uint eventCount = mine_slots_3[activeSlot_ap3].eventsCount;
406         uint newEventCount = eventCount + 1;
407 
408         if (newEventCount == 3) {
409             require(reinvestSlot(
410                 mine_slots_3[activeSlot_ap3].userAddress, 
411                 mine_slots_3[activeSlot_ap3].id, 
412                 idToAddress[users[mine_slots_3[activeSlot_ap3].userAddress].referrerId], 
413                 3
414             ));
415             mine_slots_3[activeSlot_ap3].eventsCount++;
416         }
417         
418         uint _referrerId = users[msg.sender].referrerId;
419 
420         UsersMine memory user3 = UsersMine({
421             id: newSlotId_ap3,
422             referrerId: _referrerId,
423             reinvestCount: uint(0)
424         });
425         users_3[msg.sender] = user3;
426         
427         MineSlots memory _newSlot = MineSlots({
428             id: newSlotId_ap3,
429             userAddress: msg.sender,
430             referrerId: _referrerId,
431             eventsCount: uint8(0)
432         });
433         
434         mine_slots_3[newSlotId_ap3] = _newSlot;
435         newUserId_ap3++;
436         emit RegisterUserEvent(newSlotId_ap3, msg.sender, idToAddress[_referrerId], 3, msg.value, now);
437         
438         if (_referrerId > 0) {
439             payUpline(idToAddress[_referrerId], 1, 3);
440             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
441         }
442         else{
443             payUpline(idToAddress[1], 1, 3);
444             users[idToAddress[1]].earnedFromRef += msg.value/2;
445         }
446 
447         newSlotId_ap3++;
448 
449         if (eventCount < 2) {
450             
451             if(eventCount == 0) {
452                 payUpline(mine_slots_3[activeSlot_ap3].userAddress, 1, 3);
453                 users[mine_slots_3[activeSlot_ap3].userAddress].earnedFromGlobal += msg.value/2;
454             }
455             if(eventCount == 1) {
456                 if (mine_slots_3[activeSlot_ap3].referrerId > 0) {
457                     payUpline(idToAddress[mine_slots_3[activeSlot_ap3].referrerId], 1, 3);
458                     users[idToAddress[mine_slots_3[activeSlot_ap3].referrerId]].earnedFromRef += msg.value/2;
459                 }
460                 else {
461                     payUpline(idToAddress[1], 1, 3);
462                     users[idToAddress[1]].earnedFromRef += msg.value/2;
463                 }
464             }
465 
466             mine_slots_3[activeSlot_ap3].eventsCount++;
467             
468         }
469         
470     }
471 
472     function buyMineRubi() 
473       public 
474       payable 
475     {
476         require(msg.value == 0.4 ether, "Participation fee in Automine is 0.4 ETH");
477         require(isUserExists(msg.sender, 1), "User not present in AP1");
478         require(isUserQualified(msg.sender), "User not qualified in AP1");
479         require(!isUserExists(msg.sender, 4), "User already registered in AP4");
480         require(isUserQualifiedbuyMineRubi(msg.sender), "User not qualified in for payment mine MineRubi");
481 
482         uint eventCount = mine_slots_4[activeSlot_ap4].eventsCount;
483         uint newEventCount = eventCount + 1;
484 
485         if (newEventCount == 3) {
486             require(reinvestSlot(
487                 mine_slots_4[activeSlot_ap4].userAddress, 
488                 mine_slots_4[activeSlot_ap4].id, 
489                 idToAddress[users[mine_slots_4[activeSlot_ap4].userAddress].referrerId], 
490                 4
491             ));
492             mine_slots_4[activeSlot_ap4].eventsCount++;
493         }
494         
495         uint _referrerId = users[msg.sender].referrerId;
496 
497         UsersMine memory user4 = UsersMine({
498             id: newSlotId_ap4,
499             referrerId: _referrerId,
500             reinvestCount: uint(0)
501         });
502         users_4[msg.sender] = user4;
503         
504         MineSlots memory _newSlot = MineSlots({
505             id: newSlotId_ap4,
506             userAddress: msg.sender,
507             referrerId: _referrerId,
508             eventsCount: uint8(0)
509         });
510         
511         mine_slots_4[newSlotId_ap4] = _newSlot;
512         newUserId_ap4++;
513         emit RegisterUserEvent(newSlotId_ap4, msg.sender, idToAddress[_referrerId], 4, msg.value, now);
514         
515         if (_referrerId > 0) {
516             payUpline(idToAddress[_referrerId], 1, 4);
517             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
518         }
519         else{
520             payUpline(idToAddress[1], 1, 4);
521             users[idToAddress[1]].earnedFromRef += msg.value/2;
522         }
523 
524         newSlotId_ap4++;
525 
526         if (eventCount < 2) {
527             
528             if(eventCount == 0) {
529                 payUpline(mine_slots_4[activeSlot_ap4].userAddress, 1, 4);
530                 users[mine_slots_4[activeSlot_ap4].userAddress].earnedFromGlobal += msg.value/2;
531             }
532             if(eventCount == 1) {
533                 if (mine_slots_4[activeSlot_ap4].referrerId > 0) {
534                     payUpline(idToAddress[mine_slots_4[activeSlot_ap4].referrerId], 1, 4);
535                     users[idToAddress[mine_slots_4[activeSlot_ap4].referrerId]].earnedFromRef += msg.value/2;
536                 }
537                 else {
538                     payUpline(idToAddress[1], 1, 4);
539                     users[idToAddress[1]].earnedFromRef += msg.value/2;
540                 }
541             }
542 
543             mine_slots_4[activeSlot_ap4].eventsCount++;
544             
545         }
546         
547     }
548 
549     function buyMineSapphire() 
550       public 
551       payable 
552     {
553         require(msg.value == 0.5 ether, "Participation fee in Automine is 0.5 ETH");
554         require(isUserExists(msg.sender, 1), "User not present in AP1");
555         require(isUserQualified(msg.sender), "User not qualified in AP1");
556         require(!isUserExists(msg.sender, 5), "User already registered in AP5");
557          require(isUserQualifiedbuyMineSapphire(msg.sender), "User not qualified in for payment mine MineSapphire");
558 
559         uint eventCount = mine_slots_5[activeSlot_ap5].eventsCount;
560         uint newEventCount = eventCount + 1;
561 
562         if (newEventCount == 3) {
563             require(reinvestSlot(
564                 mine_slots_5[activeSlot_ap5].userAddress, 
565                 mine_slots_5[activeSlot_ap5].id, 
566                 idToAddress[users[mine_slots_5[activeSlot_ap5].userAddress].referrerId], 
567                 5
568             ));
569             mine_slots_5[activeSlot_ap5].eventsCount++;
570         }
571         
572         uint _referrerId = users[msg.sender].referrerId;
573 
574         UsersMine memory user5 = UsersMine({
575             id: newSlotId_ap5,
576             referrerId: _referrerId,
577             reinvestCount: uint(0)
578         });
579         users_5[msg.sender] = user5;
580         
581         MineSlots memory _newSlot = MineSlots({
582             id: newSlotId_ap5,
583             userAddress: msg.sender,
584             referrerId: _referrerId,
585             eventsCount: uint8(0)
586         });
587         
588         mine_slots_5[newSlotId_ap5] = _newSlot;
589         newUserId_ap5++;
590         emit RegisterUserEvent(newSlotId_ap5, msg.sender, idToAddress[_referrerId], 5, msg.value, now);
591         
592         if (_referrerId > 0) {
593             payUpline(idToAddress[_referrerId], 1, 5);
594             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
595         }
596         else{
597             payUpline(idToAddress[1], 1, 5);
598             users[idToAddress[1]].earnedFromRef += msg.value/2;
599         }
600 
601         newSlotId_ap5++;
602 
603         if (eventCount < 2) {
604             
605             if(eventCount == 0) {
606                 payUpline(mine_slots_5[activeSlot_ap5].userAddress, 1, 5);
607                 users[mine_slots_5[activeSlot_ap5].userAddress].earnedFromGlobal += msg.value/2;
608             }
609             if(eventCount == 1) {
610                 if (mine_slots_5[activeSlot_ap5].referrerId > 0) {
611                     payUpline(idToAddress[mine_slots_5[activeSlot_ap5].referrerId], 1, 5);
612                     users[idToAddress[mine_slots_5[activeSlot_ap5].referrerId]].earnedFromRef += msg.value/2;
613                 }
614                 else {
615                     payUpline(idToAddress[1], 1, 5);
616                     users[idToAddress[1]].earnedFromRef += msg.value/2;
617                 }
618             }
619 
620             mine_slots_5[activeSlot_ap5].eventsCount++;
621             
622         }
623         
624     }
625 
626     function buyMineEmerald() 
627       public 
628       payable 
629     {
630         require(msg.value == 0.7 ether, "Participation fee in Automine is 0.7 ETH");
631         require(isUserExists(msg.sender, 1), "User not present in AP1");
632         require(isUserQualified(msg.sender), "User not qualified in AP1");
633         require(!isUserExists(msg.sender, 6), "User already registered in AP6");
634         require(isUserQualifiedbuyMineEmerald(msg.sender), "User not qualified in for payment mine MineEmerald");
635 
636         uint eventCount = mine_slots_6[activeSlot_ap6].eventsCount;
637         uint newEventCount = eventCount + 1;
638 
639         if (newEventCount == 3) {
640             require(reinvestSlot(
641                 mine_slots_6[activeSlot_ap6].userAddress, 
642                 mine_slots_6[activeSlot_ap6].id, 
643                 idToAddress[users[mine_slots_6[activeSlot_ap6].userAddress].referrerId], 
644                 6
645             ));
646             mine_slots_6[activeSlot_ap6].eventsCount++;
647         }
648         
649         uint _referrerId = users[msg.sender].referrerId;
650 
651         UsersMine memory user6 = UsersMine({
652             id: newSlotId_ap6,
653             referrerId: _referrerId,
654             reinvestCount: uint(0)
655         });
656         users_6[msg.sender] = user6;
657         
658         MineSlots memory _newSlot = MineSlots({
659             id: newSlotId_ap6,
660             userAddress: msg.sender,
661             referrerId: _referrerId,
662             eventsCount: uint8(0)
663         });
664         
665         mine_slots_6[newSlotId_ap6] = _newSlot;
666         newUserId_ap6++;
667         emit RegisterUserEvent(newSlotId_ap6, msg.sender, idToAddress[_referrerId], 6, msg.value, now);
668         
669         if (_referrerId > 0) {
670             payUpline(idToAddress[_referrerId], 1, 6);
671             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
672         }
673         else{
674             payUpline(idToAddress[1], 1, 6);
675             users[idToAddress[1]].earnedFromRef += msg.value/2;
676         }
677 
678         newSlotId_ap6++;
679 
680         if (eventCount < 2) {
681             
682             if(eventCount == 0) {
683                 payUpline(mine_slots_6[activeSlot_ap6].userAddress, 1, 6);
684                 users[mine_slots_6[activeSlot_ap6].userAddress].earnedFromGlobal += msg.value/2;
685             }
686             if(eventCount == 1) {
687                 if (mine_slots_6[activeSlot_ap6].referrerId > 0) {
688                     payUpline(idToAddress[mine_slots_6[activeSlot_ap6].referrerId], 1, 6);
689                     users[idToAddress[mine_slots_6[activeSlot_ap6].referrerId]].earnedFromRef += msg.value/2;
690                 }
691                 else {
692                     payUpline(idToAddress[1], 1, 6);
693                     users[idToAddress[1]].earnedFromRef += msg.value/2;
694                 }
695             }
696 
697             mine_slots_6[activeSlot_ap6].eventsCount++;
698             
699         }
700         
701     }
702 
703     function buyMineDiamond() 
704       public 
705       payable 
706     {
707         require(msg.value == 1 ether, "Participation fee in Automine is 1 ETH");
708         require(isUserExists(msg.sender, 1), "User not present in AP1");
709         require(isUserQualified(msg.sender), "User not qualified in AP1");
710         require(!isUserExists(msg.sender, 7), "User already registered in AP7");
711         require(isUserQualifiedbuyMineDiamond(msg.sender), "User not qualified in for payment mine MineDiamond");
712 
713         uint eventCount = mine_slots_7[activeSlot_ap7].eventsCount;
714         uint newEventCount = eventCount + 1;
715 
716         if (newEventCount == 3) {
717             require(reinvestSlot(
718                 mine_slots_7[activeSlot_ap7].userAddress, 
719                 mine_slots_7[activeSlot_ap7].id, 
720                 idToAddress[users[mine_slots_7[activeSlot_ap7].userAddress].referrerId], 
721                 7
722             ));
723             mine_slots_7[activeSlot_ap7].eventsCount++;
724         }
725         
726         uint _referrerId = users[msg.sender].referrerId;
727 
728         UsersMine memory user7 = UsersMine({
729             id: newSlotId_ap7,
730             referrerId: _referrerId,
731             reinvestCount: uint(0)
732         });
733         users_7[msg.sender] = user7;
734         
735         MineSlots memory _newSlot = MineSlots({
736             id: newSlotId_ap7,
737             userAddress: msg.sender,
738             referrerId: _referrerId,
739             eventsCount: uint8(0)
740         });
741         
742         mine_slots_7[newSlotId_ap7] = _newSlot;
743         newUserId_ap7++;
744         emit RegisterUserEvent(newSlotId_ap7, msg.sender, idToAddress[_referrerId], 7, msg.value, now);
745 
746         if (_referrerId > 0) {
747             payUpline(idToAddress[_referrerId], 1, 7);
748             users[idToAddress[_referrerId]].earnedFromRef += msg.value/2;
749         }
750         else{
751             payUpline(idToAddress[1], 1, 7);
752             users[idToAddress[1]].earnedFromRef += msg.value/2;
753         }
754         
755         newSlotId_ap7++;
756 
757         if (eventCount < 2) {
758             
759             if(eventCount == 0) {
760                 payUpline(mine_slots_7[activeSlot_ap7].userAddress, 1, 7);
761                 users[mine_slots_7[activeSlot_ap7].userAddress].earnedFromGlobal += msg.value/2;
762             }
763             if(eventCount == 1) {
764                 if (mine_slots_7[activeSlot_ap7].referrerId > 0) {
765                     payUpline(idToAddress[mine_slots_7[activeSlot_ap7].referrerId], 1, 7);
766                     users[idToAddress[mine_slots_7[activeSlot_ap7].referrerId]].earnedFromRef += msg.value/2;
767                 }
768                 else {
769                     payUpline(idToAddress[1], 1, 7);
770                     users[idToAddress[1]].earnedFromRef += msg.value/2;
771                 }
772             }
773 
774             mine_slots_7[activeSlot_ap7].eventsCount++;
775             
776         }
777         
778     }
779     function isUserQualifiedbuyMineGold(address _userAddress)
780         public
781         view
782         returns (bool)
783     {
784         return (users_2[_userAddress].id > 0);
785     }
786 
787     function isUserQualifiedbuyMineRubi(address _userAddress)
788         public
789         view
790         returns (bool)
791     {
792         return (users_3[_userAddress].id > 0);
793     }
794 
795     function isUserQualifiedbuyMineSapphire(address _userAddress)
796         public
797         view
798         returns (bool)
799     {
800         return (users_4[_userAddress].id > 0);
801     }
802 
803     function isUserQualifiedbuyMineEmerald(address _userAddress)
804         public
805         view
806         returns (bool)
807     {
808         return (users_5[_userAddress].id > 0);
809     }
810 
811     function isUserQualifiedbuyMineDiamond(address _userAddress)
812         public
813         view
814         returns (bool)
815     {
816         return (users_6[_userAddress].id > 0);
817     }
818 
819     function reinvestSlot(address _userAddress, uint _userId, address _sponsorAddress, uint8 _fromMine) private returns (bool _isReinvested) {
820 
821         uint _referrerId = users[_userAddress].referrerId;
822 
823         MineSlots memory _reinvestslot = MineSlots({
824             id: _userId,
825             userAddress: _userAddress,
826             referrerId: _referrerId,
827             eventsCount: uint8(0)
828         });
829         
830         if (_fromMine == 2) {
831             users_2[mine_slots_2[activeSlot_ap2].userAddress].reinvestCount++;        
832             mine_slots_2[newSlotId_ap2] = _reinvestslot;
833             emit ReinvestEvent(newSlotId_ap2, _userAddress, _sponsorAddress, 2, msg.value, now);
834             newSlotId_ap2++;
835         }
836         if (_fromMine == 3) {
837             users_3[mine_slots_3[activeSlot_ap3].userAddress].reinvestCount++;        
838             mine_slots_3[newSlotId_ap3] = _reinvestslot;
839             emit ReinvestEvent(newSlotId_ap3, _userAddress, _sponsorAddress, 3, msg.value, now);
840             newSlotId_ap3++;
841         }
842         if (_fromMine == 4) {
843             users_4[mine_slots_4[activeSlot_ap4].userAddress].reinvestCount++;        
844             mine_slots_4[newSlotId_ap4] = _reinvestslot;
845             emit ReinvestEvent(newSlotId_ap4, _userAddress, _sponsorAddress, 4, msg.value, now);
846             newSlotId_ap4++;
847         }
848         if (_fromMine == 5) {
849             users_5[mine_slots_5[activeSlot_ap5].userAddress].reinvestCount++;        
850             mine_slots_5[newSlotId_ap5] = _reinvestslot;
851             emit ReinvestEvent(newSlotId_ap5, _userAddress, _sponsorAddress, 5, msg.value, now);
852             newSlotId_ap5++;
853         }
854         if (_fromMine == 6) {
855             users_6[mine_slots_6[activeSlot_ap6].userAddress].reinvestCount++;        
856             mine_slots_6[newSlotId_ap6] = _reinvestslot;
857             emit ReinvestEvent(newSlotId_ap6, _userAddress, _sponsorAddress, 6, msg.value, now);
858             newSlotId_ap6++;
859         }
860         if (_fromMine == 7) {
861             users_7[mine_slots_7[activeSlot_ap7].userAddress].reinvestCount++;        
862             mine_slots_7[newSlotId_ap7] = _reinvestslot;
863             emit ReinvestEvent(newSlotId_ap7, _userAddress, _sponsorAddress, 7, msg.value, now);
864             newSlotId_ap7++;
865         }
866         
867         if (_fromMine == 2) {
868             mine_slots_2[activeSlot_ap2].eventsCount = 3;
869             uint _nextActiveSlot = activeSlot_ap2+1;
870 
871             payUpline(mine_slots_2[_nextActiveSlot].userAddress, 1, 2);
872             users[mine_slots_2[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
873             activeSlot_ap2++;
874         }
875         if (_fromMine == 3) {
876             mine_slots_3[activeSlot_ap3].eventsCount = 3;
877             uint _nextActiveSlot = activeSlot_ap3+1;
878 
879             payUpline(mine_slots_3[_nextActiveSlot].userAddress, 1, 3);
880             users[mine_slots_3[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
881             activeSlot_ap3++;
882         }
883         if (_fromMine == 4) {
884             mine_slots_4[activeSlot_ap4].eventsCount = 3;
885             uint _nextActiveSlot = activeSlot_ap4+1;
886 
887             payUpline(mine_slots_4[_nextActiveSlot].userAddress, 1, 4);
888             users[mine_slots_4[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
889             activeSlot_ap4++;
890         }
891         if (_fromMine == 5) {
892             mine_slots_5[activeSlot_ap5].eventsCount = 3;
893             uint _nextActiveSlot = activeSlot_ap5+1;
894 
895             payUpline(mine_slots_5[_nextActiveSlot].userAddress, 1, 5);
896             users[mine_slots_5[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
897             activeSlot_ap5++;
898         }
899         if (_fromMine == 6) {
900             mine_slots_6[activeSlot_ap6].eventsCount = 3;
901             uint _nextActiveSlot = activeSlot_ap6+1;
902 
903             payUpline(mine_slots_6[_nextActiveSlot].userAddress, 1, 6);
904             users[mine_slots_6[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
905             activeSlot_ap6++;
906         }
907         if (_fromMine == 7) {
908             mine_slots_7[activeSlot_ap7].eventsCount = 3;
909             uint _nextActiveSlot = activeSlot_ap7+1;
910 
911             payUpline(mine_slots_7[_nextActiveSlot].userAddress, 1, 7);
912             users[mine_slots_7[_nextActiveSlot].userAddress].earnedFromGlobal += msg.value/2;
913             activeSlot_ap7++;
914         }
915 
916         _isReinvested = true;
917 
918         return _isReinvested;
919 
920     }
921     
922     function payUpline(address _sponsorAddress, uint8 _refLevel, uint8 _fromMine) private returns (uint distributeAmount) {        
923         require( _refLevel <= 4);
924         distributeAmount = msg.value / 100 * uplineAmount[_refLevel];
925         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
926             if (_fromMine > 1) {
927                 emit ReferralPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, _fromMine, now);
928             } else
929                 emit DistributeUplineEvent(distributeAmount, _sponsorAddress, msg.sender, _refLevel, _fromMine, now);
930         }        
931         return distributeAmount;
932     }
933     
934     function payFirstLine(address _sponsorAddress, uint payAmount, uint8 _fromMine) private returns (uint distributeAmount) {        
935         distributeAmount = payAmount;
936         if (address(uint160(_sponsorAddress)).send(distributeAmount)) {
937             if (_fromMine > 1) {
938                 emit ReferralPaymentEvent(distributeAmount, msg.sender, _sponsorAddress, _fromMine, now);
939             } else emit DistributeUplineEvent(distributeAmount, _sponsorAddress, msg.sender, 1, _fromMine, now);
940         }        
941         return distributeAmount;        
942     }
943     
944     function isUserQualified(address _userAddress) public view returns (bool) {
945         return (users[_userAddress].referrerCount > 0);
946     }
947     
948     function isUserExists(address _userAddress, uint8 _automine) public view returns (bool) {
949         require((_automine > 0) && (_automine <= 7));
950         if (_automine == 1) return (users[_userAddress].id != 0);
951         if (_automine == 2) return (users_2[_userAddress].id != 0);
952         if (_automine == 3) return (users_3[_userAddress].id != 0);
953         if (_automine == 4) return (users_4[_userAddress].id != 0);
954         if (_automine == 5) return (users_5[_userAddress].id != 0);
955         if (_automine == 6) return (users_6[_userAddress].id != 0);
956         if (_automine == 7) return (users_7[_userAddress].id != 0);
957     }
958     
959     function getUserReferrals(address _userAddress)
960         public
961         view
962         returns (address[] memory)
963       {
964         return users[_userAddress].referrals;
965       }
966     
967 }