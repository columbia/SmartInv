1 /*
2 ██████╗░██╗░░░██╗██╗░░░░░██╗░░░░░██████╗░██╗░░░██╗███╗░░██╗
3 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║████╗░██║
4 ██████╦╝██║░░░██║██║░░░░░██║░░░░░██████╔╝██║░░░██║██╔██╗██║
5 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║██║╚████║
6 ██████╦╝╚██████╔╝███████╗███████╗██║░░██║╚██████╔╝██║░╚███║
7 ╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝
8 
9 Hello 
10 I am Bullrun,
11 Global One line AutoPool Smart contract.
12 
13 My URL : https://bullrun.live
14 Hashtag: #bullrunlive
15 */
16 pragma solidity 0.5.11;
17 
18 contract BullRun {
19      address public ownerWallet;
20       uint public currUserID = 0;
21       uint public pool1currUserID = 0;
22       uint public pool2currUserID = 0;
23       uint public pool3currUserID = 0;
24       uint public pool4currUserID = 0;
25       uint public pool5currUserID = 0;
26       uint public pool6currUserID = 0;
27       uint public pool7currUserID = 0;
28       uint public pool8currUserID = 0;
29       uint public pool9currUserID = 0;
30       uint public pool10currUserID = 0;
31       
32         uint public pool1activeUserID = 0;
33       uint public pool2activeUserID = 0;
34       uint public pool3activeUserID = 0;
35       uint public pool4activeUserID = 0;
36       uint public pool5activeUserID = 0;
37       uint public pool6activeUserID = 0;
38       uint public pool7activeUserID = 0;
39       uint public pool8activeUserID = 0;
40       uint public pool9activeUserID = 0;
41       uint public pool10activeUserID = 0;
42       
43       
44       uint public unlimited_level_price=0;
45      
46       struct UserStruct {
47         bool isExist;
48         uint id;
49         uint referrerID;
50        uint referredUsers;
51         mapping(uint => uint) levelExpired;
52     }
53     
54      struct PoolUserStruct {
55         bool isExist;
56         uint id;
57        uint payment_received; 
58     }
59     
60     mapping (address => UserStruct) public users;
61      mapping (uint => address) public userList;
62      
63      mapping (address => PoolUserStruct) public pool1users;
64      mapping (uint => address) public pool1userList;
65      
66      mapping (address => PoolUserStruct) public pool2users;
67      mapping (uint => address) public pool2userList;
68      
69      mapping (address => PoolUserStruct) public pool3users;
70      mapping (uint => address) public pool3userList;
71      
72      mapping (address => PoolUserStruct) public pool4users;
73      mapping (uint => address) public pool4userList;
74      
75      mapping (address => PoolUserStruct) public pool5users;
76      mapping (uint => address) public pool5userList;
77      
78      mapping (address => PoolUserStruct) public pool6users;
79      mapping (uint => address) public pool6userList;
80      
81      mapping (address => PoolUserStruct) public pool7users;
82      mapping (uint => address) public pool7userList;
83      
84      mapping (address => PoolUserStruct) public pool8users;
85      mapping (uint => address) public pool8userList;
86      
87      mapping (address => PoolUserStruct) public pool9users;
88      mapping (uint => address) public pool9userList;
89      
90      mapping (address => PoolUserStruct) public pool10users;
91      mapping (uint => address) public pool10userList;
92      
93     mapping(uint => uint) public LEVEL_PRICE;
94     
95    uint REGESTRATION_FESS=0.05 ether;
96    uint pool1_price=0.1 ether;
97    uint pool2_price=0.2 ether ;
98    uint pool3_price=0.5 ether;
99    uint pool4_price=1 ether;
100    uint pool5_price=2 ether;
101    uint pool6_price=5 ether;
102    uint pool7_price=10 ether ;
103    uint pool8_price=20 ether;
104    uint pool9_price=50 ether;
105    uint pool10_price=100 ether;
106    
107      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
108       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
109       
110      event regPoolEntry(address indexed _user,uint _level,   uint _time);
111    
112      
113     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
114    
115     UserStruct[] public requests;
116      
117       constructor() public {
118           ownerWallet = msg.sender;
119 
120         LEVEL_PRICE[1] = 0.01 ether;
121         LEVEL_PRICE[2] = 0.005 ether;
122         LEVEL_PRICE[3] = 0.0025 ether;
123         LEVEL_PRICE[4] = 0.00025 ether;
124       unlimited_level_price=0.00025 ether;
125 
126         UserStruct memory userStruct;
127         currUserID++;
128 
129         userStruct = UserStruct({
130             isExist: true,
131             id: currUserID,
132             referrerID: 0,
133             referredUsers:0
134            
135         });
136         
137         users[ownerWallet] = userStruct;
138        userList[currUserID] = ownerWallet;
139        
140        
141          PoolUserStruct memory pooluserStruct;
142         
143         pool1currUserID++;
144 
145         pooluserStruct = PoolUserStruct({
146             isExist:true,
147             id:pool1currUserID,
148             payment_received:0
149         });
150     pool1activeUserID=pool1currUserID;
151        pool1users[msg.sender] = pooluserStruct;
152        pool1userList[pool1currUserID]=msg.sender;
153       
154         
155         pool2currUserID++;
156         pooluserStruct = PoolUserStruct({
157             isExist:true,
158             id:pool2currUserID,
159             payment_received:0
160         });
161     pool2activeUserID=pool2currUserID;
162        pool2users[msg.sender] = pooluserStruct;
163        pool2userList[pool2currUserID]=msg.sender;
164        
165        
166         pool3currUserID++;
167         pooluserStruct = PoolUserStruct({
168             isExist:true,
169             id:pool3currUserID,
170             payment_received:0
171         });
172     pool3activeUserID=pool3currUserID;
173        pool3users[msg.sender] = pooluserStruct;
174        pool3userList[pool3currUserID]=msg.sender;
175        
176        
177          pool4currUserID++;
178         pooluserStruct = PoolUserStruct({
179             isExist:true,
180             id:pool4currUserID,
181             payment_received:0
182         });
183     pool4activeUserID=pool4currUserID;
184        pool4users[msg.sender] = pooluserStruct;
185        pool4userList[pool4currUserID]=msg.sender;
186 
187         
188           pool5currUserID++;
189         pooluserStruct = PoolUserStruct({
190             isExist:true,
191             id:pool5currUserID,
192             payment_received:0
193         });
194     pool5activeUserID=pool5currUserID;
195        pool5users[msg.sender] = pooluserStruct;
196        pool5userList[pool5currUserID]=msg.sender;
197        
198        
199          pool6currUserID++;
200         pooluserStruct = PoolUserStruct({
201             isExist:true,
202             id:pool6currUserID,
203             payment_received:0
204         });
205     pool6activeUserID=pool6currUserID;
206        pool6users[msg.sender] = pooluserStruct;
207        pool6userList[pool6currUserID]=msg.sender;
208        
209          pool7currUserID++;
210         pooluserStruct = PoolUserStruct({
211             isExist:true,
212             id:pool7currUserID,
213             payment_received:0
214         });
215     pool7activeUserID=pool7currUserID;
216        pool7users[msg.sender] = pooluserStruct;
217        pool7userList[pool7currUserID]=msg.sender;
218        
219        pool8currUserID++;
220         pooluserStruct = PoolUserStruct({
221             isExist:true,
222             id:pool8currUserID,
223             payment_received:0
224         });
225     pool8activeUserID=pool8currUserID;
226        pool8users[msg.sender] = pooluserStruct;
227        pool8userList[pool8currUserID]=msg.sender;
228        
229         pool9currUserID++;
230         pooluserStruct = PoolUserStruct({
231             isExist:true,
232             id:pool9currUserID,
233             payment_received:0
234         });
235     pool9activeUserID=pool9currUserID;
236        pool9users[msg.sender] = pooluserStruct;
237        pool9userList[pool9currUserID]=msg.sender;
238        
239        
240         pool10currUserID++;
241         pooluserStruct = PoolUserStruct({
242             isExist:true,
243             id:pool10currUserID,
244             payment_received:0
245         });
246     pool10activeUserID=pool10currUserID;
247        pool10users[msg.sender] = pooluserStruct;
248        pool10userList[pool10currUserID]=msg.sender;
249        
250        
251       }
252      
253        function regUser(uint _referrerID) public payable {
254        
255       require(!users[msg.sender].isExist, "User Exists");
256       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
257         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
258        
259         UserStruct memory userStruct;
260         currUserID++;
261 
262         userStruct = UserStruct({
263             isExist: true,
264             id: currUserID,
265             referrerID: _referrerID,
266             referredUsers:0
267         });
268    
269     
270        users[msg.sender] = userStruct;
271        userList[currUserID]=msg.sender;
272        
273         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
274         
275        payReferral(1,msg.sender);
276         emit regLevelEvent(msg.sender, userList[_referrerID], now);
277     }
278    
279    
280      function payReferral(uint _level, address _user) internal {
281         address referer;
282        
283         referer = userList[users[_user].referrerID];
284        
285        
286          bool sent = false;
287        
288             uint level_price_local=0;
289             if(_level>4){
290             level_price_local=unlimited_level_price;
291             }
292             else{
293             level_price_local=LEVEL_PRICE[_level];
294             }
295             sent = address(uint160(referer)).send(level_price_local);
296 
297             if (sent) {
298                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
299                 if(_level < 100 && users[referer].referrerID >= 1){
300                     payReferral(_level+1,referer);
301                 }
302                 else
303                 {
304                     sendBalance();
305                 }
306                
307             }
308        
309         if(!sent) {
310           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
311 
312             payReferral(_level, referer);
313         }
314      }
315    
316    
317    
318    
319        function buyPool1() public payable {
320        require(users[msg.sender].isExist, "User Not Registered");
321       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
322       
323         require(msg.value == pool1_price, 'Incorrect Value');
324         
325        
326         PoolUserStruct memory userStruct;
327         address pool1Currentuser=pool1userList[pool1activeUserID];
328         
329         pool1currUserID++;
330 
331         userStruct = PoolUserStruct({
332             isExist:true,
333             id:pool1currUserID,
334             payment_received:0
335         });
336    
337        pool1users[msg.sender] = userStruct;
338        pool1userList[pool1currUserID]=msg.sender;
339        bool sent = false;
340        sent = address(uint160(pool1Currentuser)).send(pool1_price);
341 
342             if (sent) {
343                 pool1users[pool1Currentuser].payment_received+=1;
344                 if(pool1users[pool1Currentuser].payment_received>=2)
345                 {
346                     pool1activeUserID+=1;
347                 }
348                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
349             }
350        emit regPoolEntry(msg.sender, 1, now);
351     }
352     
353     
354       function buyPool2() public payable {
355           require(users[msg.sender].isExist, "User Not Registered");
356       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
357         require(msg.value == pool2_price, 'Incorrect Value');
358         require(users[msg.sender].referredUsers>=1, "Must need 1 referral");
359          
360         PoolUserStruct memory userStruct;
361         address pool2Currentuser=pool2userList[pool2activeUserID];
362         
363         pool2currUserID++;
364         userStruct = PoolUserStruct({
365             isExist:true,
366             id:pool2currUserID,
367             payment_received:0
368         });
369        pool2users[msg.sender] = userStruct;
370        pool2userList[pool2currUserID]=msg.sender;
371        
372        
373        
374        bool sent = false;
375        sent = address(uint160(pool2Currentuser)).send(pool2_price);
376 
377             if (sent) {
378                 pool2users[pool2Currentuser].payment_received+=1;
379                 if(pool2users[pool2Currentuser].payment_received>=3)
380                 {
381                     pool2activeUserID+=1;
382                 }
383                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
384             }
385             emit regPoolEntry(msg.sender,2,  now);
386     }
387     
388     
389      function buyPool3() public payable {
390          require(users[msg.sender].isExist, "User Not Registered");
391       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
392         require(msg.value == pool3_price, 'Incorrect Value');
393         require(users[msg.sender].referredUsers>=2, "Must need 2 referral");
394         
395         PoolUserStruct memory userStruct;
396         address pool3Currentuser=pool3userList[pool3activeUserID];
397         
398         pool3currUserID++;
399         userStruct = PoolUserStruct({
400             isExist:true,
401             id:pool3currUserID,
402             payment_received:0
403         });
404        pool3users[msg.sender] = userStruct;
405        pool3userList[pool3currUserID]=msg.sender;
406        bool sent = false;
407        sent = address(uint160(pool3Currentuser)).send(pool3_price);
408 
409             if (sent) {
410                 pool3users[pool3Currentuser].payment_received+=1;
411                 if(pool3users[pool3Currentuser].payment_received>=3)
412                 {
413                     pool3activeUserID+=1;
414                 }
415                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
416             }
417 emit regPoolEntry(msg.sender,3,  now);
418     }
419     
420     
421     function buyPool4() public payable {
422         require(users[msg.sender].isExist, "User Not Registered");
423       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
424         require(msg.value == pool4_price, 'Incorrect Value');
425         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
426       
427         PoolUserStruct memory userStruct;
428         address pool4Currentuser=pool4userList[pool4activeUserID];
429         
430         pool4currUserID++;
431         userStruct = PoolUserStruct({
432             isExist:true,
433             id:pool4currUserID,
434             payment_received:0
435         });
436        pool4users[msg.sender] = userStruct;
437        pool4userList[pool4currUserID]=msg.sender;
438        bool sent = false;
439        sent = address(uint160(pool4Currentuser)).send(pool4_price);
440 
441             if (sent) {
442                 pool4users[pool4Currentuser].payment_received+=1;
443                 if(pool4users[pool4Currentuser].payment_received>=3)
444                 {
445                     pool4activeUserID+=1;
446                 }
447                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
448             }
449         emit regPoolEntry(msg.sender,4, now);
450     }
451     
452     
453     
454     function buyPool5() public payable {
455         require(users[msg.sender].isExist, "User Not Registered");
456       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
457         require(msg.value == pool5_price, 'Incorrect Value');
458         require(users[msg.sender].referredUsers>=4, "Must need 4 referral");
459         
460         PoolUserStruct memory userStruct;
461         address pool5Currentuser=pool5userList[pool5activeUserID];
462         
463         pool5currUserID++;
464         userStruct = PoolUserStruct({
465             isExist:true,
466             id:pool5currUserID,
467             payment_received:0
468         });
469        pool5users[msg.sender] = userStruct;
470        pool5userList[pool5currUserID]=msg.sender;
471        bool sent = false;
472        sent = address(uint160(pool5Currentuser)).send(pool5_price);
473 
474             if (sent) {
475                 pool5users[pool5Currentuser].payment_received+=1;
476                 if(pool5users[pool5Currentuser].payment_received>=3)
477                 {
478                     pool5activeUserID+=1;
479                 }
480                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
481             }
482         emit regPoolEntry(msg.sender,5,  now);
483     }
484     
485     function buyPool6() public payable {
486       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
487         require(msg.value == pool6_price, 'Incorrect Value');
488         require(users[msg.sender].referredUsers>=5, "Must need 5 referral");
489         
490         PoolUserStruct memory userStruct;
491         address pool6Currentuser=pool6userList[pool6activeUserID];
492         
493         pool6currUserID++;
494         userStruct = PoolUserStruct({
495             isExist:true,
496             id:pool6currUserID,
497             payment_received:0
498         });
499        pool6users[msg.sender] = userStruct;
500        pool6userList[pool6currUserID]=msg.sender;
501        bool sent = false;
502        sent = address(uint160(pool6Currentuser)).send(pool6_price);
503 
504             if (sent) {
505                 pool6users[pool6Currentuser].payment_received+=1;
506                 if(pool6users[pool6Currentuser].payment_received>=3)
507                 {
508                     pool6activeUserID+=1;
509                 }
510                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
511             }
512         emit regPoolEntry(msg.sender,6,  now);
513     }
514     
515     function buyPool7() public payable {
516         require(users[msg.sender].isExist, "User Not Registered");
517       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
518         require(msg.value == pool7_price, 'Incorrect Value');
519         require(users[msg.sender].referredUsers>=6, "Must need 6 referral");
520         
521         PoolUserStruct memory userStruct;
522         address pool7Currentuser=pool7userList[pool7activeUserID];
523         
524         pool7currUserID++;
525         userStruct = PoolUserStruct({
526             isExist:true,
527             id:pool7currUserID,
528             payment_received:0
529         });
530        pool7users[msg.sender] = userStruct;
531        pool7userList[pool7currUserID]=msg.sender;
532        bool sent = false;
533        sent = address(uint160(pool7Currentuser)).send(pool7_price);
534 
535             if (sent) {
536                 pool7users[pool7Currentuser].payment_received+=1;
537                 if(pool7users[pool7Currentuser].payment_received>=3)
538                 {
539                     pool7activeUserID+=1;
540                 }
541                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
542             }
543         emit regPoolEntry(msg.sender,7,  now);
544     }
545     
546     
547     function buyPool8() public payable {
548         require(users[msg.sender].isExist, "User Not Registered");
549       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
550         require(msg.value == pool8_price, 'Incorrect Value');
551         require(users[msg.sender].referredUsers>=7, "Must need 7 referral");
552        
553         PoolUserStruct memory userStruct;
554         address pool8Currentuser=pool8userList[pool8activeUserID];
555         
556         pool8currUserID++;
557         userStruct = PoolUserStruct({
558             isExist:true,
559             id:pool8currUserID,
560             payment_received:0
561         });
562        pool8users[msg.sender] = userStruct;
563        pool8userList[pool8currUserID]=msg.sender;
564        bool sent = false;
565        sent = address(uint160(pool8Currentuser)).send(pool8_price);
566 
567             if (sent) {
568                 pool8users[pool8Currentuser].payment_received+=1;
569                 if(pool8users[pool8Currentuser].payment_received>=3)
570                 {
571                     pool8activeUserID+=1;
572                 }
573                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
574             }
575         emit regPoolEntry(msg.sender,8,  now);
576     }
577     
578     
579     
580     function buyPool9() public payable {
581         require(users[msg.sender].isExist, "User Not Registered");
582       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
583         require(msg.value == pool9_price, 'Incorrect Value');
584         require(users[msg.sender].referredUsers>=8, "Must need 8 referral");
585        
586         PoolUserStruct memory userStruct;
587         address pool9Currentuser=pool9userList[pool9activeUserID];
588         
589         pool9currUserID++;
590         userStruct = PoolUserStruct({
591             isExist:true,
592             id:pool9currUserID,
593             payment_received:0
594         });
595        pool9users[msg.sender] = userStruct;
596        pool9userList[pool9currUserID]=msg.sender;
597        bool sent = false;
598        sent = address(uint160(pool9Currentuser)).send(pool9_price);
599 
600             if (sent) {
601                 pool9users[pool9Currentuser].payment_received+=1;
602                 if(pool9users[pool9Currentuser].payment_received>=3)
603                 {
604                     pool9activeUserID+=1;
605                 }
606                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
607             }
608         emit regPoolEntry(msg.sender,9,  now);
609     }
610     
611     
612     function buyPool10() public payable {
613         require(users[msg.sender].isExist, "User Not Registered");
614       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
615         require(msg.value == pool10_price, 'Incorrect Value');
616         require(users[msg.sender].referredUsers>=9, "Must need 9 referral");
617         
618         PoolUserStruct memory userStruct;
619         address pool10Currentuser=pool10userList[pool10activeUserID];
620         
621         pool10currUserID++;
622         userStruct = PoolUserStruct({
623             isExist:true,
624             id:pool10currUserID,
625             payment_received:0
626         });
627        pool10users[msg.sender] = userStruct;
628        pool10userList[pool10currUserID]=msg.sender;
629        bool sent = false;
630        sent = address(uint160(pool10Currentuser)).send(pool10_price);
631 
632             if (sent) {
633                 pool10users[pool10Currentuser].payment_received+=1;
634                 if(pool10users[pool10Currentuser].payment_received>=3)
635                 {
636                     pool10activeUserID+=1;
637                 }
638                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
639             }
640         emit regPoolEntry(msg.sender, 10, now);
641     }
642     
643     function getEthBalance() public view returns(uint) {
644     return address(this).balance;
645     }
646     
647     function sendBalance() private
648     {
649          if (!address(uint160(ownerWallet)).send(getEthBalance()))
650          {
651              
652          }
653     }
654    
655    
656 }