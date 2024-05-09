1 /*
2 
3 .########.........########..##.......##.....##..######.
4 .##...............##.....##.##.......##.....##.##....##
5 .##...............##.....##.##.......##.....##.##......
6 .######...#######.########..##.......##.....##..######.
7 .##...............##........##.......##.....##.......##
8 .##...............##........##.......##.....##.##....##
9 .########.........##........########..#######...######.
10 
11 */
12 pragma solidity 0.5.11;
13 
14 contract eeplus {
15      address public ownerWallet;
16       uint public currUserID = 0;
17       uint public pool1currUserID = 0;
18       uint public pool2currUserID = 0;
19       uint public pool3currUserID = 0;
20       uint public pool4currUserID = 0;
21       uint public pool5currUserID = 0;
22       uint public pool6currUserID = 0; 
23       
24       uint public pool1activeUserID = 0;
25       uint public pool2activeUserID = 0;
26       uint public pool3activeUserID = 0;
27       uint public pool4activeUserID = 0;
28       uint public pool5activeUserID = 0;
29       uint public pool6activeUserID = 0; 
30       
31        
32      
33       struct UserStruct {
34         bool isExist;
35         uint id;
36         uint referrerID;
37        uint referredUsers;
38         mapping(uint => uint) levelExpired;
39     }
40     
41      struct PoolUserStruct {
42         bool isExist;
43         uint id;
44        uint payment_received; 
45     }
46     
47      mapping (address => UserStruct) public users;
48      mapping (uint => address) public userList;
49      
50      mapping (address => PoolUserStruct) public pool1users;
51      mapping (uint => address) public pool1userList;
52      
53      mapping (address => PoolUserStruct) public pool2users;
54      mapping (uint => address) public pool2userList;
55      
56      mapping (address => PoolUserStruct) public pool3users;
57      mapping (uint => address) public pool3userList;
58      
59      mapping (address => PoolUserStruct) public pool4users;
60      mapping (uint => address) public pool4userList;
61      
62      mapping (address => PoolUserStruct) public pool5users;
63      mapping (uint => address) public pool5userList;
64      
65      mapping (address => PoolUserStruct) public pool6users;
66      mapping (uint => address) public pool6userList; 
67      
68     mapping(uint => uint) public LEVEL_PRICE;
69     
70    uint REGESTRATION_FESS=0.05 ether;
71    uint pool1_price=0.025 ether;
72    uint pool2_price=0.05 ether ;
73    uint pool3_price=0.1 ether;
74    uint pool4_price=0.2 ether;
75    uint pool5_price=0.8 ether;
76    uint pool6_price=1.6 ether; 
77    
78     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
79     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
80     event getMoneyForSplEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
81     event regPoolEntry(address indexed _user,uint _level,   uint _time);
82     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
83     event getReInvestPoolPayment(address indexed _user, uint _level, uint _time);
84    
85     UserStruct[] public requests;
86     uint public totalEarned = 0;
87      
88     constructor() public {
89         ownerWallet = msg.sender;
90 
91  
92        
93 
94         UserStruct memory userStruct;
95         currUserID++;
96 
97         userStruct = UserStruct({
98             isExist: true,
99             id: currUserID,
100             referrerID: 0,
101             referredUsers:0
102            
103         });
104         
105         users[ownerWallet] = userStruct;
106         userList[currUserID] = ownerWallet;
107        
108        
109         PoolUserStruct memory pooluserStruct;
110         
111         pool1currUserID++;
112 
113         pooluserStruct = PoolUserStruct({
114             isExist:true,
115             id:pool1currUserID,
116             payment_received:0
117         });
118         pool1activeUserID=pool1currUserID;
119         pool1users[msg.sender] = pooluserStruct;
120         pool1userList[pool1currUserID]=msg.sender;
121       
122         
123         pool2currUserID++;
124         pooluserStruct = PoolUserStruct({
125             isExist:true,
126             id:pool2currUserID,
127             payment_received:0
128         });
129         pool2activeUserID=pool2currUserID;
130         pool2users[msg.sender] = pooluserStruct;
131         pool2userList[pool2currUserID]=msg.sender;
132        
133        
134         pool3currUserID++;
135         pooluserStruct = PoolUserStruct({
136             isExist:true,
137             id:pool3currUserID,
138             payment_received:0
139         });
140         pool3activeUserID=pool3currUserID;
141         pool3users[msg.sender] = pooluserStruct;
142         pool3userList[pool3currUserID]=msg.sender;
143        
144        
145         pool4currUserID++;
146         pooluserStruct = PoolUserStruct({
147             isExist:true,
148             id:pool4currUserID,
149             payment_received:0
150         });
151         pool4activeUserID=pool4currUserID;
152        pool4users[msg.sender] = pooluserStruct;
153        pool4userList[pool4currUserID]=msg.sender;
154 
155         
156         pool5currUserID++;
157         pooluserStruct = PoolUserStruct({
158             isExist:true,
159             id:pool5currUserID,
160             payment_received:0
161         });
162         pool5activeUserID=pool5currUserID;
163         pool5users[msg.sender] = pooluserStruct;
164         pool5userList[pool5currUserID]=msg.sender;
165        
166        
167         pool6currUserID++;
168         pooluserStruct = PoolUserStruct({
169             isExist:true,
170             id:pool6currUserID,
171             payment_received:0
172         });
173         pool6activeUserID=pool6currUserID;
174         pool6users[msg.sender] = pooluserStruct;
175         pool6userList[pool6currUserID]=msg.sender;
176        
177       
178        
179        
180       }
181      
182     function regUser(uint _referrerID) public payable {
183        
184         require(!users[msg.sender].isExist, "User Exists");
185         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
186         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
187        
188         UserStruct memory userStruct;
189         currUserID++;
190 
191         userStruct = UserStruct({
192             isExist: true,
193             id: currUserID,
194             referrerID: _referrerID,
195             referredUsers:0
196         });
197    
198     
199        users[msg.sender] = userStruct;
200        userList[currUserID]=msg.sender;
201        
202         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
203         
204        payReferral(1,msg.sender);
205         emit regLevelEvent(msg.sender, userList[_referrerID], now);
206     }
207 
208     function payReferral(uint _level, address _user) internal {
209         address referer;
210        
211         referer = userList[users[_user].referrerID];
212         bool sent = false;
213         uint level_price_local=0;
214       if(users[userList[users[_user].referrerID]].referredUsers  % 4 == 0 ) 
215       {
216           
217           level_price_local=0.05 ether; 
218           sent = address(uint160(referer)).send(level_price_local); 
219        
220        
221              if (sent) {
222                 totalEarned += level_price_local;
223                 emit getMoneyForSplEvent(referer, msg.sender, _level, now);
224                  
225                
226             }
227       }
228       else
229       {
230            level_price_local=0.025 ether;
231           
232           sent = address(uint160(referer)).send(level_price_local); 
233        
234        
235          
236 
237             if (sent) {
238                 totalEarned += level_price_local;
239                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
240                  
241                
242             }
243       }
244        
245        
246        
247          
248      }
249      
250      function reInvest( address _user, uint _level) internal {
251          
252 if(_level==1)
253 {
254 PoolUserStruct memory userStruct;
255 address pool1Currentuser=pool1userList[pool1activeUserID];
256 pool1currUserID++;
257 userStruct = PoolUserStruct({
258 isExist:true,
259 id:pool1currUserID,
260 payment_received:0
261 });
262 pool1users[_user] = userStruct;
263 pool1userList[pool1currUserID]=_user;
264 emit getReInvestPoolPayment(_user, _level, now);
265 }
266 else if(_level==2)
267 {
268 PoolUserStruct memory userStruct;
269 address pool2Currentuser=pool2userList[pool2activeUserID];
270 pool2currUserID++;
271 userStruct = PoolUserStruct({
272 isExist:true,
273 id:pool2currUserID,
274 payment_received:0
275 });
276 pool2users[_user] = userStruct;
277 pool2userList[pool2currUserID]=_user;
278 emit getReInvestPoolPayment(_user, _level, now);
279 }
280 else if(_level==3)
281 {
282 PoolUserStruct memory userStruct;
283 address pool3Currentuser=pool3userList[pool3activeUserID];
284 pool3currUserID++;
285 userStruct = PoolUserStruct({
286 isExist:true,
287 id:pool3currUserID,
288 payment_received:0
289 });
290 pool3users[_user] = userStruct;
291 pool3userList[pool3currUserID]=_user;
292 emit getReInvestPoolPayment(_user, _level, now);
293 }
294 else if(_level==4)
295 {
296 PoolUserStruct memory userStruct;
297 address pool4Currentuser=pool4userList[pool4activeUserID];
298 pool4currUserID++;
299 userStruct = PoolUserStruct({
300 isExist:true,
301 id:pool4currUserID,
302 payment_received:0
303 });
304 pool4users[_user] = userStruct;
305 pool4userList[pool4currUserID]=_user;
306 emit getReInvestPoolPayment(_user, _level, now);
307 }
308 else if(_level==5)
309 {
310 PoolUserStruct memory userStruct;
311 address pool5Currentuser=pool5userList[pool5activeUserID];
312 pool5currUserID++;
313 userStruct = PoolUserStruct({
314 isExist:true,
315 id:pool5currUserID,
316 payment_received:0
317 });
318 pool5users[_user] = userStruct;
319 pool5userList[pool5currUserID]=_user;
320 emit getReInvestPoolPayment(_user, _level, now);
321 }
322 else if(_level==6)
323 {
324 PoolUserStruct memory userStruct;
325 address pool6Currentuser=pool6userList[pool6activeUserID];
326 pool6currUserID++;
327 userStruct = PoolUserStruct({
328 isExist:true,
329 id:pool6currUserID,
330 payment_received:0
331 });
332 pool6users[_user] = userStruct;
333 pool6userList[pool6currUserID]=_user;
334 emit getReInvestPoolPayment(_user, _level, now);
335 }
336       
337          
338      }
339 
340     function buyPool1() public payable {
341         require(users[msg.sender].isExist, "User Not Registered");
342         require(!pool1users[msg.sender].isExist, "Already in AutoPool");
343       
344         require(msg.value == pool1_price, 'Incorrect Value');
345         
346        
347         PoolUserStruct memory userStruct;
348         address pool1Currentuser=pool1userList[pool1activeUserID];
349         
350         pool1currUserID++;
351 
352         userStruct = PoolUserStruct({
353             isExist:true,
354             id:pool1currUserID,
355             payment_received:0
356         });
357    
358        pool1users[msg.sender] = userStruct;
359        pool1userList[pool1currUserID]=msg.sender;
360        bool sent = false;
361       
362        uint poolshare = pool1_price;
363         
364             sent = address(uint160(pool1Currentuser)).send(poolshare);
365 
366         if (sent) {
367             totalEarned += poolshare;
368             pool1users[pool1Currentuser].payment_received+=1;
369             if(pool1users[pool1Currentuser].payment_received>=3)
370             {
371                 pool1activeUserID+=1;
372                 reInvest(pool1Currentuser,1);
373 
374             }
375             emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
376         }
377        emit regPoolEntry(msg.sender, 1, now);
378     }
379 
380 
381     function buyPool2() public payable {
382         require(users[msg.sender].isExist, "User Not Registered");
383         require(!pool2users[msg.sender].isExist, "Already in AutoPool");
384         require(msg.value == pool2_price, 'Incorrect Value');
385          
386         PoolUserStruct memory userStruct;
387         address pool2Currentuser=pool2userList[pool2activeUserID];
388         
389         pool2currUserID++;
390         userStruct = PoolUserStruct({
391             isExist:true,
392             id:pool2currUserID,
393             payment_received:0
394         });
395        pool2users[msg.sender] = userStruct;
396        pool2userList[pool2currUserID]=msg.sender;
397        
398        
399        
400        bool sent = false;
401        
402        uint poolshare = pool2_price;
403      
404             sent = address(uint160(pool2Currentuser)).send(poolshare);
405 
406             if (sent) {
407                 totalEarned += poolshare;
408                 pool2users[pool2Currentuser].payment_received+=1;
409                 if(pool2users[pool2Currentuser].payment_received>=3)
410                 {
411                     pool2activeUserID+=1;
412                     
413                 reInvest(pool2Currentuser,2);
414                 }
415                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
416             }
417             emit regPoolEntry(msg.sender,2,  now);
418     }
419     
420     function buyPool3() public payable {
421         require(users[msg.sender].isExist, "User Not Registered");
422         require(!pool3users[msg.sender].isExist, "Already in AutoPool");
423         require(msg.value == pool3_price, 'Incorrect Value');
424         
425         PoolUserStruct memory userStruct;
426         address pool3Currentuser=pool3userList[pool3activeUserID];
427         
428         pool3currUserID++;
429         userStruct = PoolUserStruct({
430             isExist:true,
431             id:pool3currUserID,
432             payment_received:0
433         });
434        pool3users[msg.sender] = userStruct;
435        pool3userList[pool3currUserID]=msg.sender;
436        bool sent = false;
437        uint poolshare = pool3_price;
438       
439             sent = address(uint160(pool3Currentuser)).send(poolshare);
440 
441             if (sent) {
442                 totalEarned += poolshare;
443                 pool3users[pool3Currentuser].payment_received+=1;
444                 if(pool3users[pool3Currentuser].payment_received>=3)
445                 {
446                     pool3activeUserID+=1;
447                     
448                 reInvest(pool3Currentuser,3);
449                 }
450                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
451             }
452         emit regPoolEntry(msg.sender,3,  now);
453     }
454 
455     function buyPool4() public payable {
456         require(users[msg.sender].isExist, "User Not Registered");
457         require(!pool4users[msg.sender].isExist, "Already in AutoPool");
458         require(msg.value == pool4_price, 'Incorrect Value');
459       
460         PoolUserStruct memory userStruct;
461         address pool4Currentuser=pool4userList[pool4activeUserID];
462         
463         pool4currUserID++;
464         userStruct = PoolUserStruct({
465             isExist:true,
466             id:pool4currUserID,
467             payment_received:0
468         });
469        pool4users[msg.sender] = userStruct;
470        pool4userList[pool4currUserID]=msg.sender;
471        bool sent = false;
472       
473        uint poolshare = pool4_price ;
474       
475             sent = address(uint160(pool4Currentuser)).send(poolshare);
476 
477             if (sent) {
478                 totalEarned += poolshare;
479                 pool4users[pool4Currentuser].payment_received+=1;
480                 if(pool4users[pool4Currentuser].payment_received>=3)
481                 {
482                     pool4activeUserID+=1;
483                     
484                 reInvest(pool4Currentuser,4);
485                 }
486                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
487             }
488         emit regPoolEntry(msg.sender,4, now);
489     }
490 
491     function buyPool5() public payable {
492         require(users[msg.sender].isExist, "User Not Registered");
493         require(!pool5users[msg.sender].isExist, "Already in AutoPool");
494         require(msg.value == pool5_price, 'Incorrect Value');
495         
496         PoolUserStruct memory userStruct;
497         address pool5Currentuser=pool5userList[pool5activeUserID];
498         
499         pool5currUserID++;
500         userStruct = PoolUserStruct({
501             isExist:true,
502             id:pool5currUserID,
503             payment_received:0
504         });
505        pool5users[msg.sender] = userStruct;
506        pool5userList[pool5currUserID]=msg.sender;
507        bool sent = false;
508        
509        uint poolshare = pool5_price ;
510      
511             sent = address(uint160(pool5Currentuser)).send(poolshare);
512 
513             if (sent) {
514                 totalEarned += poolshare;
515                 pool5users[pool5Currentuser].payment_received+=1;
516                 if(pool5users[pool5Currentuser].payment_received>=3)
517                 {
518                     pool5activeUserID+=1;
519                 reInvest(pool5Currentuser,5);
520                 }
521                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
522             }
523         emit regPoolEntry(msg.sender,5,  now);
524     }
525     
526     function buyPool6() public payable {
527         require(users[msg.sender].isExist, "User Not Registered");
528         require(!pool6users[msg.sender].isExist, "Already in AutoPool");
529         require(msg.value == pool6_price, 'Incorrect Value');
530         
531         PoolUserStruct memory userStruct;
532         address pool6Currentuser=pool6userList[pool6activeUserID];
533         
534         pool6currUserID++;
535         userStruct = PoolUserStruct({
536             isExist:true,
537             id:pool6currUserID,
538             payment_received:0
539         });
540        pool6users[msg.sender] = userStruct;
541        pool6userList[pool6currUserID]=msg.sender;
542        bool sent = false;
543       
544        uint poolshare = pool6_price;
545      
546             sent = address(uint160(pool6Currentuser)).send(poolshare);
547 
548             if (sent) {
549                 totalEarned += poolshare;
550                 pool6users[pool6Currentuser].payment_received+=1;
551                 if(pool6users[pool6Currentuser].payment_received>=3)
552                 {
553                     pool6activeUserID+=1;
554                     
555                 reInvest(pool6Currentuser,6);
556                 }
557                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
558             }
559         emit regPoolEntry(msg.sender,6,  now);
560     }
561     
562      
563     function getEthBalance() public view returns(uint) {
564     return address(this).balance;
565     }
566     
567     function sendBalance() private
568     {
569          if (!address(uint160(ownerWallet)).send(getEthBalance()))
570          {
571              
572          }
573     }
574    
575    
576 }