1 pragma solidity >=0.4.23 <0.6.0;
2 
3 
4 contract Sendrum {
5 
6     struct Queue {
7         uint256 first;
8         uint256 last;
9         mapping(uint256 => address) queue;
10     }
11     struct User {
12         uint id;
13         address referrer;
14         uint partnersCount;
15         
16         mapping(uint8 => bool) activeX3Levels;
17         mapping(uint8 => bool) activeX6Levels;
18         mapping(uint8 => bool) activeNoRLevels;
19         mapping(uint8 => bool) noRFilledLevels;
20 
21         
22         mapping(uint8 => X3) x3Matrix;
23         mapping(uint8 => X6) x6Matrix;
24 
25 
26     }
27     
28     struct X3 {
29         address currentReferrer;
30         address[] referrals;
31         bool blocked;
32         uint reinvestCount;
33     }
34     
35     struct X6 {
36         address currentReferrer;
37         address[] firstLevelReferrals;
38         address[] secondLevelReferrals;
39         bool blocked;
40         uint reinvestCount;
41 
42         address closedPart;
43     }
44 
45     struct NoR {
46         address currentUser;
47         address[] referrals;
48     }
49 
50     uint8 public constant LAST_LEVEL = 12;
51 
52     mapping(uint8 => NoR) public xNoRMatrix;
53     mapping(uint8 => Queue) public noRQueue;
54     
55 
56     mapping(address => User) public users;
57     mapping(uint => address) public idToAddress;
58     mapping(uint => address) public userIds;
59     mapping(address => uint) public balances;
60 
61     uint public lastUserId = 2;
62     address public owner;
63     
64     mapping(uint8 => uint) public levelPrice;
65     
66     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
67     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
68     event Filled(address indexed newUser, address indexed caller, uint8 matrix, uint8 level);
69     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
70     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
71     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
72     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
73     
74     
75     constructor(address ownerAddress) public {
76         levelPrice[1] = 0.02 ether;
77         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
78             levelPrice[i] = levelPrice[i-1] * 2;
79         }
80         
81         owner = ownerAddress;
82         
83         User memory user = User({
84             id: 1,
85             referrer: address(0),
86             partnersCount: uint(0)
87         });
88         
89         users[ownerAddress] = user;
90         idToAddress[1] = ownerAddress;
91         
92         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
93             users[ownerAddress].activeX3Levels[i] = true;
94             users[ownerAddress].activeX6Levels[i] = true;
95 
96             users[ownerAddress].activeNoRLevels[i] = true;
97             
98             xNoRMatrix[i] = NoR({
99                 currentUser: owner,
100                 referrals: new address[](0)
101             });
102             noRQueue[i] = Queue({
103                 first: 1,
104                 last: 0
105             });
106         }
107 
108         userIds[1] = ownerAddress;
109     }
110     
111     function() external payable {
112         if(msg.data.length == 0) {
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
123     function buyNewLevel(uint8 matrix, uint8 level) external payable {
124         require(isUserExists(msg.sender), "user is not exists. Register first.");
125         require(matrix == 1 || matrix == 2 || matrix == 3, "invalid matrix");
126         require(msg.value == levelPrice[level], "invalid price");
127         require(level > 1 && level <= LAST_LEVEL, "invalid level");
128 
129         if (matrix == 1) {
130             require(!users[msg.sender].activeX3Levels[level], "level already activated");
131             require(users[msg.sender].activeX3Levels[level-1], "You need to activate previous level to buy this one");
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
144         } else if(matrix == 2) {
145             require(!users[msg.sender].activeX6Levels[level], "level already activated");
146             require(users[msg.sender].activeX6Levels[level-1], "You need to activate previous level to buy this one");
147 
148             if (users[msg.sender].x6Matrix[level-1].blocked) {
149                 users[msg.sender].x6Matrix[level-1].blocked = false;
150             }
151 
152             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
153         
154             users[msg.sender].activeX6Levels[level] = true;
155             updateX6Referrer(msg.sender, freeX6Referrer, level);
156         
157             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
158         } else if (matrix == 3) {
159             require(!users[msg.sender].activeNoRLevels[level], "level already activated");
160             require(users[msg.sender].activeNoRLevels[level-1], "You need to activate previous level to buy this one");
161 
162             enqueueToNoR(level, msg.sender);
163             users[msg.sender].activeNoRLevels[level] = true;
164 
165             updateNoReinvestReferrer(msg.sender, level);
166             
167             emit Upgrade(msg.sender, xNoRMatrix[level].currentUser, 3, level);
168 
169         }
170     }    
171     
172     function registration(address userAddress, address referrerAddress) private {
173         require(msg.value == 0.06 ether, "registration cost 0.06");
174         require(!isUserExists(userAddress), "user exists");
175         require(isUserExists(referrerAddress), "referrer not exists");
176         
177         uint32 size;
178         assembly {
179             size := extcodesize(userAddress)
180         }
181         require(size == 0, "cannot be a contract");
182         
183         User memory user = User({
184             id: lastUserId,
185             referrer: referrerAddress,
186             partnersCount: 0
187         });
188         
189         users[userAddress] = user;
190         idToAddress[lastUserId] = userAddress;
191         
192         users[userAddress].referrer = referrerAddress;
193         
194         users[userAddress].activeX3Levels[1] = true;
195         users[userAddress].activeX6Levels[1] = true;
196         users[userAddress].activeNoRLevels[1] = true;
197         
198         userIds[lastUserId] = userAddress;
199         lastUserId++;
200         
201         users[referrerAddress].partnersCount++;
202 
203         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
204         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
205         updateX3Referrer(userAddress, freeX3Referrer, 1);
206 
207         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
208         
209         enqueueToNoR(1, userAddress);
210         updateNoReinvestReferrer(userAddress, 1);
211             
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
249     function updateNoReinvestReferrer(address userAddress, uint8 level) private {
250         xNoRMatrix[level].referrals.push(userAddress);
251         emit NewUserPlace(userAddress, xNoRMatrix[level].currentUser, 3, level, uint8(xNoRMatrix[level].referrals.length));
252         sendETHDividends(xNoRMatrix[level].currentUser, userAddress, 3, level);
253         if (xNoRMatrix[level].referrals.length < 3) {
254             return;
255         }
256 
257         users[xNoRMatrix[level].currentUser].noRFilledLevels[level] = true;
258         
259         xNoRMatrix[level].referrals = new address[](0);
260         xNoRMatrix[level].currentUser = dequeueToNoR(level);
261         emit Filled(xNoRMatrix[level].currentUser, userAddress, 3, level);
262 
263     }
264 
265     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
266         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
267         
268         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
269             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
270             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
271 
272             //set current level
273             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
274 
275             if (referrerAddress == owner) {
276                 return sendETHDividends(referrerAddress, userAddress, 2, level);
277             }
278             
279             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;
280             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress);
281             
282             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
283             
284             if ((len == 2) &&
285                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
286                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
287                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
288                     emit NewUserPlace(userAddress, ref, 2, level, 5);
289                 } else {
290                     emit NewUserPlace(userAddress, ref, 2, level, 6);
291                 }
292             }  else if ((len == 1 || len == 2) &&
293                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
294                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
295                     emit NewUserPlace(userAddress, ref, 2, level, 3);
296                 } else {
297                     emit NewUserPlace(userAddress, ref, 2, level, 4);
298                 }
299             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
300                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
301                     emit NewUserPlace(userAddress, ref, 2, level, 5);
302                 } else {
303                     emit NewUserPlace(userAddress, ref, 2, level, 6);
304                 }
305             }
306 
307             return updateX6ReferrerSecondLevel(userAddress, ref, level);
308         }
309         
310         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
311 
312         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
313             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
314                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
315                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
316                 users[referrerAddress].x6Matrix[level].closedPart)) {
317 
318                 updateX6(userAddress, referrerAddress, level, true);
319                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
320             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
321                 users[referrerAddress].x6Matrix[level].closedPart) {
322                 updateX6(userAddress, referrerAddress, level, true);
323                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
324             } else {
325                 updateX6(userAddress, referrerAddress, level, false);
326                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
327             }
328         }
329 
330         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
331             updateX6(userAddress, referrerAddress, level, false);
332             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
333         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
334             updateX6(userAddress, referrerAddress, level, true);
335             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
336         }
337         
338         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <=
339             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
340             updateX6(userAddress, referrerAddress, level, false);
341         } else {
342             updateX6(userAddress, referrerAddress, level, true);
343         }
344         
345         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
346     }
347 
348     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
349         if (!x2) {
350             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
351             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
352             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
353             //set current level
354             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
355         } else {
356             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
357             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
358             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
359             //set current level
360             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
361         }
362     }
363     
364     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
365         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
366             return sendETHDividends(referrerAddress, userAddress, 2, level);
367         }
368         
369 
370         if(referrerAddress != owner && referrerAddress != address(0)) {
371             users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress; // reduced a lot of code
372         }
373         
374         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
375         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
376         users[referrerAddress].x6Matrix[level].closedPart = address(0);
377 
378         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
379             users[referrerAddress].x6Matrix[level].blocked = true;
380         }
381 
382         users[referrerAddress].x6Matrix[level].reinvestCount++;
383         
384         if (referrerAddress != owner) {
385             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
386 
387             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
388             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
389         } else {
390             emit Reinvest(owner, address(0), userAddress, 2, level);
391             sendETHDividends(owner, userAddress, 2, level);
392         }
393     }
394     
395     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
396         while (true) {
397             if (users[users[userAddress].referrer].activeX3Levels[level]) {
398                 return users[userAddress].referrer;
399             }
400             
401             userAddress = users[userAddress].referrer;
402         }
403     }
404     
405     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
406         while (true) {
407             if (users[users[userAddress].referrer].activeX6Levels[level]) {
408                 return users[userAddress].referrer;
409             }
410             
411             userAddress = users[userAddress].referrer;
412         }
413     }
414         
415     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
416         return users[userAddress].activeX3Levels[level];
417     }
418 
419     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
420         return users[userAddress].activeX6Levels[level];
421     }
422 
423     function usersActiveNoRLevels(address userAddress, uint8 level) public view returns(bool) {
424         return users[userAddress].activeNoRLevels[level];
425     }
426     
427     function usersFilledNoRLevels(address userAddress, uint8 level) public view returns(bool) {
428         return users[userAddress].noRFilledLevels[level];
429     }
430 
431     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, uint) {
432         return (users[userAddress].x3Matrix[level].currentReferrer,
433                 users[userAddress].x3Matrix[level].referrals,
434                 users[userAddress].x3Matrix[level].blocked,
435                 users[userAddress].x3Matrix[level].reinvestCount
436                 );
437     }
438 
439     function getXNoRMatrix(uint8 level) public view returns(address, address[] memory) {
440         return (xNoRMatrix[level].currentUser,
441                 xNoRMatrix[level].referrals
442             );
443     }
444 
445     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address, uint) {
446         return (users[userAddress].x6Matrix[level].currentReferrer,
447                 users[userAddress].x6Matrix[level].firstLevelReferrals,
448                 users[userAddress].x6Matrix[level].secondLevelReferrals,
449                 users[userAddress].x6Matrix[level].blocked,
450                 users[userAddress].x6Matrix[level].closedPart,
451                 users[userAddress].x3Matrix[level].reinvestCount    
452             );
453     }
454     
455     function isUserExists(address user) public view returns (bool) {
456         return (users[user].id != 0);
457     }
458 
459     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
460         address receiver = userAddress;
461         bool isExtraDividends;
462         if (matrix == 1) {
463             while (true) {
464                 if (users[receiver].x3Matrix[level].blocked) {
465                     emit MissedEthReceive(receiver, _from, 1, level);
466                     isExtraDividends = true;
467                     receiver = users[receiver].x3Matrix[level].currentReferrer;
468                 } else {
469                     return (receiver, isExtraDividends);
470                 }
471             }
472         } else if(matrix == 2) {
473             while (true) {
474                 if (users[receiver].x6Matrix[level].blocked) {
475                     emit MissedEthReceive(receiver, _from, 2, level);
476                     isExtraDividends = true;
477                     receiver = users[receiver].x6Matrix[level].currentReferrer;
478                 } else {
479                     return (receiver, isExtraDividends);
480                 }
481             }
482         } else if(matrix == 3) {
483             return (receiver, false);
484         }
485     }
486 
487     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
488         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
489 
490         if (!address(uint160(receiver)).send(levelPrice[level])) { // ??? What is this check?
491             return address(uint160(receiver)).transfer(address(this).balance);
492         }
493         
494         if (isExtraDividends) {
495             emit SentExtraEthDividends(_from, receiver, matrix, level);
496         }
497     }
498     
499     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
500         assembly {
501             addr := mload(add(bys, 20))
502         }
503     }
504     
505     function enqueueToNoR(uint8 level, address item) private {
506         noRQueue[level].last += 1;
507         noRQueue[level].queue[noRQueue[level].last] = item;
508     }
509 
510     function dequeueToNoR(uint8 level) private
511     returns (address data) {
512         if(noRQueue[level].last >= noRQueue[level].first) {
513             data = noRQueue[level].queue[noRQueue[level].first];
514             delete noRQueue[level].queue[noRQueue[level].first];
515             noRQueue[level].first += 1;
516         }
517     }
518 }