1 pragma solidity 0.5.14;
2 
3 contract Ballast {
4     address public ownerWallet;
5     
6     struct UserStruct {
7         bool isExist;
8         uint id;
9         uint referrerID;
10         uint totalEarning;
11         address[] referral;
12     }
13 
14     struct PoolUserStruct {
15         bool isExist;
16         uint id;
17        uint payment_received; 
18     }
19       
20     mapping (address => UserStruct) public users;
21     mapping (uint => address) public userList;
22     
23     mapping(address => mapping(uint => uint[])) public userPoolSeqID;
24     
25     mapping (address => mapping(uint => PoolUserStruct)) public pool1users;
26     mapping (uint => address) public pool1userList;
27      
28     mapping (address => mapping(uint =>PoolUserStruct)) public pool2users;
29     mapping (uint => address) public pool2userList;
30      
31     mapping (address => mapping(uint =>PoolUserStruct)) public pool3users;
32     mapping (uint => address) public pool3userList;
33      
34     mapping(uint => uint) public Auto_Pool_Upline;
35     mapping(uint => uint) public Auto_Pool_System;
36     
37     Ballast public oldBallast;
38     
39     uint public oldBallastId = 1;
40     uint public currUserID = 0;
41     
42     uint public pool1currUserID = 0;
43     uint public pool2currUserID = 0;
44     uint public pool3currUserID = 0;
45       
46     uint public pool1activeUserID = 0;
47     uint public pool2activeUserID = 0;
48     uint public pool3activeUserID = 0;
49 
50     uint public REGESTRATION_FESS=0.08 ether;
51     uint public ADMIN_FEES = 0.02 ether;
52    
53     uint public pool1_price = 0.25 ether;
54     uint public pool2_price = 0.50 ether;
55     uint public pool3_price = 1 ether;
56     
57     bool public lockStatus;
58 
59     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
60     event regPoolEntry(address indexed _user,uint indexed _poolID,uint indexed _activeUser, uint _time);
61     event poolReInvest(uint indexed _poolID, address indexed _user, uint _useID, uint _reInvestID);
62     event getPoolPayment(address indexed _user,address indexed _receiver, uint _poolID, uint _time);
63     event getPoolMoneyForLevelEvent(uint indexed _poolID,address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
64     event lostPoolMoneyForLevelEvent(uint indexed _poolID, address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
65     
66     constructor() public {
67         ownerWallet = msg.sender;
68         oldBallast = Ballast(0xdD7dA498a5F040C1BF6C6ff6406Bf07a985029D2);
69         
70         Auto_Pool_Upline[1] = 0.02 ether;
71         Auto_Pool_Upline[2] = 0.04 ether;
72         Auto_Pool_Upline[3] = 0.08 ether;
73         
74         Auto_Pool_System[1] = 0.05 ether;
75         Auto_Pool_System[2] = 0.10 ether;
76         Auto_Pool_System[3] = 0.20 ether;
77 
78         
79         PoolUserStruct memory pooluserStruct;
80         
81         pool1currUserID++;
82 
83         pooluserStruct = PoolUserStruct({
84             isExist:true,
85             id:pool1currUserID,
86             payment_received:0
87         });
88         pool1activeUserID = pool1currUserID;
89         pool1users[msg.sender][pool1currUserID] = pooluserStruct;
90         pool1userList[pool1currUserID] = msg.sender;
91         userPoolSeqID[msg.sender][1].push(pool1currUserID);
92         
93         pool2currUserID++;
94         pooluserStruct = PoolUserStruct({
95             isExist:true,
96             id:pool2currUserID,
97             payment_received:0
98         });
99         pool2activeUserID = pool2currUserID;
100         pool2users[msg.sender][pool2currUserID] = pooluserStruct;
101         pool2userList[pool2currUserID] = msg.sender;
102         userPoolSeqID[msg.sender][2].push(pool2currUserID);
103        
104        
105         pool3currUserID++;
106         pooluserStruct = PoolUserStruct({
107             isExist:true,
108             id:pool3currUserID,
109             payment_received:0
110         });
111         pool3activeUserID = pool3currUserID;
112         pool3users[msg.sender][pool3currUserID] = pooluserStruct;
113         pool3userList[pool3currUserID] = msg.sender;
114         userPoolSeqID[msg.sender][3].push(pool3currUserID);
115     }
116 
117     function () external payable {
118         revert("No contract call");
119     }
120 
121     function regUser(uint _referrerID) public payable {
122         require(lockStatus == false, "Contract Locked");
123         require(!users[msg.sender].isExist, "User exist");
124         require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect referrer Id");
125         require(msg.value == REGESTRATION_FESS, "Incorrect Value");
126 
127         UserStruct memory userStruct;
128         currUserID++;
129 
130         userStruct = UserStruct({
131             isExist: true,
132             id: currUserID,
133             referrerID: _referrerID,
134             totalEarning:0,
135             referral: new address[](0)
136         });
137 
138         users[msg.sender] = userStruct;
139         userList[currUserID] = msg.sender;
140         users[userList[_referrerID]].referral.push(msg.sender);
141 
142         uint referrerAmount = REGESTRATION_FESS-ADMIN_FEES;
143         
144         require(
145             (address(uint160(userList[_referrerID])).send(referrerAmount)) && (address(uint160(ownerWallet)).send(ADMIN_FEES)),
146             "failed to transfer referrer and ownerWallet fees"
147         );
148         
149         users[userList[_referrerID]].totalEarning += referrerAmount;
150         users[ownerWallet].totalEarning += ADMIN_FEES;  
151 
152         emit regLevelEvent(msg.sender, userList[_referrerID], now);
153     }
154 
155     function buyPool1() public payable {
156        require(lockStatus == false, "Contract Locked");
157        require(users[msg.sender].isExist, "User Not Registered");
158        require(msg.value == pool1_price, "Incorrect Value");
159         
160         pool1currUserID++;
161         
162         PoolUserStruct memory userStruct;
163         
164         if(pool1currUserID == 3)
165            pool1activeUserID++;
166            
167         address pool1Currentuser = pool1userList[pool1activeUserID];
168         
169         userStruct = PoolUserStruct({
170             isExist:true,
171             id:pool1currUserID,
172             payment_received:0
173         });
174         
175         pool1users[msg.sender][pool1currUserID] = userStruct;
176         pool1userList[pool1currUserID]=msg.sender;
177         userPoolSeqID[msg.sender][1].push(pool1currUserID);
178         
179         uint payment = pool1users[pool1Currentuser][pool1activeUserID].payment_received;
180         
181         if(payment == 1){
182             payForLevel(1, 10, pool1Currentuser);
183             require(address(uint160(ownerWallet)).send(Auto_Pool_System[1]),"failed to transfer system");
184         }
185         else if(payment == 0){
186             require(address(uint160(pool1Currentuser)).send(pool1_price),"failed to transfer direct income");
187             emit getPoolPayment(msg.sender,pool1Currentuser, 1, now);
188         }
189         pool1users[pool1Currentuser][pool1activeUserID].payment_received+=1;
190         
191         if(pool1users[pool1Currentuser][pool1activeUserID].payment_received>=3)
192         { 
193             uint pool1PreActiveUserID = pool1activeUserID;
194             pool1activeUserID++;
195             pool1currUserID++;
196             
197             address pool1ActiveCurrentuser = pool1userList[pool1activeUserID];
198             require(address(uint160(pool1ActiveCurrentuser)).send(pool1_price),"failed to transfer direct income");
199             emit getPoolPayment(msg.sender,pool1ActiveCurrentuser, 1, now);
200             
201             pool1users[pool1ActiveCurrentuser][pool1activeUserID].payment_received+=1;
202             
203             userStruct = PoolUserStruct({
204                 isExist:true,
205                 id:pool1currUserID,
206                 payment_received:0
207             });
208        
209             pool1users[pool1Currentuser][pool1currUserID] = userStruct;
210             pool1userList[pool1currUserID]=pool1Currentuser;
211             userPoolSeqID[pool1Currentuser][1].push(pool1currUserID);
212             
213             emit regPoolEntry(msg.sender, 1, pool1PreActiveUserID, now);
214             emit regPoolEntry(pool1Currentuser, 1, pool1PreActiveUserID, now);
215             emit poolReInvest(1, pool1Currentuser, pool1PreActiveUserID, pool1currUserID);
216         }
217         else{
218             emit regPoolEntry(msg.sender, 1, pool1activeUserID, now);
219         }
220     }
221     
222     function buyPool2() public payable {
223        require(lockStatus == false, "Contract Locked");        
224        require(users[msg.sender].isExist, "User Not Registered");
225        require(msg.value == pool2_price, "Incorrect Value");
226         
227         pool2currUserID++;
228        
229         PoolUserStruct memory userStruct;
230         
231         if(pool2currUserID == 3)
232            pool2activeUserID++;
233            
234         address pool2Currentuser = pool2userList[pool2activeUserID];
235         
236         userStruct = PoolUserStruct({
237             isExist:true,
238             id:pool2currUserID,
239             payment_received:0
240         });
241    
242         pool2users[msg.sender][pool2currUserID] = userStruct;
243         pool2userList[pool2currUserID]=msg.sender;
244         userPoolSeqID[msg.sender][2].push(pool2currUserID);
245         
246         uint payment = pool2users[pool2Currentuser][pool2activeUserID].payment_received;
247         
248         if(payment == 1){
249             payForLevel(2, 10, pool2Currentuser);
250             require(address(uint160(ownerWallet)).send(Auto_Pool_System[2]),"failed to transfer system");
251         }
252         else if(payment == 0){
253             require(address(uint160(pool2Currentuser)).send(pool2_price),"failed to transfer direct income");
254             emit getPoolPayment(msg.sender,pool2Currentuser, 2, now);
255         }
256         pool2users[pool2Currentuser][pool2activeUserID].payment_received+=1;
257         
258         if(pool2users[pool2Currentuser][pool2activeUserID].payment_received>=3)
259         { 
260             uint pool2PreActiveUserID = pool2activeUserID;
261             pool2activeUserID++;
262             pool2currUserID++;
263             
264             address pool2ActiveCurrentuser = pool2userList[pool2activeUserID];
265             require(address(uint160(pool2ActiveCurrentuser)).send(pool2_price),"failed to transfer direct income");
266             emit getPoolPayment(msg.sender,pool2ActiveCurrentuser, 2, now);
267             
268             pool2users[pool2ActiveCurrentuser][pool2activeUserID].payment_received+=1;
269             
270             userStruct = PoolUserStruct({
271                 isExist:true,
272                 id:pool2currUserID,
273                 payment_received:0
274             });
275        
276             pool2users[pool2Currentuser][pool2currUserID] = userStruct;
277             pool2userList[pool2currUserID]=pool2Currentuser;
278             userPoolSeqID[pool2Currentuser][2].push(pool2currUserID);
279             
280             emit regPoolEntry(msg.sender, 2, pool2PreActiveUserID, now);
281             emit regPoolEntry(pool2Currentuser, 2, pool2PreActiveUserID, now);
282             emit poolReInvest(2, pool2Currentuser, pool2PreActiveUserID, pool2currUserID);
283         }
284         else{
285             emit regPoolEntry(msg.sender, 2, pool2activeUserID, now);
286         }
287     }
288     
289     function buyPool3() public payable {
290        require(lockStatus == false, "Contract Locked");        
291        require(users[msg.sender].isExist, "User Not Registered");
292        require(msg.value == pool3_price, "Incorrect Value");
293         
294         pool3currUserID++;
295        
296         PoolUserStruct memory userStruct;
297         
298         if(pool3currUserID == 3)
299            pool3activeUserID++;
300            
301         address pool3Currentuser = pool3userList[pool3activeUserID];
302         
303         userStruct = PoolUserStruct({
304             isExist:true,
305             id:pool3currUserID,
306             payment_received:0
307         });
308    
309         pool3users[msg.sender][pool3currUserID] = userStruct;
310         pool3userList[pool3currUserID]=msg.sender;
311         userPoolSeqID[msg.sender][3].push(pool3currUserID);
312         
313         uint payment = pool3users[pool3Currentuser][pool3activeUserID].payment_received;
314         
315         if(payment == 1){
316             payForLevel(3, 10, pool3Currentuser);
317             require(address(uint160(ownerWallet)).send(Auto_Pool_System[3]),"failed to transfer system");
318         }
319         else if(payment == 0){
320             require(address(uint160(pool3Currentuser)).send(pool3_price),"failed to transfer direct income");
321             emit getPoolPayment(msg.sender,pool3Currentuser, 3, now);
322         }
323         pool3users[pool3Currentuser][pool3activeUserID].payment_received+=1;
324         
325         if(pool3users[pool3Currentuser][pool3activeUserID].payment_received>=3)
326         { 
327             uint pool3PreActiveUserID = pool3activeUserID;
328             pool3activeUserID++;
329             pool3currUserID++;
330             
331             address pool3ActiveCurrentuser = pool3userList[pool3activeUserID];
332             require(address(uint160(pool3ActiveCurrentuser)).send(pool3_price),"failed to transfer direct income");
333             emit getPoolPayment(msg.sender,pool3ActiveCurrentuser, 3, now);
334             
335             pool3users[pool3ActiveCurrentuser][pool3activeUserID].payment_received+=1;
336             
337             userStruct = PoolUserStruct({
338                 isExist:true,
339                 id:pool3currUserID,
340                 payment_received:0
341             });
342        
343             pool3users[pool3Currentuser][pool3currUserID] = userStruct;
344             pool3userList[pool3currUserID]=pool3Currentuser;
345             userPoolSeqID[pool3Currentuser][3].push(pool3currUserID);
346             
347             emit regPoolEntry(msg.sender, 3, pool3PreActiveUserID, now);
348             emit regPoolEntry(pool3Currentuser, 3, pool3PreActiveUserID, now);
349             emit poolReInvest(3, pool3Currentuser, pool3PreActiveUserID, pool3currUserID);
350         }
351         else{
352             emit regPoolEntry(msg.sender, 3, pool3activeUserID, now);
353         }
354     }
355     
356     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
357         require(msg.sender == ownerWallet, "only Owner Wallet");
358         require(_toUser != address(0), "Invalid Address");
359         require(address(this).balance >= _amount, "Insufficient balance");
360 
361         (_toUser).transfer(_amount);
362         return true;
363     }
364 
365     function contractLock(bool _lockStatus) public returns (bool) {
366         require(msg.sender == ownerWallet, "Invalid User");
367 
368         lockStatus = _lockStatus;
369         return true;
370     } 
371     
372     function payForLevel(uint _poolID, uint _level, address _user) internal {
373         address referer;
374 
375         referer = userList[users[_user].referrerID];
376         
377 
378         if(!users[referer].isExist) referer = userList[1];
379         
380         if(referer == userList[1]){
381             uint uplineAmount = Auto_Pool_Upline[_poolID]*_level;
382             require(
383                 address(uint160(referer)).send(uplineAmount),
384                 "Upline referer transfer failed"
385             );
386             users[referer].totalEarning += uplineAmount;
387             emit getPoolMoneyForLevelEvent(_poolID, referer, msg.sender, _level, uplineAmount, now);
388         }
389         else{
390             if(userPoolSeqID[referer][_poolID].length > 0){
391                 if(_level != 0) {
392                     require(
393                         address(uint160(referer)).send(Auto_Pool_Upline[_poolID]),
394                         "Upline referer transfer failed"
395                     );
396                     _level--;
397                     users[referer].totalEarning += Auto_Pool_Upline[_poolID];
398                     emit getPoolMoneyForLevelEvent(_poolID, referer, msg.sender, _level, Auto_Pool_Upline[_poolID], now);
399                     payForLevel(_poolID, _level, referer);
400                 }
401             }
402             else{
403                 emit lostPoolMoneyForLevelEvent(_poolID, referer, msg.sender, _level, Auto_Pool_Upline[_poolID], now);
404                 payForLevel(_poolID, _level, referer);
405             }
406         }
407     }
408     
409     function viewUserReferral(address _user) public view returns(address[] memory) {
410         return users[_user].referral;
411     }
412     
413     function viewUserPoolSeqID(address _user,uint _poolID)public view returns(uint[] memory) {
414         return userPoolSeqID[_user][_poolID];
415     }
416     
417      /**
418      * @dev Update old contract data
419      */ 
420     function oldBallastSync(uint limit) public {
421         require(address(oldBallast) != address(0), "Initialize closed");
422         require(msg.sender == ownerWallet, "Access denied");
423         
424         for (uint i = 0; i <= limit; i++) {
425             UserStruct  memory olduser;
426             address oldusers = oldBallast.userList(oldBallastId);
427             (olduser.isExist, 
428             olduser.id, 
429             olduser.referrerID, 
430             olduser.totalEarning) = oldBallast.users(oldusers);
431             address ref = oldBallast.userList(olduser.referrerID);
432 
433             if (olduser.isExist) {
434                 if (!users[oldusers].isExist) {
435                     if(oldBallastId == 1)
436                         oldusers = ownerWallet;
437                         
438                     users[oldusers].isExist = true;
439                     users[oldusers].id = oldBallastId;
440                     users[oldusers].referrerID = olduser.referrerID;
441                     users[oldusers].totalEarning = olduser.totalEarning;
442                     userList[oldBallastId] = oldusers;
443                     if(olduser.referrerID == 1)
444                         ref = ownerWallet;
445                         
446                     users[ref].referral.push(oldusers);
447                     
448                     emit regLevelEvent(oldusers, ref, now);
449                 }
450                 oldBallastId++;
451             } else {
452                 currUserID = oldBallastId-1;
453                 break;
454                 
455             }
456         }
457     }
458     
459     /**
460      * @dev Update old contract data
461      */ 
462     function setoldBallastID(uint _id) public returns(bool) {
463         require(ownerWallet == msg.sender, "Access Denied");
464         
465         oldBallastId = _id;
466         return true;
467     }
468 
469     /**
470      * @dev Close old contract interaction
471      */ 
472     function oldBallastSyncClosed() external {
473         require(address(oldBallast) != address(0), "Initialize already closed");
474         require(msg.sender == ownerWallet, "Access denied");
475 
476         oldBallast = Ballast(0);
477     }
478 }