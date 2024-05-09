1 pragma solidity 0.5.11;
2 
3 contract AKODAX {
4      address public ownerWallet;
5      address public balAdmin;
6       uint public currUserID = 0;
7       uint public pool1currUserID = 0;
8       uint public pool2currUserID = 0;
9       uint public pool3currUserID = 0;
10       uint public pool4currUserID = 0;
11       uint public pool5currUserID = 0;
12       uint public pool6currUserID = 0;
13       uint public pool7currUserID = 0;
14       uint public pool8currUserID = 0;
15       uint public pool9currUserID = 0;
16       uint public pool10currUserID = 0;
17       
18     uint public pool1activeUserID = 0;
19       uint public pool2activeUserID = 0;
20       uint public pool3activeUserID = 0;
21       uint public pool4activeUserID = 0;
22       uint public pool5activeUserID = 0;
23       uint public pool6activeUserID = 0;
24       uint public pool7activeUserID = 0;
25       uint public pool8activeUserID = 0;
26       uint public pool9activeUserID = 0;
27       uint public pool10activeUserID = 0;
28       
29       
30       uint public unlimited_level_price=0;
31      
32       struct UserStruct {
33         bool isExist;
34         uint id;
35         uint referrerID;
36        uint referredUsers;
37         mapping(uint => uint) levelExpired;
38     }
39     
40      struct PoolUserStruct {
41         bool isExist;
42         uint id;
43        uint payment_received; 
44     }
45     
46     mapping (address => UserStruct) public users;
47      mapping (uint => address) public userList;
48      
49      mapping (address => PoolUserStruct) public pool1users;
50      mapping (uint => address) public pool1userList;
51      
52      mapping (address => PoolUserStruct) public pool2users;
53      mapping (uint => address) public pool2userList;
54      
55      mapping (address => PoolUserStruct) public pool3users;
56      mapping (uint => address) public pool3userList;
57      
58      mapping (address => PoolUserStruct) public pool4users;
59      mapping (uint => address) public pool4userList;
60      
61      mapping (address => PoolUserStruct) public pool5users;
62      mapping (uint => address) public pool5userList;
63      
64      mapping (address => PoolUserStruct) public pool6users;
65      mapping (uint => address) public pool6userList;
66      
67      mapping (address => PoolUserStruct) public pool7users;
68      mapping (uint => address) public pool7userList;
69      
70      mapping (address => PoolUserStruct) public pool8users;
71      mapping (uint => address) public pool8userList;
72      
73      mapping (address => PoolUserStruct) public pool9users;
74      mapping (uint => address) public pool9userList;
75      
76      mapping (address => PoolUserStruct) public pool10users;
77      mapping (uint => address) public pool10userList;
78      
79     mapping(uint => uint) public LEVEL_PRICE;
80     
81    uint REGESTRATION_FESS=0.1 ether;
82    uint pool1_price=0.25 ether;
83    uint pool2_price=0.50 ether;
84    uint pool3_price=1 ether;
85    uint pool4_price=2.5 ether;
86    uint pool5_price=6 ether;
87    uint pool6_price=15 ether;
88    uint pool7_price=40 ether;
89    uint pool8_price=100 ether;
90    uint pool9_price=200 ether;
91    uint pool10_price=500 ether;
92    
93      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
94       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
95       
96      event regPoolEntry(address indexed _user,uint _level,   uint _time);
97    
98      
99     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
100    
101     UserStruct[] public requests;
102      
103       constructor() public {
104         ownerWallet = 0x47310C16091700d1Ae35abDCdDC9642765b5cf17;
105         balAdmin = 0x338851DdEa50d0220D63c76153C499D9889eC6F6;
106 
107         LEVEL_PRICE[1] = 0.02 ether;
108         LEVEL_PRICE[2] = 0.01 ether;
109         LEVEL_PRICE[3] = 0.005 ether;
110         LEVEL_PRICE[4] = 0.0005 ether;
111       unlimited_level_price=0.00025 ether;
112 
113         UserStruct memory userStruct;
114          /////////intial user 1*****************
115         currUserID++;
116 
117         userStruct = UserStruct({
118             isExist: true,
119             id: currUserID,
120             referrerID: 0,
121             referredUsers:0
122            
123         });
124         
125         users[ownerWallet] = userStruct;
126         userList[currUserID] = ownerWallet;
127        
128        
129         PoolUserStruct memory pooluserStruct;
130         
131         pool1currUserID++;
132         pooluserStruct = PoolUserStruct({
133             isExist:true,
134             id:pool1currUserID,
135             payment_received:0
136         });
137     pool1activeUserID=pool1currUserID;
138        pool1users[ownerWallet] = pooluserStruct;
139        pool1userList[pool1currUserID]=ownerWallet;
140       
141         
142         pool2currUserID++;
143         pooluserStruct = PoolUserStruct({
144             isExist:true,
145             id:pool2currUserID,
146             payment_received:0
147         });
148     pool2activeUserID=pool2currUserID;
149        pool2users[ownerWallet] = pooluserStruct;
150        pool2userList[pool2currUserID]=ownerWallet;
151        
152        
153         pool3currUserID++;
154         pooluserStruct = PoolUserStruct({
155             isExist:true,
156             id:pool3currUserID,
157             payment_received:0
158         });
159     pool3activeUserID=pool3currUserID;
160        pool3users[ownerWallet] = pooluserStruct;
161        pool3userList[pool3currUserID]=ownerWallet;
162        
163        
164          pool4currUserID++;
165         pooluserStruct = PoolUserStruct({
166             isExist:true,
167             id:pool4currUserID,
168             payment_received:0
169         });
170     pool4activeUserID=pool4currUserID;
171        pool4users[ownerWallet] = pooluserStruct;
172        pool4userList[pool4currUserID]=ownerWallet;
173 
174         
175           pool5currUserID++;
176         pooluserStruct = PoolUserStruct({
177             isExist:true,
178             id:pool5currUserID,
179             payment_received:0
180         });
181     pool5activeUserID=pool5currUserID;
182        pool5users[ownerWallet] = pooluserStruct;
183        pool5userList[pool5currUserID]=ownerWallet;
184        
185        
186          pool6currUserID++;
187         pooluserStruct = PoolUserStruct({
188             isExist:true,
189             id:pool6currUserID,
190             payment_received:0
191         });
192     pool6activeUserID=pool6currUserID;
193        pool6users[ownerWallet] = pooluserStruct;
194        pool6userList[pool6currUserID]=ownerWallet;
195        
196          pool7currUserID++;
197         pooluserStruct = PoolUserStruct({
198             isExist:true,
199             id:pool7currUserID,
200             payment_received:0
201         });
202     pool7activeUserID=pool7currUserID;
203        pool7users[ownerWallet] = pooluserStruct;
204        pool7userList[pool7currUserID]=ownerWallet;
205        
206        pool8currUserID++;
207         pooluserStruct = PoolUserStruct({
208             isExist:true,
209             id:pool8currUserID,
210             payment_received:0
211         });
212     pool8activeUserID=pool8currUserID;
213        pool8users[ownerWallet] = pooluserStruct;
214        pool8userList[pool8currUserID]=ownerWallet;
215        
216         pool9currUserID++;
217         pooluserStruct = PoolUserStruct({
218             isExist:true,
219             id:pool9currUserID,
220             payment_received:0
221         });
222     pool9activeUserID=pool9currUserID;
223        pool9users[ownerWallet] = pooluserStruct;
224        pool9userList[pool9currUserID]=ownerWallet;
225        
226        
227         pool10currUserID++;
228         pooluserStruct = PoolUserStruct({
229             isExist:true,
230             id:pool10currUserID,
231             payment_received:0
232         });
233     pool10activeUserID=pool10currUserID;
234        pool10users[ownerWallet] = pooluserStruct;
235        pool10userList[pool10currUserID]=ownerWallet;
236        ////////////////////*******************
237        //******************///////////////////
238        currUserID++;
239 
240         userStruct = UserStruct({
241             isExist: true,
242             id: currUserID,
243             referrerID: 0,
244             referredUsers:0
245            
246         });
247         
248         users[balAdmin] = userStruct;
249         userList[currUserID] = balAdmin;
250        
251         
252         pool1currUserID++;
253         pooluserStruct = PoolUserStruct({
254             isExist:true,
255             id:pool1currUserID,
256             payment_received:0
257         });
258     //pool1activeUserID=pool1currUserID;
259        pool1users[balAdmin] = pooluserStruct;
260        pool1userList[pool1currUserID]=balAdmin;
261       
262         
263         pool2currUserID++;
264         pooluserStruct = PoolUserStruct({
265             isExist:true,
266             id:pool2currUserID,
267             payment_received:0
268         });
269     //pool2activeUserID=pool2currUserID;
270        pool2users[balAdmin] = pooluserStruct;
271        pool2userList[pool2currUserID]=balAdmin;
272        
273        
274         pool3currUserID++;
275         pooluserStruct = PoolUserStruct({
276             isExist:true,
277             id:pool3currUserID,
278             payment_received:0
279         });
280     //pool3activeUserID=pool3currUserID;
281        pool3users[balAdmin] = pooluserStruct;
282        pool3userList[pool3currUserID]=balAdmin;
283        
284        
285          pool4currUserID++;
286         pooluserStruct = PoolUserStruct({
287             isExist:true,
288             id:pool4currUserID,
289             payment_received:0
290         });
291     //pool4activeUserID=pool4currUserID;
292        pool4users[balAdmin] = pooluserStruct;
293        pool4userList[pool4currUserID]=balAdmin;
294 
295         
296           pool5currUserID++;
297         pooluserStruct = PoolUserStruct({
298             isExist:true,
299             id:pool5currUserID,
300             payment_received:0
301         });
302     //pool5activeUserID=pool5currUserID;
303        pool5users[balAdmin] = pooluserStruct;
304        pool5userList[pool5currUserID]=balAdmin;
305        
306        
307          pool6currUserID++;
308         pooluserStruct = PoolUserStruct({
309             isExist:true,
310             id:pool6currUserID,
311             payment_received:0
312         });
313     //pool6activeUserID=pool6currUserID;
314        pool6users[balAdmin] = pooluserStruct;
315        pool6userList[pool6currUserID]=balAdmin;
316        
317          pool7currUserID++;
318         pooluserStruct = PoolUserStruct({
319             isExist:true,
320             id:pool7currUserID,
321             payment_received:0
322         });
323     //pool7activeUserID=pool7currUserID;
324        pool7users[balAdmin] = pooluserStruct;
325        pool7userList[pool7currUserID]=balAdmin;
326        
327        
328        
329        ////////////////////8888888888888888888
330        
331        
332        
333       }
334      
335        function regUser(uint _referrerID) public payable {
336        
337       require(!users[msg.sender].isExist, "User Exists");
338       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
339         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
340        
341         UserStruct memory userStruct;
342         currUserID++;
343 
344         userStruct = UserStruct({
345             isExist: true,
346             id: currUserID,
347             referrerID: _referrerID,
348             referredUsers:0
349         });
350    
351     
352        users[msg.sender] = userStruct;
353        userList[currUserID]=msg.sender;
354        
355         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
356         
357        payReferral(1,msg.sender);
358         emit regLevelEvent(msg.sender, userList[_referrerID], now);
359     }
360    
361    
362      function payReferral(uint _level, address _user) internal {
363         address referer;
364        
365         referer = userList[users[_user].referrerID];
366        
367        
368          bool sent = false;
369        
370             uint level_price_local=0;
371             if(_level>4){
372             level_price_local=unlimited_level_price;
373             }
374             else{
375             level_price_local=LEVEL_PRICE[_level];
376             }
377             sent = address(uint160(referer)).send(level_price_local);
378 
379             if (sent) {
380                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
381                 if(_level < 100 && users[referer].referrerID >= 1){
382                     payReferral(_level+1,referer);
383                 }
384                 else
385                 {
386                     sendBalance();
387                 }
388                
389             }
390        
391         if(!sent) {
392           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
393 
394             payReferral(_level, referer);
395         }
396      }
397    
398    
399    
400    
401        function buyPool1() public payable {
402        require(users[msg.sender].isExist, "User Not Registered");
403       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
404       
405         require(msg.value == pool1_price, 'Incorrect Value');
406         
407        
408         PoolUserStruct memory userStruct;
409         address pool1Currentuser=pool1userList[pool1activeUserID];
410         
411         pool1currUserID++;
412 
413         userStruct = PoolUserStruct({
414             isExist:true,
415             id:pool1currUserID,
416             payment_received:0
417         });
418    
419        pool1users[msg.sender] = userStruct;
420        pool1userList[pool1currUserID]=msg.sender;
421        bool sent = false;
422        sent = address(uint160(pool1Currentuser)).send(pool1_price);
423 
424             if (sent) {
425                 pool1users[pool1Currentuser].payment_received+=1;
426                 if(pool1users[pool1Currentuser].payment_received>=3)
427                 {
428                     pool1activeUserID+=1;
429                 }
430                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
431             }
432        emit regPoolEntry(msg.sender, 1, now);
433     }
434     
435     
436       function buyPool2() public payable {
437           require(users[msg.sender].isExist, "User Not Registered");
438       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
439         require(msg.value == pool2_price, 'Incorrect Value');
440         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
441          
442         PoolUserStruct memory userStruct;
443         address pool2Currentuser=pool2userList[pool2activeUserID];
444         
445         pool2currUserID++;
446         userStruct = PoolUserStruct({
447             isExist:true,
448             id:pool2currUserID,
449             payment_received:0
450         });
451        pool2users[msg.sender] = userStruct;
452        pool2userList[pool2currUserID]=msg.sender;
453        
454        
455        
456        bool sent = false;
457        sent = address(uint160(pool2Currentuser)).send(pool2_price);
458 
459             if (sent) {
460                 pool2users[pool2Currentuser].payment_received+=1;
461                 if(pool2users[pool2Currentuser].payment_received>=3)
462                 {
463                     pool2activeUserID+=1;
464                 }
465                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
466             }
467             emit regPoolEntry(msg.sender,2,  now);
468     }
469     
470     
471      function buyPool3() public payable {
472          require(users[msg.sender].isExist, "User Not Registered");
473       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
474         require(msg.value == pool3_price, 'Incorrect Value');
475         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
476         
477         PoolUserStruct memory userStruct;
478         address pool3Currentuser=pool3userList[pool3activeUserID];
479         
480         pool3currUserID++;
481         userStruct = PoolUserStruct({
482             isExist:true,
483             id:pool3currUserID,
484             payment_received:0
485         });
486        pool3users[msg.sender] = userStruct;
487        pool3userList[pool3currUserID]=msg.sender;
488        bool sent = false;
489        sent = address(uint160(pool3Currentuser)).send(pool3_price);
490 
491             if (sent) {
492                 pool3users[pool3Currentuser].payment_received+=1;
493                 if(pool3users[pool3Currentuser].payment_received>=3)
494                 {
495                     pool3activeUserID+=1;
496                 }
497                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
498             }
499 emit regPoolEntry(msg.sender,3,  now);
500     }
501     
502     
503     function buyPool4() public payable {
504         require(users[msg.sender].isExist, "User Not Registered");
505       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
506         require(msg.value == pool4_price, 'Incorrect Value');
507         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
508       
509         PoolUserStruct memory userStruct;
510         address pool4Currentuser=pool4userList[pool4activeUserID];
511         
512         pool4currUserID++;
513         userStruct = PoolUserStruct({
514             isExist:true,
515             id:pool4currUserID,
516             payment_received:0
517         });
518        pool4users[msg.sender] = userStruct;
519        pool4userList[pool4currUserID]=msg.sender;
520        bool sent = false;
521        sent = address(uint160(pool4Currentuser)).send(pool4_price);
522 
523             if (sent) {
524                 pool4users[pool4Currentuser].payment_received+=1;
525                 if(pool4users[pool4Currentuser].payment_received>=3)
526                 {
527                     pool4activeUserID+=1;
528                 }
529                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
530             }
531         emit regPoolEntry(msg.sender,4, now);
532     }
533     
534     
535     
536     function buyPool5() public payable {
537         require(users[msg.sender].isExist, "User Not Registered");
538       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
539         require(msg.value == pool5_price, 'Incorrect Value');
540         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
541         
542         PoolUserStruct memory userStruct;
543         address pool5Currentuser=pool5userList[pool5activeUserID];
544         
545         pool5currUserID++;
546         userStruct = PoolUserStruct({
547             isExist:true,
548             id:pool5currUserID,
549             payment_received:0
550         });
551        pool5users[msg.sender] = userStruct;
552        pool5userList[pool5currUserID]=msg.sender;
553        bool sent = false;
554        sent = address(uint160(pool5Currentuser)).send(pool5_price);
555 
556             if (sent) {
557                 pool5users[pool5Currentuser].payment_received+=1;
558                 if(pool5users[pool5Currentuser].payment_received>=3)
559                 {
560                     pool5activeUserID+=1;
561                 }
562                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
563             }
564         emit regPoolEntry(msg.sender,5,  now);
565     }
566     
567     function buyPool6() public payable {
568       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
569         require(msg.value == pool6_price, 'Incorrect Value');
570         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
571         
572         PoolUserStruct memory userStruct;
573         address pool6Currentuser=pool6userList[pool6activeUserID];
574         
575         pool6currUserID++;
576         userStruct = PoolUserStruct({
577             isExist:true,
578             id:pool6currUserID,
579             payment_received:0
580         });
581        pool6users[msg.sender] = userStruct;
582        pool6userList[pool6currUserID]=msg.sender;
583        bool sent = false;
584        sent = address(uint160(pool6Currentuser)).send(pool6_price);
585 
586             if (sent) {
587                 pool6users[pool6Currentuser].payment_received+=1;
588                 if(pool6users[pool6Currentuser].payment_received>=3)
589                 {
590                     pool6activeUserID+=1;
591                 }
592                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
593             }
594         emit regPoolEntry(msg.sender,6,  now);
595     }
596     
597     function buyPool7() public payable {
598         require(users[msg.sender].isExist, "User Not Registered");
599       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
600         require(msg.value == pool7_price, 'Incorrect Value');
601         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
602         
603         PoolUserStruct memory userStruct;
604         address pool7Currentuser=pool7userList[pool7activeUserID];
605         
606         pool7currUserID++;
607         userStruct = PoolUserStruct({
608             isExist:true,
609             id:pool7currUserID,
610             payment_received:0
611         });
612        pool7users[msg.sender] = userStruct;
613        pool7userList[pool7currUserID]=msg.sender;
614        bool sent = false;
615        sent = address(uint160(pool7Currentuser)).send(pool7_price);
616 
617             if (sent) {
618                 pool7users[pool7Currentuser].payment_received+=1;
619                 if(pool7users[pool7Currentuser].payment_received>=3)
620                 {
621                     pool7activeUserID+=1;
622                 }
623                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
624             }
625         emit regPoolEntry(msg.sender,7,  now);
626     }
627     
628     
629     function buyPool8() public payable {
630         require(users[msg.sender].isExist, "User Not Registered");
631       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
632         require(msg.value == pool8_price, 'Incorrect Value');
633         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
634        
635         PoolUserStruct memory userStruct;
636         address pool8Currentuser=pool8userList[pool8activeUserID];
637         
638         pool8currUserID++;
639         userStruct = PoolUserStruct({
640             isExist:true,
641             id:pool8currUserID,
642             payment_received:0
643         });
644        pool8users[msg.sender] = userStruct;
645        pool8userList[pool8currUserID]=msg.sender;
646        bool sent = false;
647        sent = address(uint160(pool8Currentuser)).send(pool8_price);
648 
649             if (sent) {
650                 pool8users[pool8Currentuser].payment_received+=1;
651                 if(pool8users[pool8Currentuser].payment_received>=3)
652                 {
653                     pool8activeUserID+=1;
654                 }
655                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
656             }
657         emit regPoolEntry(msg.sender,8,  now);
658     }
659     
660     
661     
662     function buyPool9() public payable {
663         require(users[msg.sender].isExist, "User Not Registered");
664       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
665         require(msg.value == pool9_price, 'Incorrect Value');
666         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
667        
668         PoolUserStruct memory userStruct;
669         address pool9Currentuser=pool9userList[pool9activeUserID];
670         
671         pool9currUserID++;
672         userStruct = PoolUserStruct({
673             isExist:true,
674             id:pool9currUserID,
675             payment_received:0
676         });
677        pool9users[msg.sender] = userStruct;
678        pool9userList[pool9currUserID]=msg.sender;
679        bool sent = false;
680        sent = address(uint160(pool9Currentuser)).send(pool9_price);
681 
682             if (sent) {
683                 pool9users[pool9Currentuser].payment_received+=1;
684                 if(pool9users[pool9Currentuser].payment_received>=3)
685                 {
686                     pool9activeUserID+=1;
687                 }
688                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
689             }
690         emit regPoolEntry(msg.sender,9,  now);
691     }
692     
693     
694     function buyPool10() public payable {
695         require(users[msg.sender].isExist, "User Not Registered");
696       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
697         require(msg.value == pool10_price, 'Incorrect Value');
698         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
699         
700         PoolUserStruct memory userStruct;
701         address pool10Currentuser=pool10userList[pool10activeUserID];
702         
703         pool10currUserID++;
704         userStruct = PoolUserStruct({
705             isExist:true,
706             id:pool10currUserID,
707             payment_received:0
708         });
709        pool10users[msg.sender] = userStruct;
710        pool10userList[pool10currUserID]=msg.sender;
711        bool sent = false;
712        sent = address(uint160(pool10Currentuser)).send(pool10_price);
713 
714             if (sent) {
715                 pool10users[pool10Currentuser].payment_received+=1;
716                 if(pool10users[pool10Currentuser].payment_received>=3)
717                 {
718                     pool10activeUserID+=1;
719                 }
720                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
721             }
722         emit regPoolEntry(msg.sender, 10, now);
723     }
724     
725     function getEthBalance() public view returns(uint) {
726     return address(this).balance;
727     }
728     
729     function sendBalance() private
730     {
731          if (!address(uint160(ownerWallet)).send(getEthBalance()))
732          {
733              
734          }
735     }
736    
737    
738 }