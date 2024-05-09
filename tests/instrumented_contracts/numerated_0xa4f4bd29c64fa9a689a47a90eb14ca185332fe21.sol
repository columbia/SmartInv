1 /*
2 
3                          ░██╗░░░░░░░██╗██╗░░██╗██╗███╗░░██╗██╗███╗░░██╗░██████╗░      ██╗░░██╗░█████╗░██████╗░░██████╗███████╗
4                          ░██║░░██╗░░██║██║░░██║██║████╗░██║██║████╗░██║██╔════╝░      ██║░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝
5                          ░╚██╗████╗██╔╝███████║██║██╔██╗██║██║██╔██╗██║██║░░██╗░      ███████║██║░░██║██████╔╝╚█████╗░█████╗░░
6                          ░░████╔═████║░██╔══██║██║██║╚████║██║██║╚████║██║░░╚██╗      ██╔══██║██║░░██║██╔══██╗░╚═══██╗██╔══╝░░
7                          ░░╚██╔╝░╚██╔╝░██║░░██║██║██║░╚███║██║██║░╚███║╚██████╔╝      ██║░░██║╚█████╔╝██║░░██║██████╔╝███████╗
8                          ░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝╚═╝░░╚══╝░╚═════╝░      ╚═╝░░╚═╝░╚════╝░╚═╝░░╚═╝╚═════╝░╚══════╝
9 
10 
11                                       ,  ,.~"""""~~..                                           ___
12                                       )\,)\`-,       `~._                                     .'   ``._
13                                       \  \ | )           `~._                   .-"""""-._   /         \
14                                      _/ ('  ( _(\            `~~,__________..-"'          `-<           \
15                                      )   )   `   )/)   )        \                            \           |
16                                     ') /)`      \` \,-')/\      (                             \          |
17                                     (_(\ /0"     |.   /'  )'  _(`                              |         |
18                                         \\      (  `.     ')_/`                                |         /
19                                          \       \   \                                         |        (
20                                           \ )  /\/   /                                         |         `~._
21                                            `-._)     |                                        /.            `~,
22                                                      |                          |           .'  `~.          (`
23                                                       \                       _,\          /       \        (``
24                                                        `/      /       __..-i"   \         |        \      (``
25                                                       .'     _/`-..--""      `.   `.        \        ) _.~<``
26                                                     .'    _.j     /            `-.  `.       \      '=< `
27                                                   .'   _.'   \    |               `.  `.      \
28                                                  |   .'       ;   ;               .'  .'`.     \
29                                                  \_  `.       |   \             .'  .'   /    .'
30                                                    `.  `-, __ \   /           .'  .'     |   (
31                                                      `.  `'` \|  |           /  .-`     /   .'
32                                                        `-._.--t  ;          |_.-)      /  .'
33                                                               ; /           \  /      / .'
34                                                              / /             `'     .' /
35                                                             /,_\                  .',_(
36                                                            /___(                 /___(            
37 
38 */
39 pragma solidity 0.5.11;
40 
41 contract WhiningHorse {
42      address public ownerWallet;
43       uint public currUserID = 0;
44       uint public pool1currUserID = 0;
45       uint public pool2currUserID = 0;
46       uint public pool3currUserID = 0;
47       uint public pool4currUserID = 0;
48       uint public pool5currUserID = 0;
49       uint public pool6currUserID = 0;
50       uint public pool7currUserID = 0;
51       uint public pool8currUserID = 0;
52       uint public pool9currUserID = 0;
53       uint public pool10currUserID = 0;
54       
55       uint public pool1activeUserID = 0;
56       uint public pool2activeUserID = 0;
57       uint public pool3activeUserID = 0;
58       uint public pool4activeUserID = 0;
59       uint public pool5activeUserID = 0;
60       uint public pool6activeUserID = 0;
61       uint public pool7activeUserID = 0;
62       uint public pool8activeUserID = 0;
63       uint public pool9activeUserID = 0;
64       uint public pool10activeUserID = 0;
65       
66       
67      
68      
69       struct UserStruct {
70         bool isExist;
71         uint id;
72         uint referrerID;
73        uint referredUsers;
74         mapping(uint => uint) levelExpired;
75     }
76     
77      struct PoolUserStruct {
78         bool isExist;
79         uint id;
80        uint payment_received; 
81     }
82     
83      mapping (address => UserStruct) public users;
84      mapping (uint => address) public userList;
85      
86      mapping (address => PoolUserStruct) public pool1users;
87      mapping (uint => address) public pool1userList;
88      
89      mapping (address => PoolUserStruct) public pool2users;
90      mapping (uint => address) public pool2userList;
91      
92      mapping (address => PoolUserStruct) public pool3users;
93      mapping (uint => address) public pool3userList;
94      
95      mapping (address => PoolUserStruct) public pool4users;
96      mapping (uint => address) public pool4userList;
97      
98      mapping (address => PoolUserStruct) public pool5users;
99      mapping (uint => address) public pool5userList;
100      
101      mapping (address => PoolUserStruct) public pool6users;
102      mapping (uint => address) public pool6userList;
103      
104      mapping (address => PoolUserStruct) public pool7users;
105      mapping (uint => address) public pool7userList;
106      
107      mapping (address => PoolUserStruct) public pool8users;
108      mapping (uint => address) public pool8userList;
109      
110      mapping (address => PoolUserStruct) public pool9users;
111      mapping (uint => address) public pool9userList;
112      
113      mapping (address => PoolUserStruct) public pool10users;
114      mapping (uint => address) public pool10userList;
115      
116     mapping(uint => uint) public LEVEL_PRICE;
117     
118    uint REGESTRATION_FESS=0.1 ether;
119    uint pool1_price=0.2 ether;
120    uint pool2_price=0.5 ether ;
121    uint pool3_price=1 ether;
122    uint pool4_price=2 ether;
123    uint pool5_price=3 ether;
124    uint pool6_price=5 ether;
125    uint pool7_price=7 ether ;
126    uint pool8_price=10 ether;
127    uint pool9_price=15 ether;
128    uint pool10_price=20 ether;
129    
130     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
131     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
132     event regPoolEntry(address indexed _user,uint _level,   uint _time);
133     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
134    
135     UserStruct[] public requests;
136     uint public totalEarned = 0;
137      
138     constructor() public {
139         ownerWallet = msg.sender;
140 
141            
142 
143 
144         UserStruct memory userStruct;
145         currUserID++;
146 
147         userStruct = UserStruct({
148             isExist: true,
149             id: currUserID,
150             referrerID: 0,
151             referredUsers:0
152            
153         });
154         
155         users[ownerWallet] = userStruct;
156         userList[currUserID] = ownerWallet;
157        
158        
159         PoolUserStruct memory pooluserStruct;
160         
161         pool1currUserID++;
162 
163         pooluserStruct = PoolUserStruct({
164             isExist:true,
165             id:pool1currUserID,
166             payment_received:0
167         });
168         pool1activeUserID=pool1currUserID;
169         pool1users[msg.sender] = pooluserStruct;
170         pool1userList[pool1currUserID]=msg.sender;
171       
172         
173         pool2currUserID++;
174         pooluserStruct = PoolUserStruct({
175             isExist:true,
176             id:pool2currUserID,
177             payment_received:0
178         });
179         pool2activeUserID=pool2currUserID;
180         pool2users[msg.sender] = pooluserStruct;
181         pool2userList[pool2currUserID]=msg.sender;
182        
183        
184         pool3currUserID++;
185         pooluserStruct = PoolUserStruct({
186             isExist:true,
187             id:pool3currUserID,
188             payment_received:0
189         });
190         pool3activeUserID=pool3currUserID;
191         pool3users[msg.sender] = pooluserStruct;
192         pool3userList[pool3currUserID]=msg.sender;
193        
194        
195         pool4currUserID++;
196         pooluserStruct = PoolUserStruct({
197             isExist:true,
198             id:pool4currUserID,
199             payment_received:0
200         });
201         pool4activeUserID=pool4currUserID;
202        pool4users[msg.sender] = pooluserStruct;
203        pool4userList[pool4currUserID]=msg.sender;
204 
205         
206         pool5currUserID++;
207         pooluserStruct = PoolUserStruct({
208             isExist:true,
209             id:pool5currUserID,
210             payment_received:0
211         });
212         pool5activeUserID=pool5currUserID;
213         pool5users[msg.sender] = pooluserStruct;
214         pool5userList[pool5currUserID]=msg.sender;
215        
216        
217         pool6currUserID++;
218         pooluserStruct = PoolUserStruct({
219             isExist:true,
220             id:pool6currUserID,
221             payment_received:0
222         });
223         pool6activeUserID=pool6currUserID;
224         pool6users[msg.sender] = pooluserStruct;
225         pool6userList[pool6currUserID]=msg.sender;
226        
227         pool7currUserID++;
228         pooluserStruct = PoolUserStruct({
229             isExist:true,
230             id:pool7currUserID,
231             payment_received:0
232         });
233         pool7activeUserID=pool7currUserID;
234         pool7users[msg.sender] = pooluserStruct;
235         pool7userList[pool7currUserID]=msg.sender;
236        
237         pool8currUserID++;
238         pooluserStruct = PoolUserStruct({
239             isExist:true,
240             id:pool8currUserID,
241             payment_received:0
242         });
243         pool8activeUserID=pool8currUserID;
244         pool8users[msg.sender] = pooluserStruct;
245         pool8userList[pool8currUserID]=msg.sender;
246        
247         pool9currUserID++;
248         pooluserStruct = PoolUserStruct({
249             isExist:true,
250             id:pool9currUserID,
251             payment_received:0
252         });
253         pool9activeUserID=pool9currUserID;
254         pool9users[msg.sender] = pooluserStruct;
255         pool9userList[pool9currUserID]=msg.sender;
256        
257        
258         pool10currUserID++;
259         pooluserStruct = PoolUserStruct({
260             isExist:true,
261             id:pool10currUserID,
262             payment_received:0
263         });
264         pool10activeUserID=pool10currUserID;
265         pool10users[msg.sender] = pooluserStruct;
266         pool10userList[pool10currUserID]=msg.sender;
267        
268        
269       }
270      
271    
272  function regUser(uint _referrerID) public payable {
273        
274       require(!users[msg.sender].isExist, "User Exists");
275       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
276       require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
277        
278         UserStruct memory userStruct;
279         currUserID++;
280 
281         userStruct = UserStruct({
282             isExist: true,
283             id: currUserID,
284             referrerID: _referrerID,
285             referredUsers:0
286         });
287    
288     
289        users[msg.sender] = userStruct;
290        userList[currUserID]=msg.sender;
291        
292         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
293         
294        payReferral(1,msg.sender);
295         emit regLevelEvent(msg.sender, userList[_referrerID], now);
296     }
297    
298    
299      function payReferral(uint _level, address _user) internal {
300         address referer;
301        
302         referer = userList[users[_user].referrerID];
303        
304        
305          bool sent = false;
306        
307             uint level_price_local=0;
308             
309             level_price_local=REGESTRATION_FESS/1;
310             
311             sent = address(uint160(referer)).send(level_price_local);
312 
313             if (sent) {
314                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
315                     if(_level < 1 && users[referer].referrerID >= 1){
316                         payReferral(_level+1,referer);
317                     }
318                     else {
319                         sendBalance();
320                     }
321             }
322        
323         if(!sent) {
324 
325             payReferral(_level, referer);
326         }
327      }
328      
329     function buyPool1() public payable {
330         require(users[msg.sender].isExist, "User Not Registered");
331         require(!pool1users[msg.sender].isExist, "Already in AutoPool");
332       
333         require(msg.value == pool1_price, 'Incorrect Value');
334         
335        
336         PoolUserStruct memory userStruct;
337         address pool1Currentuser=pool1userList[pool1activeUserID];
338         
339         pool1currUserID++;
340 
341         userStruct = PoolUserStruct({
342             isExist:true,
343             id:pool1currUserID,
344             payment_received:0
345         });
346    
347        pool1users[msg.sender] = userStruct;
348        pool1userList[pool1currUserID]=msg.sender;
349        bool sent = false;
350        uint fee = pool1_price * 5 / 100;
351        uint poolshare = pool1_price - fee;
352        if (address(uint160(ownerWallet)).send(fee))
353             sent = address(uint160(pool1Currentuser)).send(poolshare);
354 
355         if (sent) {
356             totalEarned += poolshare;
357             pool1users[pool1Currentuser].payment_received+=1;
358             if(pool1users[pool1Currentuser].payment_received>=2)
359             {
360                 pool1activeUserID+=1;
361             }
362             emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
363         }
364        emit regPoolEntry(msg.sender, 1, now);
365     }
366 
367     function buyPool2() public payable {
368         require(users[msg.sender].isExist, "User Not Registered");
369         require(!pool2users[msg.sender].isExist, "Already in AutoPool");
370         require(msg.value == pool2_price, 'Incorrect Value');
371          
372         PoolUserStruct memory userStruct;
373         address pool2Currentuser=pool2userList[pool2activeUserID];
374         
375         pool2currUserID++;
376         userStruct = PoolUserStruct({
377             isExist:true,
378             id:pool2currUserID,
379             payment_received:0
380         });
381        pool2users[msg.sender] = userStruct;
382        pool2userList[pool2currUserID]=msg.sender;
383        
384        
385        
386        bool sent = false;
387        uint fee = pool2_price * 5 / 100;
388        uint poolshare = pool2_price - fee;
389        if (address(uint160(ownerWallet)).send(fee))
390             sent = address(uint160(pool2Currentuser)).send(poolshare);
391 
392             if (sent) {
393                 totalEarned += poolshare;
394                 pool2users[pool2Currentuser].payment_received+=1;
395                 if(pool2users[pool2Currentuser].payment_received>=3)
396                 {
397                     pool2activeUserID+=1;
398                 }
399                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
400             }
401             emit regPoolEntry(msg.sender,2,  now);
402     }
403     
404     function buyPool3() public payable {
405         require(users[msg.sender].isExist, "User Not Registered");
406         require(!pool3users[msg.sender].isExist, "Already in AutoPool");
407         require(msg.value == pool3_price, 'Incorrect Value');
408         
409         PoolUserStruct memory userStruct;
410         address pool3Currentuser=pool3userList[pool3activeUserID];
411         
412         pool3currUserID++;
413         userStruct = PoolUserStruct({
414             isExist:true,
415             id:pool3currUserID,
416             payment_received:0
417         });
418        pool3users[msg.sender] = userStruct;
419        pool3userList[pool3currUserID]=msg.sender;
420        bool sent = false;
421        uint fee = pool3_price * 5 / 100;
422        uint poolshare = pool3_price - fee;
423        if (address(uint160(ownerWallet)).send(fee))
424             sent = address(uint160(pool3Currentuser)).send(poolshare);
425 
426             if (sent) {
427                 totalEarned += poolshare;
428                 pool3users[pool3Currentuser].payment_received+=1;
429                 if(pool3users[pool3Currentuser].payment_received>=3)
430                 {
431                     pool3activeUserID+=1;
432                 }
433                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
434             }
435         emit regPoolEntry(msg.sender,3,  now);
436     }
437 
438     function buyPool4() public payable {
439         require(users[msg.sender].isExist, "User Not Registered");
440         require(!pool4users[msg.sender].isExist, "Already in AutoPool");
441         require(msg.value == pool4_price, 'Incorrect Value');
442       
443         PoolUserStruct memory userStruct;
444         address pool4Currentuser=pool4userList[pool4activeUserID];
445         
446         pool4currUserID++;
447         userStruct = PoolUserStruct({
448             isExist:true,
449             id:pool4currUserID,
450             payment_received:0
451         });
452        pool4users[msg.sender] = userStruct;
453        pool4userList[pool4currUserID]=msg.sender;
454        bool sent = false;
455        uint fee = pool4_price * 5 / 100;
456        uint poolshare = pool4_price - fee;
457        if (address(uint160(ownerWallet)).send(fee))
458             sent = address(uint160(pool4Currentuser)).send(poolshare);
459 
460             if (sent) {
461                 totalEarned += poolshare;
462                 pool4users[pool4Currentuser].payment_received+=1;
463                 if(pool4users[pool4Currentuser].payment_received>=3)
464                 {
465                     pool4activeUserID+=1;
466                 }
467                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
468             }
469         emit regPoolEntry(msg.sender,4, now);
470     }
471 
472     function buyPool5() public payable {
473         require(users[msg.sender].isExist, "User Not Registered");
474         require(!pool5users[msg.sender].isExist, "Already in AutoPool");
475         require(msg.value == pool5_price, 'Incorrect Value');
476         
477         PoolUserStruct memory userStruct;
478         address pool5Currentuser=pool5userList[pool5activeUserID];
479         
480         pool5currUserID++;
481         userStruct = PoolUserStruct({
482             isExist:true,
483             id:pool5currUserID,
484             payment_received:0
485         });
486        pool5users[msg.sender] = userStruct;
487        pool5userList[pool5currUserID]=msg.sender;
488        bool sent = false;
489        uint fee = pool5_price * 5 / 100;
490        uint poolshare = pool5_price - fee;
491        if (address(uint160(ownerWallet)).send(fee))
492             sent = address(uint160(pool5Currentuser)).send(poolshare);
493 
494             if (sent) {
495                 totalEarned += poolshare;
496                 pool5users[pool5Currentuser].payment_received+=1;
497                 if(pool5users[pool5Currentuser].payment_received>=4)
498                 {
499                     pool5activeUserID+=1;
500                 }
501                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
502             }
503         emit regPoolEntry(msg.sender,5,  now);
504     }
505     
506     function buyPool6() public payable {
507         require(users[msg.sender].isExist, "User Not Registered");
508         require(!pool6users[msg.sender].isExist, "Already in AutoPool");
509         require(msg.value == pool6_price, 'Incorrect Value');
510         
511         PoolUserStruct memory userStruct;
512         address pool6Currentuser=pool6userList[pool6activeUserID];
513         
514         pool6currUserID++;
515         userStruct = PoolUserStruct({
516             isExist:true,
517             id:pool6currUserID,
518             payment_received:0
519         });
520        pool6users[msg.sender] = userStruct;
521        pool6userList[pool6currUserID]=msg.sender;
522        bool sent = false;
523        uint fee = pool6_price * 5 / 100;
524        uint poolshare = pool6_price - fee;
525        if (address(uint160(ownerWallet)).send(fee))
526             sent = address(uint160(pool6Currentuser)).send(poolshare);
527 
528             if (sent) {
529                 totalEarned += poolshare;
530                 pool6users[pool6Currentuser].payment_received+=1;
531                 if(pool6users[pool6Currentuser].payment_received>=4)
532                 {
533                     pool6activeUserID+=1;
534                 }
535                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
536             }
537         emit regPoolEntry(msg.sender,6,  now);
538     }
539     
540     function buyPool7() public payable {
541         require(users[msg.sender].isExist, "User Not Registered");
542       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
543         require(msg.value == pool7_price, 'Incorrect Value');
544         
545         PoolUserStruct memory userStruct;
546         address pool7Currentuser=pool7userList[pool7activeUserID];
547         
548         pool7currUserID++;
549         userStruct = PoolUserStruct({
550             isExist:true,
551             id:pool7currUserID,
552             payment_received:0
553         });
554        pool7users[msg.sender] = userStruct;
555        pool7userList[pool7currUserID]=msg.sender;
556        bool sent = false;
557        uint fee = pool7_price * 5 / 100;
558        uint poolshare = pool7_price - fee;
559        if (address(uint160(ownerWallet)).send(fee))
560             sent = address(uint160(pool7Currentuser)).send(poolshare);
561 
562             if (sent) {
563                 totalEarned += poolshare;
564                 pool7users[pool7Currentuser].payment_received+=1;
565                 if(pool7users[pool7Currentuser].payment_received>=4)
566                 {
567                     pool7activeUserID+=1;
568                 }
569                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
570             }
571         emit regPoolEntry(msg.sender,7,  now);
572     }
573     
574     function buyPool8() public payable {
575         require(users[msg.sender].isExist, "User Not Registered");
576       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
577         require(msg.value == pool8_price, 'Incorrect Value');
578        
579         PoolUserStruct memory userStruct;
580         address pool8Currentuser=pool8userList[pool8activeUserID];
581         
582         pool8currUserID++;
583         userStruct = PoolUserStruct({
584             isExist:true,
585             id:pool8currUserID,
586             payment_received:0
587         });
588        pool8users[msg.sender] = userStruct;
589        pool8userList[pool8currUserID]=msg.sender;
590        bool sent = false;
591        uint fee = pool8_price * 5 / 100;
592        uint poolshare = pool8_price - fee;
593        if (address(uint160(ownerWallet)).send(fee))
594             sent = address(uint160(pool8Currentuser)).send(poolshare);
595 
596             if (sent) {
597                 totalEarned += poolshare;
598                 pool8users[pool8Currentuser].payment_received+=1;
599                 if(pool8users[pool8Currentuser].payment_received>=4)
600                 {
601                     pool8activeUserID+=1;
602                 }
603                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
604             }
605         emit regPoolEntry(msg.sender,8,  now);
606     }
607 
608     function buyPool9() public payable {
609         require(users[msg.sender].isExist, "User Not Registered");
610       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
611         require(msg.value == pool9_price, 'Incorrect Value');
612        
613         PoolUserStruct memory userStruct;
614         address pool9Currentuser=pool9userList[pool9activeUserID];
615         
616         pool9currUserID++;
617         userStruct = PoolUserStruct({
618             isExist:true,
619             id:pool9currUserID,
620             payment_received:0
621         });
622        pool9users[msg.sender] = userStruct;
623        pool9userList[pool9currUserID]=msg.sender;
624        bool sent = false;
625        uint fee = pool9_price * 5 / 100;
626        uint poolshare = pool9_price - fee;
627        if (address(uint160(ownerWallet)).send(fee))
628             sent = address(uint160(pool9Currentuser)).send(poolshare);
629 
630             if (sent) {
631                 totalEarned += poolshare;
632                 pool9users[pool9Currentuser].payment_received+=1;
633                 if(pool9users[pool9Currentuser].payment_received>=5)
634                 {
635                     pool9activeUserID+=1;
636                 }
637                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
638             }
639         emit regPoolEntry(msg.sender,9,  now);
640     }
641     
642     function buyPool10() public payable {
643         require(users[msg.sender].isExist, "User Not Registered");
644         require(!pool10users[msg.sender].isExist, "Already in AutoPool");
645         require(msg.value == pool10_price, 'Incorrect Value');
646         
647         PoolUserStruct memory userStruct;
648         address pool10Currentuser=pool10userList[pool10activeUserID];
649         
650         pool10currUserID++;
651         userStruct = PoolUserStruct({
652             isExist:true,
653             id:pool10currUserID,
654             payment_received:0
655         });
656        pool10users[msg.sender] = userStruct;
657        pool10userList[pool10currUserID]=msg.sender;
658        bool sent = false;
659        uint fee = pool10_price * 5 / 100;
660        uint poolshare = pool10_price - fee;
661        if (address(uint160(ownerWallet)).send(fee))
662             sent = address(uint160(pool10Currentuser)).send(poolshare);
663 
664             if (sent) {
665                 totalEarned += poolshare;
666                 pool10users[pool10Currentuser].payment_received+=1;
667                 if(pool10users[pool10Currentuser].payment_received>=5)
668                 {
669                     pool10activeUserID+=1;
670                 }
671                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
672             }
673         emit regPoolEntry(msg.sender, 10, now);
674     }
675     
676     function getEthBalance() public view returns(uint) {
677     return address(this).balance;
678     }
679     
680     function sendBalance() private
681     {
682          if (!address(uint160(ownerWallet)).send(getEthBalance()))
683          {
684              
685          }
686     }
687    
688    
689 }