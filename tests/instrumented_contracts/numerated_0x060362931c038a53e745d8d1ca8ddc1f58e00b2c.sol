1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-23
3 */
4 
5 /*
6 ██████╗░██╗░░░██╗██╗░░░░░██╗░░░░░██████╗░██╗░░░██╗███╗░░██╗
7 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║████╗░██║
8 ██████╦╝██║░░░██║██║░░░░░██║░░░░░██████╔╝██║░░░██║██╔██╗██║
9 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║██║╚████║
10 ██████╦╝╚██████╔╝███████╗███████╗██║░░██║╚██████╔╝██║░╚███║
11 ╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝ V4
12 
13 Hello 
14 I am Bullrun,
15 Global One line AutoPool Smart contract.
16 
17 My URL : https://bullrun2020.github.io
18 
19 Hashtag: #bullrun2020
20 */
21 pragma solidity 0.5.11 - 0.6.4;
22 
23 contract BullRun {
24      address public ownerWallet;
25       uint public currUserID = 0;
26       uint public pool1currUserID = 0;
27       uint public pool2currUserID = 0;
28       uint public pool3currUserID = 0;
29       uint public pool4currUserID = 0;
30       uint public pool5currUserID = 0;
31       uint public pool6currUserID = 0;
32       uint public pool7currUserID = 0;
33       uint public pool8currUserID = 0;
34       uint public pool9currUserID = 0;
35       uint public pool10currUserID = 0;
36       
37         uint public pool1activeUserID = 0;
38       uint public pool2activeUserID = 0;
39       uint public pool3activeUserID = 0;
40       uint public pool4activeUserID = 0;
41       uint public pool5activeUserID = 0;
42       uint public pool6activeUserID = 0;
43       uint public pool7activeUserID = 0;
44       uint public pool8activeUserID = 0;
45       uint public pool9activeUserID = 0;
46       uint public pool10activeUserID = 0;
47       
48       
49       uint public unlimited_level_price=0;
50      
51       struct UserStruct {
52         bool isExist;
53         uint id;
54         uint referrerID;
55        uint referredUsers;
56         mapping(uint => uint) levelExpired;
57     }
58     
59      struct PoolUserStruct {
60         bool isExist;
61         uint id;
62        uint payment_received; 
63     }
64     
65     mapping (address => UserStruct) public users;
66      mapping (uint => address) public userList;
67      
68      mapping (address => PoolUserStruct) public pool1users;
69      mapping (uint => address) public pool1userList;
70      
71      mapping (address => PoolUserStruct) public pool2users;
72      mapping (uint => address) public pool2userList;
73      
74      mapping (address => PoolUserStruct) public pool3users;
75      mapping (uint => address) public pool3userList;
76      
77      mapping (address => PoolUserStruct) public pool4users;
78      mapping (uint => address) public pool4userList;
79      
80      mapping (address => PoolUserStruct) public pool5users;
81      mapping (uint => address) public pool5userList;
82      
83      mapping (address => PoolUserStruct) public pool6users;
84      mapping (uint => address) public pool6userList;
85      
86      mapping (address => PoolUserStruct) public pool7users;
87      mapping (uint => address) public pool7userList;
88      
89      mapping (address => PoolUserStruct) public pool8users;
90      mapping (uint => address) public pool8userList;
91      
92      mapping (address => PoolUserStruct) public pool9users;
93      mapping (uint => address) public pool9userList;
94      
95      mapping (address => PoolUserStruct) public pool10users;
96      mapping (uint => address) public pool10userList;
97      
98     mapping(uint => uint) public LEVEL_PRICE;
99     
100    uint REGESTRATION_FESS=0.05 ether;
101    uint pool1_price=0.1 ether;
102    uint pool2_price=0.2 ether ;
103    uint pool3_price=0.5 ether;
104    uint pool4_price=1 ether;
105    uint pool5_price=2 ether;
106    uint pool6_price=5 ether;
107    uint pool7_price=10 ether ;
108    uint pool8_price=20 ether;
109    uint pool9_price=50 ether;
110    uint pool10_price=100 ether;
111    
112      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
113       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
114       
115      event regPoolEntry(address indexed _user,uint _level,   uint _time);
116    
117      
118     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
119    
120     UserStruct[] public requests;
121      
122       constructor() public {
123           ownerWallet = msg.sender;
124 
125         LEVEL_PRICE[1] = 0.01 ether;
126         LEVEL_PRICE[2] = 0.005 ether;
127         LEVEL_PRICE[3] = 0.0025 ether;
128         LEVEL_PRICE[4] = 0.00025 ether;
129       unlimited_level_price=0.00025 ether;
130 
131         UserStruct memory userStruct;
132         currUserID++;
133 
134         userStruct = UserStruct({
135             isExist: true,
136             id: currUserID,
137             referrerID: 0,
138             referredUsers:0
139            
140         });
141         
142         users[ownerWallet] = userStruct;
143        userList[currUserID] = ownerWallet;
144        
145        
146          PoolUserStruct memory pooluserStruct;
147         
148         pool1currUserID++;
149 
150         pooluserStruct = PoolUserStruct({
151             isExist:true,
152             id:pool1currUserID,
153             payment_received:0
154         });
155     pool1activeUserID=pool1currUserID;
156        pool1users[msg.sender] = pooluserStruct;
157        pool1userList[pool1currUserID]=msg.sender;
158       
159         
160         pool2currUserID++;
161         pooluserStruct = PoolUserStruct({
162             isExist:true,
163             id:pool2currUserID,
164             payment_received:0
165         });
166     pool2activeUserID=pool2currUserID;
167        pool2users[msg.sender] = pooluserStruct;
168        pool2userList[pool2currUserID]=msg.sender;
169        
170        
171         pool3currUserID++;
172         pooluserStruct = PoolUserStruct({
173             isExist:true,
174             id:pool3currUserID,
175             payment_received:0
176         });
177     pool3activeUserID=pool3currUserID;
178        pool3users[msg.sender] = pooluserStruct;
179        pool3userList[pool3currUserID]=msg.sender;
180        
181        
182          pool4currUserID++;
183         pooluserStruct = PoolUserStruct({
184             isExist:true,
185             id:pool4currUserID,
186             payment_received:0
187         });
188     pool4activeUserID=pool4currUserID;
189        pool4users[msg.sender] = pooluserStruct;
190        pool4userList[pool4currUserID]=msg.sender;
191 
192         
193           pool5currUserID++;
194         pooluserStruct = PoolUserStruct({
195             isExist:true,
196             id:pool5currUserID,
197             payment_received:0
198         });
199     pool5activeUserID=pool5currUserID;
200        pool5users[msg.sender] = pooluserStruct;
201        pool5userList[pool5currUserID]=msg.sender;
202        
203        
204          pool6currUserID++;
205         pooluserStruct = PoolUserStruct({
206             isExist:true,
207             id:pool6currUserID,
208             payment_received:0
209         });
210     pool6activeUserID=pool6currUserID;
211        pool6users[msg.sender] = pooluserStruct;
212        pool6userList[pool6currUserID]=msg.sender;
213        
214          pool7currUserID++;
215         pooluserStruct = PoolUserStruct({
216             isExist:true,
217             id:pool7currUserID,
218             payment_received:0
219         });
220     pool7activeUserID=pool7currUserID;
221        pool7users[msg.sender] = pooluserStruct;
222        pool7userList[pool7currUserID]=msg.sender;
223        
224        pool8currUserID++;
225         pooluserStruct = PoolUserStruct({
226             isExist:true,
227             id:pool8currUserID,
228             payment_received:0
229         });
230     pool8activeUserID=pool8currUserID;
231        pool8users[msg.sender] = pooluserStruct;
232        pool8userList[pool8currUserID]=msg.sender;
233        
234         pool9currUserID++;
235         pooluserStruct = PoolUserStruct({
236             isExist:true,
237             id:pool9currUserID,
238             payment_received:0
239         });
240     pool9activeUserID=pool9currUserID;
241        pool9users[msg.sender] = pooluserStruct;
242        pool9userList[pool9currUserID]=msg.sender;
243        
244        
245         pool10currUserID++;
246         pooluserStruct = PoolUserStruct({
247             isExist:true,
248             id:pool10currUserID,
249             payment_received:0
250         });
251     pool10activeUserID=pool10currUserID;
252        pool10users[msg.sender] = pooluserStruct;
253        pool10userList[pool10currUserID]=msg.sender;
254        
255        
256       }
257      
258        function regUser(uint _referrerID) public payable {
259        
260       require(!users[msg.sender].isExist, "User Exists");
261       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
262         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
263        
264         UserStruct memory userStruct;
265         currUserID++;
266 
267         userStruct = UserStruct({
268             isExist: true,
269             id: currUserID,
270             referrerID: _referrerID,
271             referredUsers:0
272         });
273    
274     
275        users[msg.sender] = userStruct;
276        userList[currUserID]=msg.sender;
277        
278         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
279         
280        payReferral(1,msg.sender);
281         emit regLevelEvent(msg.sender, userList[_referrerID], now);
282     }
283    
284    
285      function payReferral(uint _level, address _user) internal {
286         address referer;
287        
288         referer = userList[users[_user].referrerID];
289        
290        
291          bool sent = false;
292        
293             uint level_price_local=0;
294             if(_level>4){
295             level_price_local=unlimited_level_price;
296             }
297             else{
298             level_price_local=LEVEL_PRICE[_level];
299             }
300             sent = address(uint160(referer)).send(level_price_local);
301 
302             if (sent) {
303                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
304                 if(_level < 100 && users[referer].referrerID >= 1){
305                     payReferral(_level+1,referer);
306                 }
307                 else
308                 {
309                     sendBalance();
310                 }
311                
312             }
313        
314         if(!sent) {
315           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
316 
317             payReferral(_level, referer);
318         }
319      }
320    
321    
322    
323    
324        function buyPool1() public payable {
325        require(users[msg.sender].isExist, "User Not Registered");
326       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
327       
328         require(msg.value == pool1_price, 'Incorrect Value');
329         
330        
331         PoolUserStruct memory userStruct;
332         address pool1Currentuser=pool1userList[pool1activeUserID];
333         
334         pool1currUserID++;
335 
336         userStruct = PoolUserStruct({
337             isExist:true,
338             id:pool1currUserID,
339             payment_received:0
340         });
341    
342        pool1users[msg.sender] = userStruct;
343        pool1userList[pool1currUserID]=msg.sender;
344        bool sent = false;
345        sent = address(uint160(pool1Currentuser)).send(pool1_price);
346 
347             if (sent) {
348                 pool1users[pool1Currentuser].payment_received+=1;
349                 if(pool1users[pool1Currentuser].payment_received>=2)
350                 {
351                     pool1activeUserID+=1;
352                 }
353                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
354             }
355        emit regPoolEntry(msg.sender, 1, now);
356     }
357     
358     
359       function buyPool2() public payable {
360           require(users[msg.sender].isExist, "User Not Registered");
361       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
362         require(msg.value == pool2_price, 'Incorrect Value');
363         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
364          
365         PoolUserStruct memory userStruct;
366         address pool2Currentuser=pool2userList[pool2activeUserID];
367         
368         pool2currUserID++;
369         userStruct = PoolUserStruct({
370             isExist:true,
371             id:pool2currUserID,
372             payment_received:0
373         });
374        pool2users[msg.sender] = userStruct;
375        pool2userList[pool2currUserID]=msg.sender;
376        
377        
378        
379        bool sent = false;
380        sent = address(uint160(pool2Currentuser)).send(pool2_price);
381 
382             if (sent) {
383                 pool2users[pool2Currentuser].payment_received+=1;
384                 if(pool2users[pool2Currentuser].payment_received>=3)
385                 {
386                     pool2activeUserID+=1;
387                 }
388                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
389             }
390             emit regPoolEntry(msg.sender,2,  now);
391     }
392     
393     
394      function buyPool3() public payable {
395          require(users[msg.sender].isExist, "User Not Registered");
396       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
397         require(msg.value == pool3_price, 'Incorrect Value');
398         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
399         
400         PoolUserStruct memory userStruct;
401         address pool3Currentuser=pool3userList[pool3activeUserID];
402         
403         pool3currUserID++;
404         userStruct = PoolUserStruct({
405             isExist:true,
406             id:pool3currUserID,
407             payment_received:0
408         });
409        pool3users[msg.sender] = userStruct;
410        pool3userList[pool3currUserID]=msg.sender;
411        bool sent = false;
412        sent = address(uint160(pool3Currentuser)).send(pool3_price);
413 
414             if (sent) {
415                 pool3users[pool3Currentuser].payment_received+=1;
416                 if(pool3users[pool3Currentuser].payment_received>=3)
417                 {
418                     pool3activeUserID+=1;
419                 }
420                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
421             }
422 emit regPoolEntry(msg.sender,3,  now);
423     }
424     
425     
426     function buyPool4() public payable {
427         require(users[msg.sender].isExist, "User Not Registered");
428       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
429         require(msg.value == pool4_price, 'Incorrect Value');
430         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
431       
432         PoolUserStruct memory userStruct;
433         address pool4Currentuser=pool4userList[pool4activeUserID];
434         
435         pool4currUserID++;
436         userStruct = PoolUserStruct({
437             isExist:true,
438             id:pool4currUserID,
439             payment_received:0
440         });
441        pool4users[msg.sender] = userStruct;
442        pool4userList[pool4currUserID]=msg.sender;
443        bool sent = false;
444        sent = address(uint160(pool4Currentuser)).send(pool4_price);
445 
446             if (sent) {
447                 pool4users[pool4Currentuser].payment_received+=1;
448                 if(pool4users[pool4Currentuser].payment_received>=3)
449                 {
450                     pool4activeUserID+=1;
451                 }
452                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
453             }
454         emit regPoolEntry(msg.sender,4, now);
455     }
456     
457     
458     
459     function buyPool5() public payable {
460         require(users[msg.sender].isExist, "User Not Registered");
461       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
462         require(msg.value == pool5_price, 'Incorrect Value');
463         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
464         
465         PoolUserStruct memory userStruct;
466         address pool5Currentuser=pool5userList[pool5activeUserID];
467         
468         pool5currUserID++;
469         userStruct = PoolUserStruct({
470             isExist:true,
471             id:pool5currUserID,
472             payment_received:0
473         });
474        pool5users[msg.sender] = userStruct;
475        pool5userList[pool5currUserID]=msg.sender;
476        bool sent = false;
477        sent = address(uint160(pool5Currentuser)).send(pool5_price);
478 
479             if (sent) {
480                 pool5users[pool5Currentuser].payment_received+=1;
481                 if(pool5users[pool5Currentuser].payment_received>=3)
482                 {
483                     pool5activeUserID+=1;
484                 }
485                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
486             }
487         emit regPoolEntry(msg.sender,5,  now);
488     }
489     
490     function buyPool6() public payable {
491       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
492         require(msg.value == pool6_price, 'Incorrect Value');
493         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
494         
495         PoolUserStruct memory userStruct;
496         address pool6Currentuser=pool6userList[pool6activeUserID];
497         
498         pool6currUserID++;
499         userStruct = PoolUserStruct({
500             isExist:true,
501             id:pool6currUserID,
502             payment_received:0
503         });
504        pool6users[msg.sender] = userStruct;
505        pool6userList[pool6currUserID]=msg.sender;
506        bool sent = false;
507        sent = address(uint160(pool6Currentuser)).send(pool6_price);
508 
509             if (sent) {
510                 pool6users[pool6Currentuser].payment_received+=1;
511                 if(pool6users[pool6Currentuser].payment_received>=3)
512                 {
513                     pool6activeUserID+=1;
514                 }
515                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
516             }
517         emit regPoolEntry(msg.sender,6,  now);
518     }
519     
520     function buyPool7() public payable {
521         require(users[msg.sender].isExist, "User Not Registered");
522       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
523         require(msg.value == pool7_price, 'Incorrect Value');
524         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
525         
526         PoolUserStruct memory userStruct;
527         address pool7Currentuser=pool7userList[pool7activeUserID];
528         
529         pool7currUserID++;
530         userStruct = PoolUserStruct({
531             isExist:true,
532             id:pool7currUserID,
533             payment_received:0
534         });
535        pool7users[msg.sender] = userStruct;
536        pool7userList[pool7currUserID]=msg.sender;
537        bool sent = false;
538        sent = address(uint160(pool7Currentuser)).send(pool7_price);
539 
540             if (sent) {
541                 pool7users[pool7Currentuser].payment_received+=1;
542                 if(pool7users[pool7Currentuser].payment_received>=3)
543                 {
544                     pool7activeUserID+=1;
545                 }
546                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
547             }
548         emit regPoolEntry(msg.sender,7,  now);
549     }
550     
551     
552     function buyPool8() public payable {
553         require(users[msg.sender].isExist, "User Not Registered");
554       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
555         require(msg.value == pool8_price, 'Incorrect Value');
556         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
557        
558         PoolUserStruct memory userStruct;
559         address pool8Currentuser=pool8userList[pool8activeUserID];
560         
561         pool8currUserID++;
562         userStruct = PoolUserStruct({
563             isExist:true,
564             id:pool8currUserID,
565             payment_received:0
566         });
567        pool8users[msg.sender] = userStruct;
568        pool8userList[pool8currUserID]=msg.sender;
569        bool sent = false;
570        sent = address(uint160(pool8Currentuser)).send(pool8_price);
571 
572             if (sent) {
573                 pool8users[pool8Currentuser].payment_received+=1;
574                 if(pool8users[pool8Currentuser].payment_received>=3)
575                 {
576                     pool8activeUserID+=1;
577                 }
578                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
579             }
580         emit regPoolEntry(msg.sender,8,  now);
581     }
582     
583     
584     
585     function buyPool9() public payable {
586         require(users[msg.sender].isExist, "User Not Registered");
587       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
588         require(msg.value == pool9_price, 'Incorrect Value');
589         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
590        
591         PoolUserStruct memory userStruct;
592         address pool9Currentuser=pool9userList[pool9activeUserID];
593         
594         pool9currUserID++;
595         userStruct = PoolUserStruct({
596             isExist:true,
597             id:pool9currUserID,
598             payment_received:0
599         });
600        pool9users[msg.sender] = userStruct;
601        pool9userList[pool9currUserID]=msg.sender;
602        bool sent = false;
603        sent = address(uint160(pool9Currentuser)).send(pool9_price);
604 
605             if (sent) {
606                 pool9users[pool9Currentuser].payment_received+=1;
607                 if(pool9users[pool9Currentuser].payment_received>=3)
608                 {
609                     pool9activeUserID+=1;
610                 }
611                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
612             }
613         emit regPoolEntry(msg.sender,9,  now);
614     }
615     
616     
617     function buyPool10() public payable {
618         require(users[msg.sender].isExist, "User Not Registered");
619       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
620         require(msg.value == pool10_price, 'Incorrect Value');
621         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
622         
623         PoolUserStruct memory userStruct;
624         address pool10Currentuser=pool10userList[pool10activeUserID];
625         
626         pool10currUserID++;
627         userStruct = PoolUserStruct({
628             isExist:true,
629             id:pool10currUserID,
630             payment_received:0
631         });
632        pool10users[msg.sender] = userStruct;
633        pool10userList[pool10currUserID]=msg.sender;
634        bool sent = false;
635        sent = address(uint160(pool10Currentuser)).send(pool10_price);
636 
637             if (sent) {
638                 pool10users[pool10Currentuser].payment_received+=1;
639                 if(pool10users[pool10Currentuser].payment_received>=3)
640                 {
641                     pool10activeUserID+=1;
642                 }
643                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
644             }
645         emit regPoolEntry(msg.sender, 10, now);
646     }
647     
648     function getEthBalance() public view returns(uint) {
649     return address(this).balance;
650     }
651     
652     function sendBalance() private
653     {
654          if (!address(uint160(ownerWallet)).send(getEthBalance()))
655          {
656              
657          }
658     }
659    
660    
661 }