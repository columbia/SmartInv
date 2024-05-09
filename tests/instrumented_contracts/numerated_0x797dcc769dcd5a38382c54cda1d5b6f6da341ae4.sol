1 /*
2 
3                                                                                                                             
4         8 8888888888       ,o888888o.     8 888888888o.      ,o888888o.    8 8888888888   8 8888888888   `8.`8888.      ,8' 
5         8 8888          . 8888     `88.   8 8888    `88.    8888     `88.  8 8888         8 8888          `8.`8888.    ,8'  
6         8 8888         ,8 8888       `8b  8 8888     `88 ,8 8888       `8. 8 8888         8 8888           `8.`8888.  ,8'   
7         8 8888         88 8888        `8b 8 8888     ,88 88 8888           8 8888         8 8888            `8.`8888.,8'    
8         8 888888888888 88 8888         88 8 8888.   ,88' 88 8888           8 888888888888 8 888888888888     `8.`88888'     
9         8 8888         88 8888         88 8 888888888P'  88 8888           8 8888         8 8888             .88.`8888.     
10         8 8888         88 8888        ,8P 8 8888`8b      88 8888           8 8888         8 8888            .8'`8.`8888.    
11         8 8888         `8 8888       ,8P  8 8888 `8b.    `8 8888       .8' 8 8888         8 8888           .8'  `8.`8888.   
12         8 8888          ` 8888     ,88'   8 8888   `8b.     8888     ,88'  8 8888         8 8888          .8'    `8.`8888.  
13         8 8888             `8888888P'     8 8888     `88.    `8888888P'    8 888888888888 8 888888888888 .8'      `8.`8888. 
14 
15 
16 Hello 
17 I am Forceex,
18 Global One line AutoPool Smart contract.
19 
20 */
21 
22 pragma solidity 0.5.11;
23 
24 contract Forceex {
25     address public ownerWallet;
26     struct Variables {
27         uint currUserID          ;
28         uint pool1currUserID     ;
29         uint pool2currUserID     ;
30         uint pool3currUserID     ;
31         uint pool4currUserID     ;
32         uint pool5currUserID     ;
33         uint pool6currUserID     ;
34         uint pool7currUserID     ;
35         uint pool8currUserID     ;
36         uint pool9currUserID     ;
37         uint pool10currUserID    ;
38         uint pool11currUserID    ;
39         uint pool12currUserID    ;
40     }
41     struct Variables2 {
42         uint pool1activeUserID   ;
43         uint pool2activeUserID   ;
44         uint pool3activeUserID   ;
45         uint pool4activeUserID   ;
46         uint pool5activeUserID   ;
47         uint pool6activeUserID   ;
48         uint pool7activeUserID   ;
49         uint pool8activeUserID   ;
50         uint pool9activeUserID   ;
51         uint pool10activeUserID  ;
52         uint pool11activeUserID  ;
53         uint pool12activeUserID  ;
54     }
55     Variables public vars;
56     Variables2 public vars2;
57 
58     struct UserStruct {
59         bool isExist;
60         uint id;
61         uint referrerID;
62         uint referredUsers;
63         mapping(uint => uint) levelExpired;
64     }
65     
66     struct PoolUserStruct {
67         bool isExist;
68         uint id;
69         uint payment_received; 
70     }
71     
72     mapping (address => UserStruct) public users;
73     mapping (uint => address) public userList;
74     
75     mapping (address => PoolUserStruct) public pool1users;
76     mapping (uint => address) public pool1userList;
77     
78     mapping (address => PoolUserStruct) public pool2users;
79     mapping (uint => address) public pool2userList;
80     
81     mapping (address => PoolUserStruct) public pool3users;
82     mapping (uint => address) public pool3userList;
83     
84     mapping (address => PoolUserStruct) public pool4users;
85     mapping (uint => address) public pool4userList;
86     
87     mapping (address => PoolUserStruct) public pool5users;
88     mapping (uint => address) public pool5userList;
89     
90     mapping (address => PoolUserStruct) public pool6users;
91     mapping (uint => address) public pool6userList;
92     
93     mapping (address => PoolUserStruct) public pool7users;
94     mapping (uint => address) public pool7userList;
95     
96     mapping (address => PoolUserStruct) public pool8users;
97     mapping (uint => address) public pool8userList;
98     
99     mapping (address => PoolUserStruct) public pool9users;
100     mapping (uint => address) public pool9userList;
101     
102     mapping (address => PoolUserStruct) public pool10users;
103     mapping (uint => address) public pool10userList;
104     
105     mapping (address => PoolUserStruct) public pool11users;
106     mapping (uint => address) public pool11userList;
107     
108     mapping (address => PoolUserStruct) public pool12users;
109     mapping (uint => address) public pool12userList;
110      
111     mapping(uint => uint) public LEVEL_PRICE;
112     
113     uint public unlimited_level_price   = 0;
114     
115     uint REGESTRATION_FESS      =   0.10    ether;
116     
117     uint pool1_price            =   0.10    ether;
118     uint pool2_price            =   0.30    ether;
119     uint pool3_price            =   0.70    ether;
120     uint pool4_price            =   1.00    ether;
121     uint pool5_price            =   2.00    ether;
122     uint pool6_price            =   3.00    ether;
123     uint pool7_price            =   5.00    ether;
124     uint pool8_price            =   10.00   ether;
125     uint pool9_price            =   15.00   ether;
126     uint pool10_price           =   25.00   ether;
127     uint pool11_price           =   35.00   ether;
128     uint pool12_price           =   60.00   ether;
129    
130     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
131     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
132     event regPoolEntry(address indexed _user,uint _level,   uint _time);
133     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
134     event getMoneyForPoolEvent(address indexed _user, address indexed _referral,uint _level, uint _time);
135     
136     UserStruct[] public requests;
137     uint public totalEarned = 0;
138      
139     constructor() public {
140         ownerWallet = msg.sender;
141 
142         LEVEL_PRICE[1] = 0.040 ether;   
143         LEVEL_PRICE[2] = 0.006 ether;   
144         LEVEL_PRICE[3] = 0.004 ether;   
145         LEVEL_PRICE[4] = 0.00222 ether;   
146         unlimited_level_price=0.00222 ether;   
147 
148         UserStruct memory userStruct;
149         vars.currUserID++;
150 
151         userStruct = UserStruct({
152             isExist: true,
153             id: vars.currUserID,
154             referrerID: 0,
155             referredUsers:0
156            
157         });
158         
159         users[ownerWallet] = userStruct;
160         userList[vars.currUserID] = ownerWallet;
161        
162        
163         PoolUserStruct memory pooluserStruct;
164         
165         vars.pool1currUserID++;
166         pooluserStruct = PoolUserStruct({
167             isExist:true,
168             id:vars.pool1currUserID,
169             payment_received:0
170         });
171         vars2.pool1activeUserID=vars.pool1currUserID;
172         pool1users[msg.sender] = pooluserStruct;
173         pool1userList[vars.pool1currUserID]=msg.sender;
174 
175         vars.pool2currUserID++;
176         pooluserStruct = PoolUserStruct({
177             isExist:true,
178             id:vars.pool2currUserID,
179             payment_received:0
180         });
181         vars2.pool2activeUserID=vars.pool2currUserID;
182         pool2users[msg.sender] = pooluserStruct;
183         pool2userList[vars.pool2currUserID]=msg.sender;
184        
185         vars.pool3currUserID++;
186         pooluserStruct = PoolUserStruct({
187             isExist:true,
188             id:vars.pool3currUserID,
189             payment_received:0
190         });
191         vars2.pool3activeUserID=vars.pool3currUserID;
192         pool3users[msg.sender] = pooluserStruct;
193         pool3userList[vars.pool3currUserID]=msg.sender;
194        
195         vars.pool4currUserID++;
196         pooluserStruct = PoolUserStruct({
197             isExist:true,
198             id:vars.pool4currUserID,
199             payment_received:0
200         });
201         vars2.pool4activeUserID=vars.pool4currUserID;
202         pool4users[msg.sender] = pooluserStruct;
203         pool4userList[vars.pool4currUserID]=msg.sender;
204 
205         vars.pool5currUserID++;
206         pooluserStruct = PoolUserStruct({
207             isExist:true,
208             id:vars.pool5currUserID,
209             payment_received:0
210         });
211         vars2.pool5activeUserID=vars.pool5currUserID;
212         pool5users[msg.sender] = pooluserStruct;
213         pool5userList[vars.pool5currUserID]=msg.sender;
214 
215         vars.pool6currUserID++;
216         pooluserStruct = PoolUserStruct({
217             isExist:true,
218             id:vars.pool6currUserID,
219             payment_received:0
220         });
221         vars2.pool6activeUserID=vars.pool6currUserID;
222         pool6users[msg.sender] = pooluserStruct;
223         pool6userList[vars.pool6currUserID]=msg.sender;
224        
225         vars.pool7currUserID++;
226         pooluserStruct = PoolUserStruct({
227             isExist:true,
228             id:vars.pool7currUserID,
229             payment_received:0
230         });
231         vars2.pool7activeUserID=vars.pool7currUserID;
232         pool7users[msg.sender] = pooluserStruct;
233         pool7userList[vars.pool7currUserID]=msg.sender;
234        
235         vars.pool8currUserID++;
236         pooluserStruct = PoolUserStruct({
237             isExist:true,
238             id:vars.pool8currUserID,
239             payment_received:0
240         });
241         vars2.pool8activeUserID=vars.pool8currUserID;
242         pool8users[msg.sender] = pooluserStruct;
243         pool8userList[vars.pool8currUserID]=msg.sender;
244        
245         vars.pool9currUserID++;
246         pooluserStruct = PoolUserStruct({
247             isExist:true,
248             id:vars.pool9currUserID,
249             payment_received:0
250         });
251         vars2.pool9activeUserID=vars.pool9currUserID;
252         pool9users[msg.sender] = pooluserStruct;
253         pool9userList[vars.pool9currUserID]=msg.sender;
254        
255         vars.pool10currUserID++;
256         pooluserStruct = PoolUserStruct({
257             isExist:true,
258             id:vars.pool10currUserID,
259             payment_received:0
260         });
261         vars2.pool10activeUserID=vars.pool10currUserID;
262         pool10users[msg.sender] = pooluserStruct;
263         pool10userList[vars.pool10currUserID]=msg.sender;
264         
265         vars.pool11currUserID++;
266         pooluserStruct = PoolUserStruct({
267             isExist:true,
268             id:vars.pool11currUserID,
269             payment_received:0
270         });
271         vars2.pool11activeUserID=vars.pool11currUserID;
272         pool11users[msg.sender] = pooluserStruct;
273         pool11userList[vars.pool11currUserID]=msg.sender;
274         
275         vars.pool12currUserID++;
276         pooluserStruct = PoolUserStruct({
277             isExist:true,
278             id:vars.pool12currUserID,
279             payment_received:0
280         });
281         vars2.pool12activeUserID=vars.pool12currUserID;
282         pool12users[msg.sender] = pooluserStruct;
283         pool12userList[vars.pool12currUserID]=msg.sender;
284        
285        
286     }
287      
288     function regUser(uint _referrerID) public payable {
289        
290         require(!users[msg.sender].isExist, "User Exists");
291         require(_referrerID > 0 && _referrerID <= vars.currUserID, 'Incorrect referral ID');
292         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
293        
294         UserStruct memory userStruct;
295         vars.currUserID++;
296 
297         userStruct = UserStruct({
298             isExist: true,
299             id: vars.currUserID,
300             referrerID: _referrerID,
301             referredUsers:0
302         });
303    
304         users[msg.sender] = userStruct;
305         userList[vars.currUserID]=msg.sender;
306        
307         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
308         
309         payReferral(1,msg.sender);
310         emit regLevelEvent(msg.sender, userList[_referrerID], now);
311         
312     }
313 
314     function payReferral(uint _level, address _user) internal {
315         address referer;
316        
317         referer = userList[users[_user].referrerID];
318         bool sent = false;
319        
320         uint level_price_local=0;
321         if(_level>4){
322             level_price_local=unlimited_level_price;
323         }
324         else{
325             level_price_local=LEVEL_PRICE[_level];
326         }
327         sent = address(uint160(referer)).send(level_price_local);
328 
329         if (sent) {
330             totalEarned += level_price_local;
331             emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
332             if(_level <= 20 && users[referer].referrerID >= 1){
333                 payReferral(_level+1,referer);
334             }
335             else
336             {
337                 sendBalance();
338             }
339            
340         }
341        
342         if(!sent) {
343             payReferral(_level, referer);
344         }
345      }
346     
347     function buyPool(uint poolNumber) public payable{
348         require(users[msg.sender].isExist, "User Not Registered");
349         
350         bool isinpool = isInPool(poolNumber,msg.sender);
351         require(!isinpool, "Already in AutoPool");
352         
353         require(poolNumber>=1,"Pool number <0");
354         require(poolNumber<=12,"Pool number >12");
355         
356         bool isPriceValid = checkPrice(poolNumber,msg.value);
357         require(isPriceValid,"Price of Pool is Wrong");
358         
359         PoolUserStruct memory userStruct;
360         address poolCurrentuser=getPoolCurrentUser(poolNumber);
361         increasePoolCurrentUserID(poolNumber);
362         
363         userStruct = PoolUserStruct({
364             isExist:true,
365             id:getPoolCurrentUserID(poolNumber),
366             payment_received:0
367         });
368         assignPoolUser(poolNumber,msg.sender,userStruct.id,userStruct);
369         uint pool_price = getPoolPrice(poolNumber);
370         
371         bool sent = false;
372         //direct fee for referer (15%)
373         uint fee = (pool_price * 15) / 100;
374         address referer;
375         referer = userList[users[msg.sender].referrerID];
376         
377         uint poolshare = pool_price - fee;
378         
379         if (address(uint160(referer)).send(fee))
380             sent = address(uint160(poolCurrentuser)).send(poolshare);
381         
382         if (sent) {
383             totalEarned += poolshare;
384             increasePoolPaymentReceive(poolNumber,poolCurrentuser);
385             if(getPoolPaymentReceive(poolNumber,poolCurrentuser)>=getPoolPaymentNumber(poolNumber))
386             {
387                 increasePoolActiveUserID(poolNumber);
388             }
389             emit getMoneyForPoolEvent(referer, msg.sender,poolNumber, now);
390             emit getPoolPayment(msg.sender,poolCurrentuser, poolNumber, now);
391             emit regPoolEntry(msg.sender, poolNumber, now);
392         }
393         
394     }
395     function getPoolPaymentNumber(uint _poolNumber) internal pure returns (uint){
396         if (_poolNumber ==1)
397             return 2;
398         else if ((_poolNumber > 1) && (_poolNumber <=5))
399             return 3;
400         else if ((_poolNumber > 5) && (_poolNumber <=9))
401             return 4;
402         else if (_poolNumber >9)
403             return 5; 
404         
405         return 0;
406     }
407     
408     function isInPool(uint _poolNumber,address _PoolMember) internal view returns (bool){
409         if (_poolNumber == 1)
410             return pool1users[_PoolMember].isExist;
411         else if (_poolNumber == 2)
412             return pool2users[_PoolMember].isExist;
413         else if (_poolNumber == 3)
414             return pool3users[_PoolMember].isExist;
415         else if (_poolNumber == 4)
416             return pool4users[_PoolMember].isExist;
417         else if (_poolNumber == 5)
418             return pool5users[_PoolMember].isExist;
419         else if (_poolNumber == 6)
420             return pool6users[_PoolMember].isExist;
421         else if (_poolNumber == 7)
422             return pool7users[_PoolMember].isExist;
423         else if (_poolNumber == 8)
424             return pool8users[_PoolMember].isExist;
425         else if (_poolNumber == 9)
426             return pool9users[_PoolMember].isExist;
427         else if (_poolNumber == 10)
428             return pool10users[_PoolMember].isExist;
429         else if (_poolNumber == 11)
430             return pool11users[_PoolMember].isExist;
431         else if (_poolNumber == 12)
432             return pool12users[_PoolMember].isExist;
433         
434         return true;
435     }
436     
437     function checkPrice(uint _poolNumber,uint256 Amount) internal view returns (bool){
438         bool ret = false;
439         
440         if ((_poolNumber == 1)&&(Amount ==pool1_price))
441             ret = true;
442         else if ((_poolNumber == 2)&&(Amount ==pool2_price))
443             ret = true;
444         else if ((_poolNumber == 3)&&(Amount ==pool3_price))
445             ret = true;
446         else if ((_poolNumber == 4)&&(Amount ==pool4_price))
447             ret = true;
448         else if ((_poolNumber == 5)&&(Amount ==pool5_price))
449             ret = true;
450         else if ((_poolNumber == 6)&&(Amount ==pool6_price))
451             ret = true;
452         else if ((_poolNumber == 7)&&(Amount ==pool7_price))
453             ret = true;
454         else if ((_poolNumber == 8)&&(Amount ==pool8_price))
455             ret = true;
456         else if ((_poolNumber == 9)&&(Amount ==pool9_price))
457             ret = true;
458         else if ((_poolNumber == 10)&&(Amount ==pool10_price))
459             ret = true;
460         else if ((_poolNumber == 11)&&(Amount ==pool11_price))
461             ret = true;
462         else if ((_poolNumber == 12)&&(Amount ==pool12_price))
463             ret = true;
464             
465         return ret;
466     }
467     
468     function getPoolCurrentUser(uint _poolNumber) internal view returns (address){
469         if (_poolNumber == 1)
470             return pool1userList[vars2.pool1activeUserID];
471         else if (_poolNumber == 2)
472             return pool2userList[vars2.pool2activeUserID];
473         else if (_poolNumber == 3)
474             return pool3userList[vars2.pool3activeUserID];
475         else if (_poolNumber == 4)
476             return pool4userList[vars2.pool4activeUserID];
477         else if (_poolNumber == 5)
478             return pool5userList[vars2.pool5activeUserID];
479         else if (_poolNumber == 6)
480             return pool6userList[vars2.pool6activeUserID];
481         else if (_poolNumber == 7)
482             return pool7userList[vars2.pool7activeUserID];
483         else if (_poolNumber == 8)
484             return pool8userList[vars2.pool8activeUserID];
485         else if (_poolNumber == 9)
486             return pool9userList[vars2.pool9activeUserID];
487         else if (_poolNumber == 10)
488             return pool10userList[vars2.pool10activeUserID];
489         else if (_poolNumber == 11)
490             return pool11userList[vars2.pool11activeUserID];
491         else if (_poolNumber == 12)
492             return pool12userList[vars2.pool12activeUserID];
493         
494         return address(0);
495     }
496     
497     function increasePoolCurrentUserID(uint _poolNumber) internal {
498        if (_poolNumber == 1)
499             vars.pool1currUserID++;
500         else if (_poolNumber == 2)
501             vars.pool2currUserID++;
502         else if (_poolNumber == 3)
503             vars.pool3currUserID++;
504         else if (_poolNumber == 4)
505             vars.pool4currUserID++;
506         else if (_poolNumber == 5)
507             vars.pool5currUserID++;
508         else if (_poolNumber == 6)
509             vars.pool6currUserID++;
510         else if (_poolNumber == 7)
511             vars.pool7currUserID++;
512         else if (_poolNumber == 8)
513             vars.pool8currUserID++;
514         else if (_poolNumber == 9)
515             vars.pool9currUserID++;
516         else if (_poolNumber == 10)
517             vars.pool10currUserID++;
518         else if (_poolNumber == 11)
519             vars.pool11currUserID++;
520         else if (_poolNumber == 12)
521             vars.pool12currUserID++;
522     }
523     
524     function getPoolCurrentUserID(uint _poolNumber) internal view returns (uint){
525         if (_poolNumber == 1)
526             return vars.pool1currUserID;
527         else if (_poolNumber == 2)
528             return vars.pool2currUserID;
529         else if (_poolNumber == 3)
530             return vars.pool3currUserID;
531         else if (_poolNumber == 4)
532             return vars.pool4currUserID;
533         else if (_poolNumber == 5)
534             return vars.pool5currUserID;
535         else if (_poolNumber == 6)
536             return vars.pool6currUserID;
537         else if (_poolNumber == 7)
538             return vars.pool7currUserID;
539         else if (_poolNumber == 8)
540             return vars.pool8currUserID;
541         else if (_poolNumber == 9)
542             return vars.pool9currUserID;
543         else if (_poolNumber == 10)
544             return vars.pool10currUserID;
545         else if (_poolNumber == 11)
546             return vars.pool11currUserID;
547         else if (_poolNumber == 12)
548             return vars.pool12currUserID;
549         
550         return 0;
551     }
552     
553     function assignPoolUser(uint _poolNumber,address newPoolMember,uint poolCurrentUserID,PoolUserStruct memory userStruct) internal {
554         if (_poolNumber == 1){
555             pool1users[newPoolMember] = userStruct;
556             pool1userList[poolCurrentUserID]=newPoolMember;
557         }
558         else if (_poolNumber == 2){
559             pool2users[newPoolMember] = userStruct;
560             pool2userList[poolCurrentUserID]=newPoolMember;
561         }
562         else if (_poolNumber == 3){
563             pool3users[newPoolMember] = userStruct;
564             pool3userList[poolCurrentUserID]=newPoolMember;
565         }
566         else if (_poolNumber == 4){
567             pool4users[newPoolMember] = userStruct;
568             pool4userList[poolCurrentUserID]=newPoolMember;
569         }
570         else if (_poolNumber == 5){
571             pool5users[newPoolMember] = userStruct;
572             pool5userList[poolCurrentUserID]=newPoolMember;
573         }
574         else if (_poolNumber == 6){
575             pool6users[newPoolMember] = userStruct;
576             pool6userList[poolCurrentUserID]=newPoolMember;
577         }
578         else if (_poolNumber == 7){
579             pool7users[newPoolMember] = userStruct;
580             pool7userList[poolCurrentUserID]=newPoolMember;
581         }
582         else if (_poolNumber == 8){
583             pool8users[newPoolMember] = userStruct;
584             pool8userList[poolCurrentUserID]=newPoolMember;
585         }
586         else if (_poolNumber == 9){
587             pool9users[newPoolMember] = userStruct;
588             pool9userList[poolCurrentUserID]=newPoolMember;
589         }
590         else if (_poolNumber == 10){
591             pool10users[newPoolMember] = userStruct;
592             pool10userList[poolCurrentUserID]=newPoolMember;
593         }
594         else if (_poolNumber == 11){
595             pool11users[newPoolMember] = userStruct;
596             pool11userList[poolCurrentUserID]=newPoolMember;
597         }
598         else if (_poolNumber == 12){
599             pool12users[newPoolMember] = userStruct;
600             pool12userList[poolCurrentUserID]=newPoolMember;
601         }
602     }
603     
604     function getPoolPrice(uint _poolNumber) internal view returns (uint){
605         if (_poolNumber == 1)
606             return pool1_price;
607         else if (_poolNumber == 2)
608             return pool2_price;
609         else if (_poolNumber == 3)
610             return pool3_price;
611         else if (_poolNumber == 4)
612             return pool4_price;
613         else if (_poolNumber == 5)
614             return pool5_price;
615         else if (_poolNumber == 6)
616             return pool6_price;
617         else if (_poolNumber == 7)
618             return pool7_price;
619         else if (_poolNumber == 8)
620             return pool8_price;
621         else if (_poolNumber == 9)
622             return pool9_price;
623         else if (_poolNumber == 10)
624             return pool10_price;
625         else if (_poolNumber == 11)
626             return pool11_price;
627         else if (_poolNumber == 12)
628             return pool12_price;
629         
630         return 0;
631     }
632     
633     function increasePoolPaymentReceive(uint _poolNumber, address CurrentUser) internal {
634         if (_poolNumber == 1)
635             pool1users[CurrentUser].payment_received+=1;
636         else if (_poolNumber == 2)
637             pool2users[CurrentUser].payment_received+=1;
638         else if (_poolNumber == 3)
639             pool3users[CurrentUser].payment_received+=1;
640         else if (_poolNumber == 4)
641             pool4users[CurrentUser].payment_received+=1;
642         else if (_poolNumber == 5)
643             pool5users[CurrentUser].payment_received+=1;
644         else if (_poolNumber == 6)
645             pool6users[CurrentUser].payment_received+=1;
646         else if (_poolNumber == 7)
647             pool7users[CurrentUser].payment_received+=1;
648         else if (_poolNumber == 8)
649             pool8users[CurrentUser].payment_received+=1;
650         else if (_poolNumber == 9)
651             pool9users[CurrentUser].payment_received+=1;
652         else if (_poolNumber == 10)
653             pool10users[CurrentUser].payment_received+=1;
654         else if (_poolNumber == 11)
655             pool11users[CurrentUser].payment_received+=1;
656         else if (_poolNumber == 12)
657             pool12users[CurrentUser].payment_received+=1;
658     }
659     
660     function getPoolPaymentReceive(uint _poolNumber, address CurrentUser) internal view returns(uint){
661         if (_poolNumber == 1)
662             return pool1users[CurrentUser].payment_received;
663         else if (_poolNumber == 2)
664             return pool2users[CurrentUser].payment_received;
665         else if (_poolNumber == 3)
666             return pool3users[CurrentUser].payment_received;
667         else if (_poolNumber == 4)
668             return pool4users[CurrentUser].payment_received;
669         else if (_poolNumber == 5)
670             return pool5users[CurrentUser].payment_received;
671         else if (_poolNumber == 6)
672             return pool6users[CurrentUser].payment_received;
673         else if (_poolNumber == 7)
674             return pool7users[CurrentUser].payment_received;
675         else if (_poolNumber == 8)
676             return pool8users[CurrentUser].payment_received;
677         else if (_poolNumber == 9)
678             return pool9users[CurrentUser].payment_received;
679         else if (_poolNumber == 10)
680             return pool10users[CurrentUser].payment_received;
681         else if (_poolNumber == 11)
682             return pool11users[CurrentUser].payment_received;
683         else if (_poolNumber == 12)
684             return pool12users[CurrentUser].payment_received;
685     }
686     
687     function increasePoolActiveUserID(uint _poolNumber) internal {
688         if (_poolNumber == 1)
689             vars2.pool1activeUserID+=1;
690         else if (_poolNumber == 2)
691             vars2.pool2activeUserID+=1;
692         else if (_poolNumber == 3)
693             vars2.pool3activeUserID+=1;
694         else if (_poolNumber == 4)
695             vars2.pool4activeUserID+=1;
696         else if (_poolNumber == 5)
697             vars2.pool5activeUserID+=1;
698         else if (_poolNumber == 6)
699             vars2.pool6activeUserID+=1;
700         else if (_poolNumber == 7)
701             vars2.pool7activeUserID+=1;
702         else if (_poolNumber == 8)
703             vars2.pool8activeUserID+=1;
704         else if (_poolNumber == 9)
705             vars2.pool9activeUserID+=1;
706         else if (_poolNumber == 10)
707             vars2.pool10activeUserID+=1;
708         else if (_poolNumber == 11)
709             vars2.pool11activeUserID+=1;
710         else if (_poolNumber == 12)
711             vars2.pool12activeUserID+=1;
712     }
713     
714     function getEthBalance() public view returns(uint) {
715     return address(this).balance;
716     }
717     
718     function sendBalance() private
719     {
720          if (!address(uint160(ownerWallet)).send(getEthBalance()))
721          {
722              
723          }
724     }
725    
726    
727 }