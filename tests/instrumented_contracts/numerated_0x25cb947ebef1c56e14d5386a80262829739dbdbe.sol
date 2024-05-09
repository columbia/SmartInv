1 /**
2 * Rapido.run hybrid matrix (x3,x4,x8)
3 * https://rapido.run
4 * (only for rapido.run members)
5 * 
6 **/
7 
8 
9 pragma solidity >=0.4.23 <0.6.0;
10 
11 contract Rapido {
12     
13     struct User {
14         uint id;
15         address referrer;
16         uint partnersCount;
17         
18         mapping(uint8 => bool) activeX3Levels;
19         mapping(uint8 => bool) activeX6Levels;
20         mapping(uint8 => bool) activeX12Levels;
21         mapping(uint8 => X3) x3Matrix;
22         mapping(uint8 => X6) x6Matrix;
23         mapping(uint8 => X12) x12Matrix;
24     }
25     
26     struct X3 {
27         address currentReferrer;
28         address[] referrals;
29         bool blocked;
30         uint reinvestCount;
31     }
32     
33     struct X6 {
34         address currentReferrer;
35         address[] firstLevelReferrals;
36         address[] secondLevelReferrals;
37         bool blocked;
38         uint reinvestCount;
39 
40         address closedPart;
41     }
42     
43     struct X12 {
44         address currentReferrer;
45         address[] firstLevelReferrals;
46         address[] secondLevelReferrals;
47         uint[] place;
48         address[] thirdlevelreferrals;
49         bool blocked;
50         uint reinvestCount;
51 
52         address closedPart;
53     }
54 
55     uint8 public constant LAST_LEVEL = 15;
56     
57     mapping(address => User) public users;
58     mapping(uint => address) public idToAddress;
59     mapping(uint => address) public userIds;
60     mapping(address => uint) public balances; 
61 
62     uint public lastUserId = 2;
63     address public owner;
64     
65     mapping(uint8 => uint) public levelPrice;
66     
67     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
68     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
69     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
70     event NewUserPlace(address indexed user, address indexed referrer, uint8  matrix, uint8 level, uint8 place);
71     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
72     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
73     
74     
75     constructor(address ownerAddress) public {
76          levelPrice[1] = 0.01 ether;
77         levelPrice[2] = 0.02 ether;
78         levelPrice[3] = 0.05 ether;
79         levelPrice[4] = 0.1 ether;
80         levelPrice[5] = 0.2 ether;
81         levelPrice[6] = 0.3 ether;
82         levelPrice[7] = 0.5 ether;
83         levelPrice[8] = 1 ether;
84         levelPrice[9] = 2 ether;
85         levelPrice[10] = 3 ether;
86         levelPrice[11] = 5 ether;
87         levelPrice[12] = 10 ether;
88         levelPrice[13] = 20 ether;
89         levelPrice[14] = 30 ether;
90         levelPrice[15] = 50 ether;
91         
92         owner = ownerAddress;
93         
94         User memory user = User({
95             id: 1,
96             referrer: address(0),
97             partnersCount: uint(0)
98         });
99         
100         users[ownerAddress] = user;
101         idToAddress[1] = ownerAddress;
102         
103         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
104             users[ownerAddress].activeX3Levels[i] = true;
105             users[ownerAddress].activeX6Levels[i] = true;
106             users[ownerAddress].activeX12Levels[i] = true;
107         }
108         
109         userIds[1] = ownerAddress;
110     }
111     
112     function() external payable {
113         if(msg.data.length == 0) {
114             return registration(msg.sender, owner);
115         }
116         
117         registration(msg.sender, bytesToAddress(msg.data));
118     }
119 
120     function registrationExt(address referrerAddress) external payable {
121         registration(msg.sender, referrerAddress);
122     }
123     
124     function buyNewLevel(uint8 matrix, uint8 level) external payable {
125         require(isUserExists(msg.sender), "user is not exists. Register first.");
126         require(matrix == 1 || matrix == 2 || matrix==3, "invalid matrix");
127         require(msg.value == levelPrice[level], "invalid price");
128         require(level > 1 && level <= LAST_LEVEL, "invalid level");
129 
130         if (matrix == 1) {
131             require(!users[msg.sender].activeX3Levels[level], "level already activated");
132 
133             if (users[msg.sender].x3Matrix[level-1].blocked) {
134                 users[msg.sender].x3Matrix[level-1].blocked = false;
135             }
136     
137             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
138             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
139             users[msg.sender].activeX3Levels[level] = true;
140             updateX3Referrer(msg.sender, freeX3Referrer, level);
141             
142             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
143 
144         } else if (matrix == 2){
145             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
146 
147             if (users[msg.sender].x6Matrix[level-1].blocked) {
148                 users[msg.sender].x6Matrix[level-1].blocked = false;
149             }
150 
151             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
152             
153             users[msg.sender].activeX6Levels[level] = true;
154             updateX6Referrer(msg.sender, freeX6Referrer, level);
155             
156             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
157         }
158         else{
159              require(!users[msg.sender].activeX12Levels[level], "level already activated"); 
160 
161             if (users[msg.sender].x12Matrix[level-1].blocked) {
162                 users[msg.sender].x12Matrix[level-1].blocked = false;
163             }
164 
165             address freeX12Referrer = findFreeX12Referrer(msg.sender, level);
166             
167             users[msg.sender].activeX12Levels[level] = true;
168             updateX12Referrer(msg.sender, freeX12Referrer, level);
169             
170             emit Upgrade(msg.sender, freeX12Referrer, 3, level);
171         }
172     }    
173     
174     function registration(address userAddress, address referrerAddress) private {
175         require(msg.value == 0.03 ether, "registration cost 0.05");
176         require(!isUserExists(userAddress), "user exists");
177         require(isUserExists(referrerAddress), "referrer not exists");
178         
179         uint32 size;
180         assembly {
181             size := extcodesize(userAddress)
182         }
183         require(size == 0, "cannot be a contract");
184         
185         User memory user = User({
186             id: lastUserId,
187             referrer: referrerAddress,
188             partnersCount: 0
189         });
190         
191         users[userAddress] = user;
192         idToAddress[lastUserId] = userAddress;
193         
194         users[userAddress].referrer = referrerAddress;
195         
196         users[userAddress].activeX3Levels[1] = true; 
197         users[userAddress].activeX6Levels[1] = true;
198         users[userAddress].activeX12Levels[1] = true;
199         
200         userIds[lastUserId] = userAddress;
201         lastUserId++;
202         
203         users[referrerAddress].partnersCount++;
204 
205         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
206         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
207         updateX3Referrer(userAddress, freeX3Referrer, 1);
208 
209         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
210         
211         updateX12Referrer(userAddress, findFreeX12Referrer(userAddress, 1), 1);
212         
213         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
214     }
215     
216     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
217         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
218 
219         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
220             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
221             return sendETHDividends(referrerAddress, userAddress, 1, level);
222         }
223         
224         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
225         //close matrix
226         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
227         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
228             users[referrerAddress].x3Matrix[level].blocked = true;
229         }
230 
231         //create new one by recursion
232         if (referrerAddress != owner) {
233             //check referrer active level
234             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
235             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
236                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
237             }
238             
239             users[referrerAddress].x3Matrix[level].reinvestCount++;
240             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
241             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
242         } else {
243             sendETHDividends(owner, userAddress, 1, level);
244             users[owner].x3Matrix[level].reinvestCount++;
245             emit Reinvest(owner, address(0), userAddress, 1, level);
246         }
247     }
248 
249     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
250         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
251         
252         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
253             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
254             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
255             
256             //set current level
257             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
258 
259             if (referrerAddress == owner) {
260                 return sendETHDividends(referrerAddress, userAddress, 2, level);
261             }
262             
263             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
264             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
265             
266             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
267             
268             if ((len == 2) && 
269                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
270                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
271                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
272                     emit NewUserPlace(userAddress, ref, 2, level, 5);
273                 } else {
274                     emit NewUserPlace(userAddress, ref, 2, level, 6);
275                 }
276             }  else if ((len == 1 || len == 2) &&
277                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
278                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
279                     emit NewUserPlace(userAddress, ref, 2, level, 3);
280                 } else {
281                     emit NewUserPlace(userAddress, ref, 2, level, 4);
282                 }
283             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
284                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
285                     emit NewUserPlace(userAddress, ref, 2, level, 5);
286                 } else {
287                     emit NewUserPlace(userAddress, ref, 2, level, 6);
288                 }
289             }
290 
291             return updateX6ReferrerSecondLevel(userAddress, ref, level);
292         }
293         
294         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
295 
296         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
297             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
298                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
299                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
300                 users[referrerAddress].x6Matrix[level].closedPart)) {
301 
302                 updateX6(userAddress, referrerAddress, level, true);
303                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
304             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
305                 users[referrerAddress].x6Matrix[level].closedPart) {
306                 updateX6(userAddress, referrerAddress, level, true);
307                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
308             } else {
309                 updateX6(userAddress, referrerAddress, level, false);
310                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
311             }
312         }
313 
314         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
315             updateX6(userAddress, referrerAddress, level, false);
316             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
317         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
318             updateX6(userAddress, referrerAddress, level, true);
319             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
320         }
321         
322         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
323             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
324             updateX6(userAddress, referrerAddress, level, false);
325         } else {
326             updateX6(userAddress, referrerAddress, level, true);
327         }
328         
329         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
330     }
331 
332     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
333         if (!x2) {
334             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
335             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
336             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
337             //set current level
338             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
339         } else {
340             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
341             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
342             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
343             //set current level
344             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
345         }
346     }
347     
348     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
349         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
350             return sendETHDividends(referrerAddress, userAddress, 2, level);
351         }
352         
353         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
354         
355         if (x6.length == 2) {
356             if (x6[0] == referrerAddress ||
357                 x6[1] == referrerAddress) {
358                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
359             } else if (x6.length == 1) {
360                 if (x6[0] == referrerAddress) {
361                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
362                 }
363             }
364         }
365         
366         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
367         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
368         users[referrerAddress].x6Matrix[level].closedPart = address(0);
369 
370         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
371             users[referrerAddress].x6Matrix[level].blocked = true;
372         }
373 
374         users[referrerAddress].x6Matrix[level].reinvestCount++;
375         
376         if (referrerAddress != owner) {
377             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
378 
379             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
380             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
381         } else {
382             emit Reinvest(owner, address(0), userAddress, 2, level);
383             sendETHDividends(owner, userAddress, 2, level);
384         }
385     }
386     
387     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
388         while (true) {
389             if (users[users[userAddress].referrer].activeX3Levels[level]) {
390                 return users[userAddress].referrer;
391             }
392             
393             userAddress = users[userAddress].referrer;
394         }
395     }
396     
397     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
398         while (true) {
399             if (users[users[userAddress].referrer].activeX6Levels[level]) {
400                 return users[userAddress].referrer;
401             }
402             
403             userAddress = users[userAddress].referrer;
404         }
405     }
406         
407     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
408         return users[userAddress].activeX3Levels[level];
409     }
410 
411     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
412         return users[userAddress].activeX6Levels[level];
413     }
414     
415     function usersActiveX12Levels(address userAddress, uint8 level) public view returns(bool) {
416         return users[userAddress].activeX12Levels[level];
417     }
418 
419     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
420         return (users[userAddress].x3Matrix[level].currentReferrer,
421                 users[userAddress].x3Matrix[level].referrals,
422                 users[userAddress].x3Matrix[level].blocked);
423     }
424 
425     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
426         return (users[userAddress].x6Matrix[level].currentReferrer,
427                 users[userAddress].x6Matrix[level].firstLevelReferrals,
428                 users[userAddress].x6Matrix[level].secondLevelReferrals,
429                 users[userAddress].x6Matrix[level].blocked,
430                 users[userAddress].x6Matrix[level].closedPart);
431     }
432     
433     function usersX12Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory,address[] memory, bool, address) {
434         return (users[userAddress].x12Matrix[level].currentReferrer,
435                 users[userAddress].x12Matrix[level].firstLevelReferrals,
436                 users[userAddress].x12Matrix[level].secondLevelReferrals,
437                 users[userAddress].x12Matrix[level].thirdlevelreferrals,
438                 users[userAddress].x12Matrix[level].blocked,
439                 users[userAddress].x12Matrix[level].closedPart);
440     }
441     
442     
443     function isUserExists(address user) public view returns (bool) {
444         return (users[user].id != 0);
445     }
446 
447     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
448         address receiver = userAddress;
449         bool isExtraDividends;
450         if (matrix == 1) {
451             while (true) {
452                 if (users[receiver].x3Matrix[level].blocked) {
453                     emit MissedEthReceive(receiver, _from, 1, level);
454                     isExtraDividends = true;
455                     receiver = users[receiver].x3Matrix[level].currentReferrer;
456                 } else {
457                     return (receiver, isExtraDividends);
458                 }
459             }
460         } else if (matrix == 2){
461             while (true) {
462                 if (users[receiver].x6Matrix[level].blocked) {
463                     emit MissedEthReceive(receiver, _from, 2, level);
464                     isExtraDividends = true;
465                     receiver = users[receiver].x6Matrix[level].currentReferrer;
466                 } else {
467                     return (receiver, isExtraDividends);
468                 }
469             }
470         } else{
471             while (true) {
472                 if (users[receiver].x12Matrix[level].blocked) {
473                     emit MissedEthReceive(receiver, _from, 3, level);
474                     isExtraDividends = true;
475                     receiver = users[receiver].x12Matrix[level].currentReferrer;
476                 } else {
477                     return (receiver, isExtraDividends);
478                 }
479             }
480         }
481         
482     }
483 
484     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
485         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
486 
487         if (!address(uint160(receiver)).send(levelPrice[level])) {
488             return address(uint160(receiver)).transfer(address(this).balance);
489         }
490         
491         if (isExtraDividends) {
492             emit SentExtraEthDividends(_from, receiver, matrix, level);
493         }
494     }
495     
496     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
497         assembly {
498             addr := mload(add(bys, 20))
499         }
500     }
501     
502     
503     /*  12X */
504     function updateX12Referrer(address userAddress, address referrerAddress, uint8 level) private {
505         require(users[referrerAddress].activeX12Levels[level], "500. Referrer level is inactive");
506         
507         if (users[referrerAddress].x12Matrix[level].firstLevelReferrals.length < 2) {
508             users[referrerAddress].x12Matrix[level].firstLevelReferrals.push(userAddress);
509             emit NewUserPlace(userAddress, referrerAddress, 3, level, uint8(users[referrerAddress].x12Matrix[level].firstLevelReferrals.length));
510             
511             //set current level
512             users[userAddress].x12Matrix[level].currentReferrer = referrerAddress;
513 
514             if (referrerAddress == owner) {
515                 return sendETHDividends(referrerAddress, userAddress, 3, level);
516             }
517             
518             address ref = users[referrerAddress].x12Matrix[level].currentReferrer;            
519             users[ref].x12Matrix[level].secondLevelReferrals.push(userAddress); 
520             
521             address ref1 = users[ref].x12Matrix[level].currentReferrer;            
522             users[ref1].x12Matrix[level].thirdlevelreferrals.push(userAddress);
523             
524             uint len = users[ref].x12Matrix[level].firstLevelReferrals.length;
525             uint8 toppos=2;
526             if(ref1!=address(0x0)){
527             if(ref==users[ref1].x12Matrix[level].firstLevelReferrals[0]){
528                 toppos=1;
529             }else
530             {
531                 toppos=2;
532             }
533             }
534             if ((len == 2) && 
535                 (users[ref].x12Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
536                 (users[ref].x12Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
537                 if (users[referrerAddress].x12Matrix[level].firstLevelReferrals.length == 1) {
538                     users[ref].x12Matrix[level].place.push(5);
539                     emit NewUserPlace(userAddress, ref, 3, level, 5); 
540                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+5);
541                 } else {
542                     users[ref].x12Matrix[level].place.push(6);
543                     emit NewUserPlace(userAddress, ref, 3, level, 6);
544                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+5);
545                 }
546             }  else
547             if ((len == 1 || len == 2) &&
548                     users[ref].x12Matrix[level].firstLevelReferrals[0] == referrerAddress) {
549                 if (users[referrerAddress].x12Matrix[level].firstLevelReferrals.length == 1) {
550                     users[ref].x12Matrix[level].place.push(3);
551                     emit NewUserPlace(userAddress, ref, 3, level, 3);
552                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+3);
553                 } else {
554                     users[ref].x12Matrix[level].place.push(4);
555                     emit NewUserPlace(userAddress, ref, 3, level, 4);
556                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+4);
557                 }
558             } else if (len == 2 && users[ref].x12Matrix[level].firstLevelReferrals[1] == referrerAddress) {
559                 if (users[referrerAddress].x12Matrix[level].firstLevelReferrals.length == 1) {
560                     users[ref].x12Matrix[level].place.push(5);
561                      emit NewUserPlace(userAddress, ref, 3, level, 5);
562                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+5);
563                 } else {
564                     users[ref].x12Matrix[level].place.push(6);
565                     emit NewUserPlace(userAddress, ref, 3, level, 6);
566                     emit NewUserPlace(userAddress, ref1, 3, level, (4*toppos)+6);
567                 }
568             }
569             
570             return updateX12ReferrerSecondLevel(userAddress, ref1, level);
571         }
572          if (users[referrerAddress].x12Matrix[level].secondLevelReferrals.length < 4) {
573         users[referrerAddress].x12Matrix[level].secondLevelReferrals.push(userAddress);
574         address secondref = users[referrerAddress].x12Matrix[level].currentReferrer; 
575         if(secondref==address(0x0))
576         secondref=owner;
577         if (users[referrerAddress].x12Matrix[level].firstLevelReferrals[1] == userAddress) {
578             updateX12(userAddress, referrerAddress, level, false);
579             return updateX12ReferrerSecondLevel(userAddress, secondref, level);
580         } else if (users[referrerAddress].x12Matrix[level].firstLevelReferrals[0] == userAddress) {
581             updateX12(userAddress, referrerAddress, level, true);
582             return updateX12ReferrerSecondLevel(userAddress, secondref, level);
583         }
584         
585         if (users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length < 
586             2) {
587             updateX12(userAddress, referrerAddress, level, false);
588         } else {
589             updateX12(userAddress, referrerAddress, level, true);
590         }
591         
592         updateX12ReferrerSecondLevel(userAddress, secondref, level);
593         }
594         
595         
596         else  if (users[referrerAddress].x12Matrix[level].thirdlevelreferrals.length < 8) {
597         users[referrerAddress].x12Matrix[level].thirdlevelreferrals.push(userAddress);
598 
599       if (users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length<2) {
600             updateX12Fromsecond(userAddress, referrerAddress, level, 0);
601             return updateX12ReferrerSecondLevel(userAddress, referrerAddress, level);
602         } else if (users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length<2) {
603             updateX12Fromsecond(userAddress, referrerAddress, level, 1);
604             return updateX12ReferrerSecondLevel(userAddress, referrerAddress, level);
605         }else if (users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[2]].x12Matrix[level].firstLevelReferrals.length<2) {
606             updateX12Fromsecond(userAddress, referrerAddress, level, 2);
607             return updateX12ReferrerSecondLevel(userAddress, referrerAddress, level);
608         }else if (users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[3]].x12Matrix[level].firstLevelReferrals.length<2) {
609             updateX12Fromsecond(userAddress, referrerAddress, level, 3);
610             return updateX12ReferrerSecondLevel(userAddress, referrerAddress, level);
611         }
612         
613         //updateX12Fromsecond(userAddress, referrerAddress, level, users[referrerAddress].x12Matrix[level].secondLevelReferrals.length);
614           
615         
616         updateX12ReferrerSecondLevel(userAddress, referrerAddress, level);
617         }
618     }
619 
620     function updateX12(address userAddress, address referrerAddress, uint8 level, bool x2) private {
621         if (!x2) {
622             users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.push(userAddress);
623             users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].thirdlevelreferrals.push(userAddress);
624             
625             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].firstLevelReferrals[0], 3, level, uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length));
626             emit NewUserPlace(userAddress, referrerAddress, 3, level, 2 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length));
627            
628             users[referrerAddress].x12Matrix[level].place.push(2 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length));
629            
630            if(referrerAddress!=address(0x0) && referrerAddress!=owner){
631             if(users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].firstLevelReferrals[0]==referrerAddress)
632             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].currentReferrer, 3, level,6 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length));
633             else
634             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].currentReferrer, 3, level, (10 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[0]].x12Matrix[level].firstLevelReferrals.length)));
635             //set current level
636            }
637             users[userAddress].x12Matrix[level].currentReferrer = users[referrerAddress].x12Matrix[level].firstLevelReferrals[0];
638            
639         } else {
640             users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.push(userAddress);
641             users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].thirdlevelreferrals.push(userAddress);
642             
643             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].firstLevelReferrals[1], 3, level, uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length));
644             emit NewUserPlace(userAddress, referrerAddress, 3, level, 4 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length));
645             
646             users[referrerAddress].x12Matrix[level].place.push(4 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length));
647             
648             if(referrerAddress!=address(0x0) && referrerAddress!=owner){
649             if(users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].firstLevelReferrals[0]==referrerAddress)
650             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].currentReferrer, 3, level, 8 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length));
651             else
652             emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].currentReferrer, 3, level, 12 + uint8(users[users[referrerAddress].x12Matrix[level].firstLevelReferrals[1]].x12Matrix[level].firstLevelReferrals.length));
653             }
654             //set current level
655             users[userAddress].x12Matrix[level].currentReferrer = users[referrerAddress].x12Matrix[level].firstLevelReferrals[1];
656         }
657     }
658     
659     function updateX12Fromsecond(address userAddress, address referrerAddress, uint8 level,uint pos) private {
660             users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].firstLevelReferrals.push(userAddress);
661              users[users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].currentReferrer].x12Matrix[level].secondLevelReferrals.push(userAddress);
662             
663             
664             uint8 len=uint8(users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].firstLevelReferrals.length);
665             
666             uint temppos=users[referrerAddress].x12Matrix[level].place[pos];
667             emit NewUserPlace(userAddress, referrerAddress, 3, level,uint8(((temppos)*2)+len)); //third position
668             if(temppos<5){
669             emit NewUserPlace(userAddress, users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].currentReferrer, 3, level,uint8((((temppos-3)+1)*2)+len));
670                        users[users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].currentReferrer].x12Matrix[level].place.push((((temppos-3)+1)*2)+len);
671             }else{
672             emit NewUserPlace(userAddress, users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].currentReferrer, 3, level,uint8((((temppos-3)-1)*2)+len));
673                        users[users[users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos]].x12Matrix[level].currentReferrer].x12Matrix[level].place.push((((temppos-3)-1)*2)+len);
674             }
675              emit NewUserPlace(userAddress, users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos], 3, level, len); //first position
676            //set current level
677             
678             users[userAddress].x12Matrix[level].currentReferrer = users[referrerAddress].x12Matrix[level].secondLevelReferrals[pos];
679            
680        
681     }
682     
683     function updateX12ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
684         if(referrerAddress==address(0x0)){
685             return sendETHDividends(owner, userAddress, 3, level);
686         }
687         if (users[referrerAddress].x12Matrix[level].thirdlevelreferrals.length < 8) {
688             return sendETHDividends(referrerAddress, userAddress, 3, level);
689         }
690         
691         address[] memory x12 = users[users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].currentReferrer].x12Matrix[level].firstLevelReferrals;
692         
693         if (x12.length == 2) {
694             if (x12[0] == referrerAddress ||
695                 x12[1] == referrerAddress) {
696                 users[users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].currentReferrer].x12Matrix[level].closedPart = referrerAddress;
697             } else if (x12.length == 1) {
698                 if (x12[0] == referrerAddress) {
699                     users[users[users[referrerAddress].x12Matrix[level].currentReferrer].x12Matrix[level].currentReferrer].x12Matrix[level].closedPart = referrerAddress;
700                 }
701             }
702         }
703         
704         users[referrerAddress].x12Matrix[level].firstLevelReferrals = new address[](0);
705         users[referrerAddress].x12Matrix[level].secondLevelReferrals = new address[](0);
706         users[referrerAddress].x12Matrix[level].thirdlevelreferrals = new address[](0);
707         users[referrerAddress].x12Matrix[level].closedPart = address(0);
708         users[referrerAddress].x12Matrix[level].place=new uint[](0);
709 
710         if (!users[referrerAddress].activeX12Levels[level+1] && level != LAST_LEVEL) {
711             users[referrerAddress].x12Matrix[level].blocked = true;
712         }
713 
714         users[referrerAddress].x12Matrix[level].reinvestCount++;
715         
716         if (referrerAddress != owner) {
717             address freeReferrerAddress = findFreeX12Referrer(referrerAddress, level);
718 
719             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 3, level);
720             updateX12Referrer(referrerAddress, freeReferrerAddress, level);
721         } else {
722             emit Reinvest(owner, address(0), userAddress, 3, level);
723             sendETHDividends(owner, userAddress, 3, level);
724         }
725     }
726     
727      function findFreeX12Referrer(address userAddress, uint8 level) public view returns(address) {
728         while (true) {
729             if (users[users[userAddress].referrer].activeX12Levels[level]) {
730                 return users[userAddress].referrer;
731             }
732             
733             userAddress = users[userAddress].referrer;
734         }
735     }
736 }