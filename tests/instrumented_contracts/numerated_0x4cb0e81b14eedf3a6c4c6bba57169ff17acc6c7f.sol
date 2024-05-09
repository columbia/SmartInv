1 pragma solidity 0.5.11 - 0.6.4;
2 
3 contract BullRun {
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
17       uint public pool1activeUserID = 0;
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
29       struct UserStruct {
30         bool isExist;
31         uint id;
32         uint referrerID;
33        uint referredUsers;
34         mapping(uint => uint) levelExpired;
35     }
36     
37      struct PoolUserStruct {
38         bool isExist;
39         uint id;
40        uint payment_received; 
41     }
42     
43     mapping (address => UserStruct) public users;
44      mapping (uint => address) public userList;
45      
46      mapping (address => PoolUserStruct) public pool1users;
47      mapping (uint => address) public pool1userList;
48      
49      mapping (address => PoolUserStruct) public pool2users;
50      mapping (uint => address) public pool2userList;
51      
52      mapping (address => PoolUserStruct) public pool3users;
53      mapping (uint => address) public pool3userList;
54      
55      mapping (address => PoolUserStruct) public pool4users;
56      mapping (uint => address) public pool4userList;
57      
58      mapping (address => PoolUserStruct) public pool5users;
59      mapping (uint => address) public pool5userList;
60      
61      mapping (address => PoolUserStruct) public pool6users;
62      mapping (uint => address) public pool6userList;
63      
64      mapping (address => PoolUserStruct) public pool7users;
65      mapping (uint => address) public pool7userList;
66      
67      mapping (address => PoolUserStruct) public pool8users;
68      mapping (uint => address) public pool8userList;
69      
70      mapping (address => PoolUserStruct) public pool9users;
71      mapping (uint => address) public pool9userList;
72      
73      mapping (address => PoolUserStruct) public pool10users;
74      mapping (uint => address) public pool10userList;
75      
76     mapping(uint => uint) public LEVEL_PRICE;
77     
78    uint REGESTRATION_FESS=0.1 ether;
79    uint pool1_price=0.1 ether;
80    uint pool2_price=0.2 ether ;
81    uint pool3_price=0.5 ether;
82    uint pool4_price=1 ether;
83    uint pool5_price=2 ether;
84    uint pool6_price=5 ether;
85    uint pool7_price=10 ether ;
86    uint pool8_price=20 ether;
87    uint pool9_price=50 ether;
88    uint pool10_price=100 ether;
89    
90      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
91       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
92       
93      event regPoolEntry(address indexed _user,uint _level,   uint _time);
94    
95      
96     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
97    
98     UserStruct[] public requests;
99      
100       constructor() public {
101           ownerWallet = msg.sender;
102 
103         LEVEL_PRICE[1] = 0.05 ether;
104         LEVEL_PRICE[2] = 0.02 ether;
105         LEVEL_PRICE[3] = 0.015 ether;
106         LEVEL_PRICE[4] = 0.015 ether;
107 
108         UserStruct memory userStruct;
109         currUserID++;
110 
111         userStruct = UserStruct({
112             isExist: true,
113             id: currUserID,
114             referrerID: 0,
115             referredUsers:0
116            
117         });
118         
119         users[ownerWallet] = userStruct;
120        userList[currUserID] = ownerWallet;
121        
122        
123          PoolUserStruct memory pooluserStruct;
124         
125         pool1currUserID++;
126 
127         pooluserStruct = PoolUserStruct({
128             isExist:true,
129             id:pool1currUserID,
130             payment_received:0
131         });
132     pool1activeUserID=pool1currUserID;
133        pool1users[msg.sender] = pooluserStruct;
134        pool1userList[pool1currUserID]=msg.sender;
135       
136         
137         pool2currUserID++;
138         pooluserStruct = PoolUserStruct({
139             isExist:true,
140             id:pool2currUserID,
141             payment_received:0
142         });
143     pool2activeUserID=pool2currUserID;
144        pool2users[msg.sender] = pooluserStruct;
145        pool2userList[pool2currUserID]=msg.sender;
146        
147        
148         pool3currUserID++;
149         pooluserStruct = PoolUserStruct({
150             isExist:true,
151             id:pool3currUserID,
152             payment_received:0
153         });
154     pool3activeUserID=pool3currUserID;
155        pool3users[msg.sender] = pooluserStruct;
156        pool3userList[pool3currUserID]=msg.sender;
157        
158        
159          pool4currUserID++;
160         pooluserStruct = PoolUserStruct({
161             isExist:true,
162             id:pool4currUserID,
163             payment_received:0
164         });
165     pool4activeUserID=pool4currUserID;
166        pool4users[msg.sender] = pooluserStruct;
167        pool4userList[pool4currUserID]=msg.sender;
168 
169         
170           pool5currUserID++;
171         pooluserStruct = PoolUserStruct({
172             isExist:true,
173             id:pool5currUserID,
174             payment_received:0
175         });
176     pool5activeUserID=pool5currUserID;
177        pool5users[msg.sender] = pooluserStruct;
178        pool5userList[pool5currUserID]=msg.sender;
179        
180        
181          pool6currUserID++;
182         pooluserStruct = PoolUserStruct({
183             isExist:true,
184             id:pool6currUserID,
185             payment_received:0
186         });
187     pool6activeUserID=pool6currUserID;
188        pool6users[msg.sender] = pooluserStruct;
189        pool6userList[pool6currUserID]=msg.sender;
190        
191          pool7currUserID++;
192         pooluserStruct = PoolUserStruct({
193             isExist:true,
194             id:pool7currUserID,
195             payment_received:0
196         });
197     pool7activeUserID=pool7currUserID;
198        pool7users[msg.sender] = pooluserStruct;
199        pool7userList[pool7currUserID]=msg.sender;
200        
201        pool8currUserID++;
202         pooluserStruct = PoolUserStruct({
203             isExist:true,
204             id:pool8currUserID,
205             payment_received:0
206         });
207     pool8activeUserID=pool8currUserID;
208        pool8users[msg.sender] = pooluserStruct;
209        pool8userList[pool8currUserID]=msg.sender;
210        
211         pool9currUserID++;
212         pooluserStruct = PoolUserStruct({
213             isExist:true,
214             id:pool9currUserID,
215             payment_received:0
216         });
217     pool9activeUserID=pool9currUserID;
218        pool9users[msg.sender] = pooluserStruct;
219        pool9userList[pool9currUserID]=msg.sender;
220        
221        
222         pool10currUserID++;
223         pooluserStruct = PoolUserStruct({
224             isExist:true,
225             id:pool10currUserID,
226             payment_received:0
227         });
228     pool10activeUserID=pool10currUserID;
229        pool10users[msg.sender] = pooluserStruct;
230        pool10userList[pool10currUserID]=msg.sender;
231        
232        
233       }
234      
235      function regUser(uint _referrerID) public payable {
236        
237       require(!users[msg.sender].isExist, "User Exists");
238       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
239       require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
240        
241         UserStruct memory userStruct;
242         currUserID++;
243 
244         userStruct = UserStruct({
245             isExist: true,
246             id: currUserID,
247             referrerID: _referrerID,
248             referredUsers:0
249         });
250    
251     
252        users[msg.sender] = userStruct;
253        userList[currUserID]=msg.sender;
254        
255         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
256         
257        payReferral(1,msg.sender);
258         emit regLevelEvent(msg.sender, userList[_referrerID], now);
259     }
260    
261    
262      function payReferral(uint _level, address _user) internal {
263         address referer;
264        
265         referer = userList[users[_user].referrerID];
266        
267        
268          bool sent = false;
269        
270             uint level_price_local=0;
271             
272             level_price_local=LEVEL_PRICE[_level];
273             
274             sent = address(uint160(referer)).send(level_price_local);
275 
276             if (sent) {
277                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
278                 if(_level < 4) {
279                     if(users[referer].referrerID >= 1){
280                         payReferral(_level+1,referer);
281                     }
282                     else {
283                         sendBalance();
284                     }
285                 }
286             }
287        
288         if(!sent) {
289 
290             payReferral(_level, referer);
291         }
292      }
293    
294    
295    
296    
297        function buyPool1() public payable {
298        require(users[msg.sender].isExist, "User Not Registered");
299        require(msg.value == pool1_price, 'Incorrect Value');
300         
301        
302         PoolUserStruct memory userStruct;
303         address pool1Currentuser=pool1userList[pool1activeUserID];
304         
305         pool1currUserID++;
306 
307         userStruct = PoolUserStruct({
308             isExist:true,
309             id:pool1currUserID,
310             payment_received:0
311         });
312    
313        pool1users[msg.sender] = userStruct;
314        pool1userList[pool1currUserID]=msg.sender;
315        bool sent = false;
316        sent = address(uint160(pool1Currentuser)).send(pool1_price);
317 
318             if (sent) {
319                 pool1users[pool1Currentuser].payment_received+=1;
320                 if(pool1users[pool1Currentuser].payment_received>=3)
321                 {
322                     pool1activeUserID+=1;
323                 }
324                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
325             }
326        emit regPoolEntry(msg.sender, 1, now);
327     }
328     
329     
330       function buyPool2() public payable {
331         require(users[msg.sender].isExist, "User Not Registered");
332         require(msg.value == pool2_price, 'Incorrect Value');
333          
334         PoolUserStruct memory userStruct;
335         address pool2Currentuser=pool2userList[pool2activeUserID];
336         
337         pool2currUserID++;
338         userStruct = PoolUserStruct({
339             isExist:true,
340             id:pool2currUserID,
341             payment_received:0
342         });
343        pool2users[msg.sender] = userStruct;
344        pool2userList[pool2currUserID]=msg.sender;
345        
346        
347        
348        bool sent = false;
349        sent = address(uint160(pool2Currentuser)).send(pool2_price);
350 
351             if (sent) {
352                 pool2users[pool2Currentuser].payment_received+=1;
353                 if(pool2users[pool2Currentuser].payment_received>=3)
354                 {
355                     pool2activeUserID+=1;
356                 }
357                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
358             }
359             emit regPoolEntry(msg.sender,2,  now);
360     }
361     
362     
363      function buyPool3() public payable {
364         require(users[msg.sender].isExist, "User Not Registered");
365         require(msg.value == pool3_price, 'Incorrect Value');
366         
367         PoolUserStruct memory userStruct;
368         address pool3Currentuser=pool3userList[pool3activeUserID];
369         
370         pool3currUserID++;
371         userStruct = PoolUserStruct({
372             isExist:true,
373             id:pool3currUserID,
374             payment_received:0
375         });
376        pool3users[msg.sender] = userStruct;
377        pool3userList[pool3currUserID]=msg.sender;
378        bool sent = false;
379        sent = address(uint160(pool3Currentuser)).send(pool3_price);
380 
381             if (sent) {
382                 pool3users[pool3Currentuser].payment_received+=1;
383                 if(pool3users[pool3Currentuser].payment_received>=3)
384                 {
385                     pool3activeUserID+=1;
386                 }
387                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
388             }
389         emit regPoolEntry(msg.sender,3,  now);
390     }
391     
392     
393     function buyPool4() public payable {
394        require(users[msg.sender].isExist, "User Not Registered");
395        require(msg.value == pool4_price, 'Incorrect Value');
396       
397         PoolUserStruct memory userStruct;
398         address pool4Currentuser=pool4userList[pool4activeUserID];
399         
400         pool4currUserID++;
401         userStruct = PoolUserStruct({
402             isExist:true,
403             id:pool4currUserID,
404             payment_received:0
405         });
406        pool4users[msg.sender] = userStruct;
407        pool4userList[pool4currUserID]=msg.sender;
408        bool sent = false;
409        sent = address(uint160(pool4Currentuser)).send(pool4_price);
410 
411             if (sent) {
412                 pool4users[pool4Currentuser].payment_received+=1;
413                 if(pool4users[pool4Currentuser].payment_received>=3)
414                 {
415                     pool4activeUserID+=1;
416                 }
417                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
418             }
419         emit regPoolEntry(msg.sender,4, now);
420     }
421     
422     
423     
424     function buyPool5() public payable {
425         require(users[msg.sender].isExist, "User Not Registered");
426         require(msg.value == pool5_price, 'Incorrect Value');
427         
428         PoolUserStruct memory userStruct;
429         address pool5Currentuser=pool5userList[pool5activeUserID];
430         
431         pool5currUserID++;
432         userStruct = PoolUserStruct({
433             isExist:true,
434             id:pool5currUserID,
435             payment_received:0
436         });
437        pool5users[msg.sender] = userStruct;
438        pool5userList[pool5currUserID]=msg.sender;
439        bool sent = false;
440        sent = address(uint160(pool5Currentuser)).send(pool5_price);
441 
442             if (sent) {
443                 pool5users[pool5Currentuser].payment_received+=1;
444                 if(pool5users[pool5Currentuser].payment_received>=3)
445                 {
446                     pool5activeUserID+=1;
447                 }
448                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
449             }
450         emit regPoolEntry(msg.sender,5,  now);
451     }
452     
453     function buyPool6() public payable {
454         require(users[msg.sender].isExist, "User Not Registered");
455         require(msg.value == pool6_price, 'Incorrect Value');
456         
457         PoolUserStruct memory userStruct;
458         address pool6Currentuser=pool6userList[pool6activeUserID];
459         
460         pool6currUserID++;
461         userStruct = PoolUserStruct({
462             isExist:true,
463             id:pool6currUserID,
464             payment_received:0
465         });
466        pool6users[msg.sender] = userStruct;
467        pool6userList[pool6currUserID]=msg.sender;
468        bool sent = false;
469        sent = address(uint160(pool6Currentuser)).send(pool6_price);
470 
471             if (sent) {
472                 pool6users[pool6Currentuser].payment_received+=1;
473                 if(pool6users[pool6Currentuser].payment_received>=3)
474                 {
475                     pool6activeUserID+=1;
476                 }
477                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
478             }
479         emit regPoolEntry(msg.sender,6,  now);
480     }
481     
482     function buyPool7() public payable {
483         require(users[msg.sender].isExist, "User Not Registered");
484         require(msg.value == pool7_price, 'Incorrect Value');
485         
486         PoolUserStruct memory userStruct;
487         address pool7Currentuser=pool7userList[pool7activeUserID];
488         
489         pool7currUserID++;
490         userStruct = PoolUserStruct({
491             isExist:true,
492             id:pool7currUserID,
493             payment_received:0
494         });
495        pool7users[msg.sender] = userStruct;
496        pool7userList[pool7currUserID]=msg.sender;
497        bool sent = false;
498        sent = address(uint160(pool7Currentuser)).send(pool7_price);
499 
500             if (sent) {
501                 pool7users[pool7Currentuser].payment_received+=1;
502                 if(pool7users[pool7Currentuser].payment_received>=3)
503                 {
504                     pool7activeUserID+=1;
505                 }
506                  emit getPoolPayment(msg.sender,pool7Currentuser, 7, now);
507             }
508         emit regPoolEntry(msg.sender,7,  now);
509     }
510     
511     
512     function buyPool8() public payable {
513         require(users[msg.sender].isExist, "User Not Registered");
514         require(msg.value == pool8_price, 'Incorrect Value');
515        
516         PoolUserStruct memory userStruct;
517         address pool8Currentuser=pool8userList[pool8activeUserID];
518         
519         pool8currUserID++;
520         userStruct = PoolUserStruct({
521             isExist:true,
522             id:pool8currUserID,
523             payment_received:0
524         });
525        pool8users[msg.sender] = userStruct;
526        pool8userList[pool8currUserID]=msg.sender;
527        bool sent = false;
528        sent = address(uint160(pool8Currentuser)).send(pool8_price);
529 
530             if (sent) {
531                 pool8users[pool8Currentuser].payment_received+=1;
532                 if(pool8users[pool8Currentuser].payment_received>=3)
533                 {
534                     pool8activeUserID+=1;
535                 }
536                  emit getPoolPayment(msg.sender,pool8Currentuser, 8, now);
537             }
538         emit regPoolEntry(msg.sender,8,  now);
539     }
540     
541     
542     
543     function buyPool9() public payable {
544         require(users[msg.sender].isExist, "User Not Registered");
545         require(msg.value == pool9_price, 'Incorrect Value');
546        
547         PoolUserStruct memory userStruct;
548         address pool9Currentuser=pool9userList[pool9activeUserID];
549         
550         pool9currUserID++;
551         userStruct = PoolUserStruct({
552             isExist:true,
553             id:pool9currUserID,
554             payment_received:0
555         });
556        pool9users[msg.sender] = userStruct;
557        pool9userList[pool9currUserID]=msg.sender;
558        bool sent = false;
559        sent = address(uint160(pool9Currentuser)).send(pool9_price);
560 
561             if (sent) {
562                 pool9users[pool9Currentuser].payment_received+=1;
563                 if(pool9users[pool9Currentuser].payment_received>=3)
564                 {
565                     pool9activeUserID+=1;
566                 }
567                  emit getPoolPayment(msg.sender,pool9Currentuser, 9, now);
568             }
569         emit regPoolEntry(msg.sender,9,  now);
570     }
571     
572     
573     function buyPool10() public payable {
574         require(users[msg.sender].isExist, "User Not Registered");
575         require(msg.value == pool10_price, 'Incorrect Value');
576         
577         PoolUserStruct memory userStruct;
578         address pool10Currentuser=pool10userList[pool10activeUserID];
579         
580         pool10currUserID++;
581         userStruct = PoolUserStruct({
582             isExist:true,
583             id:pool10currUserID,
584             payment_received:0
585         });
586        pool10users[msg.sender] = userStruct;
587        pool10userList[pool10currUserID]=msg.sender;
588        bool sent = false;
589        sent = address(uint160(pool10Currentuser)).send(pool10_price);
590 
591             if (sent) {
592                 pool10users[pool10Currentuser].payment_received+=1;
593                 if(pool10users[pool10Currentuser].payment_received>=3)
594                 {
595                     pool10activeUserID+=1;
596                 }
597                  emit getPoolPayment(msg.sender,pool10Currentuser, 10, now);
598             }
599         emit regPoolEntry(msg.sender, 10, now);
600     }
601     
602     function getEthBalance() public view returns(uint) {
603     return address(this).balance;
604     }
605     
606     function sendBalance() private
607     {
608          if (!address(uint160(ownerWallet)).send(getEthBalance()))
609          {
610              
611          }
612     }
613    
614    
615 }