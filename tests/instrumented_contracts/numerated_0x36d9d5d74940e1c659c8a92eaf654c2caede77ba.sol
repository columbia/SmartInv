1 /*
2  ████████╗ ██╗  ██████╗  ███████╗ ██████╗  ███████╗
3  ╚══██╔══╝ ██║ ██╔════╝  ██╔════╝ ██╔══██╗ ██╔════╝
4     ██║    ██║ ██║  ███╗ █████╗   ██████╔╝ ███████╗
5     ██║    ██║ ██║   ██║ ██╔══╝   ██╔══██╗ ╚════██║
6     ██║    ██║ ╚██████╔╝ ███████╗ ██║  ██║ ███████║
7     ╚═╝    ╚═╝  ╚═════╝  ╚══════╝ ╚═╝  ╚═╝ ╚══════╝
8 
9            ██╗      ██╗ ███╗   ██╗ ███████╗
10            ██║      ██║ ████╗  ██║ ██╔════╝
11            ██║      ██║ ██╔██╗ ██║ █████╗
12            ██║      ██║ ██║╚██╗██║ ██╔══╝
13            ███████╗ ██║ ██║ ╚████║ ███████╗
14            ╚══════╝ ╚═╝ ╚═╝  ╚═══╝ ╚══════╝
15 Hello 
16 I am TigersLine,
17 Global One line AutoPool Smart contract.
18 
19 My URL : https://tigersline.cash
20 Hashtag: #tigerslinecash
21 */
22 pragma solidity 0.5.11;
23 
24 contract TigersLine {
25      address public ownerWallet;
26       uint public currUserID = 0;
27       uint public pool1currUserID = 0;
28       uint public pool2currUserID = 0;
29       uint public pool3currUserID = 0;
30       uint public pool4currUserID = 0;
31       uint public pool5currUserID = 0;
32       uint public pool6currUserID = 0;
33       uint public pool7currUserID = 0;
34       uint public pool8currUserID = 0;
35       uint public pool9currUserID = 0;
36       uint public pool10currUserID = 0;
37       
38         uint public pool1activeUserID = 0;
39       uint public pool2activeUserID = 0;
40       uint public pool3activeUserID = 0;
41       uint public pool4activeUserID = 0;
42       uint public pool5activeUserID = 0;
43       uint public pool6activeUserID = 0;
44       uint public pool7activeUserID = 0;
45       uint public pool8activeUserID = 0;
46       uint public pool9activeUserID = 0;
47       uint public pool10activeUserID = 0;
48       
49       
50       uint public unlimited_level_price=0;
51      
52       struct UserStruct {
53         bool isExist;
54         uint id;
55         uint referrerID;
56        uint referredUsers;
57         mapping(uint => uint) levelExpired;
58     }
59     
60      struct PoolUserStruct {
61         bool isExist;
62         uint id;
63        uint payment_received; 
64     }
65     
66     mapping (address => UserStruct) public users;
67      mapping (uint => address) public userList;
68      
69      mapping (address => PoolUserStruct) public pool1users;
70      mapping (uint => address) public pool1userList;
71      
72      mapping (address => PoolUserStruct) public pool2users;
73      mapping (uint => address) public pool2userList;
74      
75      mapping (address => PoolUserStruct) public pool3users;
76      mapping (uint => address) public pool3userList;
77      
78      mapping (address => PoolUserStruct) public pool4users;
79      mapping (uint => address) public pool4userList;
80      
81      mapping (address => PoolUserStruct) public pool5users;
82      mapping (uint => address) public pool5userList;
83      
84      mapping (address => PoolUserStruct) public pool6users;
85      mapping (uint => address) public pool6userList;
86      
87      mapping (address => PoolUserStruct) public pool7users;
88      mapping (uint => address) public pool7userList;
89      
90      mapping (address => PoolUserStruct) public pool8users;
91      mapping (uint => address) public pool8userList;
92      
93      mapping (address => PoolUserStruct) public pool9users;
94      mapping (uint => address) public pool9userList;
95      
96      mapping (address => PoolUserStruct) public pool10users;
97      mapping (uint => address) public pool10userList;
98      
99     mapping(uint => uint) public LEVEL_PRICE;
100     
101    uint REGESTRATION_FESS=0.1 ether;
102    uint pool1_price=0.1 ether;
103    uint pool2_price=0.5 ether ;
104    uint pool3_price=1 ether;
105    uint pool4_price=2 ether;
106    uint pool5_price=4 ether;
107    uint pool6_price=8 ether;
108    uint pool7_price=16 ether ;
109    uint pool8_price=32 ether;
110    uint pool9_price=64 ether;
111    uint pool10_price=128 ether;
112    
113      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
114       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
115       
116      event regPoolEntry(address indexed _user,uint _level,   uint _time);
117    
118      
119     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
120    
121     UserStruct[] public requests;
122      
123       constructor() public {
124           ownerWallet = msg.sender;
125 
126         LEVEL_PRICE[1] = 0.022 ether;
127         LEVEL_PRICE[2] = 0.012 ether;
128         LEVEL_PRICE[3] = 0.005 ether;
129         LEVEL_PRICE[4] = 0.0005 ether;
130       unlimited_level_price=0.0005 ether;
131 
132         UserStruct memory userStruct;
133         currUserID++;
134 
135         userStruct = UserStruct({
136             isExist: true,
137             id: currUserID,
138             referrerID: 0,
139             referredUsers:0
140            
141         });
142         
143         users[ownerWallet] = userStruct;
144        userList[currUserID] = ownerWallet;
145        
146        
147          PoolUserStruct memory pooluserStruct;
148         
149         pool1currUserID++;
150 
151         pooluserStruct = PoolUserStruct({
152             isExist:true,
153             id:pool1currUserID,
154             payment_received:0
155         });
156     pool1activeUserID=pool1currUserID;
157        pool1users[msg.sender] = pooluserStruct;
158        pool1userList[pool1currUserID]=msg.sender;
159       
160         
161         pool2currUserID++;
162         pooluserStruct = PoolUserStruct({
163             isExist:true,
164             id:pool2currUserID,
165             payment_received:0
166         });
167     pool2activeUserID=pool2currUserID;
168        pool2users[msg.sender] = pooluserStruct;
169        pool2userList[pool2currUserID]=msg.sender;
170        
171        
172         pool3currUserID++;
173         pooluserStruct = PoolUserStruct({
174             isExist:true,
175             id:pool3currUserID,
176             payment_received:0
177         });
178     pool3activeUserID=pool3currUserID;
179        pool3users[msg.sender] = pooluserStruct;
180        pool3userList[pool3currUserID]=msg.sender;
181        
182        
183          pool4currUserID++;
184         pooluserStruct = PoolUserStruct({
185             isExist:true,
186             id:pool4currUserID,
187             payment_received:0
188         });
189     pool4activeUserID=pool4currUserID;
190        pool4users[msg.sender] = pooluserStruct;
191        pool4userList[pool4currUserID]=msg.sender;
192 
193         
194           pool5currUserID++;
195         pooluserStruct = PoolUserStruct({
196             isExist:true,
197             id:pool5currUserID,
198             payment_received:0
199         });
200     pool5activeUserID=pool5currUserID;
201        pool5users[msg.sender] = pooluserStruct;
202        pool5userList[pool5currUserID]=msg.sender;
203        
204        
205          pool6currUserID++;
206         pooluserStruct = PoolUserStruct({
207             isExist:true,
208             id:pool6currUserID,
209             payment_received:0
210         });
211     pool6activeUserID=pool6currUserID;
212        pool6users[msg.sender] = pooluserStruct;
213        pool6userList[pool6currUserID]=msg.sender;
214        
215          pool7currUserID++;
216         pooluserStruct = PoolUserStruct({
217             isExist:true,
218             id:pool7currUserID,
219             payment_received:0
220         });
221     pool7activeUserID=pool7currUserID;
222        pool7users[msg.sender] = pooluserStruct;
223        pool7userList[pool7currUserID]=msg.sender;
224        
225        pool8currUserID++;
226         pooluserStruct = PoolUserStruct({
227             isExist:true,
228             id:pool8currUserID,
229             payment_received:0
230         });
231     pool8activeUserID=pool8currUserID;
232        pool8users[msg.sender] = pooluserStruct;
233        pool8userList[pool8currUserID]=msg.sender;
234        
235         pool9currUserID++;
236         pooluserStruct = PoolUserStruct({
237             isExist:true,
238             id:pool9currUserID,
239             payment_received:0
240         });
241     pool9activeUserID=pool9currUserID;
242        pool9users[msg.sender] = pooluserStruct;
243        pool9userList[pool9currUserID]=msg.sender;
244        
245        
246         pool10currUserID++;
247         pooluserStruct = PoolUserStruct({
248             isExist:true,
249             id:pool10currUserID,
250             payment_received:0
251         });
252     pool10activeUserID=pool10currUserID;
253        pool10users[msg.sender] = pooluserStruct;
254        pool10userList[pool10currUserID]=msg.sender;
255        
256        
257       }
258      
259        function regUser(uint _referrerID) public payable {
260        
261       require(!users[msg.sender].isExist, "User Exists");
262       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
263         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
264        
265         UserStruct memory userStruct;
266         currUserID++;
267 
268         userStruct = UserStruct({
269             isExist: true,
270             id: currUserID,
271             referrerID: _referrerID,
272             referredUsers:0
273         });
274    
275     
276        users[msg.sender] = userStruct;
277        userList[currUserID]=msg.sender;
278        
279         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
280         
281        payReferral(1,msg.sender);
282         emit regLevelEvent(msg.sender, userList[_referrerID], now);
283     }
284    
285    
286      function payReferral(uint _level, address _user) internal {
287         address referer;
288        
289         referer = userList[users[_user].referrerID];
290        
291        
292          bool sent = false;
293        
294             uint level_price_local=0;
295             if(_level>4){
296             level_price_local=unlimited_level_price;
297             }
298             else{
299             level_price_local=LEVEL_PRICE[_level];
300             }
301             sent = address(uint160(referer)).send(level_price_local);
302 
303             if (sent) {
304                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
305                 if(_level < 100 && users[referer].referrerID >= 1){
306                     payReferral(_level+1,referer);
307                 }
308                 else
309                 {
310                     sendBalance();
311                 }
312                
313             }
314        
315         if(!sent) {
316           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
317 
318             payReferral(_level, referer);
319         }
320      }
321    
322    
323    
324    
325        function buyPool1() public payable {
326        require(users[msg.sender].isExist, "User Not Registered");
327       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
328       
329         require(msg.value == pool1_price, 'Incorrect Value');
330         
331        
332         PoolUserStruct memory userStruct;
333         address pool1Currentuser=pool1userList[pool1activeUserID];
334         
335         pool1currUserID++;
336 
337         userStruct = PoolUserStruct({
338             isExist:true,
339             id:pool1currUserID,
340             payment_received:0
341         });
342    
343        pool1users[msg.sender] = userStruct;
344        pool1userList[pool1currUserID]=msg.sender;
345        bool sent = false;
346        sent = address(uint160(pool1Currentuser)).send(pool1_price);
347 
348             if (sent) {
349                 pool1users[pool1Currentuser].payment_received+=1;
350                 if(pool1users[pool1Currentuser].payment_received>=2)
351                 {
352                     pool1activeUserID+=1;
353                 }
354                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
355             }
356        emit regPoolEntry(msg.sender, 1, now);
357     }
358     
359     
360       function buyPool2() public payable {
361           require(users[msg.sender].isExist, "User Not Registered");
362       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
363         require(msg.value == pool2_price, 'Incorrect Value');
364         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
365          
366         PoolUserStruct memory userStruct;
367         address pool2Currentuser=pool2userList[pool2activeUserID];
368         
369         pool2currUserID++;
370         userStruct = PoolUserStruct({
371             isExist:true,
372             id:pool2currUserID,
373             payment_received:0
374         });
375        pool2users[msg.sender] = userStruct;
376        pool2userList[pool2currUserID]=msg.sender;
377        
378        
379        
380        bool sent = false;
381        sent = address(uint160(pool2Currentuser)).send(pool2_price);
382 
383             if (sent) {
384                 pool2users[pool2Currentuser].payment_received+=1;
385                 if(pool2users[pool2Currentuser].payment_received>=3)
386                 {
387                     pool2activeUserID+=1;
388                 }
389                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
390             }
391             emit regPoolEntry(msg.sender,2,  now);
392     }
393     
394     
395      function buyPool3() public payable {
396          require(users[msg.sender].isExist, "User Not Registered");
397       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
398         require(msg.value == pool3_price, 'Incorrect Value');
399         require(users[msg.sender].referredUsers>=2, "Must need 2 referral");
400         
401         PoolUserStruct memory userStruct;
402         address pool3Currentuser=pool3userList[pool3activeUserID];
403         
404         pool3currUserID++;
405         userStruct = PoolUserStruct({
406             isExist:true,
407             id:pool3currUserID,
408             payment_received:0
409         });
410        pool3users[msg.sender] = userStruct;
411        pool3userList[pool3currUserID]=msg.sender;
412        bool sent = false;
413        sent = address(uint160(pool3Currentuser)).send(pool3_price);
414 
415             if (sent) {
416                 pool3users[pool3Currentuser].payment_received+=1;
417                 if(pool3users[pool3Currentuser].payment_received>=3)
418                 {
419                     pool3activeUserID+=1;
420                 }
421                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
422             }
423 emit regPoolEntry(msg.sender,3,  now);
424     }
425     
426     
427     function buyPool4() public payable {
428         require(users[msg.sender].isExist, "User Not Registered");
429       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
430         require(msg.value == pool4_price, 'Incorrect Value');
431         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
432       
433         PoolUserStruct memory userStruct;
434         address pool4Currentuser=pool4userList[pool4activeUserID];
435         
436         pool4currUserID++;
437         userStruct = PoolUserStruct({
438             isExist:true,
439             id:pool4currUserID,
440             payment_received:0
441         });
442        pool4users[msg.sender] = userStruct;
443        pool4userList[pool4currUserID]=msg.sender;
444        bool sent = false;
445        sent = address(uint160(pool4Currentuser)).send(pool4_price);
446 
447             if (sent) {
448                 pool4users[pool4Currentuser].payment_received+=1;
449                 if(pool4users[pool4Currentuser].payment_received>=3)
450                 {
451                     pool4activeUserID+=1;
452                 }
453                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
454             }
455         emit regPoolEntry(msg.sender,4, now);
456     }
457     
458     
459     
460     function buyPool5() public payable {
461         require(users[msg.sender].isExist, "User Not Registered");
462       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
463         require(msg.value == pool5_price, 'Incorrect Value');
464         require(users[msg.sender].referredUsers>=4, "Must need 4 referral");
465         
466         PoolUserStruct memory userStruct;
467         address pool5Currentuser=pool5userList[pool5activeUserID];
468         
469         pool5currUserID++;
470         userStruct = PoolUserStruct({
471             isExist:true,
472             id:pool5currUserID,
473             payment_received:0
474         });
475        pool5users[msg.sender] = userStruct;
476        pool5userList[pool5currUserID]=msg.sender;
477        bool sent = false;
478        sent = address(uint160(pool5Currentuser)).send(pool5_price);
479 
480             if (sent) {
481                 pool5users[pool5Currentuser].payment_received+=1;
482                 if(pool5users[pool5Currentuser].payment_received>=3)
483                 {
484                     pool5activeUserID+=1;
485                 }
486                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
487             }
488         emit regPoolEntry(msg.sender,5,  now);
489     }
490     
491     function buyPool6() public payable {
492       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
493         require(msg.value == pool6_price, 'Incorrect Value');
494         require(users[msg.sender].referredUsers>=5, "Must need 5 referral");
495         
496         PoolUserStruct memory userStruct;
497         address pool6Currentuser=pool6userList[pool6activeUserID];
498         
499         pool6currUserID++;
500         userStruct = PoolUserStruct({
501             isExist:true,
502             id:pool6currUserID,
503             payment_received:0
504         });
505        pool6users[msg.sender] = userStruct;
506        pool6userList[pool6currUserID]=msg.sender;
507        bool sent = false;
508        sent = address(uint160(pool6Currentuser)).send(pool6_price);
509 
510             if (sent) {
511                 pool6users[pool6Currentuser].payment_received+=1;
512                 if(pool6users[pool6Currentuser].payment_received>=3)
513                 {
514                     pool6activeUserID+=1;
515                 }
516                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
517             }
518         emit regPoolEntry(msg.sender,6,  now);
519     }
520     
521     function buyPool7() public payable {
522         require(users[msg.sender].isExist, "User Not Registered");
523       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
524         require(msg.value == pool7_price, 'Incorrect Value');
525         require(users[msg.sender].referredUsers>=6, "Must need 6 referral");
526         
527         PoolUserStruct memory userStruct;
528         address pool7Currentuser=pool7userList[pool7activeUserID];
529         
530         pool7currUserID++;
531         userStruct = PoolUserStruct({
532             isExist:true,
533             id:pool7currUserID,
534             payment_received:0
535         });
536        pool7users[msg.sender] = userStruct;
537        pool7userList[pool7currUserID]=msg.sender;
538        bool sent = false;
539        sent = address(uint160(pool7Currentuser)).send(pool7_price);
540 
541             if (sent) {
542                 pool7users[pool7Currentuser].payment_received+=1;
543                 if(pool7users[pool7Currentuser].payment_received>=3)
544                 {
545                     pool7activeUserID+=1;
546                 }
547                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
548             }
549         emit regPoolEntry(msg.sender,7,  now);
550     }
551     
552     
553     function buyPool8() public payable {
554         require(users[msg.sender].isExist, "User Not Registered");
555       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
556         require(msg.value == pool8_price, 'Incorrect Value');
557         require(users[msg.sender].referredUsers>=7, "Must need 7 referral");
558        
559         PoolUserStruct memory userStruct;
560         address pool8Currentuser=pool8userList[pool8activeUserID];
561         
562         pool8currUserID++;
563         userStruct = PoolUserStruct({
564             isExist:true,
565             id:pool8currUserID,
566             payment_received:0
567         });
568        pool8users[msg.sender] = userStruct;
569        pool8userList[pool8currUserID]=msg.sender;
570        bool sent = false;
571        sent = address(uint160(pool8Currentuser)).send(pool8_price);
572 
573             if (sent) {
574                 pool8users[pool8Currentuser].payment_received+=1;
575                 if(pool8users[pool8Currentuser].payment_received>=3)
576                 {
577                     pool8activeUserID+=1;
578                 }
579                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
580             }
581         emit regPoolEntry(msg.sender,8,  now);
582     }
583     
584     
585     
586     function buyPool9() public payable {
587         require(users[msg.sender].isExist, "User Not Registered");
588       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
589         require(msg.value == pool9_price, 'Incorrect Value');
590         require(users[msg.sender].referredUsers>=8, "Must need 8 referral");
591        
592         PoolUserStruct memory userStruct;
593         address pool9Currentuser=pool9userList[pool9activeUserID];
594         
595         pool9currUserID++;
596         userStruct = PoolUserStruct({
597             isExist:true,
598             id:pool9currUserID,
599             payment_received:0
600         });
601        pool9users[msg.sender] = userStruct;
602        pool9userList[pool9currUserID]=msg.sender;
603        bool sent = false;
604        sent = address(uint160(pool9Currentuser)).send(pool9_price);
605 
606             if (sent) {
607                 pool9users[pool9Currentuser].payment_received+=1;
608                 if(pool9users[pool9Currentuser].payment_received>=3)
609                 {
610                     pool9activeUserID+=1;
611                 }
612                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
613             }
614         emit regPoolEntry(msg.sender,9,  now);
615     }
616     
617     
618     function buyPool10() public payable {
619         require(users[msg.sender].isExist, "User Not Registered");
620       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
621         require(msg.value == pool10_price, 'Incorrect Value');
622         require(users[msg.sender].referredUsers>=9, "Must need 9 referral");
623         
624         PoolUserStruct memory userStruct;
625         address pool10Currentuser=pool10userList[pool10activeUserID];
626         
627         pool10currUserID++;
628         userStruct = PoolUserStruct({
629             isExist:true,
630             id:pool10currUserID,
631             payment_received:0
632         });
633        pool10users[msg.sender] = userStruct;
634        pool10userList[pool10currUserID]=msg.sender;
635        bool sent = false;
636        sent = address(uint160(pool10Currentuser)).send(pool10_price);
637 
638             if (sent) {
639                 pool10users[pool10Currentuser].payment_received+=1;
640                 if(pool10users[pool10Currentuser].payment_received>=3)
641                 {
642                     pool10activeUserID+=1;
643                 }
644                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
645             }
646         emit regPoolEntry(msg.sender, 10, now);
647     }
648     
649     function getEthBalance() public view returns(uint) {
650     return address(this).balance;
651     }
652     
653     function sendBalance() private
654     {
655          if (!address(uint160(ownerWallet)).send(getEthBalance()))
656          {
657              
658          }
659     }
660    
661    
662 }