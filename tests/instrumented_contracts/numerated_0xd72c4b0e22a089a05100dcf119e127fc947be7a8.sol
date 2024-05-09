1 pragma solidity ^0.5.7;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 
31 contract Ownable {
32 
33   address public owner;
34   address public ownerWallet;
35 
36   constructor() public {
37     owner = msg.sender;
38     ownerWallet = 0xB67d52d9BDA884d487b6eae57478E387602e522d;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner, "only for owner");
43     _;
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     owner = newOwner;
48   }
49 
50 }
51 
52 contract ETHStvo is Ownable {
53 
54     event regStarEvent(address indexed _user, address indexed _referrer, uint _time);
55     event buyStarEvent(address indexed _user, uint _star, uint _cycle, uint _time);
56     event prolongateStarEvent(address indexed _user, uint _star, uint _time);
57     event getMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);
58     event lostMoneyForStarEvent(address indexed _user, address indexed _referral, uint _star, uint _cycle, uint _time);
59     //------------------------------
60 
61     mapping (uint => uint) public STAR_PRICE;
62     uint REFERRER_1_STAR_LIMIT = 3;
63     uint PERIOD_LENGTH = 3650 days;
64 
65 
66     struct UserStruct {
67         bool isExist;
68         uint id;
69         uint referrerID;
70         uint referrerIDInitial;
71         address[] referral;
72         mapping (uint => uint) starExpired;
73     }
74 
75     mapping (address => UserStruct) public users;
76     mapping (uint => address) public userList;
77     uint public currUserID = 0;
78 
79     constructor() public {
80 
81         //Cycle 1
82         STAR_PRICE[1] = 0.05 ether;
83         STAR_PRICE[2] = 0.15 ether;
84         STAR_PRICE[3] = 0.90 ether;
85         STAR_PRICE[4] = 2.70 ether;
86         STAR_PRICE[5] = 24.75 ether;
87         STAR_PRICE[6] = 37.50 ether;
88         STAR_PRICE[7] = 72.90 ether;
89         STAR_PRICE[8] = 218.70 ether;
90 
91         //Cycle 2
92         STAR_PRICE[9] = 5.50 ether;
93         STAR_PRICE[10] = 15.00 ether;
94         STAR_PRICE[11] = 90.00 ether;
95         STAR_PRICE[12] = 270.00 ether;
96         STAR_PRICE[13] = 2475.00 ether;
97         STAR_PRICE[14] = 3750.00 ether;
98         STAR_PRICE[15] = 7290.00 ether;
99         STAR_PRICE[16] = 21870.00 ether;
100 
101         //Cycle 3
102         STAR_PRICE[17] = 55.0 ether;
103         STAR_PRICE[18] = 150.00 ether;
104         STAR_PRICE[19] = 900.00 ether;
105         STAR_PRICE[20] = 2700.00 ether;
106         STAR_PRICE[21] = 24750.00 ether;
107         STAR_PRICE[22] = 37500.00 ether;
108         STAR_PRICE[23] = 72900.00 ether;
109         STAR_PRICE[24] = 218700.00 ether;
110 
111         UserStruct memory userStruct;
112         currUserID++;
113 
114         userStruct = UserStruct({
115             isExist : true,
116             id : currUserID,
117             referrerID : 0,
118             referrerIDInitial : 0,
119             referral : new address[](0)
120         });
121         users[ownerWallet] = userStruct;
122         userList[currUserID] = ownerWallet;
123 
124         users[ownerWallet].starExpired[1] = 77777777777;
125         users[ownerWallet].starExpired[2] = 77777777777;
126         users[ownerWallet].starExpired[3] = 77777777777;
127         users[ownerWallet].starExpired[4] = 77777777777;
128         users[ownerWallet].starExpired[5] = 77777777777;
129         users[ownerWallet].starExpired[6] = 77777777777;
130         users[ownerWallet].starExpired[7] = 77777777777;
131         users[ownerWallet].starExpired[8] = 77777777777;
132         users[ownerWallet].starExpired[9] = 77777777777;
133         users[ownerWallet].starExpired[10] = 77777777777;
134         users[ownerWallet].starExpired[11] = 77777777777;
135         users[ownerWallet].starExpired[12] = 77777777777;
136         users[ownerWallet].starExpired[13] = 77777777777;
137         users[ownerWallet].starExpired[14] = 77777777777;
138         users[ownerWallet].starExpired[15] = 77777777777;
139         users[ownerWallet].starExpired[16] = 77777777777;
140         users[ownerWallet].starExpired[17] = 77777777777;
141         users[ownerWallet].starExpired[18] = 77777777777;
142         users[ownerWallet].starExpired[19] = 77777777777;
143         users[ownerWallet].starExpired[20] = 77777777777;
144         users[ownerWallet].starExpired[21] = 77777777777;
145         users[ownerWallet].starExpired[22] = 77777777777;
146         users[ownerWallet].starExpired[23] = 77777777777;
147         users[ownerWallet].starExpired[24] = 77777777777;
148     }
149 
150     function setOwnerWallet(address _ownerWallet) public onlyOwner {
151         userList[1] = _ownerWallet;
152       }
153 
154     function () external payable {
155 
156         uint star;
157         uint cycle;
158 
159         if(msg.value == STAR_PRICE[1]){
160             star = 1;
161             cycle = 1;
162         }else if(msg.value == STAR_PRICE[2]){
163             star = 2;
164             cycle = 1;
165         }else if(msg.value == STAR_PRICE[3]){
166             star = 3;
167             cycle = 1;
168         }else if(msg.value == STAR_PRICE[4]){
169             star = 4;
170             cycle = 1;
171         }else if(msg.value == STAR_PRICE[5]){
172             star = 5;
173             cycle = 1;
174         }else if(msg.value == STAR_PRICE[6]){
175             star = 6;
176             cycle = 1;
177         }else if(msg.value == STAR_PRICE[7]){
178             star = 7;
179             cycle = 1;
180         }else if(msg.value == STAR_PRICE[8]){
181             star = 8;
182             cycle = 1;
183         }else if(msg.value == STAR_PRICE[9]){
184             star = 9;
185             cycle = 2;
186         }else if(msg.value == STAR_PRICE[10]){
187             star = 10;
188             cycle = 2;
189         }else if(msg.value == STAR_PRICE[11]){
190             star = 11;
191             cycle = 2;
192         }else if(msg.value == STAR_PRICE[12]){
193             star = 12;
194             cycle = 2;
195         }else if(msg.value == STAR_PRICE[13]){
196             star = 13;
197             cycle = 2;
198         }else if(msg.value == STAR_PRICE[14]){
199             star = 14;
200             cycle = 2;
201         }else if(msg.value == STAR_PRICE[15]){
202             star = 15;
203             cycle = 2;
204         }else if(msg.value == STAR_PRICE[16]){
205             star = 16;
206             cycle = 2;
207         }else if(msg.value == STAR_PRICE[17]){
208             star = 17;
209             cycle = 3;
210         }else if(msg.value == STAR_PRICE[18]){
211             star = 18;
212             cycle = 3;
213         }else if(msg.value == STAR_PRICE[19]){
214             star = 19;
215             cycle = 3;
216         }else if(msg.value == STAR_PRICE[20]){
217             star = 20;
218             cycle = 3;
219         }else if(msg.value == STAR_PRICE[21]){
220             star = 21;
221             cycle = 3;
222         }else if(msg.value == STAR_PRICE[22]){
223             star = 22;
224             cycle = 3;
225         }else if(msg.value == STAR_PRICE[23]){
226             star = 23;
227             cycle = 3;
228         }else if(msg.value == STAR_PRICE[24]){
229             star = 24;
230             cycle = 3;
231         }else {
232             revert('Incorrect Value send');
233         }
234 
235         if(users[msg.sender].isExist){
236             buyStar(star, cycle);
237         } else if(star == 1) {
238             uint refId = 0;
239             address referrer = bytesToAddress(msg.data);
240 
241             if (users[referrer].isExist){
242                 refId = users[referrer].id;
243             } else {
244                 revert('Incorrect referrer');
245             }
246 
247             regUser(refId);
248         } else {
249             revert("Please buy first star for 0.05 ETH");
250         }
251     }
252 
253     function regUser(uint _referrerID) public payable {
254         require(!users[msg.sender].isExist, 'User exist');
255 
256         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
257 
258         require(msg.value==STAR_PRICE[1], 'Incorrect Value');
259 
260         uint _referrerIDInitial = _referrerID;
261 
262         if(users[userList[_referrerID]].referral.length >= REFERRER_1_STAR_LIMIT)
263         {
264             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
265         }
266 
267         UserStruct memory userStruct;
268         currUserID++;
269 
270         userStruct = UserStruct({
271             isExist : true,
272             id : currUserID,
273             referrerID : _referrerID,
274             referrerIDInitial : _referrerIDInitial,
275             referral : new address[](0)
276         });
277 
278         users[msg.sender] = userStruct;
279         userList[currUserID] = msg.sender;
280 
281         users[msg.sender].starExpired[1] = now + PERIOD_LENGTH;
282         users[msg.sender].starExpired[2] = 0;
283         users[msg.sender].starExpired[3] = 0;
284         users[msg.sender].starExpired[4] = 0;
285         users[msg.sender].starExpired[5] = 0;
286         users[msg.sender].starExpired[6] = 0;
287         users[msg.sender].starExpired[7] = 0;
288         users[msg.sender].starExpired[8] = 0;
289         users[msg.sender].starExpired[9] = 0;
290         users[msg.sender].starExpired[10] = 0;
291         users[msg.sender].starExpired[11] = 0;
292         users[msg.sender].starExpired[12] = 0;
293         users[msg.sender].starExpired[13] = 0;
294         users[msg.sender].starExpired[14] = 0;
295         users[msg.sender].starExpired[15] = 0;
296         users[msg.sender].starExpired[16] = 0;
297         users[msg.sender].starExpired[17] = 0;
298         users[msg.sender].starExpired[18] = 0;
299         users[msg.sender].starExpired[19] = 0;
300         users[msg.sender].starExpired[20] = 0;
301         users[msg.sender].starExpired[21] = 0;
302         users[msg.sender].starExpired[22] = 0;
303         users[msg.sender].starExpired[23] = 0;
304         users[msg.sender].starExpired[24] = 0;
305 
306         users[userList[_referrerID]].referral.push(msg.sender);
307 
308         payForStar(1, 1, msg.sender);
309 
310         emit regStarEvent(msg.sender, userList[_referrerID], now);
311     }
312 
313     function buyStar(uint _star, uint _cycle) public payable {
314         require(users[msg.sender].isExist, 'User not exist');
315 
316         require( _star>0 && _star<=24, 'Incorrect star');
317         require( _cycle>0 && _cycle<=3, 'Incorrect cycle');
318 
319         if(_star == 1){
320             require(msg.value==STAR_PRICE[1], 'Incorrect Value');
321             users[msg.sender].starExpired[1] += PERIOD_LENGTH;
322         } else {
323                 require(msg.value==STAR_PRICE[_star], 'Incorrect Value');
324 
325             for(uint l =_star-1; l>0; l-- ){
326                 require(users[msg.sender].starExpired[l] >= now, 'Buy the previous star');
327             }
328 
329             if(users[msg.sender].starExpired[_star] == 0){
330                 users[msg.sender].starExpired[_star] = now + PERIOD_LENGTH;
331             } else {
332                 users[msg.sender].starExpired[_star] += PERIOD_LENGTH;
333             }
334 
335         }
336         payForStar(_star, _cycle, msg.sender);
337         emit buyStarEvent(msg.sender, _star, _cycle, now);
338     }
339 
340     function payForStar(uint _star, uint _cycle, address _user) internal {
341 
342         address referer;
343         address referer1;
344         address referer2;
345         address referer3;
346         address refererInitial;
347         uint money;
348         if(_star == 1 || _star == 5 || _star == 9 || _star == 13 || _star == 17 || _star == 21){
349             referer = userList[users[_user].referrerID];
350         } else if(_star == 2 || _star == 6 || _star == 10 || _star == 14 || _star == 18 || _star == 22){
351             referer1 = userList[users[_user].referrerID];
352             referer = userList[users[referer1].referrerID];
353         } else if(_star == 3 || _star == 7 || _star == 11 || _star == 15 || _star == 19 || _star == 23){
354             referer1 = userList[users[_user].referrerID];
355             referer2 = userList[users[referer1].referrerID];
356             referer = userList[users[referer2].referrerID];
357         } else if(_star == 4 || _star == 8 || _star == 12 || _star == 16 || _star == 20 || _star == 24){
358             referer1 = userList[users[_user].referrerID];
359             referer2 = userList[users[referer1].referrerID];
360             referer3 = userList[users[referer2].referrerID];
361             referer = userList[users[referer3].referrerID];
362         }
363 
364         if(!users[referer].isExist){
365             referer = userList[1];
366         }
367 
368         refererInitial = userList[users[_user].referrerIDInitial];
369 
370         if(!users[refererInitial].isExist){
371             refererInitial = userList[1];
372         }
373 
374         if(users[referer].starExpired[_star] >= now ){
375 
376             money = STAR_PRICE[_star];
377 
378             if(_star>=3){
379                 
380                 if(_star==5){
381                     bool result;
382                     result = address(uint160(userList[1])).send(uint(2.25 ether));
383                     money = SafeMath.sub(money,uint(2.25 ether));
384                 }
385 
386                 if(_star==9){
387                     bool result;
388                     result = address(uint160(userList[1])).send(uint(0.50 ether));
389                     money = SafeMath.sub(money,uint(0.50 ether));
390                 }
391 
392                 if(_star==13){
393                     bool result;
394                     result = address(uint160(userList[1])).send(uint(225.00 ether));
395                     money = SafeMath.sub(money,uint(225.00 ether));
396                 }
397 
398                 if(_star==17){
399                     bool result;
400                     result = address(uint160(userList[1])).send(uint(5.00 ether));
401                     money = SafeMath.sub(money,uint(5.00 ether));
402                 }
403 
404                 if(_star==21){
405                     bool result;
406                     result = address(uint160(userList[1])).send(uint(2250.00 ether));
407                     money = SafeMath.sub(money,uint(2250.00 ether));
408                 }
409 
410                 bool result_one;
411                 result_one = address(uint160(referer)).send(SafeMath.div(money,2));
412 
413                 bool result_two;
414                 result_two = address(uint160(refererInitial)).send(SafeMath.div(money,2));
415                 
416             } else {
417                 bool result;
418                 result = address(uint160(referer)).send(money);
419             }
420 
421             emit getMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);
422 
423         } else {
424             emit lostMoneyForStarEvent(referer, msg.sender, _star, _cycle, now);
425             payForStar(_star,_cycle,referer);
426         }
427     }
428 
429     function findFreeReferrer(address _user) public view returns(address) {
430 
431         require(users[_user].isExist, 'Upline does not exist');
432 
433         if(users[_user].referral.length < REFERRER_1_STAR_LIMIT){
434             return _user;
435         }
436 
437         address[] memory referrals = new address[](363);
438         referrals[0] = users[_user].referral[0]; 
439         referrals[1] = users[_user].referral[1];
440         referrals[2] = users[_user].referral[2];
441 
442         address freeReferrer;
443         bool noFreeReferrer = true;
444 
445         for(uint i =0; i<363;i++){
446             if(users[referrals[i]].referral.length == REFERRER_1_STAR_LIMIT){
447                 if(i<120){
448                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
449                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
450                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
451                 }
452             }else{
453                 noFreeReferrer = false;
454                 freeReferrer = referrals[i];
455                 break;
456             }
457         }
458         require(!noFreeReferrer, 'No Free Referrer');
459         return freeReferrer;
460 
461     }
462 
463     function viewUserReferral(address _user) public view returns(address[] memory) {
464         return users[_user].referral;
465     }
466 
467     function viewUserStarExpired(address _user, uint _star) public view returns(uint) {
468         return users[_user].starExpired[_star];
469     }
470     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
471         assembly {
472             addr := mload(add(bys, 20))
473         }
474     }
475 }