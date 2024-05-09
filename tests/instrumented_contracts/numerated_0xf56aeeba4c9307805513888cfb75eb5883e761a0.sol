1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-24
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-05-23
7 */
8 
9 /*
10 ██████╗░██╗░░░██╗██╗░░░░░██╗░░░░░██████╗░██╗░░░██╗███╗░░██╗
11 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║████╗░██║
12 ██████╦╝██║░░░██║██║░░░░░██║░░░░░██████╔╝██║░░░██║██╔██╗██║
13 ██╔══██╗██║░░░██║██║░░░░░██║░░░░░██╔══██╗██║░░░██║██║╚████║
14 ██████╦╝╚██████╔╝███████╗███████╗██║░░██║╚██████╔╝██║░╚███║
15 ╚═════╝░░╚═════╝░╚══════╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝ V5
16 
17 Hello 
18 I am Bullrun,
19 Global One line AutoPool Smart contract.
20 
21 My URL : https://bullrun2020.github.io
22 
23 Hashtag: #bullrun2020
24 */
25 pragma solidity 0.5.11 - 0.6.4;
26 
27 contract BullRun {
28      address public ownerWallet;
29       uint public currUserID = 0;
30       uint public pool1currUserID = 0;
31       uint public pool2currUserID = 0;
32       uint public pool3currUserID = 0;
33       uint public pool4currUserID = 0;
34       uint public pool5currUserID = 0;
35       uint public pool6currUserID = 0;
36       uint public pool7currUserID = 0;
37       uint public pool8currUserID = 0;
38       uint public pool9currUserID = 0;
39       uint public pool10currUserID = 0;
40       
41         uint public pool1activeUserID = 0;
42       uint public pool2activeUserID = 0;
43       uint public pool3activeUserID = 0;
44       uint public pool4activeUserID = 0;
45       uint public pool5activeUserID = 0;
46       uint public pool6activeUserID = 0;
47       uint public pool7activeUserID = 0;
48       uint public pool8activeUserID = 0;
49       uint public pool9activeUserID = 0;
50       uint public pool10activeUserID = 0;
51       
52       
53       uint public unlimited_level_price=0;
54      
55       struct UserStruct {
56         bool isExist;
57         uint id;
58         uint referrerID;
59        uint referredUsers;
60         mapping(uint => uint) levelExpired;
61     }
62     
63      struct PoolUserStruct {
64         bool isExist;
65         uint id;
66        uint payment_received; 
67     }
68     
69     mapping (address => UserStruct) public users;
70      mapping (uint => address) public userList;
71      
72      mapping (address => PoolUserStruct) public pool1users;
73      mapping (uint => address) public pool1userList;
74      
75      mapping (address => PoolUserStruct) public pool2users;
76      mapping (uint => address) public pool2userList;
77      
78      mapping (address => PoolUserStruct) public pool3users;
79      mapping (uint => address) public pool3userList;
80      
81      mapping (address => PoolUserStruct) public pool4users;
82      mapping (uint => address) public pool4userList;
83      
84      mapping (address => PoolUserStruct) public pool5users;
85      mapping (uint => address) public pool5userList;
86      
87      mapping (address => PoolUserStruct) public pool6users;
88      mapping (uint => address) public pool6userList;
89      
90      mapping (address => PoolUserStruct) public pool7users;
91      mapping (uint => address) public pool7userList;
92      
93      mapping (address => PoolUserStruct) public pool8users;
94      mapping (uint => address) public pool8userList;
95      
96      mapping (address => PoolUserStruct) public pool9users;
97      mapping (uint => address) public pool9userList;
98      
99      mapping (address => PoolUserStruct) public pool10users;
100      mapping (uint => address) public pool10userList;
101      
102     mapping(uint => uint) public LEVEL_PRICE;
103     
104    uint REGESTRATION_FESS=0.05 ether;
105    uint pool1_price=0.1 ether;
106    uint pool2_price=0.2 ether ;
107    uint pool3_price=0.5 ether;
108    uint pool4_price=1 ether;
109    uint pool5_price=2 ether;
110    uint pool6_price=5 ether;
111    uint pool7_price=10 ether ;
112    uint pool8_price=20 ether;
113    uint pool9_price=50 ether;
114    uint pool10_price=100 ether;
115    
116      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
117       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
118       
119      event regPoolEntry(address indexed _user,uint _level,   uint _time);
120    
121      
122     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
123    
124     UserStruct[] public requests;
125      
126       constructor() public {
127           ownerWallet = msg.sender;
128 
129         LEVEL_PRICE[1] = 0.01 ether;
130         LEVEL_PRICE[2] = 0.005 ether;
131         LEVEL_PRICE[3] = 0.0025 ether;
132         LEVEL_PRICE[4] = 0.00025 ether;
133       unlimited_level_price=0.00025 ether;
134 
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
260       }
261      
262        function regUser(uint _referrerID) public payable {
263        
264       require(!users[msg.sender].isExist, "User Exists");
265       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
266         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
267        
268         UserStruct memory userStruct;
269         currUserID++;
270 
271         userStruct = UserStruct({
272             isExist: true,
273             id: currUserID,
274             referrerID: _referrerID,
275             referredUsers:0
276         });
277    
278     
279        users[msg.sender] = userStruct;
280        userList[currUserID]=msg.sender;
281        
282         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
283         
284        payReferral(1,msg.sender);
285         emit regLevelEvent(msg.sender, userList[_referrerID], now);
286     }
287    
288    
289      function payReferral(uint _level, address _user) internal {
290         address referer;
291        
292         referer = userList[users[_user].referrerID];
293        
294        
295          bool sent = false;
296        
297             uint level_price_local=0;
298             if(_level>4){
299             level_price_local=unlimited_level_price;
300             }
301             else{
302             level_price_local=LEVEL_PRICE[_level];
303             }
304             sent = address(uint160(referer)).send(level_price_local);
305 
306             if (sent) {
307                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
308                 if(_level < 100 && users[referer].referrerID >= 1){
309                     payReferral(_level+1,referer);
310                 }
311                 else
312                 {
313                     sendBalance();
314                 }
315                
316             }
317        
318         if(!sent) {
319           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
320 
321             payReferral(_level, referer);
322         }
323      }
324    
325    
326    
327    
328        function buyPool1() public payable {
329        require(users[msg.sender].isExist, "User Not Registered");
330       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
331       
332         require(msg.value == pool1_price, 'Incorrect Value');
333         
334        
335         PoolUserStruct memory userStruct;
336         address pool1Currentuser=pool1userList[pool1activeUserID];
337         
338         pool1currUserID++;
339 
340         userStruct = PoolUserStruct({
341             isExist:true,
342             id:pool1currUserID,
343             payment_received:0
344         });
345    
346        pool1users[msg.sender] = userStruct;
347        pool1userList[pool1currUserID]=msg.sender;
348        bool sent = false;
349        sent = address(uint160(pool1Currentuser)).send(pool1_price);
350 
351             if (sent) {
352                 pool1users[pool1Currentuser].payment_received+=1;
353                 if(pool1users[pool1Currentuser].payment_received>=2)
354                 {
355                     pool1activeUserID+=1;
356                 }
357                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
358             }
359        emit regPoolEntry(msg.sender, 1, now);
360     }
361     
362     
363       function buyPool2() public payable {
364           require(users[msg.sender].isExist, "User Not Registered");
365       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
366         require(msg.value == pool2_price, 'Incorrect Value');
367         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
368          
369         PoolUserStruct memory userStruct;
370         address pool2Currentuser=pool2userList[pool2activeUserID];
371         
372         pool2currUserID++;
373         userStruct = PoolUserStruct({
374             isExist:true,
375             id:pool2currUserID,
376             payment_received:0
377         });
378        pool2users[msg.sender] = userStruct;
379        pool2userList[pool2currUserID]=msg.sender;
380        
381        
382        
383        bool sent = false;
384        sent = address(uint160(pool2Currentuser)).send(pool2_price);
385 
386             if (sent) {
387                 pool2users[pool2Currentuser].payment_received+=1;
388                 if(pool2users[pool2Currentuser].payment_received>=3)
389                 {
390                     pool2activeUserID+=1;
391                 }
392                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
393             }
394             emit regPoolEntry(msg.sender,2,  now);
395     }
396     
397     
398      function buyPool3() public payable {
399          require(users[msg.sender].isExist, "User Not Registered");
400       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
401         require(msg.value == pool3_price, 'Incorrect Value');
402         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
403         
404         PoolUserStruct memory userStruct;
405         address pool3Currentuser=pool3userList[pool3activeUserID];
406         
407         pool3currUserID++;
408         userStruct = PoolUserStruct({
409             isExist:true,
410             id:pool3currUserID,
411             payment_received:0
412         });
413        pool3users[msg.sender] = userStruct;
414        pool3userList[pool3currUserID]=msg.sender;
415        bool sent = false;
416        sent = address(uint160(pool3Currentuser)).send(pool3_price);
417 
418             if (sent) {
419                 pool3users[pool3Currentuser].payment_received+=1;
420                 if(pool3users[pool3Currentuser].payment_received>=3)
421                 {
422                     pool3activeUserID+=1;
423                 }
424                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
425             }
426 emit regPoolEntry(msg.sender,3,  now);
427     }
428     
429     
430     function buyPool4() public payable {
431         require(users[msg.sender].isExist, "User Not Registered");
432       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
433         require(msg.value == pool4_price, 'Incorrect Value');
434         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
435       
436         PoolUserStruct memory userStruct;
437         address pool4Currentuser=pool4userList[pool4activeUserID];
438         
439         pool4currUserID++;
440         userStruct = PoolUserStruct({
441             isExist:true,
442             id:pool4currUserID,
443             payment_received:0
444         });
445        pool4users[msg.sender] = userStruct;
446        pool4userList[pool4currUserID]=msg.sender;
447        bool sent = false;
448        sent = address(uint160(pool4Currentuser)).send(pool4_price);
449 
450             if (sent) {
451                 pool4users[pool4Currentuser].payment_received+=1;
452                 if(pool4users[pool4Currentuser].payment_received>=3)
453                 {
454                     pool4activeUserID+=1;
455                 }
456                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
457             }
458         emit regPoolEntry(msg.sender,4, now);
459     }
460     
461     
462     
463     function buyPool5() public payable {
464         require(users[msg.sender].isExist, "User Not Registered");
465       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
466         require(msg.value == pool5_price, 'Incorrect Value');
467         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
468         
469         PoolUserStruct memory userStruct;
470         address pool5Currentuser=pool5userList[pool5activeUserID];
471         
472         pool5currUserID++;
473         userStruct = PoolUserStruct({
474             isExist:true,
475             id:pool5currUserID,
476             payment_received:0
477         });
478        pool5users[msg.sender] = userStruct;
479        pool5userList[pool5currUserID]=msg.sender;
480        bool sent = false;
481        sent = address(uint160(pool5Currentuser)).send(pool5_price);
482 
483             if (sent) {
484                 pool5users[pool5Currentuser].payment_received+=1;
485                 if(pool5users[pool5Currentuser].payment_received>=3)
486                 {
487                     pool5activeUserID+=1;
488                 }
489                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
490             }
491         emit regPoolEntry(msg.sender,5,  now);
492     }
493     
494     function buyPool6() public payable {
495       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
496         require(msg.value == pool6_price, 'Incorrect Value');
497         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
498         
499         PoolUserStruct memory userStruct;
500         address pool6Currentuser=pool6userList[pool6activeUserID];
501         
502         pool6currUserID++;
503         userStruct = PoolUserStruct({
504             isExist:true,
505             id:pool6currUserID,
506             payment_received:0
507         });
508        pool6users[msg.sender] = userStruct;
509        pool6userList[pool6currUserID]=msg.sender;
510        bool sent = false;
511        sent = address(uint160(pool6Currentuser)).send(pool6_price);
512 
513             if (sent) {
514                 pool6users[pool6Currentuser].payment_received+=1;
515                 if(pool6users[pool6Currentuser].payment_received>=3)
516                 {
517                     pool6activeUserID+=1;
518                 }
519                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
520             }
521         emit regPoolEntry(msg.sender,6,  now);
522     }
523     
524     function buyPool7() public payable {
525         require(users[msg.sender].isExist, "User Not Registered");
526       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
527         require(msg.value == pool7_price, 'Incorrect Value');
528         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
529         
530         PoolUserStruct memory userStruct;
531         address pool7Currentuser=pool7userList[pool7activeUserID];
532         
533         pool7currUserID++;
534         userStruct = PoolUserStruct({
535             isExist:true,
536             id:pool7currUserID,
537             payment_received:0
538         });
539        pool7users[msg.sender] = userStruct;
540        pool7userList[pool7currUserID]=msg.sender;
541        bool sent = false;
542        sent = address(uint160(pool7Currentuser)).send(pool7_price);
543 
544             if (sent) {
545                 pool7users[pool7Currentuser].payment_received+=1;
546                 if(pool7users[pool7Currentuser].payment_received>=3)
547                 {
548                     pool7activeUserID+=1;
549                 }
550                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
551             }
552         emit regPoolEntry(msg.sender,7,  now);
553     }
554     
555     
556     function buyPool8() public payable {
557         require(users[msg.sender].isExist, "User Not Registered");
558       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
559         require(msg.value == pool8_price, 'Incorrect Value');
560         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
561        
562         PoolUserStruct memory userStruct;
563         address pool8Currentuser=pool8userList[pool8activeUserID];
564         
565         pool8currUserID++;
566         userStruct = PoolUserStruct({
567             isExist:true,
568             id:pool8currUserID,
569             payment_received:0
570         });
571        pool8users[msg.sender] = userStruct;
572        pool8userList[pool8currUserID]=msg.sender;
573        bool sent = false;
574        sent = address(uint160(pool8Currentuser)).send(pool8_price);
575 
576             if (sent) {
577                 pool8users[pool8Currentuser].payment_received+=1;
578                 if(pool8users[pool8Currentuser].payment_received>=3)
579                 {
580                     pool8activeUserID+=1;
581                 }
582                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
583             }
584         emit regPoolEntry(msg.sender,8,  now);
585     }
586     
587     
588     
589     function buyPool9() public payable {
590         require(users[msg.sender].isExist, "User Not Registered");
591       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
592         require(msg.value == pool9_price, 'Incorrect Value');
593         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
594        
595         PoolUserStruct memory userStruct;
596         address pool9Currentuser=pool9userList[pool9activeUserID];
597         
598         pool9currUserID++;
599         userStruct = PoolUserStruct({
600             isExist:true,
601             id:pool9currUserID,
602             payment_received:0
603         });
604        pool9users[msg.sender] = userStruct;
605        pool9userList[pool9currUserID]=msg.sender;
606        bool sent = false;
607        sent = address(uint160(pool9Currentuser)).send(pool9_price);
608 
609             if (sent) {
610                 pool9users[pool9Currentuser].payment_received+=1;
611                 if(pool9users[pool9Currentuser].payment_received>=3)
612                 {
613                     pool9activeUserID+=1;
614                 }
615                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
616             }
617         emit regPoolEntry(msg.sender,9,  now);
618     }
619     
620     
621     function buyPool10() public payable {
622         require(users[msg.sender].isExist, "User Not Registered");
623       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
624         require(msg.value == pool10_price, 'Incorrect Value');
625         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
626         
627         PoolUserStruct memory userStruct;
628         address pool10Currentuser=pool10userList[pool10activeUserID];
629         
630         pool10currUserID++;
631         userStruct = PoolUserStruct({
632             isExist:true,
633             id:pool10currUserID,
634             payment_received:0
635         });
636        pool10users[msg.sender] = userStruct;
637        pool10userList[pool10currUserID]=msg.sender;
638        bool sent = false;
639        sent = address(uint160(pool10Currentuser)).send(pool10_price);
640 
641             if (sent) {
642                 pool10users[pool10Currentuser].payment_received+=1;
643                 if(pool10users[pool10Currentuser].payment_received>=3)
644                 {
645                     pool10activeUserID+=1;
646                 }
647                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
648             }
649         emit regPoolEntry(msg.sender, 10, now);
650     }
651     
652     function getEthBalance() public view returns(uint) {
653     return address(this).balance;
654     }
655     
656     function sendBalance() private
657     {
658          if (!address(uint160(ownerWallet)).send(getEthBalance()))
659          {
660              
661          }
662     }
663    
664    
665 }