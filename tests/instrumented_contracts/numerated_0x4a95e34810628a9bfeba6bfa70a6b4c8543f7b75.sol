1 /*
2 ██████╗░██╗░░░██╗██╗░░░░░██╗░░░░░██████╗░██╗░░░██╗███╗░░██╗
3 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║████╗░██║
4 ██████╦╝██║░░░██║██║░░░░░██║░░░░░██████╔╝██║░░░██║██╔██╗██║
5 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║██║╚████║
6 ██████╦╝╚██████╔╝███████╗███████╗██║░░██║╚██████╔╝██║░╚███║
7 ╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝ V4
8 
9 Hello 
10 I am Bullrun,
11 Global One line AutoPool Smart contract.
12 
13 My URL : https://bullrunv4.github.io
14 Telegram Channel: https://t.me/BullRunV3
15 Hashtag: #bullrun V3.0
16 */
17 pragma solidity 0.5.11 - 0.6.4;
18 
19 contract BullRun {
20      address public ownerWallet;
21       uint public currUserID = 0;
22       uint public pool1currUserID = 0;
23       uint public pool2currUserID = 0;
24       uint public pool3currUserID = 0;
25       uint public pool4currUserID = 0;
26       uint public pool5currUserID = 0;
27       uint public pool6currUserID = 0;
28       uint public pool7currUserID = 0;
29       uint public pool8currUserID = 0;
30       uint public pool9currUserID = 0;
31       uint public pool10currUserID = 0;
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
43       
44       
45       uint public unlimited_level_price=0;
46      
47       struct UserStruct {
48         bool isExist;
49         uint id;
50         uint referrerID;
51        uint referredUsers;
52         mapping(uint => uint) levelExpired;
53     }
54     
55      struct PoolUserStruct {
56         bool isExist;
57         uint id;
58        uint payment_received; 
59     }
60     
61     mapping (address => UserStruct) public users;
62      mapping (uint => address) public userList;
63      
64      mapping (address => PoolUserStruct) public pool1users;
65      mapping (uint => address) public pool1userList;
66      
67      mapping (address => PoolUserStruct) public pool2users;
68      mapping (uint => address) public pool2userList;
69      
70      mapping (address => PoolUserStruct) public pool3users;
71      mapping (uint => address) public pool3userList;
72      
73      mapping (address => PoolUserStruct) public pool4users;
74      mapping (uint => address) public pool4userList;
75      
76      mapping (address => PoolUserStruct) public pool5users;
77      mapping (uint => address) public pool5userList;
78      
79      mapping (address => PoolUserStruct) public pool6users;
80      mapping (uint => address) public pool6userList;
81      
82      mapping (address => PoolUserStruct) public pool7users;
83      mapping (uint => address) public pool7userList;
84      
85      mapping (address => PoolUserStruct) public pool8users;
86      mapping (uint => address) public pool8userList;
87      
88      mapping (address => PoolUserStruct) public pool9users;
89      mapping (uint => address) public pool9userList;
90      
91      mapping (address => PoolUserStruct) public pool10users;
92      mapping (uint => address) public pool10userList;
93      
94     mapping(uint => uint) public LEVEL_PRICE;
95     
96    uint REGESTRATION_FESS=0.05 ether;
97    uint pool1_price=0.1 ether;
98    uint pool2_price=0.2 ether ;
99    uint pool3_price=0.5 ether;
100    uint pool4_price=1 ether;
101    uint pool5_price=2 ether;
102    uint pool6_price=5 ether;
103    uint pool7_price=10 ether ;
104    uint pool8_price=20 ether;
105    uint pool9_price=50 ether;
106    uint pool10_price=100 ether;
107    
108      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
109       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
110       
111      event regPoolEntry(address indexed _user,uint _level,   uint _time);
112    
113      
114     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
115    
116     UserStruct[] public requests;
117      
118       constructor() public {
119           ownerWallet = msg.sender;
120 
121         LEVEL_PRICE[1] = 0.01 ether;
122         LEVEL_PRICE[2] = 0.005 ether;
123         LEVEL_PRICE[3] = 0.0025 ether;
124         LEVEL_PRICE[4] = 0.00025 ether;
125       unlimited_level_price=0.00025 ether;
126 
127         UserStruct memory userStruct;
128         currUserID++;
129 
130         userStruct = UserStruct({
131             isExist: true,
132             id: currUserID,
133             referrerID: 0,
134             referredUsers:0
135            
136         });
137         
138         users[ownerWallet] = userStruct;
139        userList[currUserID] = ownerWallet;
140        
141        
142          PoolUserStruct memory pooluserStruct;
143         
144         pool1currUserID++;
145 
146         pooluserStruct = PoolUserStruct({
147             isExist:true,
148             id:pool1currUserID,
149             payment_received:0
150         });
151     pool1activeUserID=pool1currUserID;
152        pool1users[msg.sender] = pooluserStruct;
153        pool1userList[pool1currUserID]=msg.sender;
154       
155         
156         pool2currUserID++;
157         pooluserStruct = PoolUserStruct({
158             isExist:true,
159             id:pool2currUserID,
160             payment_received:0
161         });
162     pool2activeUserID=pool2currUserID;
163        pool2users[msg.sender] = pooluserStruct;
164        pool2userList[pool2currUserID]=msg.sender;
165        
166        
167         pool3currUserID++;
168         pooluserStruct = PoolUserStruct({
169             isExist:true,
170             id:pool3currUserID,
171             payment_received:0
172         });
173     pool3activeUserID=pool3currUserID;
174        pool3users[msg.sender] = pooluserStruct;
175        pool3userList[pool3currUserID]=msg.sender;
176        
177        
178          pool4currUserID++;
179         pooluserStruct = PoolUserStruct({
180             isExist:true,
181             id:pool4currUserID,
182             payment_received:0
183         });
184     pool4activeUserID=pool4currUserID;
185        pool4users[msg.sender] = pooluserStruct;
186        pool4userList[pool4currUserID]=msg.sender;
187 
188         
189           pool5currUserID++;
190         pooluserStruct = PoolUserStruct({
191             isExist:true,
192             id:pool5currUserID,
193             payment_received:0
194         });
195     pool5activeUserID=pool5currUserID;
196        pool5users[msg.sender] = pooluserStruct;
197        pool5userList[pool5currUserID]=msg.sender;
198        
199        
200          pool6currUserID++;
201         pooluserStruct = PoolUserStruct({
202             isExist:true,
203             id:pool6currUserID,
204             payment_received:0
205         });
206     pool6activeUserID=pool6currUserID;
207        pool6users[msg.sender] = pooluserStruct;
208        pool6userList[pool6currUserID]=msg.sender;
209        
210          pool7currUserID++;
211         pooluserStruct = PoolUserStruct({
212             isExist:true,
213             id:pool7currUserID,
214             payment_received:0
215         });
216     pool7activeUserID=pool7currUserID;
217        pool7users[msg.sender] = pooluserStruct;
218        pool7userList[pool7currUserID]=msg.sender;
219        
220        pool8currUserID++;
221         pooluserStruct = PoolUserStruct({
222             isExist:true,
223             id:pool8currUserID,
224             payment_received:0
225         });
226     pool8activeUserID=pool8currUserID;
227        pool8users[msg.sender] = pooluserStruct;
228        pool8userList[pool8currUserID]=msg.sender;
229        
230         pool9currUserID++;
231         pooluserStruct = PoolUserStruct({
232             isExist:true,
233             id:pool9currUserID,
234             payment_received:0
235         });
236     pool9activeUserID=pool9currUserID;
237        pool9users[msg.sender] = pooluserStruct;
238        pool9userList[pool9currUserID]=msg.sender;
239        
240        
241         pool10currUserID++;
242         pooluserStruct = PoolUserStruct({
243             isExist:true,
244             id:pool10currUserID,
245             payment_received:0
246         });
247     pool10activeUserID=pool10currUserID;
248        pool10users[msg.sender] = pooluserStruct;
249        pool10userList[pool10currUserID]=msg.sender;
250        
251        
252       }
253      
254        function regUser(uint _referrerID) public payable {
255        
256       require(!users[msg.sender].isExist, "User Exists");
257       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
258         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
259        
260         UserStruct memory userStruct;
261         currUserID++;
262 
263         userStruct = UserStruct({
264             isExist: true,
265             id: currUserID,
266             referrerID: _referrerID,
267             referredUsers:0
268         });
269    
270     
271        users[msg.sender] = userStruct;
272        userList[currUserID]=msg.sender;
273        
274         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
275         
276        payReferral(1,msg.sender);
277         emit regLevelEvent(msg.sender, userList[_referrerID], now);
278     }
279    
280    
281      function payReferral(uint _level, address _user) internal {
282         address referer;
283        
284         referer = userList[users[_user].referrerID];
285        
286        
287          bool sent = false;
288        
289             uint level_price_local=0;
290             if(_level>4){
291             level_price_local=unlimited_level_price;
292             }
293             else{
294             level_price_local=LEVEL_PRICE[_level];
295             }
296             sent = address(uint160(referer)).send(level_price_local);
297 
298             if (sent) {
299                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
300                 if(_level < 100 && users[referer].referrerID >= 1){
301                     payReferral(_level+1,referer);
302                 }
303                 else
304                 {
305                     sendBalance();
306                 }
307                
308             }
309        
310         if(!sent) {
311           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
312 
313             payReferral(_level, referer);
314         }
315      }
316    
317    
318    
319    
320        function buyPool1() public payable {
321        require(users[msg.sender].isExist, "User Not Registered");
322       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
323       
324         require(msg.value == pool1_price, 'Incorrect Value');
325         
326        
327         PoolUserStruct memory userStruct;
328         address pool1Currentuser=pool1userList[pool1activeUserID];
329         
330         pool1currUserID++;
331 
332         userStruct = PoolUserStruct({
333             isExist:true,
334             id:pool1currUserID,
335             payment_received:0
336         });
337    
338        pool1users[msg.sender] = userStruct;
339        pool1userList[pool1currUserID]=msg.sender;
340        bool sent = false;
341        sent = address(uint160(pool1Currentuser)).send(pool1_price);
342 
343             if (sent) {
344                 pool1users[pool1Currentuser].payment_received+=1;
345                 if(pool1users[pool1Currentuser].payment_received>=2)
346                 {
347                     pool1activeUserID+=1;
348                 }
349                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
350             }
351        emit regPoolEntry(msg.sender, 1, now);
352     }
353     
354     
355       function buyPool2() public payable {
356           require(users[msg.sender].isExist, "User Not Registered");
357       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
358         require(msg.value == pool2_price, 'Incorrect Value');
359         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
360          
361         PoolUserStruct memory userStruct;
362         address pool2Currentuser=pool2userList[pool2activeUserID];
363         
364         pool2currUserID++;
365         userStruct = PoolUserStruct({
366             isExist:true,
367             id:pool2currUserID,
368             payment_received:0
369         });
370        pool2users[msg.sender] = userStruct;
371        pool2userList[pool2currUserID]=msg.sender;
372        
373        
374        
375        bool sent = false;
376        sent = address(uint160(pool2Currentuser)).send(pool2_price);
377 
378             if (sent) {
379                 pool2users[pool2Currentuser].payment_received+=1;
380                 if(pool2users[pool2Currentuser].payment_received>=3)
381                 {
382                     pool2activeUserID+=1;
383                 }
384                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
385             }
386             emit regPoolEntry(msg.sender,2,  now);
387     }
388     
389     
390      function buyPool3() public payable {
391          require(users[msg.sender].isExist, "User Not Registered");
392       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
393         require(msg.value == pool3_price, 'Incorrect Value');
394         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
395         
396         PoolUserStruct memory userStruct;
397         address pool3Currentuser=pool3userList[pool3activeUserID];
398         
399         pool3currUserID++;
400         userStruct = PoolUserStruct({
401             isExist:true,
402             id:pool3currUserID,
403             payment_received:0
404         });
405        pool3users[msg.sender] = userStruct;
406        pool3userList[pool3currUserID]=msg.sender;
407        bool sent = false;
408        sent = address(uint160(pool3Currentuser)).send(pool3_price);
409 
410             if (sent) {
411                 pool3users[pool3Currentuser].payment_received+=1;
412                 if(pool3users[pool3Currentuser].payment_received>=3)
413                 {
414                     pool3activeUserID+=1;
415                 }
416                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
417             }
418 emit regPoolEntry(msg.sender,3,  now);
419     }
420     
421     
422     function buyPool4() public payable {
423         require(users[msg.sender].isExist, "User Not Registered");
424       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
425         require(msg.value == pool4_price, 'Incorrect Value');
426         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
427       
428         PoolUserStruct memory userStruct;
429         address pool4Currentuser=pool4userList[pool4activeUserID];
430         
431         pool4currUserID++;
432         userStruct = PoolUserStruct({
433             isExist:true,
434             id:pool4currUserID,
435             payment_received:0
436         });
437        pool4users[msg.sender] = userStruct;
438        pool4userList[pool4currUserID]=msg.sender;
439        bool sent = false;
440        sent = address(uint160(pool4Currentuser)).send(pool4_price);
441 
442             if (sent) {
443                 pool4users[pool4Currentuser].payment_received+=1;
444                 if(pool4users[pool4Currentuser].payment_received>=3)
445                 {
446                     pool4activeUserID+=1;
447                 }
448                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
449             }
450         emit regPoolEntry(msg.sender,4, now);
451     }
452     
453     
454     
455     function buyPool5() public payable {
456         require(users[msg.sender].isExist, "User Not Registered");
457       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
458         require(msg.value == pool5_price, 'Incorrect Value');
459         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
460         
461         PoolUserStruct memory userStruct;
462         address pool5Currentuser=pool5userList[pool5activeUserID];
463         
464         pool5currUserID++;
465         userStruct = PoolUserStruct({
466             isExist:true,
467             id:pool5currUserID,
468             payment_received:0
469         });
470        pool5users[msg.sender] = userStruct;
471        pool5userList[pool5currUserID]=msg.sender;
472        bool sent = false;
473        sent = address(uint160(pool5Currentuser)).send(pool5_price);
474 
475             if (sent) {
476                 pool5users[pool5Currentuser].payment_received+=1;
477                 if(pool5users[pool5Currentuser].payment_received>=3)
478                 {
479                     pool5activeUserID+=1;
480                 }
481                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
482             }
483         emit regPoolEntry(msg.sender,5,  now);
484     }
485     
486     function buyPool6() public payable {
487       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
488         require(msg.value == pool6_price, 'Incorrect Value');
489         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
490         
491         PoolUserStruct memory userStruct;
492         address pool6Currentuser=pool6userList[pool6activeUserID];
493         
494         pool6currUserID++;
495         userStruct = PoolUserStruct({
496             isExist:true,
497             id:pool6currUserID,
498             payment_received:0
499         });
500        pool6users[msg.sender] = userStruct;
501        pool6userList[pool6currUserID]=msg.sender;
502        bool sent = false;
503        sent = address(uint160(pool6Currentuser)).send(pool6_price);
504 
505             if (sent) {
506                 pool6users[pool6Currentuser].payment_received+=1;
507                 if(pool6users[pool6Currentuser].payment_received>=3)
508                 {
509                     pool6activeUserID+=1;
510                 }
511                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
512             }
513         emit regPoolEntry(msg.sender,6,  now);
514     }
515     
516     function buyPool7() public payable {
517         require(users[msg.sender].isExist, "User Not Registered");
518       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
519         require(msg.value == pool7_price, 'Incorrect Value');
520         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
521         
522         PoolUserStruct memory userStruct;
523         address pool7Currentuser=pool7userList[pool7activeUserID];
524         
525         pool7currUserID++;
526         userStruct = PoolUserStruct({
527             isExist:true,
528             id:pool7currUserID,
529             payment_received:0
530         });
531        pool7users[msg.sender] = userStruct;
532        pool7userList[pool7currUserID]=msg.sender;
533        bool sent = false;
534        sent = address(uint160(pool7Currentuser)).send(pool7_price);
535 
536             if (sent) {
537                 pool7users[pool7Currentuser].payment_received+=1;
538                 if(pool7users[pool7Currentuser].payment_received>=3)
539                 {
540                     pool7activeUserID+=1;
541                 }
542                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
543             }
544         emit regPoolEntry(msg.sender,7,  now);
545     }
546     
547     
548     function buyPool8() public payable {
549         require(users[msg.sender].isExist, "User Not Registered");
550       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
551         require(msg.value == pool8_price, 'Incorrect Value');
552         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
553        
554         PoolUserStruct memory userStruct;
555         address pool8Currentuser=pool8userList[pool8activeUserID];
556         
557         pool8currUserID++;
558         userStruct = PoolUserStruct({
559             isExist:true,
560             id:pool8currUserID,
561             payment_received:0
562         });
563        pool8users[msg.sender] = userStruct;
564        pool8userList[pool8currUserID]=msg.sender;
565        bool sent = false;
566        sent = address(uint160(pool8Currentuser)).send(pool8_price);
567 
568             if (sent) {
569                 pool8users[pool8Currentuser].payment_received+=1;
570                 if(pool8users[pool8Currentuser].payment_received>=3)
571                 {
572                     pool8activeUserID+=1;
573                 }
574                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
575             }
576         emit regPoolEntry(msg.sender,8,  now);
577     }
578     
579     
580     
581     function buyPool9() public payable {
582         require(users[msg.sender].isExist, "User Not Registered");
583       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
584         require(msg.value == pool9_price, 'Incorrect Value');
585         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
586        
587         PoolUserStruct memory userStruct;
588         address pool9Currentuser=pool9userList[pool9activeUserID];
589         
590         pool9currUserID++;
591         userStruct = PoolUserStruct({
592             isExist:true,
593             id:pool9currUserID,
594             payment_received:0
595         });
596        pool9users[msg.sender] = userStruct;
597        pool9userList[pool9currUserID]=msg.sender;
598        bool sent = false;
599        sent = address(uint160(pool9Currentuser)).send(pool9_price);
600 
601             if (sent) {
602                 pool9users[pool9Currentuser].payment_received+=1;
603                 if(pool9users[pool9Currentuser].payment_received>=3)
604                 {
605                     pool9activeUserID+=1;
606                 }
607                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
608             }
609         emit regPoolEntry(msg.sender,9,  now);
610     }
611     
612     
613     function buyPool10() public payable {
614         require(users[msg.sender].isExist, "User Not Registered");
615       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
616         require(msg.value == pool10_price, 'Incorrect Value');
617         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
618         
619         PoolUserStruct memory userStruct;
620         address pool10Currentuser=pool10userList[pool10activeUserID];
621         
622         pool10currUserID++;
623         userStruct = PoolUserStruct({
624             isExist:true,
625             id:pool10currUserID,
626             payment_received:0
627         });
628        pool10users[msg.sender] = userStruct;
629        pool10userList[pool10currUserID]=msg.sender;
630        bool sent = false;
631        sent = address(uint160(pool10Currentuser)).send(pool10_price);
632 
633             if (sent) {
634                 pool10users[pool10Currentuser].payment_received+=1;
635                 if(pool10users[pool10Currentuser].payment_received>=3)
636                 {
637                     pool10activeUserID+=1;
638                 }
639                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
640             }
641         emit regPoolEntry(msg.sender, 10, now);
642     }
643     
644     function getEthBalance() public view returns(uint) {
645     return address(this).balance;
646     }
647     
648     function sendBalance() private
649     {
650          if (!address(uint160(ownerWallet)).send(getEthBalance()))
651          {
652              
653          }
654     }
655    
656    
657 }