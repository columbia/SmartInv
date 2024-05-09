1 pragma solidity >=0.4.23 <0.6.0;
2 
3 contract Eth2Plus {
4     
5     struct User {
6         uint id;
7         address referrer;
8         uint partnersCount;
9         
10         mapping(uint8 => bool) activeX3Levels;
11         mapping(uint8 => bool) activeX6Levels;
12         
13         mapping(uint8 => X3) x3Matrix;
14         mapping(uint8 => X6) x6Matrix;
15     }
16     
17     struct X3 {
18         address currentReferrer;
19         address[] referrals;
20         bool blocked;
21         uint reinvestCount;
22     }
23     
24     struct X6 {
25         address currentReferrer;
26         address[] firstLevelReferrals;
27         address[] secondLevelReferrals;
28         bool blocked;
29         uint reinvestCount;
30 
31         address closedPart;
32     }
33 
34     uint8 public constant LAST_LEVEL = 12;
35     
36     mapping(address => User) public users;
37     mapping(uint => address) public idToAddress;
38     mapping(uint => address) public userIds;
39     mapping(address => uint) public balances; 
40     
41     
42     mapping(address=>mapping(uint=>mapping(uint=>uint256))) public matrixLevelReward;
43     
44     mapping(address=>mapping(uint=>uint256)) public matrixReward;
45 
46     uint public lastUserId = 2;
47     address public starNode;
48     
49     address owner;
50     
51     address truncateNode;
52     
53     mapping(uint8 => uint) public levelPrice;
54     
55     uint256 public global1FallUid=0;
56     uint256 public global2FallUid=11;
57     mapping(uint256=>uint256) public globalFallCount;
58     uint256 public globalFallType=1;
59     
60     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
61     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
62     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
63     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
64     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
65     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
66     
67     
68     constructor(address starNodeAddress) public {
69         levelPrice[1] = 0.025 ether;
70         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
71             levelPrice[i] = levelPrice[i-1] * 2;
72         }
73         starNode = starNodeAddress;
74         truncateNode = starNodeAddress;
75         owner=msg.sender;
76         
77         User memory user = User({
78             id: 1,
79             referrer: address(0),
80             partnersCount: uint(0)
81         });
82         
83         users[starNodeAddress] = user;
84         idToAddress[1] = starNodeAddress;
85         
86         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
87             users[starNodeAddress].activeX3Levels[i] = true;
88             users[starNodeAddress].activeX6Levels[i] = true;
89         }
90         
91         userIds[1] = starNodeAddress;
92     }
93     
94     function globalfall(uint8 level) internal{
95         if(globalFallType==1){
96             globalFallType=2;
97             
98             if(global1FallUid>=10){
99                 global1FallUid=0;
100             }
101             
102             address receiver=owner;
103             
104             if(lastUserId>global1FallUid+1){
105                 global1FallUid++;
106                 receiver=userIds[global1FallUid];
107             }
108             sendETHDividendsToGobalFall( receiver,level);
109             
110             
111             
112         }else{
113             globalFallType=1;
114             
115             address receiver=owner;
116             
117             if(lastUserId>global2FallUid+1){
118                 if(globalFallCount[global2FallUid]>=2){
119                     global2FallUid++;
120                 }
121                 receiver=userIds[global2FallUid];
122                 globalFallCount[global2FallUid]=globalFallCount[global2FallUid]+1;
123             }
124             sendETHDividendsToGobalFall( receiver,level);     
125             
126          
127         }
128     }
129     
130     function() external payable {
131         if(msg.data.length == 0) {
132             return registration(msg.sender, starNode);
133         }
134         
135         registration(msg.sender, bytesToAddress(msg.data));
136     }
137 
138     function registrationExt(address referrerAddress) external payable {
139         registration(msg.sender, referrerAddress);
140     }
141     
142     function buyNewLevel(uint8 matrix, uint8 level) external payable {
143         require(isUserExists(msg.sender), "user is not exists. Register first.");
144         require(matrix == 1 || matrix == 2, "invalid matrix");
145         require(msg.value == levelPrice[level], "invalid price");
146         require(level > 1 && level <= LAST_LEVEL, "invalid level");
147 
148         if (matrix == 1) {
149             require(!users[msg.sender].activeX3Levels[level], "level already activated");
150 
151             if (users[msg.sender].x3Matrix[level-1].blocked) {
152                 users[msg.sender].x3Matrix[level-1].blocked = false;
153             }
154     
155             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
156             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
157             users[msg.sender].activeX3Levels[level] = true;
158             updateX3Referrer(msg.sender, freeX3Referrer, level);
159             
160             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
161 
162         } else {
163             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
164 
165             if (users[msg.sender].x6Matrix[level-1].blocked) {
166                 users[msg.sender].x6Matrix[level-1].blocked = false;
167             }
168 
169             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
170             
171             users[msg.sender].activeX6Levels[level] = true;
172             updateX6Referrer(msg.sender, freeX6Referrer, level,false);
173             
174             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
175         }
176     }    
177     
178     function registration(address userAddress, address referrerAddress) private {
179         require(msg.value == 0.05 ether, "registration cost 0.05");
180         require(!isUserExists(userAddress), "user exists");
181         require(isUserExists(referrerAddress), "referrer not exists");
182         
183         uint32 size;
184         assembly {
185             size := extcodesize(userAddress)
186         }
187         require(size == 0, "cannot be a contract");
188         
189         User memory user = User({
190             id: lastUserId,
191             referrer: referrerAddress,
192             partnersCount: 0
193         });
194         
195         users[userAddress] = user;
196         idToAddress[lastUserId] = userAddress;
197         
198         users[userAddress].referrer = referrerAddress;
199         
200         users[userAddress].activeX3Levels[1] = true; 
201         users[userAddress].activeX6Levels[1] = true;
202         
203         
204         userIds[lastUserId] = userAddress;
205         lastUserId++;
206         
207         users[referrerAddress].partnersCount++;
208 
209         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
210         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
211         updateX3Referrer(userAddress, freeX3Referrer, 1);
212 
213         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1,false);
214         
215         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
216     }
217     
218     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
219         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
220 
221         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
222             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
223             return sendETHDividends(referrerAddress, userAddress, 1, level);
224         }
225         
226         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
227         //close matrix
228         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
229         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
230             users[referrerAddress].x3Matrix[level].blocked = true;
231         }
232 
233         //create new one by recursion
234         if (referrerAddress != starNode) {
235             //check referrer active level
236             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
237             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
238                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
239             }
240             
241             users[referrerAddress].x3Matrix[level].reinvestCount++;
242             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
243             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
244         } else {
245             sendETHDividends(starNode, userAddress, 1, level);
246             users[starNode].x3Matrix[level].reinvestCount++;
247             emit Reinvest(starNode, address(0), userAddress, 1, level);
248         }
249     }
250 
251     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
252         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
253         
254         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
255             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
256             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
257             
258             //set current level
259             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
260 
261             if (referrerAddress == starNode) {
262                 return sendETHDividends(referrerAddress, userAddress, 2, level);
263             }
264             
265             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
266             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
267             
268             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
269             
270             if ((len == 2) && 
271                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
272                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
273                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
274                     emit NewUserPlace(userAddress, ref, 2, level, 5);
275                 } else {
276                     emit NewUserPlace(userAddress, ref, 2, level, 6);
277                 }
278             }  else if ((len == 1 || len == 2) &&
279                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
280                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
281                     emit NewUserPlace(userAddress, ref, 2, level, 3);
282                 } else {
283                     emit NewUserPlace(userAddress, ref, 2, level, 4);
284                 }
285             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
286                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
287                     emit NewUserPlace(userAddress, ref, 2, level, 5);
288                 } else {
289                     emit NewUserPlace(userAddress, ref, 2, level, 6);
290                 }
291             }
292 
293             return updateX6ReferrerSecondLevel(userAddress, ref, level,needRSkipecursionDivide);
294         }
295         
296         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
297 
298         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
299             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
300                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
301                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
302                 users[referrerAddress].x6Matrix[level].closedPart)) {
303 
304                 updateX6(userAddress, referrerAddress, level, true);
305                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
306             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
307                 users[referrerAddress].x6Matrix[level].closedPart) {
308                 updateX6(userAddress, referrerAddress, level, true);
309                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
310             } else {
311                 updateX6(userAddress, referrerAddress, level, false);
312                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
313             }
314         }
315 
316         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
317             updateX6(userAddress, referrerAddress, level, false);
318             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
319         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
320             updateX6(userAddress, referrerAddress, level, true);
321             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
322         }
323         
324         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
325             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
326             updateX6(userAddress, referrerAddress, level, false);
327         } else {
328             updateX6(userAddress, referrerAddress, level, true);
329         }
330         
331         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
332     }
333 
334     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
335         if (!x2) {
336             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
337             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
338             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
339             //set current level
340             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
341         } else {
342             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
343             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
344             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
345             //set current level
346             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
347         }
348     }
349     
350     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
351         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
352             if(!needRSkipecursionDivide){
353                 return sendETHDividends(referrerAddress, userAddress, 2, level);
354             }else{
355                 return;
356             }
357             
358         }
359         
360         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
361         
362         if (x6.length == 2) {
363             if (x6[0] == referrerAddress ||
364                 x6[1] == referrerAddress) {
365                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
366             } else if (x6.length == 1) {
367                 if (x6[0] == referrerAddress) {
368                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
369                 }
370             }
371         }
372         
373         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
374         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
375         users[referrerAddress].x6Matrix[level].closedPart = address(0);
376 
377         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
378             users[referrerAddress].x6Matrix[level].blocked = true;
379         }
380 
381         users[referrerAddress].x6Matrix[level].reinvestCount++;
382         
383         if (referrerAddress != starNode) {
384             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
385 
386             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
387             if(lastUserId>10){
388                 //cut the divide to global
389                 globalfall(level);
390                 
391                 updateX6Referrer(referrerAddress, freeReferrerAddress, level,true);
392             }else{
393                 updateX6Referrer(referrerAddress, freeReferrerAddress, level,false);
394             }
395     
396         } else {
397             emit Reinvest(starNode, address(0), userAddress, 2, level);
398             sendETHDividends(starNode, userAddress, 2, level);
399         }
400     }
401     
402     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
403         if (users[users[userAddress].referrer].activeX3Levels[level]) {
404             return users[userAddress].referrer;
405         }else{
406             return truncateNode;
407         }
408     }
409     
410     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
411         if (users[users[userAddress].referrer].activeX6Levels[level]) {
412             return users[userAddress].referrer;
413         }else{
414             return truncateNode;
415         }
416     }
417         
418     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
419         return users[userAddress].activeX3Levels[level];
420     }
421 
422     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
423         return users[userAddress].activeX6Levels[level];
424     }
425 
426     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
427         return (users[userAddress].x3Matrix[level].currentReferrer,
428                 users[userAddress].x3Matrix[level].referrals,
429                 users[userAddress].x3Matrix[level].blocked);
430     }
431 
432     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
433         return (users[userAddress].x6Matrix[level].currentReferrer,
434                 users[userAddress].x6Matrix[level].firstLevelReferrals,
435                 users[userAddress].x6Matrix[level].secondLevelReferrals,
436                 users[userAddress].x6Matrix[level].blocked,
437                 users[userAddress].x6Matrix[level].closedPart);
438     }
439     
440     function refreshTruncateNode(address _truncateNode) external{
441         require(msg.sender==owner, "require owner");
442         truncateNode=_truncateNode;
443     }    
444     
445     function isUserExists(address user) public view returns (bool) {
446         return (users[user].id != 0);
447     }
448     
449     function activeAllLevels(address _addr) external{
450         require(msg.sender==owner, "require owner");
451         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
452             users[_addr].activeX3Levels[i] = true;
453             users[_addr].activeX6Levels[i] = true;
454         }
455     }    
456     
457     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
458         address receiver = userAddress;
459         bool isExtraDividends;
460         if (matrix == 1) {
461                 if (users[receiver].x3Matrix[level].blocked) {
462                     emit MissedEthReceive(receiver, _from, 1, level);
463                     isExtraDividends = true;
464                     return (owner, isExtraDividends);
465                 } else {
466                     return (receiver, isExtraDividends);
467                 }
468            
469         } else {
470                 if (users[receiver].x6Matrix[level].blocked) {
471                     emit MissedEthReceive(receiver, _from, 2, level);
472                     isExtraDividends = true;
473                     return (owner, isExtraDividends);
474                 } else {
475                     return (receiver, isExtraDividends);
476                 }
477             
478         }
479     }
480     
481     function sendETHDividendsToGobalFall(address receiver, uint8 level) private {
482 
483         matrixLevelReward[receiver][2][level]=matrixLevelReward[receiver][2][level]+levelPrice[level];
484         matrixReward[receiver][2]=matrixReward[receiver][2]+levelPrice[level];
485         if (!address(uint160(receiver)).send(levelPrice[level])) {
486             return address(uint160(receiver)).transfer(address(this).balance);
487         }
488     }
489 
490     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
491         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
492 
493         matrixLevelReward[receiver][matrix][level]=matrixLevelReward[receiver][matrix][level]+levelPrice[level];
494         matrixReward[receiver][matrix]=matrixReward[receiver][matrix]+levelPrice[level];
495 
496         if (!address(uint160(receiver)).send(levelPrice[level])) {
497             return address(uint160(receiver)).transfer(address(this).balance);
498         }
499         
500         if (isExtraDividends) {
501             emit SentExtraEthDividends(_from, receiver, matrix, level);
502         }
503     }
504     
505     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
506         assembly {
507             addr := mload(add(bys, 20))
508         }
509     }
510     
511 
512     
513 
514 }