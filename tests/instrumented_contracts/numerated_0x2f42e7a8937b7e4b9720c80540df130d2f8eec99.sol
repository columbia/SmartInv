1 /**
2  * ether convention
3 ** BBBBBB  BBBBBBB  BB    BB 
4 *  BBB       BBB    BB    BB 
5 *  BBBBBB    BBB    BBBBBBBB
6 *  BBB       BBB    BB    BB 
7 *  BBBBBB    BBB    BB    BB 
8 * 
9 *   BBBB     BBB    BBBB   B       B  BBBBB     BBBB   BBBBB  B   BBB    BBB       
10 *  B       B    B  B    B   B     B   B        B    B    B    B  B   B  B   B
11 * B        B    B  B    B    B   B    BBBBB    B    B    B    B  B   B  B   B
12 *  B       B    B  B    B     B B     B        B    B    B    B  B   B  B   B
13 *  BBBB     BBB    B    B      B      BBBBB    B    B    B    B   BBB   B   B
14 * 
15 * SmartWay convention
16 * https://www.convention.group
17 * (only for SmartWay.run members)
18 * 
19 **/
20 
21 
22 pragma solidity >=0.4.23 <0.6.0;
23 
24 contract SmartMatrixForsage {
25     
26     struct User {
27         uint id;
28         address referrer;
29         uint partnersCount;
30         
31         mapping(uint8 => bool) activeX3Levels;
32         mapping(uint8 => bool) activeX6Levels;
33         
34         mapping(uint8 => X3) x3Matrix;
35         mapping(uint8 => X6) x6Matrix;
36     }
37     
38     struct X3 {
39         address currentReferrer;
40         address[] referrals;
41         bool blocked;
42         uint reinvestCount;
43     }
44     
45     struct X6 {
46         address currentReferrer;
47         address[] firstLevelReferrals;
48         address[] secondLevelReferrals;
49         bool blocked;
50         uint reinvestCount;
51 
52         address closedPart;
53     }
54 
55     uint8 public constant LAST_LEVEL = 10;
56     uint256 public poolTempAmount = 0; 
57     
58     mapping(address => User) public users;
59     mapping(uint => address) public idToAddress;
60     mapping(uint => address) public userIds;
61     mapping(address => uint) public balances; 
62 
63     uint public lastUserId = 2;
64     address public owner;
65     address public contractOwner;
66     address public poolAdmin;
67     
68     mapping(uint8 => uint) public levelPrice;
69     
70     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
71     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
72     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
73     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
74     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
75     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
76     
77     
78     constructor(address ownerAddress, address pool) public {
79         levelPrice[1] = 0.05 ether;
80         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
81             levelPrice[i] = levelPrice[i-1] * 2;
82         }
83         
84         owner = ownerAddress;
85         contractOwner = msg.sender;
86         poolAdmin = pool;
87         User memory user = User({
88             id: 1,
89             referrer: address(0),
90             partnersCount: uint(0)
91         });
92         
93         users[ownerAddress] = user;
94         idToAddress[1] = ownerAddress;
95         
96         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
97             users[ownerAddress].activeX3Levels[i] = true;
98             users[ownerAddress].activeX6Levels[i] = true;
99         }
100         
101         userIds[1] = ownerAddress;
102        
103     }
104     
105     function() external payable {
106         if(msg.data.length == 0) {
107             return registration(msg.sender, owner);
108         }
109         
110         registration(msg.sender, bytesToAddress(msg.data));
111     }
112 
113     function registrationExt(address referrerAddress) external payable {
114         registration(msg.sender, referrerAddress);
115     }
116     
117     function buyNewLevel(uint8 matrix, uint8 level) external payable {
118         require(isUserExists(msg.sender), "user is not exists. Register first.");
119         require(matrix == 1 || matrix == 2, "invalid matrix");
120         require(msg.value == levelPrice[level], "invalid price");
121         require(level > 1 && level <= LAST_LEVEL, "invalid level");
122 
123         if (matrix == 1) {
124             require(!users[msg.sender].activeX3Levels[level], "level already activated");
125 
126             if (users[msg.sender].x3Matrix[level-1].blocked) {
127                 users[msg.sender].x3Matrix[level-1].blocked = false;
128             }
129     
130             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
131             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
132             users[msg.sender].activeX3Levels[level] = true;
133             updateX3Referrer(msg.sender, freeX3Referrer, level);
134             
135             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
136 
137         } else {
138             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
139 
140             if (users[msg.sender].x6Matrix[level-1].blocked) {
141                 users[msg.sender].x6Matrix[level-1].blocked = false;
142             }
143 
144             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
145             
146             users[msg.sender].activeX6Levels[level] = true;
147             updateX6Referrer(msg.sender, freeX6Referrer, level);
148             
149             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
150         }
151     }    
152     
153     function registration(address userAddress, address referrerAddress) private {
154         require(msg.value == 0.1 ether, "registration cost 0.1");
155         require(!isUserExists(userAddress), "user exists");
156         require(isUserExists(referrerAddress), "referrer not exists");
157         
158         uint32 size;
159         assembly {
160             size := extcodesize(userAddress)
161         }
162         require(size == 0, "cannot be a contract");
163         
164         User memory user = User({
165             id: lastUserId,
166             referrer: referrerAddress,
167             partnersCount: 0
168         });
169         
170         users[userAddress] = user;
171         idToAddress[lastUserId] = userAddress;
172         
173         users[userAddress].referrer = referrerAddress;
174         
175         users[userAddress].activeX3Levels[1] = true; 
176         users[userAddress].activeX6Levels[1] = true;
177         
178         
179         userIds[lastUserId] = userAddress;
180         lastUserId++;
181         
182         users[referrerAddress].partnersCount++;
183 
184         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
185         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
186         updateX3Referrer(userAddress, freeX3Referrer, 1);
187 
188         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
189         
190         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
191     }
192     
193     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
194         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
195 
196         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
197             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
198             return sendETHDividends(referrerAddress, userAddress, 1, level);
199         }
200         
201         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
202         //close matrix
203         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
204         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
205             users[referrerAddress].x3Matrix[level].blocked = true;
206         }
207 
208         //create new one by recursion
209         if (referrerAddress != owner) {
210             //check referrer active level
211             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
212             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
213                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
214             }
215             
216             users[referrerAddress].x3Matrix[level].reinvestCount++;
217             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
218             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
219         } else {
220             sendETHDividends(owner, userAddress, 1, level);
221             users[owner].x3Matrix[level].reinvestCount++;
222             emit Reinvest(owner, address(0), userAddress, 1, level);
223         }
224     }
225 
226     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
227         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
228         
229         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
230             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
231             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
232             
233             //set current level
234             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
235 
236             if (referrerAddress == owner) {
237                 return sendETHDividends(referrerAddress, userAddress, 2, level);
238             }
239             
240             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
241             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
242             
243             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
244             
245             if ((len == 2) && 
246                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
247                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
248                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
249                     emit NewUserPlace(userAddress, ref, 2, level, 5);
250                 } else {
251                     emit NewUserPlace(userAddress, ref, 2, level, 6);
252                 }
253             }  else if ((len == 1 || len == 2) &&
254                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
255                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
256                     emit NewUserPlace(userAddress, ref, 2, level, 3);
257                 } else {
258                     emit NewUserPlace(userAddress, ref, 2, level, 4);
259                 }
260             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
261                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
262                     emit NewUserPlace(userAddress, ref, 2, level, 5);
263                 } else {
264                     emit NewUserPlace(userAddress, ref, 2, level, 6);
265                 }
266             }
267 
268             return updateX6ReferrerSecondLevel(userAddress, ref, level);
269         }
270         
271         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
272 
273         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
274             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
275                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
276                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
277                 users[referrerAddress].x6Matrix[level].closedPart)) {
278 
279                 updateX6(userAddress, referrerAddress, level, true);
280                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
281             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
282                 users[referrerAddress].x6Matrix[level].closedPart) {
283                 updateX6(userAddress, referrerAddress, level, true);
284                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
285             } else {
286                 updateX6(userAddress, referrerAddress, level, false);
287                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
288             }
289         }
290 
291         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
292             updateX6(userAddress, referrerAddress, level, false);
293             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
294         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
295             updateX6(userAddress, referrerAddress, level, true);
296             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
297         }
298         
299         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
300             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
301             updateX6(userAddress, referrerAddress, level, false);
302         } else {
303             updateX6(userAddress, referrerAddress, level, true);
304         }
305         
306         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
307     }
308 
309     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
310         if (!x2) {
311             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
312             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
313             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
314             //set current level
315             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
316         } else {
317             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
318             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
319             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
320             //set current level
321             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
322         }
323     }
324     
325     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
326         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
327             return sendETHDividends(referrerAddress, userAddress, 2, level);
328         }
329         
330         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
331         
332         if (x6.length == 2) {
333             if (x6[0] == referrerAddress ||
334                 x6[1] == referrerAddress) {
335                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
336             } else if (x6.length == 1) {
337                 if (x6[0] == referrerAddress) {
338                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
339                 }
340             }
341         }
342         
343         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
344         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
345         users[referrerAddress].x6Matrix[level].closedPart = address(0);
346 
347         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
348             users[referrerAddress].x6Matrix[level].blocked = true;
349         }
350 
351         users[referrerAddress].x6Matrix[level].reinvestCount++;
352         
353         if (referrerAddress != owner) {
354             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
355 
356             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
357             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
358         } else {
359             emit Reinvest(owner, address(0), userAddress, 2, level);
360             sendETHDividends(owner, userAddress, 2, level);
361         }
362     }
363     
364     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
365         while (true) {
366             if (users[users[userAddress].referrer].activeX3Levels[level]) {
367                 return users[userAddress].referrer;
368             }
369             
370             userAddress = users[userAddress].referrer;
371         }
372     }
373     
374     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
375         while (true) {
376             if (users[users[userAddress].referrer].activeX6Levels[level]) {
377                 return users[userAddress].referrer;
378             }
379             
380             userAddress = users[userAddress].referrer;
381         }
382     }
383         
384     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
385         return users[userAddress].activeX3Levels[level];
386     }
387 
388     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
389         return users[userAddress].activeX6Levels[level];
390     }
391 
392     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
393         return (users[userAddress].x3Matrix[level].currentReferrer,
394                 users[userAddress].x3Matrix[level].referrals,
395                 users[userAddress].x3Matrix[level].blocked);
396     }
397 
398     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
399         return (users[userAddress].x6Matrix[level].currentReferrer,
400                 users[userAddress].x6Matrix[level].firstLevelReferrals,
401                 users[userAddress].x6Matrix[level].secondLevelReferrals,
402                 users[userAddress].x6Matrix[level].blocked,
403                 users[userAddress].x6Matrix[level].closedPart);
404     }
405     
406     function isUserExists(address user) public view returns (bool) {
407         return (users[user].id != 0);
408     }
409 
410     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
411         address receiver = userAddress;
412         bool isExtraDividends;
413         if (matrix == 1) {
414             while (true) {
415                 if (users[receiver].x3Matrix[level].blocked) {
416                     emit MissedEthReceive(receiver, _from, 1, level);
417                     isExtraDividends = true;
418                     receiver = users[receiver].x3Matrix[level].currentReferrer;
419                 } else {
420                     return (receiver, isExtraDividends);
421                 }
422             }
423         } else {
424             while (true) {
425                 if (users[receiver].x6Matrix[level].blocked) {
426                     emit MissedEthReceive(receiver, _from, 2, level);
427                     isExtraDividends = true;
428                     receiver = users[receiver].x6Matrix[level].currentReferrer;
429                 } else {
430                     return (receiver, isExtraDividends);
431                 }
432             }
433         }
434     }
435 
436     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
437         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
438         
439         address(uint160(poolAdmin)).transfer(levelPrice[level]*3/10);
440         if (!address(uint160(receiver)).send(levelPrice[level]*7/10)) {
441             return address(uint160(receiver)).transfer(address(this).balance);
442         }
443         poolTempAmount = poolTempAmount + uint256(levelPrice[level]*3/10);
444         if (isExtraDividends) {
445             emit SentExtraEthDividends(_from, receiver, matrix, level);
446         }
447     }
448     
449     function clearPool() public {
450         require(msg.sender==contractOwner ,"No Auth.");
451         poolTempAmount = uint256(0);
452     }
453     
454     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
455         assembly {
456             addr := mload(add(bys, 20))
457         }
458     }
459 }