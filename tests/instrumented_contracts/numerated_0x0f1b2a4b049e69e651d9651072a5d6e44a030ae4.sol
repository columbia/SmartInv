1 /*
2 EasyPool
3 Easy and Fast AutoPool
4 
5 Donate 0.03 Ether and Earn 15+ Ether !
6 1. Attractive Direct Income
7 2. 12 Super Autopool Income
8 
9 Website  : https://easypool.live
10 Telegram : @easypool_official
11 
12 ==========================================================================================
13 */
14 
15 pragma solidity 0.5.11;
16 
17 contract EasyPool {
18      address public ownerWallet;
19       uint public currUserID = 0;
20       uint public pool1currUserID = 0;
21       uint public pool2currUserID = 0;
22       uint public pool3currUserID = 0;
23       uint public pool4currUserID = 0;
24       uint public pool5currUserID = 0;
25       uint public pool6currUserID = 0;
26       uint public pool7currUserID = 0;
27       uint public pool8currUserID = 0;
28       uint public pool9currUserID = 0;
29       uint public pool10currUserID = 0;
30       uint public pool11currUserID = 0;
31       uint public pool12currUserID = 0;
32       
33         uint public pool1activeUserID = 0;
34       uint public pool2activeUserID = 0;
35       uint public pool3activeUserID = 0;
36       uint public pool4activeUserID = 0;
37       uint public pool5activeUserID = 0;
38       uint public pool6activeUserID = 0;
39       uint public pool7activeUserID = 0;
40       uint public pool8activeUserID = 0;
41       uint public pool9activeUserID = 0;
42       uint public pool10activeUserID = 0;
43       uint public pool11activeUserID = 0;
44       uint public pool12activeUserID = 0;
45       
46       
47       uint public unlimited_level_price=0;
48      
49       struct UserStruct {
50         bool isExist;
51         uint id;
52         uint referrerID;
53        uint referredUsers;
54         mapping(uint => uint) levelExpired;
55     }
56     
57      struct PoolUserStruct {
58         bool isExist;
59         uint id;
60        uint payment_received; 
61     }
62     
63     mapping (address => UserStruct) public users;
64      mapping (uint => address) public userList;
65      
66      mapping (address => PoolUserStruct) public pool1users;
67      mapping (uint => address) public pool1userList;
68      
69      mapping (address => PoolUserStruct) public pool2users;
70      mapping (uint => address) public pool2userList;
71      
72      mapping (address => PoolUserStruct) public pool3users;
73      mapping (uint => address) public pool3userList;
74      
75      mapping (address => PoolUserStruct) public pool4users;
76      mapping (uint => address) public pool4userList;
77      
78      mapping (address => PoolUserStruct) public pool5users;
79      mapping (uint => address) public pool5userList;
80      
81      mapping (address => PoolUserStruct) public pool6users;
82      mapping (uint => address) public pool6userList;
83      
84      mapping (address => PoolUserStruct) public pool7users;
85      mapping (uint => address) public pool7userList;
86      
87      mapping (address => PoolUserStruct) public pool8users;
88      mapping (uint => address) public pool8userList;
89      
90      mapping (address => PoolUserStruct) public pool9users;
91      mapping (uint => address) public pool9userList;
92      
93      mapping (address => PoolUserStruct) public pool10users;
94      mapping (uint => address) public pool10userList;
95      
96      mapping (address => PoolUserStruct) public pool11users;
97      mapping (uint => address) public pool11userList;
98      
99      mapping (address => PoolUserStruct) public pool12users;
100      mapping (uint => address) public pool12userList;
101      
102     mapping(uint => uint) public LEVEL_PRICE;
103     
104    uint REGESTRATION_FESS=0.03 ether;
105    uint pool1_price=0.05 ether;
106    uint pool2_price=0.075 ether ;
107    uint pool3_price=0.1 ether;
108    uint pool4_price=0.15 ether;
109    uint pool5_price=0.2 ether;
110    uint pool6_price=0.3 ether;
111    uint pool7_price=0.5 ether ;
112    uint pool8_price=0.75 ether;
113    uint pool9_price=1 ether;
114    uint pool10_price=2 ether;
115    uint pool11_price=3 ether;
116    uint pool12_price=5 ether ;
117    
118      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
119       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
120       
121      event regPoolEntry(address indexed _user,uint _level,   uint _time);
122    
123      
124     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
125    
126     UserStruct[] public requests;
127      
128       constructor() public {
129           ownerWallet = msg.sender;
130 
131         LEVEL_PRICE[1] = 0.03 ether;
132 /*        
133       unlimited_level_price=0 ether;
134 */
135         UserStruct memory userStruct;
136         currUserID++;
137 
138         userStruct = UserStruct({
139             isExist: true,
140             id: currUserID,
141             referrerID: 0,
142             referredUsers:0
143            
144         });
145         
146         users[ownerWallet] = userStruct;
147        userList[currUserID] = ownerWallet;
148        
149        
150          PoolUserStruct memory pooluserStruct;
151         
152         pool1currUserID++;
153 
154         pooluserStruct = PoolUserStruct({
155             isExist:true,
156             id:pool1currUserID,
157             payment_received:0
158         });
159     pool1activeUserID=pool1currUserID;
160        pool1users[msg.sender] = pooluserStruct;
161        pool1userList[pool1currUserID]=msg.sender;
162       
163         
164         pool2currUserID++;
165         pooluserStruct = PoolUserStruct({
166             isExist:true,
167             id:pool2currUserID,
168             payment_received:0
169         });
170     pool2activeUserID=pool2currUserID;
171        pool2users[msg.sender] = pooluserStruct;
172        pool2userList[pool2currUserID]=msg.sender;
173        
174        
175         pool3currUserID++;
176         pooluserStruct = PoolUserStruct({
177             isExist:true,
178             id:pool3currUserID,
179             payment_received:0
180         });
181     pool3activeUserID=pool3currUserID;
182        pool3users[msg.sender] = pooluserStruct;
183        pool3userList[pool3currUserID]=msg.sender;
184        
185        
186          pool4currUserID++;
187         pooluserStruct = PoolUserStruct({
188             isExist:true,
189             id:pool4currUserID,
190             payment_received:0
191         });
192     pool4activeUserID=pool4currUserID;
193        pool4users[msg.sender] = pooluserStruct;
194        pool4userList[pool4currUserID]=msg.sender;
195 
196         
197           pool5currUserID++;
198         pooluserStruct = PoolUserStruct({
199             isExist:true,
200             id:pool5currUserID,
201             payment_received:0
202         });
203     pool5activeUserID=pool5currUserID;
204        pool5users[msg.sender] = pooluserStruct;
205        pool5userList[pool5currUserID]=msg.sender;
206        
207        
208          pool6currUserID++;
209         pooluserStruct = PoolUserStruct({
210             isExist:true,
211             id:pool6currUserID,
212             payment_received:0
213         });
214     pool6activeUserID=pool6currUserID;
215        pool6users[msg.sender] = pooluserStruct;
216        pool6userList[pool6currUserID]=msg.sender;
217        
218          pool7currUserID++;
219         pooluserStruct = PoolUserStruct({
220             isExist:true,
221             id:pool7currUserID,
222             payment_received:0
223         });
224     pool7activeUserID=pool7currUserID;
225        pool7users[msg.sender] = pooluserStruct;
226        pool7userList[pool7currUserID]=msg.sender;
227        
228        pool8currUserID++;
229         pooluserStruct = PoolUserStruct({
230             isExist:true,
231             id:pool8currUserID,
232             payment_received:0
233         });
234     pool8activeUserID=pool8currUserID;
235        pool8users[msg.sender] = pooluserStruct;
236        pool8userList[pool8currUserID]=msg.sender;
237        
238         pool9currUserID++;
239         pooluserStruct = PoolUserStruct({
240             isExist:true,
241             id:pool9currUserID,
242             payment_received:0
243         });
244     pool9activeUserID=pool9currUserID;
245        pool9users[msg.sender] = pooluserStruct;
246        pool9userList[pool9currUserID]=msg.sender;
247        
248        
249         pool10currUserID++;
250         pooluserStruct = PoolUserStruct({
251             isExist:true,
252             id:pool10currUserID,
253             payment_received:0
254         });
255     pool10activeUserID=pool10currUserID;
256        pool10users[msg.sender] = pooluserStruct;
257        pool10userList[pool10currUserID]=msg.sender;
258        
259        
260        pool11currUserID++;
261         pooluserStruct = PoolUserStruct({
262             isExist:true,
263             id:pool11currUserID,
264             payment_received:0
265        
266       });
267       pool11activeUserID=pool11currUserID;
268        pool11users[msg.sender] = pooluserStruct;
269        pool11userList[pool11currUserID]=msg.sender;
270        
271        
272        pool12currUserID++;
273         pooluserStruct = PoolUserStruct({
274             isExist:true,
275             id:pool12currUserID,
276             payment_received:0
277        
278       });
279       pool12activeUserID=pool12currUserID;
280        pool12users[msg.sender] = pooluserStruct;
281        pool12userList[pool12currUserID]=msg.sender;
282 
283        
284       }
285      
286        function regUser(uint _referrerID) public payable {
287        
288       require(!users[msg.sender].isExist, "User Exists");
289       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
290         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
291        
292         UserStruct memory userStruct;
293         currUserID++;
294 
295         userStruct = UserStruct({
296             isExist: true,
297             id: currUserID,
298             referrerID: _referrerID,
299             referredUsers:0
300         });
301    
302     
303        users[msg.sender] = userStruct;
304        userList[currUserID]=msg.sender;
305        
306         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
307         
308        payReferral(1,msg.sender);
309         emit regLevelEvent(msg.sender, userList[_referrerID], now);
310     }
311    
312    
313      function payReferral(uint _level, address _user) internal {
314         address referer;
315        
316         referer = userList[users[_user].referrerID];
317        
318        
319          bool sent = false;
320        
321             uint level_price_local=0;
322             if(_level>1){
323             level_price_local=unlimited_level_price;
324             }
325             else{
326             level_price_local=LEVEL_PRICE[_level];
327             }
328             sent = address(uint160(referer)).send(level_price_local);
329 
330             if (sent) {
331                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
332                 if(_level < 1 && users[referer].referrerID >= 1){
333                     payReferral(_level+1,referer);
334                 }
335                 
336                 else
337                 {
338                     sendBalance();
339                 }
340                
341             }
342        
343         if(!sent) {
344           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
345 
346             payReferral(_level, referer);
347         }
348      }
349    
350    
351    
352        function buyPool1() public payable {
353        require(users[msg.sender].isExist, "User Not Registered");
354       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
355       
356         require(msg.value == pool1_price, 'Incorrect Value');
357         
358        
359         PoolUserStruct memory userStruct;
360         address pool1Currentuser=pool1userList[pool1activeUserID];
361         
362         pool1currUserID++;
363 
364         userStruct = PoolUserStruct({
365             isExist:true,
366             id:pool1currUserID,
367             payment_received:0
368         });
369    
370        pool1users[msg.sender] = userStruct;
371        pool1userList[pool1currUserID]=msg.sender;
372        bool sent = false;
373        sent = address(uint160(pool1Currentuser)).send(pool1_price);
374 
375             if (sent) {
376                 pool1users[pool1Currentuser].payment_received+=1;
377                 if(pool1users[pool1Currentuser].payment_received>=2)
378                 {
379                     pool1activeUserID+=1;
380                 }
381                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
382             }
383        emit regPoolEntry(msg.sender, 1, now);
384     }
385     
386     
387       function buyPool2() public payable {
388           require(users[msg.sender].isExist, "User Not Registered");
389       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
390         require(msg.value == pool2_price, 'Incorrect Value');
391          
392         PoolUserStruct memory userStruct;
393         address pool2Currentuser=pool2userList[pool2activeUserID];
394         
395         pool2currUserID++;
396         userStruct = PoolUserStruct({
397             isExist:true,
398             id:pool2currUserID,
399             payment_received:0
400         });
401        pool2users[msg.sender] = userStruct;
402        pool2userList[pool2currUserID]=msg.sender;
403        
404        
405        
406        bool sent = false;
407        sent = address(uint160(pool2Currentuser)).send(pool2_price);
408 
409             if (sent) {
410                 pool2users[pool2Currentuser].payment_received+=1;
411                 if(pool2users[pool2Currentuser].payment_received>=2)
412                 {
413                     pool2activeUserID+=1;
414                 }
415                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
416             }
417             emit regPoolEntry(msg.sender,2,  now);
418     }
419     
420     
421      function buyPool3() public payable {
422          require(users[msg.sender].isExist, "User Not Registered");
423       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
424         require(msg.value == pool3_price, 'Incorrect Value');
425         
426         PoolUserStruct memory userStruct;
427         address pool3Currentuser=pool3userList[pool3activeUserID];
428         
429         pool3currUserID++;
430         userStruct = PoolUserStruct({
431             isExist:true,
432             id:pool3currUserID,
433             payment_received:0
434         });
435        pool3users[msg.sender] = userStruct;
436        pool3userList[pool3currUserID]=msg.sender;
437        bool sent = false;
438        sent = address(uint160(pool3Currentuser)).send(pool3_price);
439 
440             if (sent) {
441                 pool3users[pool3Currentuser].payment_received+=1;
442                 if(pool3users[pool3Currentuser].payment_received>=2)
443                 {
444                     pool3activeUserID+=1;
445                 }
446                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
447             }
448 emit regPoolEntry(msg.sender,3,  now);
449     }
450     
451     
452     function buyPool4() public payable {
453         require(users[msg.sender].isExist, "User Not Registered");
454       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
455         require(msg.value == pool4_price, 'Incorrect Value');
456       
457         PoolUserStruct memory userStruct;
458         address pool4Currentuser=pool4userList[pool4activeUserID];
459         
460         pool4currUserID++;
461         userStruct = PoolUserStruct({
462             isExist:true,
463             id:pool4currUserID,
464             payment_received:0
465         });
466        pool4users[msg.sender] = userStruct;
467        pool4userList[pool4currUserID]=msg.sender;
468        bool sent = false;
469        sent = address(uint160(pool4Currentuser)).send(pool4_price);
470 
471             if (sent) {
472                 pool4users[pool4Currentuser].payment_received+=1;
473                 if(pool4users[pool4Currentuser].payment_received>=2)
474                 {
475                     pool4activeUserID+=1;
476                 }
477                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
478             }
479         emit regPoolEntry(msg.sender,4, now);
480     }
481     
482     
483     
484     function buyPool5() public payable {
485         require(users[msg.sender].isExist, "User Not Registered");
486       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
487         require(msg.value == pool5_price, 'Incorrect Value');
488         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
489         
490         PoolUserStruct memory userStruct;
491         address pool5Currentuser=pool5userList[pool5activeUserID];
492         
493         pool5currUserID++;
494         userStruct = PoolUserStruct({
495             isExist:true,
496             id:pool5currUserID,
497             payment_received:0
498         });
499        pool5users[msg.sender] = userStruct;
500        pool5userList[pool5currUserID]=msg.sender;
501        bool sent = false;
502        sent = address(uint160(pool5Currentuser)).send(pool5_price);
503 
504             if (sent) {
505                 pool5users[pool5Currentuser].payment_received+=1;
506                 if(pool5users[pool5Currentuser].payment_received>=2)
507                 {
508                     pool5activeUserID+=1;
509                 }
510                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
511             }
512         emit regPoolEntry(msg.sender,5,  now);
513     }
514     
515     function buyPool6() public payable {
516       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
517         require(msg.value == pool6_price, 'Incorrect Value');
518         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
519         
520         PoolUserStruct memory userStruct;
521         address pool6Currentuser=pool6userList[pool6activeUserID];
522         
523         pool6currUserID++;
524         userStruct = PoolUserStruct({
525             isExist:true,
526             id:pool6currUserID,
527             payment_received:0
528         });
529        pool6users[msg.sender] = userStruct;
530        pool6userList[pool6currUserID]=msg.sender;
531        bool sent = false;
532        sent = address(uint160(pool6Currentuser)).send(pool6_price);
533 
534             if (sent) {
535                 pool6users[pool6Currentuser].payment_received+=1;
536                 if(pool6users[pool6Currentuser].payment_received>=2)
537                 {
538                     pool6activeUserID+=1;
539                 }
540                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
541             }
542         emit regPoolEntry(msg.sender,6,  now);
543     }
544     
545     function buyPool7() public payable {
546         require(users[msg.sender].isExist, "User Not Registered");
547       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
548         require(msg.value == pool7_price, 'Incorrect Value');
549         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
550         
551         PoolUserStruct memory userStruct;
552         address pool7Currentuser=pool7userList[pool7activeUserID];
553         
554         pool7currUserID++;
555         userStruct = PoolUserStruct({
556             isExist:true,
557             id:pool7currUserID,
558             payment_received:0
559         });
560        pool7users[msg.sender] = userStruct;
561        pool7userList[pool7currUserID]=msg.sender;
562        bool sent = false;
563        sent = address(uint160(pool7Currentuser)).send(pool7_price);
564 
565             if (sent) {
566                 pool7users[pool7Currentuser].payment_received+=1;
567                 if(pool7users[pool7Currentuser].payment_received>=2)
568                 {
569                     pool7activeUserID+=1;
570                 }
571                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
572             }
573         emit regPoolEntry(msg.sender,7,  now);
574     }
575     
576     
577     function buyPool8() public payable {
578         require(users[msg.sender].isExist, "User Not Registered");
579       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
580         require(msg.value == pool8_price, 'Incorrect Value');
581         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
582        
583         PoolUserStruct memory userStruct;
584         address pool8Currentuser=pool8userList[pool8activeUserID];
585         
586         pool8currUserID++;
587         userStruct = PoolUserStruct({
588             isExist:true,
589             id:pool8currUserID,
590             payment_received:0
591         });
592        pool8users[msg.sender] = userStruct;
593        pool8userList[pool8currUserID]=msg.sender;
594        bool sent = false;
595        sent = address(uint160(pool8Currentuser)).send(pool8_price);
596 
597             if (sent) {
598                 pool8users[pool8Currentuser].payment_received+=1;
599                 if(pool8users[pool8Currentuser].payment_received>=2)
600                 {
601                     pool8activeUserID+=1;
602                 }
603                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
604             }
605         emit regPoolEntry(msg.sender,8,  now);
606     }
607     
608     
609     
610     function buyPool9() public payable {
611         require(users[msg.sender].isExist, "User Not Registered");
612       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
613         require(msg.value == pool9_price, 'Incorrect Value');
614         require(users[msg.sender].referredUsers>=2, "Must need 2 referral");
615        
616         PoolUserStruct memory userStruct;
617         address pool9Currentuser=pool9userList[pool9activeUserID];
618         
619         pool9currUserID++;
620         userStruct = PoolUserStruct({
621             isExist:true,
622             id:pool9currUserID,
623             payment_received:0
624         });
625        pool9users[msg.sender] = userStruct;
626        pool9userList[pool9currUserID]=msg.sender;
627        bool sent = false;
628        sent = address(uint160(pool9Currentuser)).send(pool9_price);
629 
630             if (sent) {
631                 pool9users[pool9Currentuser].payment_received+=1;
632                 if(pool9users[pool9Currentuser].payment_received>=3)
633                 {
634                     pool9activeUserID+=1;
635                 }
636                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
637             }
638         emit regPoolEntry(msg.sender,9,  now);
639     }
640     
641     
642     function buyPool10() public payable {
643         require(users[msg.sender].isExist, "User Not Registered");
644       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
645         require(msg.value == pool10_price, 'Incorrect Value');
646         require(users[msg.sender].referredUsers>=2, "Must need 2 referral");
647         
648         PoolUserStruct memory userStruct;
649         address pool10Currentuser=pool10userList[pool10activeUserID];
650         
651         pool10currUserID++;
652         userStruct = PoolUserStruct({
653             isExist:true,
654             id:pool10currUserID,
655             payment_received:0
656         });
657        pool10users[msg.sender] = userStruct;
658        pool10userList[pool10currUserID]=msg.sender;
659        bool sent = false;
660        sent = address(uint160(pool10Currentuser)).send(pool10_price);
661 
662             if (sent) {
663                 pool10users[pool10Currentuser].payment_received+=1;
664                 if(pool10users[pool10Currentuser].payment_received>=3)
665                 {
666                     pool10activeUserID+=1;
667                 }
668                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
669             }
670         emit regPoolEntry(msg.sender, 10, now);
671     }
672     
673     function buyPool11() public payable {
674         require(users[msg.sender].isExist, "User Not Registered");
675       require(!pool11users[msg.sender].isExist, "Already in AutoPool");
676         require(msg.value == pool11_price, 'Incorrect Value');
677         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
678         
679         PoolUserStruct memory userStruct;
680         address pool11Currentuser=pool11userList[pool11activeUserID];
681         
682         pool11currUserID++;
683         userStruct = PoolUserStruct({
684             isExist:true,
685             id:pool11currUserID,
686             payment_received:0
687         });
688        pool11users[msg.sender] = userStruct;
689        pool11userList[pool11currUserID]=msg.sender;
690        bool sent = false;
691        sent = address(uint160(pool11Currentuser)).send(pool11_price);
692 
693             if (sent) {
694                 pool11users[pool11Currentuser].payment_received+=1;
695                 if(pool11users[pool11Currentuser].payment_received>=3)
696                 {
697                     pool11activeUserID+=1;
698                 }
699                  emit getPoolPayment(msg.sender,pool11Currentuser, 11, now);
700             }
701         emit regPoolEntry(msg.sender, 11, now);
702     }
703     
704     function buyPool12() public payable {
705         require(users[msg.sender].isExist, "User Not Registered");
706       require(!pool12users[msg.sender].isExist, "Already in AutoPool");
707         require(msg.value == pool12_price, 'Incorrect Value');
708         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
709         
710         PoolUserStruct memory userStruct;
711         address pool12Currentuser=pool12userList[pool12activeUserID];
712         
713         pool12currUserID++;
714         userStruct = PoolUserStruct({
715             isExist:true,
716             id:pool12currUserID,
717             payment_received:0
718         });
719        pool12users[msg.sender] = userStruct;
720        pool12userList[pool12currUserID]=msg.sender;
721        bool sent = false;
722        sent = address(uint160(pool12Currentuser)).send(pool12_price);
723 
724             if (sent) {
725                 pool12users[pool12Currentuser].payment_received+=1;
726                 if(pool12users[pool12Currentuser].payment_received>=3)
727                 {
728                     pool12activeUserID+=1;
729                 }
730                  emit getPoolPayment(msg.sender,pool12Currentuser, 12, now);
731             }
732         emit regPoolEntry(msg.sender, 12, now);
733     }
734     
735     function getEthBalance() public view returns(uint) {
736     return address(this).balance;
737     }
738     
739     function sendBalance() private
740     {
741          if (!address(uint160(ownerWallet)).send(getEthBalance()))
742          {
743              
744          }
745     }
746    
747    
748 }