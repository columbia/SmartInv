1 /**
2  * Submitted for verification at Ethereum.io on 2020-07-16
3 */
4 
5 /**
6  *   +-------------------------------------------------------------------+
7  *   |                                                                   |
8  *   |                                                                   |
9  *   |   +------+                                           +            |
10  *   |   |       -+                                         |    ++      |
11  *   |   |         -+                                       |            |
12  *   |   |          ++        ++         +----+       +---+ |    ++      |
13  *   |   |          ||      +-  -+      +-    -+     ++   +-+    ||      |
14  *   |   |          ++     ++    ++     |      |     |      |    ||      |
15  *   |   |         -+      ++    ++     |      |     |      |    ||      |
16  *   |   |       -+         +-  -+      |      |     ++   +-+    ||      |
17  *   |   +------+             ++       ++      +-+    +---+ ++   ++      |
18  *   |                                                                   |
19  *   |                                                                   |
20  *   +-------------------------------------------------------------------+
21  **/
22  
23 pragma solidity >=0.4.23 <0.7.0;
24 
25 contract SmartContractDondi {
26     
27     // user structure
28     struct User {
29         uint id;
30         address referrer;
31         uint partnersCount;
32         
33         mapping(uint8 => bool) activeX3Levels;
34         mapping(uint8 => bool) activeX6Levels;
35         
36         mapping(uint8 => X3) x3Matrix;
37         mapping(uint8 => X6) x6Matrix;
38     }
39 
40     // x3 matrix
41     struct X3 {
42         address currentReferrer;
43         address[] referrals;
44         bool blocked;
45         uint reinvestCount;
46     }
47     
48     // x6 matrix
49     struct X6 {
50         address currentReferrer;
51         address[] firstLevelReferrals;
52         address[] secondLevelReferrals;
53         bool blocked;
54         uint reinvestCount;
55 
56         address closedPart;
57     }
58 
59     // slot count
60     uint8 public constant LAST_LEVEL = 12;
61     
62     mapping(address => User) public users;
63     mapping(uint => address) public idToAddress;
64     mapping(uint => address) public userIds;
65     mapping(address => uint) public balances; 
66 
67     uint public lastUserId = 2;
68     address public owner;
69     
70     mapping(uint8 => uint) public levelPrice;
71     
72     // signals
73     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
74     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
75     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
76     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
77     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
78     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
79 
80     // constructor of SmartContractDondi
81     constructor(address ownerAddress) public {
82         // initial price(ether) per each slot
83         levelPrice[1] = 0.025 ether;
84 
85         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
86             levelPrice[i] = levelPrice[i-1] * 2;
87         }
88         
89         owner = ownerAddress;
90         
91         User memory user = User({
92             id: 1,
93             referrer: address(0),
94             partnersCount: uint(0)
95         });
96         
97         users[ownerAddress] = user;
98         idToAddress[1] = ownerAddress;
99         
100         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
101             users[ownerAddress].activeX3Levels[i] = true;
102             users[ownerAddress].activeX6Levels[i] = true;
103         }
104         
105         userIds[1] = ownerAddress;
106     }
107 
108     // external payable functions
109     function() external payable {
110         if(msg.data.length == 0) {
111             return registration(msg.sender, owner);
112         }
113         
114         registration(msg.sender, bytesToAddress(msg.data));
115     }
116 
117     // external payable functions
118     function registrationExt(address referrerAddress) external payable {
119         registration(msg.sender, referrerAddress);
120     }
121     
122     // external payable functions
123     function buyNewLevel(uint8 matrix, uint8 level) external payable {
124         require(isUserExists(msg.sender), "user is not exists. Register first.");
125         require(matrix == 1 || matrix == 2, "invalid matrix");
126         require(msg.value == levelPrice[level], "invalid price");
127         require(level > 1 && level <= LAST_LEVEL, "invalid level");
128 
129         if (matrix == 1) {
130             require(!users[msg.sender].activeX3Levels[level], "level already activated");
131 
132             if (users[msg.sender].x3Matrix[level-1].blocked) {
133                 users[msg.sender].x3Matrix[level-1].blocked = false;
134             }
135     
136             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
137             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
138             users[msg.sender].activeX3Levels[level] = true;
139             updateX3Referrer(msg.sender, freeX3Referrer, level);
140             
141             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
142 
143         } else {
144             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
145 
146             if (users[msg.sender].x6Matrix[level-1].blocked) {
147                 users[msg.sender].x6Matrix[level-1].blocked = false;
148             }
149 
150             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
151             
152             users[msg.sender].activeX6Levels[level] = true;
153             updateX6Referrer(msg.sender, freeX6Referrer, level);
154             
155             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
156         }
157     }
158 
159     // pure functions
160     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
161         assembly {
162             addr := mload(add(bys, 20))
163         }
164     }
165 
166     // private functions - find Ethereum Receiver
167     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
168         address receiver = userAddress;
169         bool isExtraDividends;
170         if (matrix == 1) {
171             while (true) {
172                 if (users[receiver].x3Matrix[level].blocked) {
173                     emit MissedEthReceive(receiver, _from, 1, level);
174                     isExtraDividends = true;
175                     receiver = users[receiver].x3Matrix[level].currentReferrer;
176                 } else {
177                     return (receiver, isExtraDividends);
178                 }
179             }
180         } else {
181             while (true) {
182                 if (users[receiver].x6Matrix[level].blocked) {
183                     emit MissedEthReceive(receiver, _from, 2, level);
184                     isExtraDividends = true;
185                     receiver = users[receiver].x6Matrix[level].currentReferrer;
186                 } else {
187                     return (receiver, isExtraDividends);
188                 }
189             }
190         }
191     }
192 
193     // private functions - send Ethereum Dividends
194     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
195         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
196 
197         if (!address(uint160(receiver)).send(levelPrice[level])) {
198             return address(uint160(receiver)).transfer(address(this).balance);
199         }
200         
201         if (isExtraDividends) {
202             emit SentExtraEthDividends(_from, receiver, matrix, level);
203         }
204     }
205 
206     // user register function
207     function registration(address userAddress, address referrerAddress) private {
208         require(msg.value == 0.05 ether, "registration cost 0.05");
209         require(!isUserExists(userAddress), "user exists");
210         require(isUserExists(referrerAddress), "referrer not exists");
211         
212         uint32 size;
213         assembly {
214             size := extcodesize(userAddress)
215         }
216         require(size == 0, "cannot be a contract");
217         
218         User memory user = User({
219             id: lastUserId,
220             referrer: referrerAddress,
221             partnersCount: 0
222         });
223         
224         users[userAddress] = user;
225         idToAddress[lastUserId] = userAddress;
226         
227         users[userAddress].referrer = referrerAddress;
228         
229         users[userAddress].activeX3Levels[1] = true; 
230         users[userAddress].activeX6Levels[1] = true;
231         
232         
233         userIds[lastUserId] = userAddress;
234         lastUserId++;
235         
236         users[referrerAddress].partnersCount++;
237 
238         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
239         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
240         updateX3Referrer(userAddress, freeX3Referrer, 1);
241 
242         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
243         
244         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
245     }
246 
247     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
248         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
249 
250         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
251             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
252             return sendETHDividends(referrerAddress, userAddress, 1, level);
253         }
254         
255         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
256         //close matrix
257         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
258         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
259             users[referrerAddress].x3Matrix[level].blocked = true;
260         }
261 
262         //create new one by recursion
263         if (referrerAddress != owner) {
264             //check referrer active level
265             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
266             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
267                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
268             }
269             
270             users[referrerAddress].x3Matrix[level].reinvestCount++;
271             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
272             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
273         } else {
274             sendETHDividends(owner, userAddress, 1, level);
275             users[owner].x3Matrix[level].reinvestCount++;
276             emit Reinvest(owner, address(0), userAddress, 1, level);
277         }
278     }
279 
280     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
281         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
282         
283         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
284             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
285             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
286             
287             //set current level
288             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
289 
290             if (referrerAddress == owner) {
291                 return sendETHDividends(referrerAddress, userAddress, 2, level);
292             }
293             
294             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
295             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
296             
297             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
298             
299             if ((len == 2) && 
300                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
301                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
302                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
303                     emit NewUserPlace(userAddress, ref, 2, level, 5);
304                 } else {
305                     emit NewUserPlace(userAddress, ref, 2, level, 6);
306                 }
307             }  else if ((len == 1 || len == 2) &&
308                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
309                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
310                     emit NewUserPlace(userAddress, ref, 2, level, 3);
311                 } else {
312                     emit NewUserPlace(userAddress, ref, 2, level, 4);
313                 }
314             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
315                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
316                     emit NewUserPlace(userAddress, ref, 2, level, 5);
317                 } else {
318                     emit NewUserPlace(userAddress, ref, 2, level, 6);
319                 }
320             }
321 
322             return updateX6ReferrerSecondLevel(userAddress, ref, level);
323         }
324         
325         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
326 
327         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
328             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
329                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
330                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
331                 users[referrerAddress].x6Matrix[level].closedPart)) {
332 
333                 updateX6(userAddress, referrerAddress, level, true);
334                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
335             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
336                 users[referrerAddress].x6Matrix[level].closedPart) {
337                 updateX6(userAddress, referrerAddress, level, true);
338                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
339             } else {
340                 updateX6(userAddress, referrerAddress, level, false);
341                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
342             }
343         }
344 
345         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
346             updateX6(userAddress, referrerAddress, level, false);
347             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
348         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
349             updateX6(userAddress, referrerAddress, level, true);
350             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
351         }
352         
353         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
354             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
355             updateX6(userAddress, referrerAddress, level, false);
356         } else {
357             updateX6(userAddress, referrerAddress, level, true);
358         }
359         
360         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
361     }
362 
363     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
364         if (!x2) {
365             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
366             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
367             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
368             //set current level
369             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
370         } else {
371             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
372             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
373             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
374             //set current level
375             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
376         }
377     }
378     
379     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
380         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
381             return sendETHDividends(referrerAddress, userAddress, 2, level);
382         }
383         
384         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
385         
386         if (x6.length == 2) {
387             if (x6[0] == referrerAddress ||
388                 x6[1] == referrerAddress) {
389                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
390             } else if (x6.length == 1) {
391                 if (x6[0] == referrerAddress) {
392                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
393                 }
394             }
395         }
396         
397         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
398         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
399         users[referrerAddress].x6Matrix[level].closedPart = address(0);
400 
401         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
402             users[referrerAddress].x6Matrix[level].blocked = true;
403         }
404 
405         users[referrerAddress].x6Matrix[level].reinvestCount++;
406         
407         if (referrerAddress != owner) {
408             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
409 
410             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
411             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
412         } else {
413             emit Reinvest(owner, address(0), userAddress, 2, level);
414             sendETHDividends(owner, userAddress, 2, level);
415         }
416     }
417 
418     // public views - check user
419     function isUserExists(address user) public view returns (bool) {
420         return (users[user].id != 0);
421     }
422 
423     // public views - get user matrix
424     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
425         return (users[userAddress].x3Matrix[level].currentReferrer,
426                 users[userAddress].x3Matrix[level].referrals,
427                 users[userAddress].x3Matrix[level].blocked);
428     }
429 
430     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
431         return (users[userAddress].x6Matrix[level].currentReferrer,
432                 users[userAddress].x6Matrix[level].firstLevelReferrals,
433                 users[userAddress].x6Matrix[level].secondLevelReferrals,
434                 users[userAddress].x6Matrix[level].blocked,
435                 users[userAddress].x6Matrix[level].closedPart);
436     }
437 
438     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
439         return users[userAddress].activeX3Levels[level];
440     }
441 
442     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
443         return users[userAddress].activeX6Levels[level];
444     }
445 
446     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
447         while (true) {
448             if (users[users[userAddress].referrer].activeX3Levels[level]) {
449                 return users[userAddress].referrer;
450             }
451             
452             userAddress = users[userAddress].referrer;
453         }
454     }
455     
456     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
457         while (true) {
458             if (users[users[userAddress].referrer].activeX6Levels[level]) {
459                 return users[userAddress].referrer;
460             }
461             
462             userAddress = users[userAddress].referrer;
463         }
464     }
465 }