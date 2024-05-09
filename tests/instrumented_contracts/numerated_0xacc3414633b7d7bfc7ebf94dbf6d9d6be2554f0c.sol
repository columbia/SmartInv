1 /*
2     @CashQuestBot
3 */
4 
5 pragma solidity ^ 0.5.11;
6 pragma experimental ABIEncoderV2;
7 
8 contract Dates {
9     uint constant DAY_IN_SECONDS = 86400;
10 
11     function getNow() public view returns(uint) {
12         return now;
13     }
14 
15     function getDelta(uint _date) public view returns(uint) {
16         // now - date
17         return (now / DAY_IN_SECONDS) - (_date / DAY_IN_SECONDS);
18     }
19 }
20 
21 
22 
23 contract EventInterface {
24     event Activation(address indexed user);
25     event FirstActivation(address indexed user);
26     event Refund(address indexed user, uint indexed amount);
27     event LossOfReward(address indexed user, uint indexed amount);
28     event LevelUp(address indexed user, uint indexed level);
29     event AcceptLevel(address indexed user);
30     event ToFund(uint indexed amount);
31     event ToReferrer(address indexed user, uint indexed amount);
32     event HardworkerSeq(address indexed user, uint indexed sequence, uint indexed title);
33     event ComandosSeq(address indexed user, uint indexed sequence, uint indexed title);
34     event EveryDaySeq(address indexed user);
35     event CustomerSeq(address indexed user, uint indexed sequence);
36     event DaredevilSeq(address indexed user, uint indexed sequence, uint indexed achievement);
37     event NovatorSeq(address indexed user, uint indexed sequence, uint indexed achievement);
38     event ScoreConverted(address indexed user, uint indexed eth);
39     event ScoreEarned(address indexed user);
40 }
41 
42 contract Owned {
43     address public owner;
44     address public oracul;
45     uint public cashbox;
46     uint public kickback;
47     uint public rest;
48     address public newOwner;
49     uint public lastTxTime;
50     uint idleTime = 7776000; // 90 days
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53     event OraculChanged(address indexed _oracul);
54 
55     constructor() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner {
60         require(msg.sender == owner);
61         _;
62     }
63     modifier onlyOracul {
64         require(msg.sender == oracul);
65         _;
66     }
67     function refundFromCashbox() public onlyOwner {
68         msg.sender.transfer(cashbox);
69         cashbox = 0;
70     }
71     function refundFromKickback() public onlyOwner {
72         msg.sender.transfer(kickback);
73         kickback = 0;
74     }
75     function refundFromRest() public onlyOwner {
76         msg.sender.transfer(rest);
77         rest = 0;
78     }
79     function setOracul(address _newOracul) public onlyOwner {
80         oracul = _newOracul;
81         emit OraculChanged(_newOracul);
82     }
83     function suicideContract() public onlyOwner {
84         if (now - lastTxTime <  idleTime) {
85             revert();
86         } else {
87             selfdestruct(msg.sender);
88         }
89     }
90 }
91 
92 
93 contract CashQuestBot is EventInterface, Owned, Dates {
94     uint public Fund;
95     uint public activationPrice = 4000000000000000;
96     uint public activationTime = 28 days;
97     uint public comission = 15;
98     address[] public members;
99     
100 
101     uint public AllScore;
102 
103     struct Hardworker {
104         uint time;
105         uint seq;
106         uint title;
107     }
108 
109     struct Comandos {
110         uint time;
111         uint seq;
112         uint count;
113         uint title;
114     }
115 
116     struct RegularCustomer {
117         uint seq;
118         uint title;
119     }
120 
121     struct Referrals {
122         uint daredevil;
123         uint novator;
124         uint mastermind;
125         uint sensei;
126         uint guru;
127     }
128 
129     struct Info {
130         // level => count
131         mapping(uint => uint) referralsCount;
132         address referrer;
133         uint level;
134         uint line;
135         bool isLevelUp;
136         uint new_level;
137         uint balance;
138         uint score;
139         uint earned;
140         address[] referrals;
141         uint activationEnds;
142     }
143 
144     struct AllTime {
145         uint score;
146         uint scoreConverted;
147     }
148 
149     struct User {
150         Hardworker hardworker;
151         Comandos comandos;
152         RegularCustomer customer;
153         Referrals referrals;
154         Info info;
155         AllTime alltime;
156     }
157 
158     mapping(address => User) users;
159 
160 
161     constructor() public {
162         owner = msg.sender;
163         oracul = msg.sender;
164 
165         users[msg.sender].info.level = 4;
166         users[msg.sender].info.referralsCount[1] = 1;
167         users[msg.sender].info.line = 1;
168         users[msg.sender].info.activationEnds = now + 50000 days;
169 
170         users[msg.sender].hardworker.time = 0;
171         users[msg.sender].hardworker.seq = 0;
172         users[msg.sender].hardworker.title = 0;
173 
174         users[msg.sender].comandos.time = 0;
175         users[msg.sender].comandos.seq = 0;
176         users[msg.sender].comandos.count = 0;
177         users[msg.sender].comandos.title = 0;
178 
179         users[msg.sender].customer.seq = 0;
180         users[msg.sender].customer.title = 0;
181 
182         users[msg.sender].referrals.daredevil = 0;
183         users[msg.sender].referrals.novator = 0;
184 
185         lastTxTime = now;
186     }
187 
188     // Owner
189     function transferOwnership(address _newOwner) public onlyOwner {
190         newOwner = _newOwner;
191     }
192     function acceptOwnership() public {
193         require(msg.sender == newOwner);
194         emit OwnershipTransferred(owner, newOwner);
195         users[newOwner] = users[owner];
196         delete users[owner];
197         owner = newOwner;
198         newOwner = address(0);
199     }
200 
201 
202 
203 
204     // ACHIEVE HANDLERS
205     function hardworkerPath(address _user) public {
206         uint delta = getDelta(users[_user].hardworker.time);
207 
208         if (delta == 0) {
209             return;
210         }
211 
212         if (delta == 1) {
213             // calculate some stuff
214             users[_user].hardworker.time = now;
215             users[_user].hardworker.seq++;
216 
217             if (users[_user].hardworker.seq % 7 == 0 && users[_user].hardworker.seq > 0 && users[_user].hardworker.seq < 42) {
218                 users[_user].info.score += 100;
219                 users[_user].alltime.score += 100;
220                 AllScore += 100;
221                 emit ScoreEarned(_user);
222                 emit HardworkerSeq(_user, users[_user].hardworker.seq, users[_user].hardworker.title);
223                 return;
224             }
225 
226             if (users[_user].hardworker.seq == 42) {
227                 users[_user].hardworker.title++;
228                 users[_user].hardworker.seq = 0;
229                 users[_user].info.score += 100;
230                 users[_user].alltime.score += 100;
231             
232                 emit ScoreEarned(_user);
233                 AllScore += 100;
234                 emit HardworkerSeq(_user, users[_user].hardworker.seq, users[_user].hardworker.title);
235                 return;
236             }
237             return;
238         }
239 
240         if (delta >= 2) {
241             // reset seq
242             users[_user].hardworker.time = now;
243             users[_user].hardworker.seq = 1;
244             return;
245         }
246     }
247 
248     function everyDay(address _user) public {
249         if (users[_user].comandos.count % 2 == 0 && users[_user].comandos.count > 0) {
250             users[_user].info.score += 100;
251             users[_user].alltime.score += 100; 
252             AllScore += 100;     
253             emit ScoreEarned(_user);
254             emit EveryDaySeq(_user);
255             return;
256         }
257     }
258 
259     function comandosPath(address _user) public {
260         uint delta = getDelta(users[_user].comandos.time);
261 
262         // Comandos
263         /**
264             If last activation was yesterday and count less than 2 - reset sequence.
265             Set count to one and time to current(because it activation now)
266         */
267         if (delta == 1) {
268             if (users[_user].comandos.count < 2) {
269                 users[_user].comandos.seq = 0;
270             }
271             users[_user].comandos.time = now;
272             users[_user].comandos.count = 1;
273             return;
274         }
275         /**
276             If last activation today - increment count.
277             If count >= 2 - increment  sequence and check all.
278         */
279         if (delta == 0) {
280             users[_user].comandos.count++;
281             users[_user].comandos.time = now;
282             if (users[_user].comandos.count == 2) {
283                 users[_user].comandos.seq++;
284 
285                 if (users[_user].comandos.seq % 7 == 0 && users[_user].comandos.seq > 0 && users[_user].comandos.seq < 42) {
286                     users[_user].info.score += 100;
287                     users[_user].alltime.score += 100;
288                     AllScore += 100;
289                     emit ScoreEarned(_user);
290                     emit ComandosSeq(_user, users[_user].comandos.seq, users[_user].comandos.title);
291                     return;
292                 }
293                 if (users[_user].comandos.seq == 42) {
294                     users[_user].comandos.title++;
295                     users[_user].info.score += 100;
296                     users[_user].alltime.score += 100;
297                     AllScore += 100;
298                     emit ScoreEarned(_user);
299                     users[_user].comandos.seq = 0;
300                     emit ComandosSeq(_user, users[_user].comandos.seq, users[_user].comandos.title);
301                     return;
302                 }
303             }
304         }
305 
306         if (delta >= 2) {
307             // reset seq
308             users[_user].comandos.time = now;
309             users[_user].comandos.count = 1;
310             users[_user].comandos.seq = 0;
311             return;
312         }
313     }
314 
315     function regularCustomer(address _user) public {
316         users[_user].info.score += 100;
317         users[_user].alltime.score += 100;
318         AllScore += 100;
319         emit ScoreEarned(_user);
320 
321         if (isActive(_user) == true) {
322             users[_user].customer.seq++;
323             if (users[_user].customer.seq == 12) {
324                 users[_user].customer.title = 1; 
325 
326                 users[_user].info.score += 100;
327                 users[_user].alltime.score += 100;
328 
329                 AllScore += 100;
330                 emit ScoreEarned(_user);   
331             }
332             
333         } else {
334             users[_user].customer.seq = 1;
335         }
336         emit CustomerSeq(_user, users[_user].customer.seq);
337     }
338 
339     function forDaredevil(address _user) public {
340         users[_user].referrals.daredevil++;
341         if (users[_user].referrals.daredevil == 100) {
342             users[_user].info.score += 100;
343             users[_user].alltime.score += 100;
344             AllScore += 100;
345             emit ScoreEarned(_user);
346             emit DaredevilSeq(_user, users[_user].referrals.daredevil, 1);
347             return;
348         }
349         if (users[_user].referrals.daredevil == 250) {
350             users[_user].info.score += 100;
351             users[_user].alltime.score += 100;
352             AllScore += 100;
353             emit ScoreEarned(_user);
354             emit DaredevilSeq(_user, users[_user].referrals.daredevil, 2);
355             return;
356         }
357         if (users[_user].referrals.daredevil == 500) {
358             users[_user].info.score += 100;
359             users[_user].alltime.score += 100;
360             AllScore += 100;
361             emit ScoreEarned(_user);
362             emit DaredevilSeq(_user, users[_user].referrals.daredevil, 3);
363             return;
364         }
365         if (users[_user].referrals.daredevil == 1000) {
366             users[_user].info.score += 100;
367             users[_user].alltime.score += 100;
368             AllScore += 100;     
369             emit ScoreEarned(_user);
370             emit DaredevilSeq(_user, users[_user].referrals.daredevil, 4);
371             return;
372         }
373         if (users[_user].referrals.daredevil == 1500) {
374             users[_user].info.score += 100;
375             users[_user].alltime.score += 100;
376             AllScore += 100;
377             emit ScoreEarned(_user);
378             emit DaredevilSeq(_user, users[_user].referrals.daredevil, 5);
379             return;
380         }
381     }
382 
383     function forNovator(address _user) public {
384         users[_user].referrals.novator++;
385         if (users[_user].referrals.novator == 25) {
386             users[_user].info.score += 100;
387             users[_user].alltime.score += 100;
388             AllScore += 100;
389             emit ScoreEarned(_user);
390             emit NovatorSeq(_user, users[_user].referrals.novator, 1);
391             return;
392         }
393         if (users[_user].referrals.novator == 50) {
394             users[_user].info.score += 100;
395             users[_user].alltime.score += 100;
396             AllScore += 100;
397             emit ScoreEarned(_user);
398             emit NovatorSeq(_user, users[_user].referrals.novator, 2);
399             return;
400         }
401         if (users[_user].referrals.novator == 100) {
402             users[_user].info.score += 100;
403             users[_user].alltime.score += 100;
404             AllScore += 100;
405             emit ScoreEarned(_user);
406             emit NovatorSeq(_user, users[_user].referrals.novator, 3);
407             return;
408         }
409         if (users[_user].referrals.novator == 200) {
410             users[_user].info.score += 100;
411             users[_user].alltime.score += 100;
412             AllScore += 100;
413             emit ScoreEarned(_user);
414             emit NovatorSeq(_user, users[_user].referrals.novator, 4);
415             return;
416         }
417         if (users[_user].referrals.novator == 300) {
418             users[_user].info.score += 100;
419             users[_user].alltime.score += 100;
420             AllScore += 100;
421             emit ScoreEarned(_user);
422             emit NovatorSeq(_user, users[_user].referrals.novator, 5);
423             return;
424         }
425     }
426 
427     // Combined calls for referrer
428     function checkReferrerAcv(address _user) public {
429         if (isActive(_user) == false) {
430             return;
431         }
432         
433         hardworkerPath(_user);
434         comandosPath(_user);
435         everyDay(_user);
436         forDaredevil(_user);
437     }
438 
439     // =========== Getters
440     function canSuicide() public view returns(bool) {
441         if (now - lastTxTime <  idleTime) {
442             return false;
443         } else {
444             return true;
445         }
446     }
447 
448     function getMembers() public view returns(address[] memory) {
449         return members;
450     }
451 
452     function getMembersCount() public view returns(uint) {
453         return members.length;
454     }
455 
456     function getHardworker(address _user) public view returns(Hardworker memory) {
457         return users[_user].hardworker;
458     }
459 
460     function getComandos(address _user) public view returns(Comandos memory) {
461         return users[_user].comandos;
462     }
463 
464     function getCustomer(address _user) public view returns(RegularCustomer memory) {
465         return users[_user].customer;
466     }
467 
468     function getReferrals(address _user) public view returns(uint, uint, uint, uint, uint) {
469         return (users[_user].referrals.daredevil, users[_user].referrals.novator, users[_user].referrals.mastermind, users[_user].referrals.sensei, users[_user].referrals.guru);
470     }
471 
472     function getScore(address _user) public view returns(uint) {
473         return users[_user].info.score;
474     }
475 
476     function getAlltime(address _user) public view returns(uint, uint) {
477         return (users[_user].alltime.score, users[_user].alltime.scoreConverted);
478     }
479 
480     function getPayAmount(address _user) public view returns(uint) {
481         if (users[_user].info.earned / 100 * 10 > activationPrice) {
482             return users[_user].info.earned / 100 * 10;
483         } else {
484             return activationPrice;
485         }
486     }
487     
488     function getUser(address user) public view returns (address, uint, uint, uint, address[] memory, uint) {
489         return (users[user].info.referrer, users[user].info.level, users[user].info.line, users[user].info.balance, users[user].info.referrals, users[user].info.activationEnds);
490     }
491 
492     function getEarned(address user) public view returns (uint) {
493         return users[user].info.earned;
494     }
495 
496     function getActivationEnds(address user) public view returns (uint) {
497         return users[user].info.activationEnds;
498     }
499 
500     function getReferralsCount(address user, uint level) public view returns (uint) {
501         return users[user].info.referralsCount[level];
502     }
503 
504     function isLevelUp(address user) public view returns (bool) {
505         return users[user].info.new_level > users[user].info.level;
506     }
507 
508     function getNewLevel(address user) public view returns (uint) {
509         return users[user].info.new_level;
510     }
511 
512 
513 
514     // =========== Setters
515     function setActivationPrice(uint _newActivationPrice) public onlyOracul {
516         activationPrice = _newActivationPrice;
517     }
518 
519 
520     // =========== Functions
521     function refund() public {
522         require(users[msg.sender].info.balance > 0);
523         uint _comission = users[msg.sender].info.balance / 1000 * comission;
524         uint _balance = users[msg.sender].info.balance - _comission;
525         users[msg.sender].info.balance = 0;
526         msg.sender.transfer(_balance);
527         kickback += _comission;
528         emit Refund(msg.sender, _balance);
529         lastTxTime = now;
530     }
531 
532     function howMuchConverted(address _user) public view returns(uint) {
533         if (AllScore == 0 || Fund == 0 || users[_user].info.score == 0) {
534             return 0;
535         } else {
536             return (Fund / AllScore) * users[_user].info.score + ((Fund % AllScore) * users[_user].info.score);
537         }
538     }
539 
540     function exchangeRate() public view returns(uint) {
541         if (Fund == 0 || AllScore == 0) {
542             return 0;
543         }
544         return Fund / AllScore;
545     }
546 
547     function convertScore() public returns(uint) {
548         require(users[msg.sender].info.score > 0);
549         users[msg.sender].alltime.scoreConverted = users[msg.sender].info.score;
550         uint convertedEther = (Fund / AllScore) * users[msg.sender].info.score;
551         users[msg.sender].info.balance += convertedEther;
552         users[msg.sender].info.earned += convertedEther;
553         AllScore -= users[msg.sender].info.score;
554         Fund -= convertedEther;
555         users[msg.sender].info.score = 0;
556         emit ScoreConverted(msg.sender, convertedEther);
557         lastTxTime = now;
558     }
559 
560     function calculateReferrerLevel(address referrer, uint referralLevel) internal {
561 
562         users[referrer].info.referralsCount[referralLevel]++;
563 
564         if (users[referrer].info.referralsCount[5] == 6 && users[referrer].info.level < 6) {
565             users[referrer].info.isLevelUp = true;
566             users[referrer].info.new_level = 6;
567             emit LevelUp(referrer, 6);
568 
569             return;
570         }
571 
572         if (users[referrer].info.referralsCount[4] == 12 && users[referrer].info.level < 5) {
573             users[referrer].info.isLevelUp = true;
574             users[referrer].info.new_level = 5;
575             emit LevelUp(referrer, 5);
576             return;
577         }
578 
579         if (users[referrer].info.referralsCount[3] == 9 && users[referrer].info.level < 4) {
580             users[referrer].info.isLevelUp = true;
581             users[referrer].info.new_level = 4;
582             emit LevelUp(referrer, 4);
583             return;
584         }
585 
586         if (users[referrer].info.referralsCount[2] == 6 && users[referrer].info.level < 3) {
587             users[referrer].info.isLevelUp = true;
588             users[referrer].info.new_level = 3;
589             emit LevelUp(referrer, 3);
590             return;
591         }
592 
593         if (users[referrer].info.referralsCount[1] == 3 && users[referrer].info.level < 2) {
594             users[referrer].info.isLevelUp = true;
595             users[referrer].info.new_level = 2;
596             emit LevelUp(referrer, 2);
597             return;
598         }
599         
600     }
601 
602     function acceptLevel() public {
603         require(isActive(msg.sender) == true);
604         require(users[msg.sender].info.isLevelUp == true);
605         
606         users[msg.sender].info.isLevelUp = false;
607         users[msg.sender].info.level = users[msg.sender].info.new_level; 
608 
609         // Change state of referrer
610         if (users[msg.sender].info.level == 2) {
611             forNovator(users[msg.sender].info.referrer);
612         }
613 
614         calculateReferrerLevel(users[msg.sender].info.referrer, users[msg.sender].info.level);
615         users[msg.sender].info.score += 100;
616         AllScore += 100;
617         emit ScoreEarned(msg.sender);
618         emit AcceptLevel(msg.sender);
619         lastTxTime = now;
620     }
621 
622     
623 
624     function extendActivation(address _user) internal {
625         if (users[_user].info.activationEnds < now) {
626             users[_user].info.activationEnds = now + activationTime;
627             if (users[_user].info.level == 0) {
628                 users[_user].info.level = 1;
629             }
630         } else {
631             users[_user].info.activationEnds = users[_user].info.activationEnds + activationTime;
632             if (users[_user].info.level == 0) {
633                 users[_user].info.level = 1;
634             }
635         }
636         return;
637     }
638 
639     function isActive(address _user) public view returns(bool) {
640         if (users[_user].info.activationEnds > now) {
641             return true;
642         } else {
643             return false;
644         }
645     }
646 
647     function canPay(address user) public view returns(bool) {
648         if (users[user].info.activationEnds - 3 days < now) {
649             return true;
650         } else {
651             return false;
652         }
653     }
654 
655     function toFund(uint amount) internal {
656         emit ToFund(amount / 2);
657         Fund += amount / 2;
658         cashbox += amount / 2;
659 
660         if (amount % 2 > 0) {
661             rest += amount % 2;
662         }
663     }
664 
665     // ============== TO REFERRER
666     function toReferrer(address user, uint amount, uint control_level) internal {
667         // If activated and grower than control level
668         if (isActive(user) == true && users[user].info.level >= control_level) {
669             emit ToReferrer(user, amount);
670             users[user].info.balance += amount;
671             users[user].info.earned += amount;
672         } else {
673             toFund(amount);
674             emit LossOfReward(user, amount);
675         }
676     }
677 
678     // ==================== Pay!
679     function firstPay(address _referrer) public payable {
680         require(users[msg.sender].info.line == 0);
681         require(users[_referrer].info.line > 0);
682         members.push(msg.sender);
683 
684         users[msg.sender].info.referrer = _referrer;
685         users[msg.sender].info.line = users[_referrer].info.line + 1;
686         users[msg.sender].info.activationEnds = 3 days;
687         users[msg.sender].info.new_level = 0;
688 
689         users[_referrer].info.referrals.push(msg.sender);
690 
691         users[msg.sender].hardworker.time = 0;
692         users[msg.sender].hardworker.seq = 0;
693         users[msg.sender].hardworker.title = 0;
694 
695         users[msg.sender].comandos.time = 0;
696         users[msg.sender].comandos.seq = 0;
697         users[msg.sender].comandos.count = 0;
698         users[msg.sender].comandos.title = 0;
699 
700         users[msg.sender].customer.seq = 0;
701         users[msg.sender].customer.title = 0;
702 
703         users[msg.sender].referrals.daredevil = 0;
704         users[msg.sender].referrals.novator = 0;
705   
706         // Is msg.value correct
707         if (users[msg.sender].info.earned / 100 * 10 > activationPrice) {
708             if (msg.value != users[msg.sender].info.earned / 100 * 10) {
709                 revert();
710             }
711         } else {
712             if (msg.value != activationPrice) {
713                 revert();
714             }
715         }
716 
717         // Is activation needed?
718         if (canPay(msg.sender) == false) {
719             revert();
720         }
721 
722         // Its just another activation(prolongation)
723         users[msg.sender].info.earned = 0;
724         // Extend activation series
725         extendActivation(msg.sender);
726         
727         
728         if (users[msg.sender].info.line == 2) {
729             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
730             toFund(msg.value / 100 * 30 + msg.value / 100 * 20 + msg.value / 100 * 10);
731         }
732 
733         if (users[msg.sender].info.line == 3) {
734             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
735             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
736             toFund(msg.value / 100 * 20 + msg.value / 100 * 10);
737         }
738 
739         if (users[msg.sender].info.line == 4) {
740             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
741             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
742             toReferrer(users[users[users[msg.sender].info.referrer].info.referrer].info.referrer, msg.value / 100 * 20, 3);
743             toFund(msg.value / 100 * 10);
744         }
745 
746         if (users[msg.sender].info.line >= 5) {
747             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
748             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
749             toReferrer(users[users[users[msg.sender].info.referrer].info.referrer].info.referrer, msg.value / 100 * 20, 3);
750             toReferrer(users[users[users[users[msg.sender].info.referrer].info.referrer].info.referrer].info.referrer, msg.value / 100 * 10, 4);
751         }
752         
753         calculateReferrerLevel(users[msg.sender].info.referrer, 1);
754         checkReferrerAcv(users[msg.sender].info.referrer);
755         emit FirstActivation(msg.sender);
756         emit AcceptLevel(msg.sender);
757         lastTxTime = now;
758     }
759 
760 
761     function pay() public payable {
762         // Is user exist
763         if (users[msg.sender].info.line < 2) {
764             revert();
765         }
766 
767 
768         // Is msg.value correct
769         if (users[msg.sender].info.earned / 100 * 10 > activationPrice) {
770             if (msg.value != users[msg.sender].info.earned / 100 * 10) {
771                 revert();
772             }
773         } else {
774             if (msg.value != activationPrice) {
775                 revert();
776             }
777         }
778 
779         // Is activation needed?
780         if (canPay(msg.sender) == false) {
781             revert();
782         }
783 
784         // Its just another activation(prolongation)
785         users[msg.sender].info.earned = 0;
786         // Extend activation series
787         regularCustomer(msg.sender);
788         extendActivation(msg.sender);
789         
790         emit Activation(msg.sender);
791         
792         if (users[msg.sender].info.line == 2) {
793             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
794             toFund(msg.value / 100 * 30 + msg.value / 100 * 20 + msg.value / 100 * 10);
795         }
796 
797         if (users[msg.sender].info.line == 3) {
798             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
799             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
800             toFund(msg.value / 100 * 20 + msg.value / 100 * 10);
801         }
802 
803         if (users[msg.sender].info.line == 4) {
804             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
805             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
806             toReferrer(users[users[users[msg.sender].info.referrer].info.referrer].info.referrer, msg.value / 100 * 20, 3);
807             toFund(msg.value / 100 * 10);
808         }
809 
810         if (users[msg.sender].info.line >= 5) {
811             toReferrer(users[msg.sender].info.referrer, msg.value / 100 * 40, 1);
812             toReferrer(users[users[msg.sender].info.referrer].info.referrer, msg.value / 100 * 30, 2);
813             toReferrer(users[users[users[msg.sender].info.referrer].info.referrer].info.referrer, msg.value / 100 * 20, 3);
814             toReferrer(users[users[users[users[msg.sender].info.referrer].info.referrer].info.referrer].info.referrer, msg.value / 100 * 10, 4);
815         }
816         lastTxTime = now;
817     }
818     // ==================== Fallback!
819     function() external payable {
820         if (msg.value == 1000000000) {
821             refund();
822             return;
823         }
824         if (msg.value == 2000000000) {
825             convertScore();
826             return;
827         }
828         if (msg.value == 3000000000) {
829             refundFromCashbox();
830             return;
831         }
832         if (msg.value == 4000000000) {
833             refundFromKickback();
834             return;
835         }
836         if (msg.value == 5000000000) {
837             suicideContract();
838             return;
839         }
840         pay();
841     }
842 }