1 pragma solidity >=0.4.23 <0.6.0;
2 
3 /**
4 * eplans.vip
5 **/
6 contract ETPlanV3 {
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
53     constructor() public {
54         levelPrice[1] = 0.1 ether;
55         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
56             levelPrice[i] = levelPrice[i - 1] * 2;
57         }
58         _this = address(this);
59         super = msg.sender;
60     }
61 
62     function initQ8(address _etplan) OnlySuper external {
63         ETPlanV2 etplan = ETPlanV2(address(uint160(_etplan)));
64         owner = etplan.owner();
65         manager = etplan.manager();
66         pool = etplan.pool();
67         eTPlanToken = etplan.eTPlanToken();
68 
69         for (uint8 j = 1; j <= 12; j++) {
70             (address currentReferrer, address[] memory firstLevelReferrals
71             , address[] memory secondLevelReferrals,
72             uint reinvestCount) = etplan.getq8Matrix(j);
73             q8Matrix[j].currentReferrer = currentReferrer;
74             q8Matrix[j].firstLevelReferrals = firstLevelReferrals;
75             q8Matrix[j].secondLevelReferrals = secondLevelReferrals;
76             q8Matrix[j].reinvestCount = reinvestCount;
77         }
78     }
79 
80     function initData(address _etplan, uint start, uint end) OnlySuper external {
81 
82         ETPlanV2 etplan = ETPlanV2(address(uint160(_etplan)));
83 
84         lastUserId = end + 1;
85 
86         for (uint i = start; i <= end; i++) {
87             address currentUser = etplan.idToAddress(i);
88             (uint id,address referrer,uint partnersCount) = etplan.users(currentUser);
89             User memory user = User({
90                 id : id,
91                 referrer : referrer,
92                 partnersCount : partnersCount
93                 });
94             users[currentUser] = user;
95 
96             for (uint8 j = 1; j <= 12; j++) {
97                 if (i == 3) {
98                     users[currentUser].blocked[j] = true;
99                     users[currentUser].activeQ8Levels[j] = false;
100                 } else {
101                     bool active = etplan.activeQ8Levels(currentUser, j);
102                     users[currentUser].activeQ8Levels[j] = active;
103                     users[currentUser].income[j] = etplan.income(currentUser, j);
104                 }
105             }
106 
107             idToAddress[i] = currentUser;
108         }
109     }
110 
111     function() external payable {
112         if (msg.data.length == 0) {
113             return registration(msg.sender, owner);
114         }
115 
116         registration(msg.sender, bytesToAddress(msg.data));
117     }
118 
119     function registrationExt(address referrerAddress) external payable {
120         registration(msg.sender, referrerAddress);
121     }
122 
123     function registration(address userAddress, address referrerAddress) private {
124         require(msg.value == 0.1 ether, "registration cost 0.1");
125         require(!isUserExists(userAddress), "user exists");
126         require(isUserExists(referrerAddress), "referrer not exists");
127 
128         uint32 size;
129         assembly {
130             size := extcodesize(userAddress)
131         }
132         require(size == 0, "cannot be a contract");
133 
134         User memory user = User({
135             id : lastUserId,
136             referrer : referrerAddress,
137             partnersCount : 0
138             });
139 
140         users[userAddress] = user;
141         idToAddress[lastUserId] = userAddress;
142 
143         users[userAddress].activeQ8Levels[1] = true;
144 
145         lastUserId++;
146 
147         users[referrerAddress].partnersCount++;
148 
149         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
150 
151         updateQ8Referrer(userAddress, referrerAddress, uint8(1));
152         if (ETPlanToken(eTPlanToken).balanceOf(_this) >= (levelPrice[uint8(1)] * 3 / 2)) {
153             ETPlanToken(eTPlanToken).transfer(userAddress, levelPrice[uint8(1)]);
154             ETPlanToken(eTPlanToken).transfer(referrerAddress, levelPrice[uint8(1)] / 2);
155         }
156 
157     }
158 
159     function buyNewLevel(uint8 level) external payable {
160         require(isUserExists(msg.sender), "user is not exists. Register first.");
161         require(msg.value == levelPrice[level], "invalid price");
162         require(level > 1 && level <= LAST_LEVEL, "invalid level");
163         require(!users[msg.sender].activeQ8Levels[level], "level already activated");
164 
165         if (users[msg.sender].blocked[level - 1]) {
166             users[msg.sender].blocked[level - 1] = false;
167         }
168         users[msg.sender].activeQ8Levels[level] = true;
169         address freeReferrer = findFreeQ8Referrer(msg.sender, level);
170         updateQ8Referrer(msg.sender, freeReferrer, level);
171         emit NewRound(msg.sender, freeReferrer, level);
172         if (ETPlanToken(eTPlanToken).balanceOf(_this) >= (levelPrice[level] * 3 / 2)) {
173             ETPlanToken(eTPlanToken).transfer(msg.sender, levelPrice[level]);
174             ETPlanToken(eTPlanToken).transfer(freeReferrer, levelPrice[level] / 2);
175         }
176     }
177 
178     function updateQ8Referrer(address userAddress, address referrerAddress, uint8 level) private {
179         require(users[referrerAddress].activeQ8Levels[level], "500. Referrer level is inactive");
180 
181         if ((users[referrerAddress].income[level] / (levelPrice[level] / 2)) >= 6) {
182             if (!users[referrerAddress].activeQ8Levels[level + 1] && level != LAST_LEVEL) {
183                 users[referrerAddress].blocked[level] = true;
184             }
185         }
186         if (q8Matrix[level].firstLevelReferrals.length < 2) {
187             q8Matrix[level].firstLevelReferrals.push(userAddress);
188             emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].firstLevelReferrals.length));
189 
190             q8Matrix[level].currentReferrer = referrerAddress;
191             if (referrerAddress == owner) {
192                 users[owner].income[level] += levelPrice[level];
193                 return sendETHDividends(referrerAddress, userAddress, level, levelPrice[level]);
194             }
195 
196             uint poolAmount = levelPrice[level] * 20 / 100;
197             if (!address(uint160(pool)).send(poolAmount)) {
198                 return address(uint160(pool)).transfer(address(this).balance);
199             }
200             uint managerAmount = levelPrice[level] * 30 / 100;
201             if (!address(uint160(manager)).send(managerAmount)) {
202                 return address(uint160(manager)).transfer(address(this).balance);
203             }
204             address freeReferrer = findFreeQ8Referrer(userAddress, level);
205             users[freeReferrer].income[level] += levelPrice[level] / 2;
206             return sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
207         }
208         q8Matrix[level].secondLevelReferrals.push(userAddress);
209         q8Matrix[level].currentReferrer = referrerAddress;
210         emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].secondLevelReferrals.length + 2));
211 
212         if (q8Matrix[level].secondLevelReferrals.length == 1) {
213             address freeReferrer = findFreeQ8Referrer(userAddress, level);
214             users[freeReferrer].income[level] += levelPrice[level] / 2;
215             sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
216             uint poolAmount = levelPrice[level] * 20 / 100;
217             if (!address(uint160(pool)).send(poolAmount)) {
218                 return address(uint160(pool)).transfer(address(this).balance);
219             }
220             address freeReferrerRe = findFreeQ8Referrer(freeReferrer, level);
221             users[freeReferrerRe].income[level] += levelPrice[level] * 30 / 100;
222             return sendETHDividends(freeReferrerRe, userAddress, level, levelPrice[level] * 30 / 100);
223         }
224 
225         if (q8Matrix[level].secondLevelReferrals.length == 4) {//reinvest
226             q8Matrix[level].reinvestCount++;
227 
228             q8Matrix[level].firstLevelReferrals = new address[](0);
229             q8Matrix[level].secondLevelReferrals = new address[](0);
230         }
231         address freeReferrer = findFreeQ8Referrer(userAddress, level);
232         users[freeReferrer].income[level] += levelPrice[level] / 2;
233         sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
234         uint poolAmount = levelPrice[level] * 20 / 100;
235         if (!address(uint160(pool)).send(poolAmount)) {
236             return address(uint160(pool)).transfer(address(this).balance);
237         }
238         uint managerAmount = levelPrice[level] * 30 / 100;
239         if (!address(uint160(manager)).send(managerAmount)) {
240             return address(uint160(manager)).transfer(address(this).balance);
241         }
242     }
243 
244     function findFreeQ8Referrer(address userAddress, uint8 level) public view returns (address) {
245         while (true) {
246             if (users[users[userAddress].referrer].activeQ8Levels[level]) {
247                 return users[userAddress].referrer;
248             }
249 
250             userAddress = users[userAddress].referrer;
251         }
252     }
253 
254     function findEthReceiver(address userAddress, address _from, uint8 level) private returns (address, bool) {
255         address receiver = userAddress;
256         bool isExtraDividends;
257         while (true) {
258             if (users[receiver].blocked[level]) {
259                 emit MissedEthReceive(receiver, _from, level);
260                 isExtraDividends = true;
261                 receiver = users[receiver].referrer;
262             } else {
263                 return (receiver, isExtraDividends);
264             }
265         }
266     }
267 
268     function sendETHDividends(address userAddress, address _from, uint8 level, uint amount) private {
269         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);
270 
271         if (!address(uint160(receiver)).send(amount)) {
272             return address(uint160(receiver)).transfer(address(this).balance);
273         }
274 
275         if (isExtraDividends) {
276             emit SentExtraEthDividends(_from, receiver, level);
277         }
278     }
279 
280     function isUserExists(address user) public view returns (bool) {
281         return (users[user].id != 0);
282     }
283 
284     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
285         assembly {
286             addr := mload(add(bys, 20))
287         }
288     }
289 
290     function activeQ8Levels(address _user, uint8 level) public view returns (bool){
291         return users[_user].activeQ8Levels[level];
292     }
293 
294     function blocked(address _user, uint8 level) public view returns (bool){
295         return users[_user].blocked[level];
296     }
297 
298     function income(address _user, uint8 level) public view returns (uint){
299         return users[_user].income[level];
300     }
301 
302     function getUserInfo(address _user, uint8 level) public view returns (bool, bool, uint){
303         return (users[_user].activeQ8Levels[level]
304         , users[_user].blocked[level]
305         , users[_user].income[level]);
306     }
307 
308     function getq8Matrix(uint8 level) public view returns (address, address[] memory, address[] memory, uint){
309         return (q8Matrix[level].currentReferrer,
310         q8Matrix[level].firstLevelReferrals,
311         q8Matrix[level].secondLevelReferrals,
312         q8Matrix[level].reinvestCount);
313     }
314 
315     function updatePool(address _pool) public OnlySuper {
316         pool = _pool;
317     }
318 
319     function updateManager(address _manager) public OnlySuper {
320         manager = _manager;
321     }
322 
323     function updateSuper(address _super) public OnlySuper {
324         super = _super;
325     }
326 
327     function update(address _user, uint8 _level) public OnlySuper {
328         require(isUserExists(_user), "user not exists");
329         users[_user].activeQ8Levels[_level] = !users[_user].activeQ8Levels[_level];
330     }
331 
332     function updateBlocked(address _user, uint8 _level) public OnlySuper {
333         require(isUserExists(_user), "user not exists");
334         users[_user].blocked[_level] = !users[_user].blocked[_level];
335     }
336 
337     function withdrawELS(address _user, uint _value) public OnlySuper {
338         ETPlanToken(eTPlanToken).transfer(_user, _value);
339     }
340 }
341 
342 
343 contract ETPlanV2 {
344 
345     struct User {
346         uint id;
347         address referrer;
348         uint partnersCount;
349 
350         mapping(uint8 => bool) activeQ8Levels;
351         mapping(uint8 => bool) blocked;
352         mapping(uint8 => uint) income;
353     }
354 
355     struct Q8 {
356         address currentReferrer;
357         address[] firstLevelReferrals;
358         address[] secondLevelReferrals;
359         uint reinvestCount;
360     }
361 
362     uint8 public constant LAST_LEVEL = 12;
363 
364     uint public lastUserId = 2;
365     address public owner;
366     address public pool;
367     address public manager;
368     address public eTPlanToken;
369 
370     mapping(uint8 => uint) public levelPrice;
371     mapping(uint8 => Q8) public q8Matrix;
372     mapping(address => User) public users;
373     mapping(uint => address) public idToAddress;
374 
375     event NewUserPlace(address indexed user, address indexed referrer, uint8 level, uint8 place);
376     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
377     event MissedEthReceive(address indexed receiver, address indexed from, uint8 level);
378     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 level);
379     event NewRound(address indexed user, address indexed referrer, uint8 level);
380 
381     address public super;
382 
383     address public _this;
384 
385     modifier OnlySuper {
386         require(msg.sender == super);
387         _;
388     }
389 
390     constructor() public {
391         levelPrice[1] = 0.1 ether;
392         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
393             levelPrice[i] = levelPrice[i - 1] * 2;
394         }
395         _this = address(this);
396         super = msg.sender;
397     }
398 
399     function initQ8(address _etplan) OnlySuper external {
400         ETPlan etplan = ETPlan(address(uint160(_etplan)));
401         for (uint8 j = 1; j <= 12; j++) {
402             (address currentReferrer, address[] memory firstLevelReferrals
403             , address[] memory secondLevelReferrals,
404             uint reinvestCount) = etplan.getq8Matrix(j);
405             q8Matrix[j].currentReferrer = currentReferrer;
406             q8Matrix[j].firstLevelReferrals = firstLevelReferrals;
407             q8Matrix[j].secondLevelReferrals = secondLevelReferrals;
408             q8Matrix[j].reinvestCount = reinvestCount;
409         }
410     }
411 
412     function initData(address _etplan, uint start, uint end) OnlySuper external {
413 
414         ETPlan etplan = ETPlan(address(uint160(_etplan)));
415         owner = etplan.owner();
416         manager = etplan.manager();
417         pool = etplan.pool();
418         eTPlanToken = etplan.eTPlanToken();
419         lastUserId = end + 1;
420 
421         for (uint i = start; i <= end; i++) {
422             address currentUser = etplan.idToAddress(i);
423             (uint id,address referrer,uint partnersCount) = etplan.users(currentUser);
424             User memory user = User({
425                 id : id,
426                 referrer : referrer,
427                 partnersCount : partnersCount
428                 });
429             users[currentUser] = user;
430 
431             for (uint8 j = 1; j <= 12; j++) {
432                 if (i == 3) {
433                     users[currentUser].blocked[j] = true;
434                     users[currentUser].activeQ8Levels[j] = false;
435                 } else {
436                     bool active = etplan.activeQ8Levels(currentUser, j);
437                     users[currentUser].activeQ8Levels[j] = active;
438                     users[currentUser].income[j] = etplan.income(currentUser, j);
439                 }
440             }
441 
442             idToAddress[i] = currentUser;
443         }
444     }
445 
446     function() external payable {
447         if (msg.data.length == 0) {
448             return registration(msg.sender, owner);
449         }
450 
451         registration(msg.sender, bytesToAddress(msg.data));
452     }
453 
454     function registrationExt(address referrerAddress) external payable {
455         registration(msg.sender, referrerAddress);
456     }
457 
458     function registration(address userAddress, address referrerAddress) private {
459         require(msg.value == 0.1 ether, "registration cost 0.1");
460         require(!isUserExists(userAddress), "user exists");
461         require(isUserExists(referrerAddress), "referrer not exists");
462 
463         uint32 size;
464         assembly {
465             size := extcodesize(userAddress)
466         }
467         require(size == 0, "cannot be a contract");
468 
469         User memory user = User({
470             id : lastUserId,
471             referrer : referrerAddress,
472             partnersCount : 0
473             });
474 
475         users[userAddress] = user;
476         idToAddress[lastUserId] = userAddress;
477 
478         users[userAddress].activeQ8Levels[1] = true;
479 
480         lastUserId++;
481 
482         users[referrerAddress].partnersCount++;
483 
484         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
485 
486         updateQ8Referrer(userAddress, referrerAddress, uint8(1));
487         if (ETPlanToken(eTPlanToken).balanceOf(_this) >= (levelPrice[uint8(1)] * 3 / 2)) {
488             ETPlanToken(eTPlanToken).transfer(userAddress, levelPrice[uint8(1)]);
489             ETPlanToken(eTPlanToken).transfer(referrerAddress, levelPrice[uint8(1)] / 2);
490         }
491 
492     }
493 
494     function buyNewLevel(uint8 level) external payable {
495         require(isUserExists(msg.sender), "user is not exists. Register first.");
496         require(msg.value == levelPrice[level], "invalid price");
497         require(level > 1 && level <= LAST_LEVEL, "invalid level");
498         require(!users[msg.sender].activeQ8Levels[level], "level already activated");
499 
500         if (users[msg.sender].blocked[level - 1]) {
501             users[msg.sender].blocked[level - 1] = false;
502         }
503         users[msg.sender].activeQ8Levels[level] = true;
504         address freeReferrer = findFreeQ8Referrer(msg.sender, level);
505         updateQ8Referrer(msg.sender, freeReferrer, level);
506         emit NewRound(msg.sender, freeReferrer, level);
507         if (ETPlanToken(eTPlanToken).balanceOf(_this) >= (levelPrice[level] * 3 / 2)) {
508             ETPlanToken(eTPlanToken).transfer(msg.sender, levelPrice[level]);
509             ETPlanToken(eTPlanToken).transfer(freeReferrer, levelPrice[level] / 2);
510         }
511     }
512 
513     function updateQ8Referrer(address userAddress, address referrerAddress, uint8 level) private {
514         require(users[referrerAddress].activeQ8Levels[level], "500. Referrer level is inactive");
515 
516         if ((users[referrerAddress].income[level] % (levelPrice[level] / 2)) >= 6) {
517             if (!users[referrerAddress].activeQ8Levels[level + 1] && level != LAST_LEVEL) {
518                 users[referrerAddress].blocked[level] = true;
519             }
520         }
521         if (q8Matrix[level].firstLevelReferrals.length < 2) {
522             q8Matrix[level].firstLevelReferrals.push(userAddress);
523             emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].firstLevelReferrals.length));
524 
525             q8Matrix[level].currentReferrer = referrerAddress;
526             if (referrerAddress == owner) {
527                 users[owner].income[level] += levelPrice[level];
528                 return sendETHDividends(referrerAddress, userAddress, level, levelPrice[level]);
529             }
530 
531             uint poolAmount = levelPrice[level] * 20 / 100;
532             if (!address(uint160(pool)).send(poolAmount)) {
533                 return address(uint160(pool)).transfer(address(this).balance);
534             }
535             uint managerAmount = levelPrice[level] * 30 / 100;
536             if (!address(uint160(manager)).send(managerAmount)) {
537                 return address(uint160(manager)).transfer(address(this).balance);
538             }
539             address freeReferrer = findFreeQ8Referrer(userAddress, level);
540             users[freeReferrer].income[level] += levelPrice[level] / 2;
541             return sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
542         }
543         q8Matrix[level].secondLevelReferrals.push(userAddress);
544         q8Matrix[level].currentReferrer = referrerAddress;
545         emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].secondLevelReferrals.length + 2));
546 
547         if (q8Matrix[level].secondLevelReferrals.length == 1) {
548             address freeReferrer = findFreeQ8Referrer(userAddress, level);
549             users[freeReferrer].income[level] += levelPrice[level] / 2;
550             sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
551             uint poolAmount = levelPrice[level] * 20 / 100;
552             if (!address(uint160(pool)).send(poolAmount)) {
553                 return address(uint160(pool)).transfer(address(this).balance);
554             }
555             address freeReferrerRe = findFreeQ8Referrer(freeReferrer, level);
556             users[freeReferrerRe].income[level] += levelPrice[level] * 30 / 100;
557             return sendETHDividends(freeReferrerRe, userAddress, level, levelPrice[level] * 30 / 100);
558         }
559 
560         if (q8Matrix[level].secondLevelReferrals.length == 4) {//reinvest
561             q8Matrix[level].reinvestCount++;
562 
563             q8Matrix[level].firstLevelReferrals = new address[](0);
564             q8Matrix[level].secondLevelReferrals = new address[](0);
565         }
566         address freeReferrer = findFreeQ8Referrer(userAddress, level);
567         users[freeReferrer].income[level] += levelPrice[level] / 2;
568         sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
569         uint poolAmount = levelPrice[level] * 20 / 100;
570         if (!address(uint160(pool)).send(poolAmount)) {
571             return address(uint160(pool)).transfer(address(this).balance);
572         }
573         uint managerAmount = levelPrice[level] * 30 / 100;
574         if (!address(uint160(manager)).send(managerAmount)) {
575             return address(uint160(manager)).transfer(address(this).balance);
576         }
577     }
578 
579     function findFreeQ8Referrer(address userAddress, uint8 level) public view returns (address) {
580         while (true) {
581             if (users[users[userAddress].referrer].activeQ8Levels[level]) {
582                 return users[userAddress].referrer;
583             }
584 
585             userAddress = users[userAddress].referrer;
586         }
587     }
588 
589     function findEthReceiver(address userAddress, address _from, uint8 level) private returns (address, bool) {
590         address receiver = userAddress;
591         bool isExtraDividends;
592         while (true) {
593             if (users[receiver].blocked[level]) {
594                 emit MissedEthReceive(receiver, _from, level);
595                 isExtraDividends = true;
596                 receiver = users[receiver].referrer;
597             } else {
598                 return (receiver, isExtraDividends);
599             }
600         }
601     }
602 
603     function sendETHDividends(address userAddress, address _from, uint8 level, uint amount) private {
604         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);
605 
606         if (!address(uint160(receiver)).send(amount)) {
607             return address(uint160(receiver)).transfer(address(this).balance);
608         }
609 
610         if (isExtraDividends) {
611             emit SentExtraEthDividends(_from, receiver, level);
612         }
613     }
614 
615     function isUserExists(address user) public view returns (bool) {
616         return (users[user].id != 0);
617     }
618 
619     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
620         assembly {
621             addr := mload(add(bys, 20))
622         }
623     }
624 
625     function activeQ8Levels(address _user, uint8 level) public view returns (bool){
626         return users[_user].activeQ8Levels[level];
627     }
628 
629     function blocked(address _user, uint8 level) public view returns (bool){
630         return users[_user].blocked[level];
631     }
632 
633     function income(address _user, uint8 level) public view returns (uint){
634         return users[_user].income[level];
635     }
636     function getq8Matrix(uint8 level) public view returns (address, address[] memory, address[] memory, uint){
637         return (q8Matrix[level].currentReferrer,
638         q8Matrix[level].firstLevelReferrals,
639         q8Matrix[level].secondLevelReferrals,
640         q8Matrix[level].reinvestCount);
641     }
642 
643     function updatePool(address _pool) public OnlySuper {
644         pool = _pool;
645     }
646 
647     function updateManager(address _manager) public OnlySuper {
648         manager = _manager;
649     }
650 
651     function updateSuper(address _super) public OnlySuper {
652         super = _super;
653     }
654 
655     function update(address _user, uint8 _level) public OnlySuper {
656         require(isUserExists(_user), "user not exists");
657         users[_user].activeQ8Levels[_level] = !users[_user].activeQ8Levels[_level];
658     }
659 
660     function updateBlocked(address _user, uint8 _level) public OnlySuper {
661         require(isUserExists(_user), "user not exists");
662         users[_user].blocked[_level] = !users[_user].blocked[_level];
663     }
664 
665     function withdrawELS(address _user, uint _value) public OnlySuper {
666         ETPlanToken(eTPlanToken).transfer(_user, _value);
667     }
668 }
669 
670 
671 contract ETPlan {
672 
673     struct User {
674         uint id;
675         address referrer;
676         uint partnersCount;
677 
678         mapping(uint8 => bool) activeQ8Levels;
679         mapping(uint8 => bool) blocked;
680         mapping(uint8 => uint) income;
681     }
682 
683     struct Q8 {
684         address currentReferrer;
685         address[] firstLevelReferrals;
686         address[] secondLevelReferrals;
687         uint reinvestCount;
688     }
689 
690     uint8 public constant LAST_LEVEL = 12;
691 
692     uint public lastUserId = 2;
693     address public owner;
694     address public pool;
695     address public manager;
696     address public eTPlanToken;
697 
698     mapping(uint8 => uint) public levelPrice;
699     mapping(uint8 => Q8) public q8Matrix;
700     mapping(address => User) public users;
701     mapping(uint => address) public idToAddress;
702 
703     event NewUserPlace(address indexed user, address indexed referrer, uint8 level, uint8 place);
704     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
705     event MissedEthReceive(address indexed receiver, address indexed from, uint8 level);
706     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 level);
707     event NewRound(address indexed user, address indexed referrer, uint8 level);
708 
709     address public super;
710 
711     address public _this;
712 
713     modifier OnlySuper {
714         require(msg.sender == super);
715         _;
716     }
717 
718     constructor(address _token) public {
719         levelPrice[1] = 0.1 ether;
720         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
721             levelPrice[i] = levelPrice[i - 1] * 2;
722         }
723         owner = msg.sender;
724         super = msg.sender;
725         manager = msg.sender;
726         pool = msg.sender;
727         eTPlanToken = _token;
728         _this = address(this);
729     }
730 
731     function initEnd(address _endless, uint start, uint end) OnlySuper external {
732 
733         Endless endless = Endless(address(uint160(_endless)));
734         owner = endless.owner();
735         lastUserId = end + 1;
736 
737         for (uint i = start; i <= end; i++) {
738             address currentUser = endless.userIds(i);
739             (uint id,address referrer,uint partnersCount) = endless.users(currentUser);
740             User memory user = User({
741                 id : id,
742                 referrer : referrer,
743                 partnersCount : partnersCount
744                 });
745             users[currentUser] = user;
746 
747             for (uint8 j = 1; j <= 12; j++) {
748                 if (i == 3) {
749                     users[currentUser].blocked[j] = true;
750                     users[currentUser].activeQ8Levels[j] = false;
751                 } else {
752                     bool active = endless.usersActiveX6Levels(currentUser, j);
753                     users[currentUser].activeQ8Levels[j] = active;
754                 }
755             }
756 
757             idToAddress[i] = currentUser;
758         }
759     }
760 
761     function() external payable {
762         if (msg.data.length == 0) {
763             return registration(msg.sender, owner);
764         }
765 
766         registration(msg.sender, bytesToAddress(msg.data));
767     }
768 
769     function registrationExt(address referrerAddress) external payable {
770         registration(msg.sender, referrerAddress);
771     }
772 
773     function registration(address userAddress, address referrerAddress) private {
774         require(msg.value == 0.1 ether, "registration cost 0.1");
775         require(!isUserExists(userAddress), "user exists");
776         require(isUserExists(referrerAddress), "referrer not exists");
777 
778         uint32 size;
779         assembly {
780             size := extcodesize(userAddress)
781         }
782         require(size == 0, "cannot be a contract");
783 
784         User memory user = User({
785             id : lastUserId,
786             referrer : referrerAddress,
787             partnersCount : 0
788             });
789 
790         users[userAddress] = user;
791         idToAddress[lastUserId] = userAddress;
792 
793         users[userAddress].activeQ8Levels[1] = true;
794 
795         lastUserId++;
796 
797         users[referrerAddress].partnersCount++;
798 
799         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
800 
801         updateQ8Referrer(userAddress, referrerAddress, uint8(1));
802         if (ETPlanToken(eTPlanToken).balanceOf(_this) > levelPrice[uint8(1)]) {
803             ETPlanToken(eTPlanToken).transfer(userAddress, levelPrice[uint8(1)]);
804             ETPlanToken(eTPlanToken).transfer(referrerAddress, levelPrice[uint8(1)] / 2);
805         }
806 
807     }
808 
809     function buyNewLevel(uint8 level) external payable {
810         require(isUserExists(msg.sender), "user is not exists. Register first.");
811         require(msg.value == levelPrice[level], "invalid price");
812         require(level > 1 && level <= LAST_LEVEL, "invalid level");
813         require(!users[msg.sender].activeQ8Levels[level], "level already activated");
814 
815         if (users[msg.sender].blocked[level - 1]) {
816             users[msg.sender].blocked[level - 1] = false;
817         }
818         users[msg.sender].activeQ8Levels[level] = true;
819         address freeReferrer = findFreeQ8Referrer(msg.sender, level);
820         updateQ8Referrer(msg.sender, freeReferrer, level);
821         emit NewRound(msg.sender, freeReferrer, level);
822         if (ETPlanToken(eTPlanToken).balanceOf(_this) > levelPrice[level]) {
823             ETPlanToken(eTPlanToken).transfer(msg.sender, levelPrice[level]);
824             ETPlanToken(eTPlanToken).transfer(freeReferrer, levelPrice[level]/2);
825         }
826     }
827 
828     function updateQ8Referrer(address userAddress, address referrerAddress, uint8 level) private {
829         require(users[referrerAddress].activeQ8Levels[level], "500. Referrer level is inactive");
830 
831         if ((users[referrerAddress].income[level] % (levelPrice[level] / 2)) >= 6) {
832             if (!users[referrerAddress].activeQ8Levels[level + 1] && level != LAST_LEVEL) {
833                 users[referrerAddress].blocked[level] = true;
834             }
835         }
836         if (q8Matrix[level].firstLevelReferrals.length < 2) {
837             q8Matrix[level].firstLevelReferrals.push(userAddress);
838             emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].firstLevelReferrals.length));
839 
840             q8Matrix[level].currentReferrer = referrerAddress;
841             if (referrerAddress == owner) {
842                 users[owner].income[level] += levelPrice[level];
843                 return sendETHDividends(referrerAddress, userAddress, level, levelPrice[level]);
844             }
845 
846             uint poolAmount = levelPrice[level] * 20 / 100;
847             if (!address(uint160(pool)).send(poolAmount)) {
848                 return address(uint160(pool)).transfer(address(this).balance);
849             }
850             uint managerAmount = levelPrice[level] * 30 / 100;
851             if (!address(uint160(manager)).send(managerAmount)) {
852                 return address(uint160(manager)).transfer(address(this).balance);
853             }
854             address freeReferrer = findFreeQ8Referrer(userAddress, level);
855             users[freeReferrer].income[level] += levelPrice[level] / 2;
856             return sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
857         }
858         q8Matrix[level].secondLevelReferrals.push(userAddress);
859         q8Matrix[level].currentReferrer = referrerAddress;
860         emit NewUserPlace(userAddress, referrerAddress, level, uint8(q8Matrix[level].secondLevelReferrals.length + 2));
861 
862         if (q8Matrix[level].secondLevelReferrals.length == 1) {
863             address freeReferrer = findFreeQ8Referrer(userAddress, level);
864             users[freeReferrer].income[level] += levelPrice[level] / 2;
865             sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
866             uint poolAmount = levelPrice[level] * 20 / 100;
867             if (!address(uint160(pool)).send(poolAmount)) {
868                 return address(uint160(pool)).transfer(address(this).balance);
869             }
870             address freeReferrerRe = findFreeQ8Referrer(freeReferrer, level);
871             users[freeReferrerRe].income[level] += levelPrice[level] * 30 / 100;
872             return sendETHDividends(freeReferrerRe, userAddress, level, levelPrice[level] * 30 / 100);
873         }
874 
875         if (q8Matrix[level].secondLevelReferrals.length == 4) {//reinvest
876             q8Matrix[level].reinvestCount++;
877 
878             q8Matrix[level].firstLevelReferrals = new address[](0);
879             q8Matrix[level].secondLevelReferrals = new address[](0);
880         }
881         address freeReferrer = findFreeQ8Referrer(userAddress, level);
882         users[freeReferrer].income[level] += levelPrice[level] / 2;
883         sendETHDividends(freeReferrer, userAddress, level, levelPrice[level] / 2);
884         uint poolAmount = levelPrice[level] * 20 / 100;
885         if (!address(uint160(pool)).send(poolAmount)) {
886             return address(uint160(pool)).transfer(address(this).balance);
887         }
888         uint managerAmount = levelPrice[level] * 30 / 100;
889         if (!address(uint160(manager)).send(managerAmount)) {
890             return address(uint160(manager)).transfer(address(this).balance);
891         }
892     }
893 
894     function findFreeQ8Referrer(address userAddress, uint8 level) public view returns (address) {
895         while (true) {
896             if (users[users[userAddress].referrer].activeQ8Levels[level]) {
897                 return users[userAddress].referrer;
898             }
899 
900             userAddress = users[userAddress].referrer;
901         }
902     }
903 
904     function findEthReceiver(address userAddress, address _from, uint8 level) private returns (address, bool) {
905         address receiver = userAddress;
906         bool isExtraDividends;
907         while (true) {
908             if (users[receiver].blocked[level]) {
909                 emit MissedEthReceive(receiver, _from, level);
910                 isExtraDividends = true;
911                 receiver = users[receiver].referrer;
912             } else {
913                 return (receiver, isExtraDividends);
914             }
915         }
916     }
917 
918     function sendETHDividends(address userAddress, address _from, uint8 level, uint amount) private {
919         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);
920 
921         if (!address(uint160(receiver)).send(amount)) {
922             return address(uint160(receiver)).transfer(address(this).balance);
923         }
924 
925         if (isExtraDividends) {
926             emit SentExtraEthDividends(_from, receiver, level);
927         }
928     }
929 
930     function isUserExists(address user) public view returns (bool) {
931         return (users[user].id != 0);
932     }
933 
934     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
935         assembly {
936             addr := mload(add(bys, 20))
937         }
938     }
939 
940     function activeQ8Levels(address _user, uint8 level) public view returns (bool){
941         return users[_user].activeQ8Levels[level];
942     }
943 
944     function blocked(address _user, uint8 level) public view returns (bool){
945         return users[_user].blocked[level];
946     }
947 
948     function income(address _user, uint8 level) public view returns (uint){
949         return users[_user].income[level];
950     }
951 
952     function getq8Matrix(uint8 level) public view returns (address, address[] memory, address[] memory, uint){
953         return (q8Matrix[level].currentReferrer,
954         q8Matrix[level].firstLevelReferrals,
955         q8Matrix[level].secondLevelReferrals,
956         q8Matrix[level].reinvestCount);
957     }
958 
959     function updatePool(address _pool) public OnlySuper {
960         pool = _pool;
961     }
962 
963     function updateManager(address _manager) public OnlySuper {
964         manager = _manager;
965     }
966 
967     function updateSuper(address _super) public OnlySuper {
968         super = _super;
969     }
970 
971     function update(address _user, uint8 _level) public OnlySuper {
972         require(isUserExists(_user), "user not exists");
973         users[_user].activeQ8Levels[_level] = !users[_user].activeQ8Levels[_level];
974     }
975 
976     function withdrawELS(address _user, uint _value) public OnlySuper {
977         ETPlanToken(eTPlanToken).transfer(_user, _value);
978     }
979 }
980 
981 
982 contract Endless {
983 
984     struct User {
985         uint id;
986         address referrer;
987         uint partnersCount;
988 
989         mapping(uint8 => bool) activeX3Levels;
990         mapping(uint8 => bool) activeX6Levels;
991 
992         mapping(uint8 => X3) x3Matrix;
993         mapping(uint8 => X6) x6Matrix;
994     }
995 
996     struct X3 {
997         address currentReferrer;
998         address[] referrals;
999         bool blocked;
1000         uint reinvestCount;
1001     }
1002 
1003     struct X6 {
1004         address currentReferrer;
1005         address[] firstLevelReferrals;
1006         address[] secondLevelReferrals;
1007         bool blocked;
1008         uint reinvestCount;
1009 
1010         address closedPart;
1011     }
1012 
1013     uint8 public constant LAST_LEVEL = 12;
1014 
1015     mapping(address => User) public users;
1016     mapping(uint => address) public idToAddress;
1017     mapping(uint => address) public userIds;
1018     mapping(address => uint) public balances;
1019 
1020     uint public lastUserId = 2;
1021     address public owner;
1022 
1023     mapping(uint8 => uint) public levelPrice;
1024 
1025     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
1026     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
1027     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
1028     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
1029     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
1030     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
1031 
1032 
1033     constructor(address ownerAddress) public {
1034         levelPrice[1] = 0.025 ether;
1035         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
1036             levelPrice[i] = levelPrice[i-1] * 2;
1037         }
1038         owner = ownerAddress;
1039 
1040         User memory user = User({
1041             id: 1,
1042             referrer: address(0),
1043             partnersCount: uint(0)
1044             });
1045 
1046         users[ownerAddress] = user;
1047         idToAddress[1] = ownerAddress;
1048 
1049         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
1050             users[ownerAddress].activeX3Levels[i] = true;
1051             users[ownerAddress].activeX6Levels[i] = true;
1052         }
1053 
1054         userIds[1] = ownerAddress;
1055     }
1056 
1057     function() external payable {
1058         if(msg.data.length == 0) {
1059             return registration(msg.sender, owner);
1060         }
1061 
1062         registration(msg.sender, bytesToAddress(msg.data));
1063     }
1064 
1065     function registrationExt(address referrerAddress) external payable {
1066         registration(msg.sender, referrerAddress);
1067     }
1068 
1069     function buyNewLevel(uint8 matrix, uint8 level) external payable {
1070         require(isUserExists(msg.sender), "user is not exists. Register first.");
1071         require(matrix == 1 || matrix == 2, "invalid matrix");
1072         require(msg.value == levelPrice[level], "invalid price");
1073         require(level > 1 && level <= LAST_LEVEL, "invalid level");
1074 
1075         if (matrix == 1) {
1076             require(!users[msg.sender].activeX3Levels[level], "level already activated");
1077 
1078             if (users[msg.sender].x3Matrix[level-1].blocked) {
1079                 users[msg.sender].x3Matrix[level-1].blocked = false;
1080             }
1081 
1082             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
1083             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
1084             users[msg.sender].activeX3Levels[level] = true;
1085             updateX3Referrer(msg.sender, freeX3Referrer, level);
1086 
1087             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
1088 
1089         } else {
1090             require(!users[msg.sender].activeX6Levels[level], "level already activated");
1091 
1092             if (users[msg.sender].x6Matrix[level-1].blocked) {
1093                 users[msg.sender].x6Matrix[level-1].blocked = false;
1094             }
1095 
1096             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
1097 
1098             users[msg.sender].activeX6Levels[level] = true;
1099             updateX6Referrer(msg.sender, freeX6Referrer, level);
1100 
1101             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
1102         }
1103     }
1104 
1105     function registration(address userAddress, address referrerAddress) private {
1106         require(msg.value == 0.05 ether, "registration cost 0.05");
1107         require(!isUserExists(userAddress), "user exists");
1108         require(isUserExists(referrerAddress), "referrer not exists");
1109 
1110         uint32 size;
1111         assembly {
1112             size := extcodesize(userAddress)
1113         }
1114         require(size == 0, "cannot be a contract");
1115 
1116         User memory user = User({
1117             id: lastUserId,
1118             referrer: referrerAddress,
1119             partnersCount: 0
1120             });
1121 
1122         users[userAddress] = user;
1123         idToAddress[lastUserId] = userAddress;
1124 
1125         users[userAddress].referrer = referrerAddress;
1126 
1127         users[userAddress].activeX3Levels[1] = true;
1128         users[userAddress].activeX6Levels[1] = true;
1129 
1130 
1131         userIds[lastUserId] = userAddress;
1132         lastUserId++;
1133 
1134         users[referrerAddress].partnersCount++;
1135 
1136         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
1137         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
1138         updateX3Referrer(userAddress, freeX3Referrer, 1);
1139 
1140         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
1141 
1142         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
1143     }
1144 
1145     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
1146         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
1147 
1148         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
1149             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
1150             return sendETHDividends(referrerAddress, userAddress, 1, level);
1151         }
1152 
1153         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
1154         //close matrix
1155         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
1156         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
1157             users[referrerAddress].x3Matrix[level].blocked = true;
1158         }
1159 
1160         //create new one by recursion
1161         if (referrerAddress != owner) {
1162             //check referrer active level
1163             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
1164             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
1165                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
1166             }
1167 
1168             users[referrerAddress].x3Matrix[level].reinvestCount++;
1169             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
1170             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
1171         } else {
1172             sendETHDividends(owner, userAddress, 1, level);
1173             users[owner].x3Matrix[level].reinvestCount++;
1174             emit Reinvest(owner, address(0), userAddress, 1, level);
1175         }
1176     }
1177 
1178     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
1179         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
1180 
1181         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
1182             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
1183             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
1184 
1185             //set current level
1186             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
1187 
1188             if (referrerAddress == owner) {
1189                 return sendETHDividends(referrerAddress, userAddress, 2, level);
1190             }
1191 
1192             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;
1193             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress);
1194 
1195             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
1196 
1197             if ((len == 2) &&
1198             (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
1199                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
1200                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
1201                     emit NewUserPlace(userAddress, ref, 2, level, 5);
1202                 } else {
1203                     emit NewUserPlace(userAddress, ref, 2, level, 6);
1204                 }
1205             }  else if ((len == 1 || len == 2) &&
1206             users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
1207                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
1208                     emit NewUserPlace(userAddress, ref, 2, level, 3);
1209                 } else {
1210                     emit NewUserPlace(userAddress, ref, 2, level, 4);
1211                 }
1212             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
1213                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
1214                     emit NewUserPlace(userAddress, ref, 2, level, 5);
1215                 } else {
1216                     emit NewUserPlace(userAddress, ref, 2, level, 6);
1217                 }
1218             }
1219 
1220             return updateX6ReferrerSecondLevel(userAddress, ref, level);
1221         }
1222 
1223         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
1224 
1225         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
1226             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
1227             users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
1228                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
1229                 users[referrerAddress].x6Matrix[level].closedPart)) {
1230 
1231                 updateX6(userAddress, referrerAddress, level, true);
1232                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1233             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
1234                 users[referrerAddress].x6Matrix[level].closedPart) {
1235                 updateX6(userAddress, referrerAddress, level, true);
1236                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1237             } else {
1238                 updateX6(userAddress, referrerAddress, level, false);
1239                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1240             }
1241         }
1242 
1243         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
1244             updateX6(userAddress, referrerAddress, level, false);
1245             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1246         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
1247             updateX6(userAddress, referrerAddress, level, true);
1248             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1249         }
1250 
1251         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <=
1252             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
1253             updateX6(userAddress, referrerAddress, level, false);
1254         } else {
1255             updateX6(userAddress, referrerAddress, level, true);
1256         }
1257 
1258         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
1259     }
1260 
1261     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
1262         if (!x2) {
1263             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
1264             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
1265             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
1266             //set current level
1267             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
1268         } else {
1269             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
1270             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
1271             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
1272             //set current level
1273             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
1274         }
1275     }
1276 
1277     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
1278         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
1279             return sendETHDividends(referrerAddress, userAddress, 2, level);
1280         }
1281 
1282         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
1283 
1284         if (x6.length == 2) {
1285             if (x6[0] == referrerAddress ||
1286             x6[1] == referrerAddress) {
1287                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
1288             } else if (x6.length == 1) {
1289                 if (x6[0] == referrerAddress) {
1290                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
1291                 }
1292             }
1293         }
1294 
1295         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
1296         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
1297         users[referrerAddress].x6Matrix[level].closedPart = address(0);
1298 
1299         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
1300             users[referrerAddress].x6Matrix[level].blocked = true;
1301         }
1302 
1303         users[referrerAddress].x6Matrix[level].reinvestCount++;
1304 
1305         if (referrerAddress != owner) {
1306             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
1307 
1308             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
1309             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
1310         } else {
1311             emit Reinvest(owner, address(0), userAddress, 2, level);
1312             sendETHDividends(owner, userAddress, 2, level);
1313         }
1314     }
1315 
1316     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
1317         while (true) {
1318             if (users[users[userAddress].referrer].activeX3Levels[level]) {
1319                 return users[userAddress].referrer;
1320             }
1321 
1322             userAddress = users[userAddress].referrer;
1323         }
1324     }
1325 
1326     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
1327         while (true) {
1328             if (users[users[userAddress].referrer].activeX6Levels[level]) {
1329                 return users[userAddress].referrer;
1330             }
1331 
1332             userAddress = users[userAddress].referrer;
1333         }
1334     }
1335 
1336     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
1337         return users[userAddress].activeX3Levels[level];
1338     }
1339 
1340     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
1341         return users[userAddress].activeX6Levels[level];
1342     }
1343 
1344     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool ,uint) {
1345         return (users[userAddress].x3Matrix[level].currentReferrer,
1346         users[userAddress].x3Matrix[level].referrals,
1347         users[userAddress].x3Matrix[level].blocked,
1348         users[userAddress].x3Matrix[level].reinvestCount);
1349     }
1350 
1351     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address,uint) {
1352         return (users[userAddress].x6Matrix[level].currentReferrer,
1353         users[userAddress].x6Matrix[level].firstLevelReferrals,
1354         users[userAddress].x6Matrix[level].secondLevelReferrals,
1355         users[userAddress].x6Matrix[level].blocked,
1356         users[userAddress].x6Matrix[level].closedPart,
1357         users[userAddress].x6Matrix[level].reinvestCount);
1358     }
1359 
1360     function isUserExists(address user) public view returns (bool) {
1361         return (users[user].id != 0);
1362     }
1363 
1364     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
1365         address receiver = userAddress;
1366         bool isExtraDividends;
1367         if (matrix == 1) {
1368             while (true) {
1369                 if (users[receiver].x3Matrix[level].blocked) {
1370                     emit MissedEthReceive(receiver, _from, 1, level);
1371                     isExtraDividends = true;
1372                     receiver = users[receiver].x3Matrix[level].currentReferrer;
1373                 } else {
1374                     return (receiver, isExtraDividends);
1375                 }
1376             }
1377         } else {
1378             while (true) {
1379                 if (users[receiver].x6Matrix[level].blocked) {
1380                     emit MissedEthReceive(receiver, _from, 2, level);
1381                     isExtraDividends = true;
1382                     receiver = users[receiver].x6Matrix[level].currentReferrer;
1383                 } else {
1384                     return (receiver, isExtraDividends);
1385                 }
1386             }
1387         }
1388     }
1389 
1390     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
1391         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
1392 
1393         if (!address(uint160(receiver)).send(levelPrice[level])) {
1394             return address(uint160(receiver)).transfer(address(this).balance);
1395         }
1396 
1397         if (isExtraDividends) {
1398             emit SentExtraEthDividends(_from, receiver, matrix, level);
1399         }
1400     }
1401 
1402     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
1403         assembly {
1404             addr := mload(add(bys, 20))
1405         }
1406     }
1407 }
1408 
1409 
1410 library SafeMath {
1411     /**
1412     * @dev Multiplies two numbers, throws on overflow.
1413     */
1414     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1415         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1416         // benefit is lost if 'b' is also tested.
1417         // See: https://github.com/OpenZeppelin/openzeppelin- solidity/pull/522
1418         if (a == 0) {
1419             return 0;
1420         }
1421         c = a * b;
1422         assert(c / a == b);
1423         return c;
1424     }
1425     /**
1426     * @dev Integer division of two numbers, truncating the quotient. 
1427     */
1428     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1429         assert(b > 0);
1430         // uint256 c = a / b;
1431         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1432         return a / b;
1433     }
1434     /**
1435     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1436     */
1437     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1438         assert(b <= a);
1439         return a - b;
1440     }
1441     /**
1442     * @dev Adds two numbers, throws on overflow.
1443     */
1444     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1445         c = a + b;
1446         assert(c >= a);
1447         return c;
1448     }
1449 }
1450 
1451 contract Token {
1452 
1453     /// @return total amount of tokens
1454     //function totalSupply() public view returns (uint supply);
1455 
1456     /// @param _owner The address from which the balance will be retrieved
1457     /// @return The balance
1458     function balanceOf(address _owner) public view returns (uint balance);
1459 
1460     /// @notice send `_value` token to `_to` from `msg.sender`
1461     /// @param _to The address of the recipient
1462     /// @param _value The amount of token to be transferred
1463     /// @return Whether the transfer was successful or not
1464     function transfer(address _to, uint _value) public returns (bool success);
1465 
1466     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
1467     /// @param _from The address of the sender
1468     /// @param _to The address of the recipient
1469     /// @param _value The amount of token to be transferred
1470     /// @return Whether the transfer was successful or not
1471     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
1472 
1473     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
1474     /// @param _spender The address of the account able to transfer the tokens
1475     /// @param _value The amount of wei to be approved for transfer
1476     /// @return Whether the approval was successful or not
1477     function approve(address _spender, uint _value) public returns (bool success);
1478 
1479     /// @param _owner The address of the account owning tokens
1480     /// @param _spender The address of the account able to transfer the tokens
1481     /// @return Amount of remaining tokens allowed to spent
1482     function allowance(address _owner, address _spender) public view returns (uint remaining);
1483 
1484     event Transfer(address indexed _from, address indexed _to, uint _value);
1485     event Approval(address indexed _owner, address indexed _spender, uint _value);
1486 }
1487 
1488 contract RegularToken is Token {
1489 
1490     using SafeMath for uint256;
1491 
1492     function transfer(address _to, uint _value) public returns (bool) {
1493         require(_to != address(0));
1494         //Default assumes totalSupply can't be over max (2^256 - 1).
1495         require(balances[msg.sender] >= _value);
1496         balances[msg.sender] = balances[msg.sender].sub(_value);
1497         balances[_to] = balances[_to].add(_value);
1498         emit Transfer(msg.sender, _to, _value);
1499         return true;
1500     }
1501 
1502     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
1503         require(_to != address(0));
1504         require(balances[_from] >= _value);
1505         require(allowed[_from][msg.sender] >= _value);
1506 
1507         balances[_to] = balances[_to].add(_value);
1508         balances[_from] = balances[_from].sub(_value);
1509         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1510         emit Transfer(_from, _to, _value);
1511         return true;
1512     }
1513 
1514     function balanceOf(address _owner) public view returns (uint) {
1515         return balances[_owner];
1516     }
1517 
1518     function approve(address _spender, uint _value) public returns (bool) {
1519         require(_spender != address(0));
1520         allowed[msg.sender][_spender] = _value;
1521         emit Approval(msg.sender, _spender, _value);
1522         return true;
1523     }
1524 
1525     function allowance(address _owner, address _spender) public view returns (uint) {
1526         return allowed[_owner][_spender];
1527     }
1528 
1529     mapping(address => uint) balances;
1530     mapping(address => mapping(address => uint)) allowed;
1531     uint public totalSupply;
1532 }
1533 
1534 contract UnboundedRegularToken is RegularToken {
1535 
1536     uint constant MAX_UINT = 2 ** 256 - 1;
1537 
1538     /// @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited amount.
1539     /// @param _from Address to transfer from.
1540     /// @param _to Address to transfer to.
1541     /// @param _value Amount to transfer.
1542     /// @return Success of transfer.
1543     function transferFrom(address _from, address _to, uint _value)
1544     public
1545     returns (bool)
1546     {
1547         require(_to != address(0));
1548         uint allowance = allowed[_from][msg.sender];
1549 
1550         require(balances[_from] >= _value);
1551         require(allowance >= _value);
1552 
1553         balances[_to] = balances[_to].add(_value);
1554         balances[_from] = balances[_from].sub(_value);
1555         if (allowance < MAX_UINT) {
1556             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1557         }
1558         emit Transfer(_from, _to, _value);
1559         return true;
1560     }
1561 }
1562 
1563 contract ETPlanToken is UnboundedRegularToken {
1564 
1565     uint8 constant public decimals = 18;
1566     string constant public name = "ETPlanToken";
1567     string constant public symbol = "ELS";
1568 
1569     constructor() public {
1570         totalSupply = 33 * 10 ** 25;
1571         balances[msg.sender] = totalSupply;
1572         emit Transfer(address(0), msg.sender, totalSupply);
1573     }
1574 }