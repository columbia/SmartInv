1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-15
3 */
4 
5 pragma solidity 0.5.11 - 0.6.4;
6 
7 contract Etherboss {
8      address public ownerWallet;
9       uint public currUserID = 0;
10       uint public pool1currUserID = 0;
11       uint public pool2currUserID = 0;
12       uint public pool3currUserID = 0;
13       uint public pool4currUserID = 0;
14       uint public pool5currUserID = 0;
15       uint public pool6currUserID = 0;
16       uint public pool7currUserID = 0;
17       uint public pool8currUserID = 0;
18       uint public pool9currUserID = 0;
19       uint public pool10currUserID = 0;
20       
21         uint public pool1activeUserID = 0;
22       uint public pool2activeUserID = 0;
23       uint public pool3activeUserID = 0;
24       uint public pool4activeUserID = 0;
25       uint public pool5activeUserID = 0;
26       uint public pool6activeUserID = 0;
27       uint public pool7activeUserID = 0;
28       uint public pool8activeUserID = 0;
29       uint public pool9activeUserID = 0;
30       uint public pool10activeUserID = 0;
31       
32       
33       uint public unlimited_level_price=0;
34      
35       struct UserStruct {
36         bool isExist;
37         uint id;
38         uint referrerID;
39        uint referredUsers;
40         mapping(uint => uint) levelExpired;
41     }
42     
43      struct PoolUserStruct {
44         bool isExist;
45         uint id;
46        uint payment_received; 
47     }
48     
49     mapping (address => UserStruct) public users;
50      mapping (uint => address) public userList;
51      
52      mapping (address => PoolUserStruct) public pool1users;
53      mapping (uint => address) public pool1userList;
54      
55      mapping (address => PoolUserStruct) public pool2users;
56      mapping (uint => address) public pool2userList;
57      
58      mapping (address => PoolUserStruct) public pool3users;
59      mapping (uint => address) public pool3userList;
60      
61      mapping (address => PoolUserStruct) public pool4users;
62      mapping (uint => address) public pool4userList;
63      
64      mapping (address => PoolUserStruct) public pool5users;
65      mapping (uint => address) public pool5userList;
66      
67      mapping (address => PoolUserStruct) public pool6users;
68      mapping (uint => address) public pool6userList;
69      
70      mapping (address => PoolUserStruct) public pool7users;
71      mapping (uint => address) public pool7userList;
72      
73      mapping (address => PoolUserStruct) public pool8users;
74      mapping (uint => address) public pool8userList;
75      
76      mapping (address => PoolUserStruct) public pool9users;
77      mapping (uint => address) public pool9userList;
78      
79      mapping (address => PoolUserStruct) public pool10users;
80      mapping (uint => address) public pool10userList;
81      
82     mapping(uint => uint) public LEVEL_PRICE;
83     
84    uint REGESTRATION_FESS=0.06 ether;
85    uint pool1_price=0.05 ether;
86    uint pool2_price=0.07 ether ;
87    uint pool3_price=0.10 ether;
88    uint pool4_price=0.15 ether;
89    uint pool5_price=0.20 ether;
90    uint pool6_price=0.25 ether;
91    uint pool7_price=0.40 ether ;
92    uint pool8_price=0.7 ether;
93    uint pool9_price=1.5 ether;
94    uint pool10_price=3 ether;
95    
96      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
97       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
98       
99      event regPoolEntry(address indexed _user,uint _level,   uint _time);
100    
101      
102     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
103    
104     UserStruct[] public requests;
105      
106       constructor() public {
107           ownerWallet = msg.sender;
108 
109         LEVEL_PRICE[1] = 0.01 ether;
110         LEVEL_PRICE[2] = 0.003 ether;
111         LEVEL_PRICE[3] = 0.0015 ether;
112         LEVEL_PRICE[4] = 0.00025 ether;
113       unlimited_level_price=0.00025 ether;
114 
115         UserStruct memory userStruct;
116         currUserID++;
117 
118         userStruct = UserStruct({
119             isExist: true,
120             id: currUserID,
121             referrerID: 0,
122             referredUsers:0
123            
124         });
125         
126         users[ownerWallet] = userStruct;
127        userList[currUserID] = ownerWallet;
128        
129        
130          PoolUserStruct memory pooluserStruct;
131         
132         pool1currUserID++;
133 
134         pooluserStruct = PoolUserStruct({
135             isExist:true,
136             id:pool1currUserID,
137             payment_received:0
138         });
139     pool1activeUserID=pool1currUserID;
140        pool1users[msg.sender] = pooluserStruct;
141        pool1userList[pool1currUserID]=msg.sender;
142       
143         
144         pool2currUserID++;
145         pooluserStruct = PoolUserStruct({
146             isExist:true,
147             id:pool2currUserID,
148             payment_received:0
149         });
150     pool2activeUserID=pool2currUserID;
151        pool2users[msg.sender] = pooluserStruct;
152        pool2userList[pool2currUserID]=msg.sender;
153        
154        
155         pool3currUserID++;
156         pooluserStruct = PoolUserStruct({
157             isExist:true,
158             id:pool3currUserID,
159             payment_received:0
160         });
161     pool3activeUserID=pool3currUserID;
162        pool3users[msg.sender] = pooluserStruct;
163        pool3userList[pool3currUserID]=msg.sender;
164        
165        
166          pool4currUserID++;
167         pooluserStruct = PoolUserStruct({
168             isExist:true,
169             id:pool4currUserID,
170             payment_received:0
171         });
172     pool4activeUserID=pool4currUserID;
173        pool4users[msg.sender] = pooluserStruct;
174        pool4userList[pool4currUserID]=msg.sender;
175 
176         
177           pool5currUserID++;
178         pooluserStruct = PoolUserStruct({
179             isExist:true,
180             id:pool5currUserID,
181             payment_received:0
182         });
183     pool5activeUserID=pool5currUserID;
184        pool5users[msg.sender] = pooluserStruct;
185        pool5userList[pool5currUserID]=msg.sender;
186        
187        
188          pool6currUserID++;
189         pooluserStruct = PoolUserStruct({
190             isExist:true,
191             id:pool6currUserID,
192             payment_received:0
193         });
194     pool6activeUserID=pool6currUserID;
195        pool6users[msg.sender] = pooluserStruct;
196        pool6userList[pool6currUserID]=msg.sender;
197        
198          pool7currUserID++;
199         pooluserStruct = PoolUserStruct({
200             isExist:true,
201             id:pool7currUserID,
202             payment_received:0
203         });
204     pool7activeUserID=pool7currUserID;
205        pool7users[msg.sender] = pooluserStruct;
206        pool7userList[pool7currUserID]=msg.sender;
207        
208        pool8currUserID++;
209         pooluserStruct = PoolUserStruct({
210             isExist:true,
211             id:pool8currUserID,
212             payment_received:0
213         });
214     pool8activeUserID=pool8currUserID;
215        pool8users[msg.sender] = pooluserStruct;
216        pool8userList[pool8currUserID]=msg.sender;
217        
218         pool9currUserID++;
219         pooluserStruct = PoolUserStruct({
220             isExist:true,
221             id:pool9currUserID,
222             payment_received:0
223         });
224     pool9activeUserID=pool9currUserID;
225        pool9users[msg.sender] = pooluserStruct;
226        pool9userList[pool9currUserID]=msg.sender;
227        
228        
229         pool10currUserID++;
230         pooluserStruct = PoolUserStruct({
231             isExist:true,
232             id:pool10currUserID,
233             payment_received:0
234         });
235     pool10activeUserID=pool10currUserID;
236        pool10users[msg.sender] = pooluserStruct;
237        pool10userList[pool10currUserID]=msg.sender;
238        
239        
240       }
241      
242        function regUser(uint _referrerID) public payable {
243        
244       require(!users[msg.sender].isExist, "User Exists");
245       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
246         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
247        
248         UserStruct memory userStruct;
249         currUserID++;
250 
251         userStruct = UserStruct({
252             isExist: true,
253             id: currUserID,
254             referrerID: _referrerID,
255             referredUsers:0
256         });
257    
258     
259        users[msg.sender] = userStruct;
260        userList[currUserID]=msg.sender;
261        
262         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
263         
264        payReferral(1,msg.sender);
265         emit regLevelEvent(msg.sender, userList[_referrerID], now);
266     }
267    
268    
269      function payReferral(uint _level, address _user) internal {
270         address referer;
271        
272         referer = userList[users[_user].referrerID];
273        
274        
275          bool sent = false;
276        
277             uint level_price_local=0;
278             if(_level>4){
279             level_price_local=unlimited_level_price;
280             }
281             else{
282             level_price_local=LEVEL_PRICE[_level];
283             }
284             sent = address(uint160(referer)).send(level_price_local);
285 
286             if (sent) {
287                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
288                 if(_level < 100 && users[referer].referrerID >= 1){
289                     payReferral(_level+1,referer);
290                 }
291                 else
292                 {
293                     sendBalance();
294                 }
295                
296             }
297        
298         if(!sent) {
299           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
300 
301             payReferral(_level, referer);
302         }
303      }
304    
305    
306    
307    
308        function buyPool1() public payable {
309        require(users[msg.sender].isExist, "User Not Registered");
310       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
311       
312         require(msg.value == pool1_price, 'Incorrect Value');
313         
314        
315         PoolUserStruct memory userStruct;
316         address pool1Currentuser=pool1userList[pool1activeUserID];
317         
318         pool1currUserID++;
319 
320         userStruct = PoolUserStruct({
321             isExist:true,
322             id:pool1currUserID,
323             payment_received:0
324         });
325    
326        pool1users[msg.sender] = userStruct;
327        pool1userList[pool1currUserID]=msg.sender;
328        bool sent = false;
329        sent = address(uint160(pool1Currentuser)).send(pool1_price);
330 
331             if (sent) {
332                 pool1users[pool1Currentuser].payment_received+=1;
333                 if(pool1users[pool1Currentuser].payment_received>=2)
334                 {
335                     pool1activeUserID+=1;
336                 }
337                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
338             }
339        emit regPoolEntry(msg.sender, 1, now);
340     }
341     
342     
343       function buyPool2() public payable {
344           require(users[msg.sender].isExist, "User Not Registered");
345       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
346         require(msg.value == pool2_price, 'Incorrect Value');
347         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
348          
349         PoolUserStruct memory userStruct;
350         address pool2Currentuser=pool2userList[pool2activeUserID];
351         
352         pool2currUserID++;
353         userStruct = PoolUserStruct({
354             isExist:true,
355             id:pool2currUserID,
356             payment_received:0
357         });
358        pool2users[msg.sender] = userStruct;
359        pool2userList[pool2currUserID]=msg.sender;
360        
361        
362        
363        bool sent = false;
364        sent = address(uint160(pool2Currentuser)).send(pool2_price);
365 
366             if (sent) {
367                 pool2users[pool2Currentuser].payment_received+=1;
368                 if(pool2users[pool2Currentuser].payment_received>=3)
369                 {
370                     pool2activeUserID+=1;
371                 }
372                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
373             }
374             emit regPoolEntry(msg.sender,2,  now);
375     }
376     
377     
378      function buyPool3() public payable {
379          require(users[msg.sender].isExist, "User Not Registered");
380       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
381         require(msg.value == pool3_price, 'Incorrect Value');
382         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
383         
384         PoolUserStruct memory userStruct;
385         address pool3Currentuser=pool3userList[pool3activeUserID];
386         
387         pool3currUserID++;
388         userStruct = PoolUserStruct({
389             isExist:true,
390             id:pool3currUserID,
391             payment_received:0
392         });
393        pool3users[msg.sender] = userStruct;
394        pool3userList[pool3currUserID]=msg.sender;
395        bool sent = false;
396        sent = address(uint160(pool3Currentuser)).send(pool3_price);
397 
398             if (sent) {
399                 pool3users[pool3Currentuser].payment_received+=1;
400                 if(pool3users[pool3Currentuser].payment_received>=3)
401                 {
402                     pool3activeUserID+=1;
403                 }
404                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
405             }
406 emit regPoolEntry(msg.sender,3,  now);
407     }
408     
409     
410     function buyPool4() public payable {
411         require(users[msg.sender].isExist, "User Not Registered");
412       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
413         require(msg.value == pool4_price, 'Incorrect Value');
414         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
415       
416         PoolUserStruct memory userStruct;
417         address pool4Currentuser=pool4userList[pool4activeUserID];
418         
419         pool4currUserID++;
420         userStruct = PoolUserStruct({
421             isExist:true,
422             id:pool4currUserID,
423             payment_received:0
424         });
425        pool4users[msg.sender] = userStruct;
426        pool4userList[pool4currUserID]=msg.sender;
427        bool sent = false;
428        sent = address(uint160(pool4Currentuser)).send(pool4_price);
429 
430             if (sent) {
431                 pool4users[pool4Currentuser].payment_received+=1;
432                 if(pool4users[pool4Currentuser].payment_received>=3)
433                 {
434                     pool4activeUserID+=1;
435                 }
436                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
437             }
438         emit regPoolEntry(msg.sender,4, now);
439     }
440     
441     
442     
443     function buyPool5() public payable {
444         require(users[msg.sender].isExist, "User Not Registered");
445       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
446         require(msg.value == pool5_price, 'Incorrect Value');
447         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
448         
449         PoolUserStruct memory userStruct;
450         address pool5Currentuser=pool5userList[pool5activeUserID];
451         
452         pool5currUserID++;
453         userStruct = PoolUserStruct({
454             isExist:true,
455             id:pool5currUserID,
456             payment_received:0
457         });
458        pool5users[msg.sender] = userStruct;
459        pool5userList[pool5currUserID]=msg.sender;
460        bool sent = false;
461        sent = address(uint160(pool5Currentuser)).send(pool5_price);
462 
463             if (sent) {
464                 pool5users[pool5Currentuser].payment_received+=1;
465                 if(pool5users[pool5Currentuser].payment_received>=3)
466                 {
467                     pool5activeUserID+=1;
468                 }
469                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
470             }
471         emit regPoolEntry(msg.sender,5,  now);
472     }
473     
474     function buyPool6() public payable {
475       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
476         require(msg.value == pool6_price, 'Incorrect Value');
477         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
478         
479         PoolUserStruct memory userStruct;
480         address pool6Currentuser=pool6userList[pool6activeUserID];
481         
482         pool6currUserID++;
483         userStruct = PoolUserStruct({
484             isExist:true,
485             id:pool6currUserID,
486             payment_received:0
487         });
488        pool6users[msg.sender] = userStruct;
489        pool6userList[pool6currUserID]=msg.sender;
490        bool sent = false;
491        sent = address(uint160(pool6Currentuser)).send(pool6_price);
492 
493             if (sent) {
494                 pool6users[pool6Currentuser].payment_received+=1;
495                 if(pool6users[pool6Currentuser].payment_received>=3)
496                 {
497                     pool6activeUserID+=1;
498                 }
499                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
500             }
501         emit regPoolEntry(msg.sender,6,  now);
502     }
503     
504     function buyPool7() public payable {
505         require(users[msg.sender].isExist, "User Not Registered");
506       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
507         require(msg.value == pool7_price, 'Incorrect Value');
508         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
509         
510         PoolUserStruct memory userStruct;
511         address pool7Currentuser=pool7userList[pool7activeUserID];
512         
513         pool7currUserID++;
514         userStruct = PoolUserStruct({
515             isExist:true,
516             id:pool7currUserID,
517             payment_received:0
518         });
519        pool7users[msg.sender] = userStruct;
520        pool7userList[pool7currUserID]=msg.sender;
521        bool sent = false;
522        sent = address(uint160(pool7Currentuser)).send(pool7_price);
523 
524             if (sent) {
525                 pool7users[pool7Currentuser].payment_received+=1;
526                 if(pool7users[pool7Currentuser].payment_received>=3)
527                 {
528                     pool7activeUserID+=1;
529                 }
530                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
531             }
532         emit regPoolEntry(msg.sender,7,  now);
533     }
534     
535     
536     function buyPool8() public payable {
537         require(users[msg.sender].isExist, "User Not Registered");
538       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
539         require(msg.value == pool8_price, 'Incorrect Value');
540         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
541        
542         PoolUserStruct memory userStruct;
543         address pool8Currentuser=pool8userList[pool8activeUserID];
544         
545         pool8currUserID++;
546         userStruct = PoolUserStruct({
547             isExist:true,
548             id:pool8currUserID,
549             payment_received:0
550         });
551        pool8users[msg.sender] = userStruct;
552        pool8userList[pool8currUserID]=msg.sender;
553        bool sent = false;
554        sent = address(uint160(pool8Currentuser)).send(pool8_price);
555 
556             if (sent) {
557                 pool8users[pool8Currentuser].payment_received+=1;
558                 if(pool8users[pool8Currentuser].payment_received>=3)
559                 {
560                     pool8activeUserID+=1;
561                 }
562                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
563             }
564         emit regPoolEntry(msg.sender,8,  now);
565     }
566     
567     
568     
569     function buyPool9() public payable {
570         require(users[msg.sender].isExist, "User Not Registered");
571       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
572         require(msg.value == pool9_price, 'Incorrect Value');
573         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
574        
575         PoolUserStruct memory userStruct;
576         address pool9Currentuser=pool9userList[pool9activeUserID];
577         
578         pool9currUserID++;
579         userStruct = PoolUserStruct({
580             isExist:true,
581             id:pool9currUserID,
582             payment_received:0
583         });
584        pool9users[msg.sender] = userStruct;
585        pool9userList[pool9currUserID]=msg.sender;
586        bool sent = false;
587        sent = address(uint160(pool9Currentuser)).send(pool9_price);
588 
589             if (sent) {
590                 pool9users[pool9Currentuser].payment_received+=1;
591                 if(pool9users[pool9Currentuser].payment_received>=3)
592                 {
593                     pool9activeUserID+=1;
594                 }
595                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
596             }
597         emit regPoolEntry(msg.sender,9,  now);
598     }
599     
600     
601     function buyPool10() public payable {
602         require(users[msg.sender].isExist, "User Not Registered");
603       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
604         require(msg.value == pool10_price, 'Incorrect Value');
605         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
606         
607         PoolUserStruct memory userStruct;
608         address pool10Currentuser=pool10userList[pool10activeUserID];
609         
610         pool10currUserID++;
611         userStruct = PoolUserStruct({
612             isExist:true,
613             id:pool10currUserID,
614             payment_received:0
615         });
616        pool10users[msg.sender] = userStruct;
617        pool10userList[pool10currUserID]=msg.sender;
618        bool sent = false;
619        sent = address(uint160(pool10Currentuser)).send(pool10_price);
620 
621             if (sent) {
622                 pool10users[pool10Currentuser].payment_received+=1;
623                 if(pool10users[pool10Currentuser].payment_received>=3)
624                 {
625                     pool10activeUserID+=1;
626                 }
627                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
628             }
629         emit regPoolEntry(msg.sender, 10, now);
630     }
631     
632     function getEthBalance() public view returns(uint) {
633     return address(this).balance;
634     }
635     
636     function sendBalance() private
637     {
638          if (!address(uint160(ownerWallet)).send(getEthBalance()))
639          {
640              
641          }
642     }
643    
644    
645 }