1 pragma solidity >=0.4.23 <0.6.0;
2 
3 contract Endless {
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
41     uint public lastUserId = 2;
42     address public owner;
43 
44     mapping(uint8 => uint) public levelPrice;
45 
46     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
47     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
48     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
49     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
50     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
51     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
52 
53 
54     constructor(address ownerAddress) public {
55         levelPrice[1] = 0.025 ether;
56         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
57             levelPrice[i] = levelPrice[i-1] * 2;
58         }
59 
60         owner = ownerAddress;
61 
62         User memory user = User({
63             id: 1,
64             referrer: address(0),
65             partnersCount: uint(0)
66             });
67 
68         users[ownerAddress] = user;
69         idToAddress[1] = ownerAddress;
70 
71         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
72             users[ownerAddress].activeX3Levels[i] = true;
73             users[ownerAddress].activeX6Levels[i] = true;
74         }
75 
76         userIds[1] = ownerAddress;
77     }
78 
79     function() external payable {
80         if(msg.data.length == 0) {
81             return registration(msg.sender, owner);
82         }
83 
84         registration(msg.sender, bytesToAddress(msg.data));
85     }
86 
87     function registrationExt(address referrerAddress) external payable {
88         registration(msg.sender, referrerAddress);
89     }
90 
91     function buyNewLevel(uint8 matrix, uint8 level) external payable {
92         require(isUserExists(msg.sender), "user is not exists. Register first.");
93         require(matrix == 1 || matrix == 2, "invalid matrix");
94         require(msg.value == levelPrice[level], "invalid price");
95         require(level > 1 && level <= LAST_LEVEL, "invalid level");
96 
97         if (matrix == 1) {
98             require(!users[msg.sender].activeX3Levels[level], "level already activated");
99 
100             if (users[msg.sender].x3Matrix[level-1].blocked) {
101                 users[msg.sender].x3Matrix[level-1].blocked = false;
102             }
103 
104             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
105             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
106             users[msg.sender].activeX3Levels[level] = true;
107             updateX3Referrer(msg.sender, freeX3Referrer, level);
108 
109             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
110 
111         } else {
112             require(!users[msg.sender].activeX6Levels[level], "level already activated");
113 
114             if (users[msg.sender].x6Matrix[level-1].blocked) {
115                 users[msg.sender].x6Matrix[level-1].blocked = false;
116             }
117 
118             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
119 
120             users[msg.sender].activeX6Levels[level] = true;
121             updateX6Referrer(msg.sender, freeX6Referrer, level);
122 
123             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
124         }
125     }
126 
127     function registration(address userAddress, address referrerAddress) private {
128         require(msg.value == 0.05 ether, "registration cost 0.05");
129         require(!isUserExists(userAddress), "user exists");
130         require(isUserExists(referrerAddress), "referrer not exists");
131 
132         uint32 size;
133         assembly {
134             size := extcodesize(userAddress)
135         }
136         require(size == 0, "cannot be a contract");
137 
138         User memory user = User({
139             id: lastUserId,
140             referrer: referrerAddress,
141             partnersCount: 0
142             });
143 
144         users[userAddress] = user;
145         idToAddress[lastUserId] = userAddress;
146 
147         users[userAddress].referrer = referrerAddress;
148 
149         users[userAddress].activeX3Levels[1] = true;
150         users[userAddress].activeX6Levels[1] = true;
151 
152 
153         userIds[lastUserId] = userAddress;
154         lastUserId++;
155 
156         users[referrerAddress].partnersCount++;
157 
158         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
159         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
160         updateX3Referrer(userAddress, freeX3Referrer, 1);
161 
162         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
163 
164         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
165     }
166 
167     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
168         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
169 
170         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
171             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
172             return sendETHDividends(referrerAddress, userAddress, 1, level);
173         }
174 
175         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
176         //close matrix
177         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
178         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
179             users[referrerAddress].x3Matrix[level].blocked = true;
180         }
181 
182         //create new one by recursion
183         if (referrerAddress != owner) {
184             //check referrer active level
185             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
186             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
187                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
188             }
189 
190             users[referrerAddress].x3Matrix[level].reinvestCount++;
191             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
192             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
193         } else {
194             sendETHDividends(owner, userAddress, 1, level);
195             users[owner].x3Matrix[level].reinvestCount++;
196             emit Reinvest(owner, address(0), userAddress, 1, level);
197         }
198     }
199 
200     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
201         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
202 
203         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
204             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
205             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
206 
207             //set current level
208             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
209 
210             if (referrerAddress == owner) {
211                 return sendETHDividends(referrerAddress, userAddress, 2, level);
212             }
213 
214             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;
215             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress);
216 
217             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
218 
219             if ((len == 2) &&
220             (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
221                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
222                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
223                     emit NewUserPlace(userAddress, ref, 2, level, 5);
224                 } else {
225                     emit NewUserPlace(userAddress, ref, 2, level, 6);
226                 }
227             }  else if ((len == 1 || len == 2) &&
228             users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
229                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
230                     emit NewUserPlace(userAddress, ref, 2, level, 3);
231                 } else {
232                     emit NewUserPlace(userAddress, ref, 2, level, 4);
233                 }
234             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
235                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
236                     emit NewUserPlace(userAddress, ref, 2, level, 5);
237                 } else {
238                     emit NewUserPlace(userAddress, ref, 2, level, 6);
239                 }
240             }
241 
242             return updateX6ReferrerSecondLevel(userAddress, ref, level);
243         }
244 
245         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
246 
247         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
248             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
249             users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
250                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
251                 users[referrerAddress].x6Matrix[level].closedPart)) {
252 
253                 updateX6(userAddress, referrerAddress, level, true);
254                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
255             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
256                 users[referrerAddress].x6Matrix[level].closedPart) {
257                 updateX6(userAddress, referrerAddress, level, true);
258                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
259             } else {
260                 updateX6(userAddress, referrerAddress, level, false);
261                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
262             }
263         }
264 
265         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
266             updateX6(userAddress, referrerAddress, level, false);
267             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
268         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
269             updateX6(userAddress, referrerAddress, level, true);
270             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
271         }
272 
273         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <=
274             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
275             updateX6(userAddress, referrerAddress, level, false);
276         } else {
277             updateX6(userAddress, referrerAddress, level, true);
278         }
279 
280         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
281     }
282 
283     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
284         if (!x2) {
285             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
286             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
287             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
288             //set current level
289             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
290         } else {
291             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
292             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
293             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
294             //set current level
295             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
296         }
297     }
298 
299     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
300         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
301             return sendETHDividends(referrerAddress, userAddress, 2, level);
302         }
303 
304         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
305 
306         if (x6.length == 2) {
307             if (x6[0] == referrerAddress ||
308             x6[1] == referrerAddress) {
309                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
310             } else if (x6.length == 1) {
311                 if (x6[0] == referrerAddress) {
312                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
313                 }
314             }
315         }
316 
317         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
318         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
319         users[referrerAddress].x6Matrix[level].closedPart = address(0);
320 
321         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
322             users[referrerAddress].x6Matrix[level].blocked = true;
323         }
324 
325         users[referrerAddress].x6Matrix[level].reinvestCount++;
326 
327         if (referrerAddress != owner) {
328             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
329 
330             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
331             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
332         } else {
333             emit Reinvest(owner, address(0), userAddress, 2, level);
334             sendETHDividends(owner, userAddress, 2, level);
335         }
336     }
337 
338     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
339         while (true) {
340             if (users[users[userAddress].referrer].activeX3Levels[level]) {
341                 return users[userAddress].referrer;
342             }
343 
344             userAddress = users[userAddress].referrer;
345         }
346     }
347 
348     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
349         while (true) {
350             if (users[users[userAddress].referrer].activeX6Levels[level]) {
351                 return users[userAddress].referrer;
352             }
353 
354             userAddress = users[userAddress].referrer;
355         }
356     }
357 
358     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
359         return users[userAddress].activeX3Levels[level];
360     }
361 
362     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
363         return users[userAddress].activeX6Levels[level];
364     }
365 
366     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool,uint) {
367         return (users[userAddress].x3Matrix[level].currentReferrer,
368         users[userAddress].x3Matrix[level].referrals,
369         users[userAddress].x3Matrix[level].blocked,
370         users[userAddress].x3Matrix[level].reinvestCount);
371     }
372 
373     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address,uint) {
374         return (users[userAddress].x6Matrix[level].currentReferrer,
375         users[userAddress].x6Matrix[level].firstLevelReferrals,
376         users[userAddress].x6Matrix[level].secondLevelReferrals,
377         users[userAddress].x6Matrix[level].blocked,
378         users[userAddress].x6Matrix[level].closedPart,
379         users[userAddress].x6Matrix[level].reinvestCount);
380     }
381 
382     function isUserExists(address user) public view returns (bool) {
383         return (users[user].id != 0);
384     }
385 
386     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
387         address receiver = userAddress;
388         bool isExtraDividends;
389         if (matrix == 1) {
390             while (true) {
391                 if (users[receiver].x3Matrix[level].blocked) {
392                     emit MissedEthReceive(receiver, _from, 1, level);
393                     isExtraDividends = true;
394                     receiver = users[receiver].x3Matrix[level].currentReferrer;
395                 } else {
396                     return (receiver, isExtraDividends);
397                 }
398             }
399         } else {
400             while (true) {
401                 if (users[receiver].x6Matrix[level].blocked) {
402                     emit MissedEthReceive(receiver, _from, 2, level);
403                     isExtraDividends = true;
404                     receiver = users[receiver].x6Matrix[level].currentReferrer;
405                 } else {
406                     return (receiver, isExtraDividends);
407                 }
408             }
409         }
410     }
411 
412     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
413         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
414 
415         if (!address(uint160(receiver)).send(levelPrice[level])) {
416             return address(uint160(receiver)).transfer(address(this).balance);
417         }
418 
419         if (isExtraDividends) {
420             emit SentExtraEthDividends(_from, receiver, matrix, level);
421         }
422     }
423 
424     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
425         assembly {
426             addr := mload(add(bys, 20))
427         }
428     }
429 }