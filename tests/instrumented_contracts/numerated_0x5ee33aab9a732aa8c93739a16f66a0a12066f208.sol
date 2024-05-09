1 pragma solidity 0.5.11 - 0.6.4;
2 
3 contract EasySmart {
4      address public ownerWallet;
5       uint public currUserID = 0;
6       uint public pool1currUserID = 0;
7       uint public pool2currUserID = 0;
8       uint public pool3currUserID = 0;
9       uint public pool4currUserID = 0;
10       uint public pool5currUserID = 0;
11       uint public pool6currUserID = 0;
12       uint public pool7currUserID = 0;
13       uint public pool8currUserID = 0;
14       uint public pool9currUserID = 0;
15       uint public pool10currUserID = 0;
16       
17         uint public pool1activeUserID = 0;
18       uint public pool2activeUserID = 0;
19       uint public pool3activeUserID = 0;
20       uint public pool4activeUserID = 0;
21       uint public pool5activeUserID = 0;
22       uint public pool6activeUserID = 0;
23       uint public pool7activeUserID = 0;
24       uint public pool8activeUserID = 0;
25       uint public pool9activeUserID = 0;
26       uint public pool10activeUserID = 0;
27       
28       
29       uint public unlimited_level_price=0;
30      
31       struct UserStruct {
32         bool isExist;
33         uint id;
34         uint referrerID;
35        uint referredUsers;
36         mapping(uint => uint) levelExpired;
37     }
38     
39      struct PoolUserStruct {
40         bool isExist;
41         uint id;
42        uint payment_received; 
43     }
44     
45     mapping (address => UserStruct) public users;
46      mapping (uint => address) public userList;
47      
48      mapping (address => PoolUserStruct) public pool1users;
49      mapping (uint => address) public pool1userList;
50      
51      mapping (address => PoolUserStruct) public pool2users;
52      mapping (uint => address) public pool2userList;
53      
54      mapping (address => PoolUserStruct) public pool3users;
55      mapping (uint => address) public pool3userList;
56      
57      mapping (address => PoolUserStruct) public pool4users;
58      mapping (uint => address) public pool4userList;
59      
60      mapping (address => PoolUserStruct) public pool5users;
61      mapping (uint => address) public pool5userList;
62      
63      mapping (address => PoolUserStruct) public pool6users;
64      mapping (uint => address) public pool6userList;
65      
66      mapping (address => PoolUserStruct) public pool7users;
67      mapping (uint => address) public pool7userList;
68      
69      mapping (address => PoolUserStruct) public pool8users;
70      mapping (uint => address) public pool8userList;
71      
72      mapping (address => PoolUserStruct) public pool9users;
73      mapping (uint => address) public pool9userList;
74      
75      mapping (address => PoolUserStruct) public pool10users;
76      mapping (uint => address) public pool10userList;
77      
78     mapping(uint => uint) public LEVEL_PRICE;
79     
80    uint REGESTRATION_FESS=0.05 ether;
81    uint pool1_price=0.1 ether;
82    uint pool2_price=0.2 ether ;
83    uint pool3_price=0.5 ether;
84    uint pool4_price=1 ether;
85    uint pool5_price=2 ether;
86    uint pool6_price=5 ether;
87    uint pool7_price=10 ether ;
88    uint pool8_price=20 ether;
89    uint pool9_price=50 ether;
90    uint pool10_price=100 ether;
91    
92      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
93       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
94       
95      event regPoolEntry(address indexed _user,uint _level,   uint _time);
96    
97      
98     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
99    
100     UserStruct[] public requests;
101      
102       constructor() public {
103           ownerWallet = 0xc740d6B054C77262b6C4a2029A4F5A5db8faF052;
104 
105         LEVEL_PRICE[1] = 0.01 ether;
106         LEVEL_PRICE[2] = 0.005 ether;
107         LEVEL_PRICE[3] = 0.0025 ether;
108         LEVEL_PRICE[4] = 0.00025 ether;
109       unlimited_level_price=0.00025 ether;
110 
111         UserStruct memory userStruct;
112         currUserID++;
113 
114         userStruct = UserStruct({
115             isExist: true,
116             id: currUserID,
117             referrerID: 0,
118             referredUsers:0
119            
120         });
121         
122         users[ownerWallet] = userStruct;
123        userList[currUserID] = ownerWallet;
124        
125        
126          PoolUserStruct memory pooluserStruct;
127         
128         pool1currUserID++;
129 
130         pooluserStruct = PoolUserStruct({
131             isExist:true,
132             id:pool1currUserID,
133             payment_received:0
134         });
135     pool1activeUserID=pool1currUserID;
136        pool1users[ownerWallet] = pooluserStruct;
137        pool1userList[pool1currUserID]=ownerWallet;
138       
139         
140         pool2currUserID++;
141         pooluserStruct = PoolUserStruct({
142             isExist:true,
143             id:pool2currUserID,
144             payment_received:0
145         });
146     pool2activeUserID=pool2currUserID;
147        pool2users[ownerWallet] = pooluserStruct;
148        pool2userList[pool2currUserID]=ownerWallet;
149        
150        
151         pool3currUserID++;
152         pooluserStruct = PoolUserStruct({
153             isExist:true,
154             id:pool3currUserID,
155             payment_received:0
156         });
157     pool3activeUserID=pool3currUserID;
158        pool3users[ownerWallet] = pooluserStruct;
159        pool3userList[pool3currUserID]=ownerWallet;
160        
161        
162          pool4currUserID++;
163         pooluserStruct = PoolUserStruct({
164             isExist:true,
165             id:pool4currUserID,
166             payment_received:0
167         });
168     pool4activeUserID=pool4currUserID;
169        pool4users[ownerWallet] = pooluserStruct;
170        pool4userList[pool4currUserID]=ownerWallet;
171 
172         
173           pool5currUserID++;
174         pooluserStruct = PoolUserStruct({
175             isExist:true,
176             id:pool5currUserID,
177             payment_received:0
178         });
179     pool5activeUserID=pool5currUserID;
180        pool5users[ownerWallet] = pooluserStruct;
181        pool5userList[pool5currUserID]=ownerWallet;
182        
183        
184          pool6currUserID++;
185         pooluserStruct = PoolUserStruct({
186             isExist:true,
187             id:pool6currUserID,
188             payment_received:0
189         });
190     pool6activeUserID=pool6currUserID;
191        pool6users[ownerWallet] = pooluserStruct;
192        pool6userList[pool6currUserID]=ownerWallet;
193        
194          pool7currUserID++;
195         pooluserStruct = PoolUserStruct({
196             isExist:true,
197             id:pool7currUserID,
198             payment_received:0
199         });
200     pool7activeUserID=pool7currUserID;
201        pool7users[ownerWallet] = pooluserStruct;
202        pool7userList[pool7currUserID]=ownerWallet;
203        
204        pool8currUserID++;
205         pooluserStruct = PoolUserStruct({
206             isExist:true,
207             id:pool8currUserID,
208             payment_received:0
209         });
210     pool8activeUserID=pool8currUserID;
211        pool8users[ownerWallet] = pooluserStruct;
212        pool8userList[pool8currUserID]=ownerWallet;
213        
214         pool9currUserID++;
215         pooluserStruct = PoolUserStruct({
216             isExist:true,
217             id:pool9currUserID,
218             payment_received:0
219         });
220     pool9activeUserID=pool9currUserID;
221        pool9users[ownerWallet] = pooluserStruct;
222        pool9userList[pool9currUserID]=ownerWallet;
223        
224        
225         pool10currUserID++;
226         pooluserStruct = PoolUserStruct({
227             isExist:true,
228             id:pool10currUserID,
229             payment_received:0
230         });
231     pool10activeUserID=pool10currUserID;
232        pool10users[ownerWallet] = pooluserStruct;
233        pool10userList[pool10currUserID]=ownerWallet;
234        
235        
236       }
237      
238        function regUser(uint _referrerID) public payable {
239        
240       require(!users[msg.sender].isExist, "User Exists");
241       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
242         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
243        
244         UserStruct memory userStruct;
245         currUserID++;
246 
247         userStruct = UserStruct({
248             isExist: true,
249             id: currUserID,
250             referrerID: _referrerID,
251             referredUsers:0
252         });
253    
254     
255        users[msg.sender] = userStruct;
256        userList[currUserID]=msg.sender;
257        
258         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
259         
260        payReferral(1,msg.sender);
261         emit regLevelEvent(msg.sender, userList[_referrerID], now);
262     }
263    
264    
265      function payReferral(uint _level, address _user) internal {
266         address referer;
267        
268         referer = userList[users[_user].referrerID];
269        
270        
271          bool sent = false;
272        
273             uint level_price_local=0;
274             if(_level>4){
275             level_price_local=unlimited_level_price;
276             }
277             else{
278             level_price_local=LEVEL_PRICE[_level];
279             }
280             sent = address(uint160(referer)).send(level_price_local);
281 
282             if (sent) {
283                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
284                 if(_level < 100 && users[referer].referrerID >= 1){
285                     payReferral(_level+1,referer);
286                 }
287                 else
288                 {
289                     sendBalance();
290                 }
291                
292             }
293        
294         if(!sent) {
295           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
296 
297             payReferral(_level, referer);
298         }
299      }
300    
301    
302    
303    
304        function buyPool1() public payable {
305        require(users[msg.sender].isExist, "User Not Registered");
306       require(!pool1users[msg.sender].isExist, "Already in AutoPool");
307       
308         require(msg.value == pool1_price, 'Incorrect Value');
309         
310        
311         PoolUserStruct memory userStruct;
312         address pool1Currentuser=pool1userList[pool1activeUserID];
313         
314         pool1currUserID++;
315 
316         userStruct = PoolUserStruct({
317             isExist:true,
318             id:pool1currUserID,
319             payment_received:0
320         });
321    
322        pool1users[msg.sender] = userStruct;
323        pool1userList[pool1currUserID]=msg.sender;
324        bool sent = false;
325        sent = address(uint160(pool1Currentuser)).send(pool1_price);
326 
327             if (sent) {
328                 pool1users[pool1Currentuser].payment_received+=1;
329                 if(pool1users[pool1Currentuser].payment_received>=2)
330                 {
331                     pool1activeUserID+=1;
332                 }
333                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
334             }
335        emit regPoolEntry(msg.sender, 1, now);
336     }
337     
338     
339       function buyPool2() public payable {
340           require(users[msg.sender].isExist, "User Not Registered");
341       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
342         require(msg.value == pool2_price, 'Incorrect Value');
343         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
344          
345         PoolUserStruct memory userStruct;
346         address pool2Currentuser=pool2userList[pool2activeUserID];
347         
348         pool2currUserID++;
349         userStruct = PoolUserStruct({
350             isExist:true,
351             id:pool2currUserID,
352             payment_received:0
353         });
354        pool2users[msg.sender] = userStruct;
355        pool2userList[pool2currUserID]=msg.sender;
356        
357        
358        
359        bool sent = false;
360        sent = address(uint160(pool2Currentuser)).send(pool2_price);
361 
362             if (sent) {
363                 pool2users[pool2Currentuser].payment_received+=1;
364                 if(pool2users[pool2Currentuser].payment_received>=3)
365                 {
366                     pool2activeUserID+=1;
367                 }
368                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
369             }
370             emit regPoolEntry(msg.sender,2,  now);
371     }
372     
373     
374      function buyPool3() public payable {
375          require(users[msg.sender].isExist, "User Not Registered");
376       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
377         require(msg.value == pool3_price, 'Incorrect Value');
378         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
379         
380         PoolUserStruct memory userStruct;
381         address pool3Currentuser=pool3userList[pool3activeUserID];
382         
383         pool3currUserID++;
384         userStruct = PoolUserStruct({
385             isExist:true,
386             id:pool3currUserID,
387             payment_received:0
388         });
389        pool3users[msg.sender] = userStruct;
390        pool3userList[pool3currUserID]=msg.sender;
391        bool sent = false;
392        sent = address(uint160(pool3Currentuser)).send(pool3_price);
393 
394             if (sent) {
395                 pool3users[pool3Currentuser].payment_received+=1;
396                 if(pool3users[pool3Currentuser].payment_received>=3)
397                 {
398                     pool3activeUserID+=1;
399                 }
400                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
401             }
402 emit regPoolEntry(msg.sender,3,  now);
403     }
404     
405     
406     function buyPool4() public payable {
407         require(users[msg.sender].isExist, "User Not Registered");
408       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
409         require(msg.value == pool4_price, 'Incorrect Value');
410         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
411       
412         PoolUserStruct memory userStruct;
413         address pool4Currentuser=pool4userList[pool4activeUserID];
414         
415         pool4currUserID++;
416         userStruct = PoolUserStruct({
417             isExist:true,
418             id:pool4currUserID,
419             payment_received:0
420         });
421        pool4users[msg.sender] = userStruct;
422        pool4userList[pool4currUserID]=msg.sender;
423        bool sent = false;
424        sent = address(uint160(pool4Currentuser)).send(pool4_price);
425 
426             if (sent) {
427                 pool4users[pool4Currentuser].payment_received+=1;
428                 if(pool4users[pool4Currentuser].payment_received>=3)
429                 {
430                     pool4activeUserID+=1;
431                 }
432                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
433             }
434         emit regPoolEntry(msg.sender,4, now);
435     }
436     
437     
438     
439     function buyPool5() public payable {
440         require(users[msg.sender].isExist, "User Not Registered");
441       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
442         require(msg.value == pool5_price, 'Incorrect Value');
443         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
444         
445         PoolUserStruct memory userStruct;
446         address pool5Currentuser=pool5userList[pool5activeUserID];
447         
448         pool5currUserID++;
449         userStruct = PoolUserStruct({
450             isExist:true,
451             id:pool5currUserID,
452             payment_received:0
453         });
454        pool5users[msg.sender] = userStruct;
455        pool5userList[pool5currUserID]=msg.sender;
456        bool sent = false;
457        sent = address(uint160(pool5Currentuser)).send(pool5_price);
458 
459             if (sent) {
460                 pool5users[pool5Currentuser].payment_received+=1;
461                 if(pool5users[pool5Currentuser].payment_received>=3)
462                 {
463                     pool5activeUserID+=1;
464                 }
465                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
466             }
467         emit regPoolEntry(msg.sender,5,  now);
468     }
469     
470     function buyPool6() public payable {
471       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
472         require(msg.value == pool6_price, 'Incorrect Value');
473         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
474         
475         PoolUserStruct memory userStruct;
476         address pool6Currentuser=pool6userList[pool6activeUserID];
477         
478         pool6currUserID++;
479         userStruct = PoolUserStruct({
480             isExist:true,
481             id:pool6currUserID,
482             payment_received:0
483         });
484        pool6users[msg.sender] = userStruct;
485        pool6userList[pool6currUserID]=msg.sender;
486        bool sent = false;
487        sent = address(uint160(pool6Currentuser)).send(pool6_price);
488 
489             if (sent) {
490                 pool6users[pool6Currentuser].payment_received+=1;
491                 if(pool6users[pool6Currentuser].payment_received>=3)
492                 {
493                     pool6activeUserID+=1;
494                 }
495                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
496             }
497         emit regPoolEntry(msg.sender,6,  now);
498     }
499     
500     function buyPool7() public payable {
501         require(users[msg.sender].isExist, "User Not Registered");
502       require(!pool7users[msg.sender].isExist, "Already in AutoPool");
503         require(msg.value == pool7_price, 'Incorrect Value');
504         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
505         
506         PoolUserStruct memory userStruct;
507         address pool7Currentuser=pool7userList[pool7activeUserID];
508         
509         pool7currUserID++;
510         userStruct = PoolUserStruct({
511             isExist:true,
512             id:pool7currUserID,
513             payment_received:0
514         });
515        pool7users[msg.sender] = userStruct;
516        pool7userList[pool7currUserID]=msg.sender;
517        bool sent = false;
518        sent = address(uint160(pool7Currentuser)).send(pool7_price);
519 
520             if (sent) {
521                 pool7users[pool7Currentuser].payment_received+=1;
522                 if(pool7users[pool7Currentuser].payment_received>=3)
523                 {
524                     pool7activeUserID+=1;
525                 }
526                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
527             }
528         emit regPoolEntry(msg.sender,7,  now);
529     }
530     
531     
532     function buyPool8() public payable {
533         require(users[msg.sender].isExist, "User Not Registered");
534       require(!pool8users[msg.sender].isExist, "Already in AutoPool");
535         require(msg.value == pool8_price, 'Incorrect Value');
536         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
537        
538         PoolUserStruct memory userStruct;
539         address pool8Currentuser=pool8userList[pool8activeUserID];
540         
541         pool8currUserID++;
542         userStruct = PoolUserStruct({
543             isExist:true,
544             id:pool8currUserID,
545             payment_received:0
546         });
547        pool8users[msg.sender] = userStruct;
548        pool8userList[pool8currUserID]=msg.sender;
549        bool sent = false;
550        sent = address(uint160(pool8Currentuser)).send(pool8_price);
551 
552             if (sent) {
553                 pool8users[pool8Currentuser].payment_received+=1;
554                 if(pool8users[pool8Currentuser].payment_received>=3)
555                 {
556                     pool8activeUserID+=1;
557                 }
558                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
559             }
560         emit regPoolEntry(msg.sender,8,  now);
561     }
562     
563     
564     
565     function buyPool9() public payable {
566         require(users[msg.sender].isExist, "User Not Registered");
567       require(!pool9users[msg.sender].isExist, "Already in AutoPool");
568         require(msg.value == pool9_price, 'Incorrect Value');
569         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
570        
571         PoolUserStruct memory userStruct;
572         address pool9Currentuser=pool9userList[pool9activeUserID];
573         
574         pool9currUserID++;
575         userStruct = PoolUserStruct({
576             isExist:true,
577             id:pool9currUserID,
578             payment_received:0
579         });
580        pool9users[msg.sender] = userStruct;
581        pool9userList[pool9currUserID]=msg.sender;
582        bool sent = false;
583        sent = address(uint160(pool9Currentuser)).send(pool9_price);
584 
585             if (sent) {
586                 pool9users[pool9Currentuser].payment_received+=1;
587                 if(pool9users[pool9Currentuser].payment_received>=3)
588                 {
589                     pool9activeUserID+=1;
590                 }
591                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
592             }
593         emit regPoolEntry(msg.sender,9,  now);
594     }
595     
596     
597     function buyPool10() public payable {
598         require(users[msg.sender].isExist, "User Not Registered");
599       require(!pool10users[msg.sender].isExist, "Already in AutoPool");
600         require(msg.value == pool10_price, 'Incorrect Value');
601         require(users[msg.sender].referredUsers>=0, "Must need 0 referral");
602         
603         PoolUserStruct memory userStruct;
604         address pool10Currentuser=pool10userList[pool10activeUserID];
605         
606         pool10currUserID++;
607         userStruct = PoolUserStruct({
608             isExist:true,
609             id:pool10currUserID,
610             payment_received:0
611         });
612        pool10users[msg.sender] = userStruct;
613        pool10userList[pool10currUserID]=msg.sender;
614        bool sent = false;
615        sent = address(uint160(pool10Currentuser)).send(pool10_price);
616 
617             if (sent) {
618                 pool10users[pool10Currentuser].payment_received+=1;
619                 if(pool10users[pool10Currentuser].payment_received>=3)
620                 {
621                     pool10activeUserID+=1;
622                 }
623                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
624             }
625         emit regPoolEntry(msg.sender, 10, now);
626     }
627     
628     function getEthBalance() public view returns(uint) {
629     return address(this).balance;
630     }
631     
632     function sendBalance() private
633     {
634          if (!address(uint160(ownerWallet)).send(getEthBalance()))
635          {
636              
637          }
638     }
639    
640    
641 }