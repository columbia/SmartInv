1 pragma solidity >=0.4.23 <0.6.0;
2 
3 /**
4 * eplans.vip
5 **/
6 contract ETPlan {
7 
8     struct User {
9         uint id;
10         address referrer;
11         uint partnersCount;
12 
13         mapping(uint8 => bool) activeQ8Levels;
14         mapping(uint8 => bool) blocked;
15         mapping(uint8 => uint) income;
16     }
17 
18     struct Q8 {
19         address currentReferrer;
20         address[] firstLevelReferrals;
21         address[] secondLevelReferrals;
22         uint reinvestCount;
23     }
24 
25     uint8 public constant LAST_LEVEL = 12;
26 
27     uint public lastUserId = 2;
28     address public owner;
29     address public pool;
30     address public manager;
31     address public eTPlanToken;
32 
33     mapping(uint8 => uint) public levelPrice;
34     mapping(uint8 => Q8) public q8Matrix;
35     mapping(address => User) public users;
36     mapping(uint => address) public idToAddress;
37 
38     event NewUserPlace(address indexed user, address indexed referrer, uint8 level, uint8 place);
39     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
40     event MissedEthReceive(address indexed receiver, address indexed from, uint8 level);
41     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 level);
42     event NewRound(address indexed user, address indexed referrer, uint8 level);
43 
44     address public super;
45 
46     address public _this;
47 
48     modifier OnlySuper {
49         require(msg.sender == super);
50         _;
51     }
52 
53     constructor(address _token) public {
54         levelPrice[1] = 0.1 ether;
55         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
56             levelPrice[i] = levelPrice[i - 1] * 2;
57         }
58         owner = msg.sender;
59         super = msg.sender;
60         manager = msg.sender;
61         pool = msg.sender;
62         eTPlanToken = _token;
63         _this = address(this);
64     }
65 
66     function initEnd(address _endless, uint start, uint end) OnlySuper external {
67 
68         Endless endless = Endless(address(uint160(_endless)));
69         owner = endless.owner();
70         lastUserId = end + 1;
71 
72         for (uint i = start; i <= end; i++) {
73             address currentUser = endless.userIds(i);
74             (uint id,address referrer,uint partnersCount) = endless.users(currentUser);
75             User memory user = User({
76                 id : id,
77                 referrer : referrer,
78                 partnersCount : partnersCount
79                 });
80             users[currentUser] = user;
81 
82             for (uint8 j = 1; j <= 12; j++) {
83                 if (i == 3) {
84                     users[currentUser].blocked[j] = true;
85                     users[currentUser].activeQ8Levels[j] = false;
86                 } else {
87                     bool active = endless.usersActiveX6Levels(currentUser, j);
88                     users[currentUser].activeQ8Levels[j] = active;
89                 }
90             }
91 
92             idToAddress[i] = currentUser;
93         }
94     }
95 
96     function() external payable {
97         if (msg.data.length == 0) {
98             return registration(msg.sender, owner);
99         }
100 
101         registration(msg.sender, bytesToAddress(msg.data));
102     }
103 
104     function registrationExt(address referrerAddress) external payable {
105         registration(msg.sender, referrerAddress);
106     }
107 
108     function registration(address userAddress, address referrerAddress) private {
109         require(msg.value == 0.1 ether, "registration cost 0.1");
110         require(!isUserExists(userAddress), "user exists");
111         require(isUserExists(referrerAddress), "referrer not exists");
112 
113         uint32 size;
114         assembly {
115             size := extcodesize(userAddress)
116         }
117         require(size == 0, "cannot be a contract");
118 
119         User memory user = User({
120             id : lastUserId,
121             referrer : referrerAddress,
122             partnersCount : 0
123             });
124 
125         users[userAddress] = user;
126         idToAddress[lastUserId] = userAddress;
127 
128         users[userAddress].activeQ8Levels[1] = true;
129 
130         lastUserId++;
131 
132         users[referrerAddress].partnersCount++;
133 
134         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
135 
136         updateQ8Referrer(userAddress, referrerAddress, uint8(1));
137         if (ETPlanToken(eTPlanToken).balanceOf(_this) > levelPrice[uint8(1)]) {
138             ETPlanToken(eTPlanToken).transfer(userAddress, levelPrice[uint8(1)]);
139         }
140 
141     }
142 
143     function buyNewLevel(uint8 level) external payable {
144         require(isUserExists(msg.sender), "user is not exists. Register first.");
145         require(msg.value == levelPrice[level], "invalid price");
146         require(level > 1 && level <= LAST_LEVEL, "invalid level");
147         require(!users[msg.sender].activeQ8Levels[level], "level already activated");
148 
149         if (users[msg.sender].blocked[level - 1]) {
150             users[msg.sender].blocked[level - 1] = false;
151         }
152         users[msg.sender].activeQ8Levels[level] = true;
153         updateQ8Referrer(msg.sender, users[msg.sender].referrer, level);
154         emit NewRound(msg.sender, users[msg.sender].referrer, level);
155         if (ETPlanToken(eTPlanToken).balanceOf(_this) > levelPrice[level]) {
156             ETPlanToken(eTPlanToken).transfer(msg.sender, levelPrice[level]);
157         }
158     }
159 
160     function updateQ8Referrer(address userAddress, address referrerAddress, uint8 level) private {
161         require(users[referrerAddress].activeQ8Levels[level], "500. Referrer level is inactive");
162 
163         if ((users[referrerAddress].income[level] % (levelPrice[level] / 2)) >= 6) {
164             if (!users[referrerAddress].activeQ8Levels[level + 1] && level != LAST_LEVEL) {
165                 users[referrerAddress].blocked[level] = true;
166             }
167         }
168         if (q8Matrix[level].firstLevelReferrals.length < 2) {
169             q8Matrix[level].firstLevelReferrals.push(userAddress);
170             emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].firstLevelReferrals.length));
171 
172             q8Matrix[level].currentReferrer = referrerAddress;
173             if (referrerAddress == owner) {
174                 users[owner].income[level] += levelPrice[level];
175                 return sendETHDividends(referrerAddress, userAddress, level, levelPrice[level]);
176             }
177 
178             uint poolAmount = levelPrice[level] * 20 / 100;
179             if (!address(uint160(pool)).send(poolAmount)) {
180                 return address(uint160(pool)).transfer(address(this).balance);
181             }
182             uint managerAmount = levelPrice[level] * 30 / 100;
183             if (!address(uint160(manager)).send(managerAmount)) {
184                 return address(uint160(manager)).transfer(address(this).balance);
185             }
186             address freeReferrer = findFreeQ8Referrer(userAddress, level);
187             users[freeReferrer].income[level] += levelPrice[level] / 2;
188             return sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
189         }
190         q8Matrix[level].secondLevelReferrals.push(userAddress);
191         q8Matrix[level].currentReferrer = referrerAddress;
192         emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].secondLevelReferrals.length + 2));
193 
194         if (q8Matrix[level].secondLevelReferrals.length == 1) {
195             address freeReferrer = findFreeQ8Referrer(userAddress, level);
196             users[freeReferrer].income[level] += levelPrice[level] / 2;
197             sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
198             uint poolAmount = levelPrice[level] * 20 / 100;
199             if (!address(uint160(pool)).send(poolAmount)) {
200                 return address(uint160(pool)).transfer(address(this).balance);
201             }
202             address freeReferrerRe = findFreeQ8Referrer(freeReferrer, level);
203             users[freeReferrerRe].income[level] += levelPrice[level] * 30 / 100;
204             return sendETHDividends(freeReferrerRe, userAddress, level, levelPrice[level] * 30 / 100);
205         }
206 
207         if (q8Matrix[level].secondLevelReferrals.length == 4) {//reinvest
208             q8Matrix[level].reinvestCount++;
209 
210             q8Matrix[level].firstLevelReferrals = new address[](0);
211             q8Matrix[level].secondLevelReferrals = new address[](0);
212         }
213         address freeReferrer = findFreeQ8Referrer(userAddress, level);
214         users[freeReferrer].income[level] += levelPrice[level] / 2;
215         sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
216         uint poolAmount = levelPrice[level] * 20 / 100;
217         if (!address(uint160(pool)).send(poolAmount)) {
218             return address(uint160(pool)).transfer(address(this).balance);
219         }
220         uint managerAmount = levelPrice[level] * 30 / 100;
221         if (!address(uint160(manager)).send(managerAmount)) {
222             return address(uint160(manager)).transfer(address(this).balance);
223         }
224     }
225 
226     function findFreeQ8Referrer(address userAddress, uint8 level) public view returns (address) {
227         while (true) {
228             if (users[users[userAddress].referrer].activeQ8Levels[level]) {
229                 return users[userAddress].referrer;
230             }
231 
232             userAddress = users[userAddress].referrer;
233         }
234     }
235 
236     function findEthReceiver(address userAddress, address _from, uint8 level) private returns (address, bool) {
237         address receiver = userAddress;
238         bool isExtraDividends;
239         while (true) {
240             if (users[receiver].blocked[level]) {
241                 emit MissedEthReceive(receiver, _from, level);
242                 isExtraDividends = true;
243                 receiver = users[receiver].referrer;
244             } else {
245                 return (receiver, isExtraDividends);
246             }
247         }
248     }
249 
250     function sendETHDividends(address userAddress, address _from, uint8 level, uint amount) private {
251         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);
252 
253         if (!address(uint160(receiver)).send(amount)) {
254             return address(uint160(receiver)).transfer(address(this).balance);
255         }
256 
257         if (isExtraDividends) {
258             emit SentExtraEthDividends(_from, receiver, level);
259         }
260     }
261 
262     function isUserExists(address user) public view returns (bool) {
263         return (users[user].id != 0);
264     }
265 
266     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
267         assembly {
268             addr := mload(add(bys, 20))
269         }
270     }
271 
272     function activeQ8Levels(address _user, uint8 level) public view returns (bool){
273         return users[_user].activeQ8Levels[level];
274     }
275 
276     function blocked(address _user, uint8 level) public view returns (bool){
277         return users[_user].blocked[level];
278     }
279 
280     function income(address _user, uint8 level) public view returns (uint){
281         return users[_user].income[level];
282     }
283 
284     function getq8Matrix(uint8 level) public view returns (address, address[] memory, address[] memory, uint){
285         return (q8Matrix[level].currentReferrer,
286         q8Matrix[level].firstLevelReferrals,
287         q8Matrix[level].secondLevelReferrals,
288         q8Matrix[level].reinvestCount);
289     }
290 
291     function updatePool(address _pool) public OnlySuper {
292         pool = _pool;
293     }
294 
295     function updateManager(address _manager) public OnlySuper {
296         manager = _manager;
297     }
298 
299     function updateSuper(address _super) public OnlySuper {
300         super = _super;
301     }
302 
303     function update(address _user, uint8 _level) public OnlySuper {
304         require(isUserExists(_user), "user not exists");
305         users[_user].activeQ8Levels[_level] = true;
306     }
307 
308     function withdrawELS(address _user, uint _value) public OnlySuper {
309         ETPlanToken(eTPlanToken).transfer(_user, _value);
310     }
311 }
312 
313 
314 contract Endless {
315 
316     struct User {
317         uint id;
318         address referrer;
319         uint partnersCount;
320 
321         mapping(uint8 => bool) activeX3Levels;
322         mapping(uint8 => bool) activeX6Levels;
323 
324         mapping(uint8 => X3) x3Matrix;
325         mapping(uint8 => X6) x6Matrix;
326     }
327 
328     struct X3 {
329         address currentReferrer;
330         address[] referrals;
331         bool blocked;
332         uint reinvestCount;
333     }
334 
335     struct X6 {
336         address currentReferrer;
337         address[] firstLevelReferrals;
338         address[] secondLevelReferrals;
339         bool blocked;
340         uint reinvestCount;
341 
342         address closedPart;
343     }
344 
345     uint8 public constant LAST_LEVEL = 12;
346 
347     mapping(address => User) public users;
348     mapping(uint => address) public idToAddress;
349     mapping(uint => address) public userIds;
350     mapping(address => uint) public balances;
351 
352     uint public lastUserId = 2;
353     address public owner;
354 
355     mapping(uint8 => uint) public levelPrice;
356 
357     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
358     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
359     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
360     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
361     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
362     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
363 
364 
365     constructor(address ownerAddress) public {
366         levelPrice[1] = 0.025 ether;
367         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
368             levelPrice[i] = levelPrice[i-1] * 2;
369         }
370         owner = ownerAddress;
371 
372         User memory user = User({
373             id: 1,
374             referrer: address(0),
375             partnersCount: uint(0)
376             });
377 
378         users[ownerAddress] = user;
379         idToAddress[1] = ownerAddress;
380 
381         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
382             users[ownerAddress].activeX3Levels[i] = true;
383             users[ownerAddress].activeX6Levels[i] = true;
384         }
385 
386         userIds[1] = ownerAddress;
387     }
388 
389     function() external payable {
390         if(msg.data.length == 0) {
391             return registration(msg.sender, owner);
392         }
393 
394         registration(msg.sender, bytesToAddress(msg.data));
395     }
396 
397     function registrationExt(address referrerAddress) external payable {
398         registration(msg.sender, referrerAddress);
399     }
400 
401     function buyNewLevel(uint8 matrix, uint8 level) external payable {
402         require(isUserExists(msg.sender), "user is not exists. Register first.");
403         require(matrix == 1 || matrix == 2, "invalid matrix");
404         require(msg.value == levelPrice[level], "invalid price");
405         require(level > 1 && level <= LAST_LEVEL, "invalid level");
406 
407         if (matrix == 1) {
408             require(!users[msg.sender].activeX3Levels[level], "level already activated");
409 
410             if (users[msg.sender].x3Matrix[level-1].blocked) {
411                 users[msg.sender].x3Matrix[level-1].blocked = false;
412             }
413 
414             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
415             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
416             users[msg.sender].activeX3Levels[level] = true;
417             updateX3Referrer(msg.sender, freeX3Referrer, level);
418 
419             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
420 
421         } else {
422             require(!users[msg.sender].activeX6Levels[level], "level already activated");
423 
424             if (users[msg.sender].x6Matrix[level-1].blocked) {
425                 users[msg.sender].x6Matrix[level-1].blocked = false;
426             }
427 
428             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
429 
430             users[msg.sender].activeX6Levels[level] = true;
431             updateX6Referrer(msg.sender, freeX6Referrer, level);
432 
433             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
434         }
435     }
436 
437     function registration(address userAddress, address referrerAddress) private {
438         require(msg.value == 0.05 ether, "registration cost 0.05");
439         require(!isUserExists(userAddress), "user exists");
440         require(isUserExists(referrerAddress), "referrer not exists");
441 
442         uint32 size;
443         assembly {
444             size := extcodesize(userAddress)
445         }
446         require(size == 0, "cannot be a contract");
447 
448         User memory user = User({
449             id: lastUserId,
450             referrer: referrerAddress,
451             partnersCount: 0
452             });
453 
454         users[userAddress] = user;
455         idToAddress[lastUserId] = userAddress;
456 
457         users[userAddress].referrer = referrerAddress;
458 
459         users[userAddress].activeX3Levels[1] = true;
460         users[userAddress].activeX6Levels[1] = true;
461 
462 
463         userIds[lastUserId] = userAddress;
464         lastUserId++;
465 
466         users[referrerAddress].partnersCount++;
467 
468         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);//获取上级开通了当前等级的邀请人地址
469         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
470         updateX3Referrer(userAddress, freeX3Referrer, 1);
471 
472         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
473 
474         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
475     }
476 
477     //修改x3矩阵的邀请情况
478     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
479         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);//？
480 
481         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {//x3矩阵少于3 发送eth给邀请人
482             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
483             return sendETHDividends(referrerAddress, userAddress, 1, level);
484         }
485 
486         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
487         //close matrix
488         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
489         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
490             users[referrerAddress].x3Matrix[level].blocked = true;
491         }
492 
493         //create new one by recursion
494         if (referrerAddress != owner) {
495             //check referrer active level
496             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
497             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
498                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
499             }
500 
501             users[referrerAddress].x3Matrix[level].reinvestCount++;
502             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
503             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
504         } else {
505             sendETHDividends(owner, userAddress, 1, level);
506             users[owner].x3Matrix[level].reinvestCount++;
507             emit Reinvest(owner, address(0), userAddress, 1, level);
508         }
509     }
510 
511     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
512         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
513 
514         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
515             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
516             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
517 
518             //set current level
519             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
520 
521             if (referrerAddress == owner) {
522                 return sendETHDividends(referrerAddress, userAddress, 2, level);
523             }
524 
525             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;
526             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress);
527 
528             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
529 
530             if ((len == 2) &&
531             (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
532                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
533                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
534                     emit NewUserPlace(userAddress, ref, 2, level, 5);
535                 } else {
536                     emit NewUserPlace(userAddress, ref, 2, level, 6);
537                 }
538             }  else if ((len == 1 || len == 2) &&
539             users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
540                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
541                     emit NewUserPlace(userAddress, ref, 2, level, 3);
542                 } else {
543                     emit NewUserPlace(userAddress, ref, 2, level, 4);
544                 }
545             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
546                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
547                     emit NewUserPlace(userAddress, ref, 2, level, 5);
548                 } else {
549                     emit NewUserPlace(userAddress, ref, 2, level, 6);
550                 }
551             }
552 
553             return updateX6ReferrerSecondLevel(userAddress, ref, level);
554         }
555 
556         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
557 
558         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
559             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
560             users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
561                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
562                 users[referrerAddress].x6Matrix[level].closedPart)) {
563 
564                 updateX6(userAddress, referrerAddress, level, true);
565                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
566             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
567                 users[referrerAddress].x6Matrix[level].closedPart) {
568                 updateX6(userAddress, referrerAddress, level, true);
569                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
570             } else {
571                 updateX6(userAddress, referrerAddress, level, false);
572                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
573             }
574         }
575 
576         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
577             updateX6(userAddress, referrerAddress, level, false);
578             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
579         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
580             updateX6(userAddress, referrerAddress, level, true);
581             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
582         }
583 
584         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <=
585             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
586             updateX6(userAddress, referrerAddress, level, false);
587         } else {
588             updateX6(userAddress, referrerAddress, level, true);
589         }
590 
591         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
592     }
593 
594     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
595         if (!x2) {
596             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
597             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
598             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
599             //set current level
600             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
601         } else {
602             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
603             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
604             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
605             //set current level
606             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
607         }
608     }
609 
610     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
611         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
612             return sendETHDividends(referrerAddress, userAddress, 2, level);
613         }
614 
615         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
616 
617         if (x6.length == 2) {
618             if (x6[0] == referrerAddress ||
619             x6[1] == referrerAddress) {
620                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
621             } else if (x6.length == 1) {
622                 if (x6[0] == referrerAddress) {
623                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
624                 }
625             }
626         }
627 
628         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
629         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
630         users[referrerAddress].x6Matrix[level].closedPart = address(0);
631 
632         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
633             users[referrerAddress].x6Matrix[level].blocked = true;
634         }
635 
636         users[referrerAddress].x6Matrix[level].reinvestCount++;
637 
638         if (referrerAddress != owner) {
639             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
640 
641             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
642             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
643         } else {
644             emit Reinvest(owner, address(0), userAddress, 2, level);
645             sendETHDividends(owner, userAddress, 2, level);
646         }
647     }
648 
649     //寻找到上面开通当前等级的邀请人
650     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
651         while (true) {
652             if (users[users[userAddress].referrer].activeX3Levels[level]) {
653                 return users[userAddress].referrer;
654             }
655 
656             userAddress = users[userAddress].referrer;
657         }
658     }
659 
660     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
661         while (true) {
662             if (users[users[userAddress].referrer].activeX6Levels[level]) {
663                 return users[userAddress].referrer;
664             }
665 
666             userAddress = users[userAddress].referrer;
667         }
668     }
669 
670     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
671         return users[userAddress].activeX3Levels[level];
672     }
673 
674     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
675         return users[userAddress].activeX6Levels[level];
676     }
677 
678     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool ,uint) {
679         return (users[userAddress].x3Matrix[level].currentReferrer,
680         users[userAddress].x3Matrix[level].referrals,
681         users[userAddress].x3Matrix[level].blocked,
682         users[userAddress].x3Matrix[level].reinvestCount);
683     }
684 
685     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address,uint) {
686         return (users[userAddress].x6Matrix[level].currentReferrer,
687         users[userAddress].x6Matrix[level].firstLevelReferrals,
688         users[userAddress].x6Matrix[level].secondLevelReferrals,
689         users[userAddress].x6Matrix[level].blocked,
690         users[userAddress].x6Matrix[level].closedPart,
691         users[userAddress].x6Matrix[level].reinvestCount);
692     }
693 
694     function isUserExists(address user) public view returns (bool) {
695         return (users[user].id != 0);
696     }
697 
698     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
699         address receiver = userAddress;
700         bool isExtraDividends;
701         if (matrix == 1) {
702             while (true) {
703                 if (users[receiver].x3Matrix[level].blocked) {
704                     emit MissedEthReceive(receiver, _from, 1, level);
705                     isExtraDividends = true;
706                     receiver = users[receiver].x3Matrix[level].currentReferrer;
707                 } else {
708                     return (receiver, isExtraDividends);
709                 }
710             }
711         } else {
712             while (true) {
713                 if (users[receiver].x6Matrix[level].blocked) {
714                     emit MissedEthReceive(receiver, _from, 2, level);
715                     isExtraDividends = true;
716                     receiver = users[receiver].x6Matrix[level].currentReferrer;
717                 } else {
718                     return (receiver, isExtraDividends);
719                 }
720             }
721         }
722     }
723 
724     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
725         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
726 
727         if (!address(uint160(receiver)).send(levelPrice[level])) {
728             return address(uint160(receiver)).transfer(address(this).balance);
729         }
730 
731         if (isExtraDividends) {
732             emit SentExtraEthDividends(_from, receiver, matrix, level);
733         }
734     }
735 
736     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
737         assembly {
738             addr := mload(add(bys, 20))
739         }
740     }
741 }
742 
743 library SafeMath {
744     /**
745     * @dev Multiplies two numbers, throws on overflow.
746     */
747     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
748         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
749         // benefit is lost if 'b' is also tested.
750         // See: https://github.com/OpenZeppelin/openzeppelin- solidity/pull/522
751         if (a == 0) {
752             return 0;
753         }
754         c = a * b;
755         assert(c / a == b);
756         return c;
757     }
758     /**
759     * @dev Integer division of two numbers, truncating the quotient. 
760     */
761     function div(uint256 a, uint256 b) internal pure returns (uint256) {
762         assert(b > 0);
763         // uint256 c = a / b;
764         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
765         return a / b;
766     }
767     /**
768     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
769     */
770     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
771         assert(b <= a);
772         return a - b;
773     }
774     /**
775     * @dev Adds two numbers, throws on overflow.
776     */
777     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
778         c = a + b;
779         assert(c >= a);
780         return c;
781     }
782 }
783 
784 contract Token {
785 
786     /// @return total amount of tokens
787     //function totalSupply() public view returns (uint supply);
788 
789     /// @param _owner The address from which the balance will be retrieved
790     /// @return The balance
791     function balanceOf(address _owner) public view returns (uint balance);
792 
793     /// @notice send `_value` token to `_to` from `msg.sender`
794     /// @param _to The address of the recipient
795     /// @param _value The amount of token to be transferred
796     /// @return Whether the transfer was successful or not
797     function transfer(address _to, uint _value) public returns (bool success);
798 
799     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
800     /// @param _from The address of the sender
801     /// @param _to The address of the recipient
802     /// @param _value The amount of token to be transferred
803     /// @return Whether the transfer was successful or not
804     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
805 
806     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
807     /// @param _spender The address of the account able to transfer the tokens
808     /// @param _value The amount of wei to be approved for transfer
809     /// @return Whether the approval was successful or not
810     function approve(address _spender, uint _value) public returns (bool success);
811 
812     /// @param _owner The address of the account owning tokens
813     /// @param _spender The address of the account able to transfer the tokens
814     /// @return Amount of remaining tokens allowed to spent
815     function allowance(address _owner, address _spender) public view returns (uint remaining);
816 
817     event Transfer(address indexed _from, address indexed _to, uint _value);
818     event Approval(address indexed _owner, address indexed _spender, uint _value);
819 }
820 
821 contract RegularToken is Token {
822 
823     using SafeMath for uint256;
824 
825     function transfer(address _to, uint _value) public returns (bool) {
826         require(_to != address(0));
827         //Default assumes totalSupply can't be over max (2^256 - 1).
828         require(balances[msg.sender] >= _value);
829         balances[msg.sender] = balances[msg.sender].sub(_value);
830         balances[_to] = balances[_to].add(_value);
831         emit Transfer(msg.sender, _to, _value);
832         return true;
833     }
834 
835     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
836         require(_to != address(0));
837         require(balances[_from] >= _value);
838         require(allowed[_from][msg.sender] >= _value);
839 
840         balances[_to] = balances[_to].add(_value);
841         balances[_from] = balances[_from].sub(_value);
842         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
843         emit Transfer(_from, _to, _value);
844         return true;
845     }
846 
847     function balanceOf(address _owner) public view returns (uint) {
848         return balances[_owner];
849     }
850 
851     function approve(address _spender, uint _value) public returns (bool) {
852         require(_spender != address(0));
853         allowed[msg.sender][_spender] = _value;
854         emit Approval(msg.sender, _spender, _value);
855         return true;
856     }
857 
858     function allowance(address _owner, address _spender) public view returns (uint) {
859         return allowed[_owner][_spender];
860     }
861 
862     mapping(address => uint) balances;
863     mapping(address => mapping(address => uint)) allowed;
864     uint public totalSupply;
865 }
866 
867 contract UnboundedRegularToken is RegularToken {
868 
869     uint constant MAX_UINT = 2 ** 256 - 1;
870 
871     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
872     /// @param _from Address to transfer from.
873     /// @param _to Address to transfer to.
874     /// @param _value Amount to transfer.
875     /// @return Success of transfer.
876     function transferFrom(address _from, address _to, uint _value)
877     public
878     returns (bool)
879     {
880         require(_to != address(0));
881         uint allowance = allowed[_from][msg.sender];
882 
883         require(balances[_from] >= _value);
884         require(allowance >= _value);
885 
886         balances[_to] = balances[_to].add(_value);
887         balances[_from] = balances[_from].sub(_value);
888         if (allowance < MAX_UINT) {
889             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
890         }
891         emit Transfer(_from, _to, _value);
892         return true;
893     }
894 }
895 
896 contract ETPlanToken is UnboundedRegularToken {
897 
898     uint8 constant public decimals = 18;
899     string constant public name = "ETPlanToken";
900     string constant public symbol = "ELS";
901 
902     constructor() public {
903         totalSupply = 33 * 10 ** 25;
904         balances[msg.sender] = totalSupply;
905         emit Transfer(address(0), msg.sender, totalSupply);
906     }
907 }