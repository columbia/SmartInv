1 pragma solidity 0.5.11;
2 
3 contract EtherRich {
4      address public ownerWallet;
5      address payable balAdmin;
6       uint public currUserID = 0;
7       uint public pool1currUserID = 0;
8       uint public pool2currUserID = 0;
9       uint public pool3currUserID = 0;
10       uint public pool4currUserID = 0;
11       uint public pool5currUserID = 0;
12       uint public pool6currUserID = 0;
13       
14         uint public pool1activeUserID = 0;
15       uint public pool2activeUserID = 0;
16       uint public pool3activeUserID = 0;
17       uint public pool4activeUserID = 0;
18       uint public pool5activeUserID = 0;
19       uint public pool6activeUserID = 0;
20       
21       
22       uint public unlimited_level_price=0;
23      
24       struct UserStruct {
25         bool isExist;
26         uint id;
27         uint referrerID;
28        uint referredUsers;
29         mapping(uint => uint) levelExpired;
30     }
31     
32      struct PoolUserStruct {
33         bool isExist;
34         uint id;
35        uint payment_received; 
36     }
37     
38     mapping (address => UserStruct) public users;
39      mapping (uint => address) public userList;
40      
41      mapping (address => PoolUserStruct) public pool1users;
42      mapping (uint => address) public pool1userList;
43      
44      mapping (address => PoolUserStruct) public pool2users;
45      mapping (uint => address) public pool2userList;
46      
47      mapping (address => PoolUserStruct) public pool3users;
48      mapping (uint => address) public pool3userList;
49      
50      mapping (address => PoolUserStruct) public pool4users;
51      mapping (uint => address) public pool4userList;
52      
53      mapping (address => PoolUserStruct) public pool5users;
54      mapping (uint => address) public pool5userList;
55      
56      mapping (address => PoolUserStruct) public pool6users;
57      mapping (uint => address) public pool6userList;
58      ////////////
59      //////////////
60     mapping(uint => uint) public LEVEL_PRICE;
61     
62    uint REGESTRATION_FESS=0.1 ether;
63    uint pool1_price=0.2 ether;
64    ///////////////////////////////
65    uint pool2_price=0.4 ether;
66    uint pool2_donation=0.04 ether;
67    ///////////////////////////////
68    uint pool3_price=1 ether;
69    uint pool3_donation=0.1 ether;
70    ///////////////////////////////
71    uint pool4_price=2.5 ether;
72    uint pool4_donation=0.2 ether;
73    ///////////////////////////////
74    uint pool5_price=5 ether;
75    uint pool5_donation=0.5 ether;
76    ///////////////////////////////
77    uint pool6_price=10 ether;
78    uint pool6_donation=1 ether;
79    ///////////////////////////////
80    
81      event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
82       event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
83       
84      event regPoolEntry(address indexed _user,uint _level,   uint _time);
85    
86      
87     event getPoolPayment(address indexed _user,address indexed _receiver, uint _level, uint _time);
88    
89     UserStruct[] public requests;
90      
91       constructor() public {
92           ownerWallet = 0x92E73829C8Fc6687C3b42d678B6fB074955709Ed;
93           balAdmin = 0x3fB0Dcb909c9334e6BF470C694ED74bB10c28BDd;
94 
95         LEVEL_PRICE[1] = 0.02 ether;
96         LEVEL_PRICE[2] = 0.01 ether;
97         LEVEL_PRICE[3] = 0.005 ether;
98         LEVEL_PRICE[4] = 0.0005 ether;
99       unlimited_level_price=0.0005 ether;
100 
101         UserStruct memory userStruct;
102         currUserID++;
103 
104         userStruct = UserStruct({
105             isExist: true,
106             id: currUserID,
107             referrerID: 0,
108             referredUsers:0
109            
110         });
111         
112         users[ownerWallet] = userStruct;
113        userList[currUserID] = ownerWallet;
114        
115        
116          PoolUserStruct memory pooluserStruct;
117         
118         pool1currUserID++;
119 
120         pooluserStruct = PoolUserStruct({
121             isExist:true,
122             id:pool1currUserID,
123             payment_received:0
124         });
125     pool1activeUserID=pool1currUserID;
126        pool1users[ownerWallet] = pooluserStruct;
127        pool1userList[pool1currUserID]=ownerWallet;
128       
129         
130         pool2currUserID++;
131         pooluserStruct = PoolUserStruct({
132             isExist:true,
133             id:pool2currUserID,
134             payment_received:0
135         });
136     pool2activeUserID=pool2currUserID;
137        pool2users[ownerWallet] = pooluserStruct;
138        pool2userList[pool2currUserID]=ownerWallet;
139        
140        
141         pool3currUserID++;
142         pooluserStruct = PoolUserStruct({
143             isExist:true,
144             id:pool3currUserID,
145             payment_received:0
146         });
147     pool3activeUserID=pool3currUserID;
148        pool3users[ownerWallet] = pooluserStruct;
149        pool3userList[pool3currUserID]=ownerWallet;
150        
151        
152          pool4currUserID++;
153         pooluserStruct = PoolUserStruct({
154             isExist:true,
155             id:pool4currUserID,
156             payment_received:0
157         });
158     pool4activeUserID=pool4currUserID;
159        pool4users[ownerWallet] = pooluserStruct;
160        pool4userList[pool4currUserID]=ownerWallet;
161 
162         
163           pool5currUserID++;
164         pooluserStruct = PoolUserStruct({
165             isExist:true,
166             id:pool5currUserID,
167             payment_received:0
168         });
169     pool5activeUserID=pool5currUserID;
170        pool5users[ownerWallet] = pooluserStruct;
171        pool5userList[pool5currUserID]=ownerWallet;
172        
173        
174          pool6currUserID++;
175         pooluserStruct = PoolUserStruct({
176             isExist:true,
177             id:pool6currUserID,
178             payment_received:0
179         });
180     pool6activeUserID=pool6currUserID;
181        pool6users[ownerWallet] = pooluserStruct;
182        pool6userList[pool6currUserID]=ownerWallet;
183        
184         
185      
186      
187        
188        
189       }
190      
191      function regUser(uint _referrerID) public payable {
192        
193       require(!users[msg.sender].isExist, "User Exists");
194       require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referral ID');
195         require(msg.value == REGESTRATION_FESS, 'Incorrect Value');
196        
197         UserStruct memory userStruct;
198         currUserID++;
199 
200         userStruct = UserStruct({
201             isExist: true,
202             id: currUserID,
203             referrerID: _referrerID,
204             referredUsers:0
205         });
206         ////////////////////
207         ////////////////////
208     
209        users[msg.sender] = userStruct;
210        userList[currUserID]=msg.sender;
211        
212         users[userList[users[msg.sender].referrerID]].referredUsers=users[userList[users[msg.sender].referrerID]].referredUsers+1;
213         
214        payReferral(1,msg.sender);
215         emit regLevelEvent(msg.sender, userList[_referrerID], now);
216     }
217    
218    
219      function payReferral(uint _level, address _user) internal {
220         address referer;
221        
222         referer = userList[users[_user].referrerID];
223        
224        
225          bool sent = false;
226        
227             uint level_price_local=0;
228             if(_level>4){
229             level_price_local=unlimited_level_price;
230             }
231             else{
232             level_price_local=LEVEL_PRICE[_level];
233             }
234             sent = address(uint160(referer)).send(level_price_local);
235 
236             if (sent) {
237                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
238                 if(_level < 100 && users[referer].referrerID >= 1){
239                     payReferral(_level+1,referer);
240                 }
241                 else
242                 {
243                     sendBalance();
244                 }
245                
246             }
247        
248         if(!sent) {
249           //  emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
250 
251             payReferral(_level, referer);
252         }
253      }
254    
255    
256    
257    
258        function buyPool1() public payable {
259         require(users[msg.sender].isExist, "User Not Registered");
260         require(!pool1users[msg.sender].isExist, "Already in AutoPool");
261         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
262         require(msg.value == pool1_price, 'Incorrect Value');
263         
264        
265         PoolUserStruct memory userStruct;
266         address pool1Currentuser=pool1userList[pool1activeUserID];
267         
268         pool1currUserID++;
269 
270         userStruct = PoolUserStruct({
271             isExist:true,
272             id:pool1currUserID,
273             payment_received:0
274         });
275    
276        pool1users[msg.sender] = userStruct;
277        pool1userList[pool1currUserID]=msg.sender;
278        bool sent = false;
279        sent = address(uint160(pool1Currentuser)).send(pool1_price);
280        
281 
282             if (sent) {
283                 pool1users[pool1Currentuser].payment_received+=1;
284                 if(pool1users[pool1Currentuser].payment_received>=2)
285                 {
286                     pool1activeUserID+=1;
287                 }
288                 emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
289             }
290        emit regPoolEntry(msg.sender, 1, now);
291     }
292     
293     
294       function buyPool2() public payable {
295           require(users[msg.sender].isExist, "User Not Registered");
296       require(!pool2users[msg.sender].isExist, "Already in AutoPool");
297         require(msg.value == pool2_price+pool2_donation, 'Incorrect Value');
298         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
299          
300         PoolUserStruct memory userStruct;
301         address pool2Currentuser=pool2userList[pool2activeUserID];
302         
303         pool2currUserID++;
304         userStruct = PoolUserStruct({
305             isExist:true,
306             id:pool2currUserID,
307             payment_received:0
308         });
309        pool2users[msg.sender] = userStruct;
310        pool2userList[pool2currUserID]=msg.sender;
311        
312        
313        
314        bool sent = false;
315        sent = address(uint160(pool2Currentuser)).send(pool2_price);
316         balAdmin.transfer(pool2_donation);
317             if (sent) {
318                 pool2users[pool2Currentuser].payment_received+=1;
319                 if(pool2users[pool2Currentuser].payment_received>=3)
320                 {
321                     pool2activeUserID+=1;
322                 }
323                 emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
324             }
325             emit regPoolEntry(msg.sender,2,  now);
326     }
327     
328     
329      function buyPool3() public payable {
330          require(users[msg.sender].isExist, "User Not Registered");
331       require(!pool3users[msg.sender].isExist, "Already in AutoPool");
332         require(msg.value == pool3_price+pool3_donation, 'Incorrect Value');
333         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
334         
335         PoolUserStruct memory userStruct;
336         address pool3Currentuser=pool3userList[pool3activeUserID];
337         
338         pool3currUserID++;
339         userStruct = PoolUserStruct({
340             isExist:true,
341             id:pool3currUserID,
342             payment_received:0
343         });
344        pool3users[msg.sender] = userStruct;
345        pool3userList[pool3currUserID]=msg.sender;
346        bool sent = false;
347        sent = address(uint160(pool3Currentuser)).send(pool3_price);
348         balAdmin.transfer(pool3_donation);
349             if (sent) {
350                 pool3users[pool3Currentuser].payment_received+=1;
351                 if(pool3users[pool3Currentuser].payment_received>=3)
352                 {
353                     pool3activeUserID+=1;
354                 }
355                 emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
356             }
357 emit regPoolEntry(msg.sender,3,  now);
358     }
359     
360     
361     function buyPool4() public payable {
362         require(users[msg.sender].isExist, "User Not Registered");
363       require(!pool4users[msg.sender].isExist, "Already in AutoPool");
364         require(msg.value == pool4_price+pool4_donation, 'Incorrect Value');
365         require(users[msg.sender].referredUsers>=3, "Must need 3 referral");
366       
367         PoolUserStruct memory userStruct;
368         address pool4Currentuser=pool4userList[pool4activeUserID];
369         
370         pool4currUserID++;
371         userStruct = PoolUserStruct({
372             isExist:true,
373             id:pool4currUserID,
374             payment_received:0
375         });
376        pool4users[msg.sender] = userStruct;
377        pool4userList[pool4currUserID]=msg.sender;
378        bool sent = false;
379        sent = address(uint160(pool4Currentuser)).send(pool4_price);
380         balAdmin.transfer(pool4_donation);
381             if (sent) {
382                 pool4users[pool4Currentuser].payment_received+=1;
383                 if(pool4users[pool4Currentuser].payment_received>=3)
384                 {
385                     pool4activeUserID+=1;
386                 }
387                  emit getPoolPayment(msg.sender,pool4Currentuser, 4, now);
388             }
389         emit regPoolEntry(msg.sender,4, now);
390     }
391     
392     
393     
394     function buyPool5() public payable {
395         require(users[msg.sender].isExist, "User Not Registered");
396       require(!pool5users[msg.sender].isExist, "Already in AutoPool");
397         require(msg.value == pool5_price+pool5_donation, 'Incorrect Value');
398         require(users[msg.sender].referredUsers>=4, "Must need 4 referral");
399         
400         PoolUserStruct memory userStruct;
401         address pool5Currentuser=pool5userList[pool5activeUserID];
402         
403         pool5currUserID++;
404         userStruct = PoolUserStruct({
405             isExist:true,
406             id:pool5currUserID,
407             payment_received:0
408         });
409        pool5users[msg.sender] = userStruct;
410        pool5userList[pool5currUserID]=msg.sender;
411        bool sent = false;
412        sent = address(uint160(pool5Currentuser)).send(pool5_price);
413         balAdmin.transfer(pool5_donation);
414             if (sent) {
415                 pool5users[pool5Currentuser].payment_received+=1;
416                 if(pool5users[pool5Currentuser].payment_received>=3)
417                 {
418                     pool5activeUserID+=1;
419                 }
420                  emit getPoolPayment(msg.sender,pool5Currentuser, 5, now);
421             }
422         emit regPoolEntry(msg.sender,5,  now);
423     }
424     
425     function buyPool6() public payable {
426       require(!pool6users[msg.sender].isExist, "Already in AutoPool");
427         require(msg.value == pool6_price+pool6_donation, 'Incorrect Value');
428         require(users[msg.sender].referredUsers>=5, "Must need 5 referral");
429         
430         PoolUserStruct memory userStruct;
431         address pool6Currentuser=pool6userList[pool6activeUserID];
432         
433         pool6currUserID++;
434         userStruct = PoolUserStruct({
435             isExist:true,
436             id:pool6currUserID,
437             payment_received:0
438         });
439        pool6users[msg.sender] = userStruct;
440        pool6userList[pool6currUserID]=msg.sender;
441        bool sent = false;
442        sent = address(uint160(pool6Currentuser)).send(pool6_price);
443         balAdmin.transfer(pool6_donation);
444             if (sent) {
445                 pool6users[pool6Currentuser].payment_received+=1;
446                 if(pool6users[pool6Currentuser].payment_received>=3)
447                 {
448                     pool6activeUserID+=1;
449                 }
450                  emit getPoolPayment(msg.sender,pool6Currentuser, 6, now);
451             }
452         emit regPoolEntry(msg.sender,6,  now);
453     }
454     
455     
456     
457     function getEthBalance() public view returns(uint) {
458     return address(this).balance;
459     }
460     
461     function sendBalance() private
462     {
463          if (!address(uint160(balAdmin)).send(getEthBalance()))
464          {
465              
466          }
467     }
468    
469    
470 }