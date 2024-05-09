1 pragma solidity >=0.4.23 <0.7.0;
2 
3 interface DONDISlotHarvester {
4     function register(address user, address referrer) external;
5 }
6 
7 contract SmartContractDondi {
8     
9     // user structure
10     struct User {
11         uint id;
12         address referrer;
13         uint partnersCount;
14         
15         mapping(uint8 => bool) activeX3Levels;
16         mapping(uint8 => bool) activeX6Levels;
17         
18         mapping(uint8 => X3) x3Matrix;
19         mapping(uint8 => X6) x6Matrix;
20     }
21 
22     // x3 matrix
23     struct X3 {
24         address currentReferrer;
25         address[] referrals;
26         bool blocked;
27         uint reinvestCount;
28     }
29     
30     // x6 matrix
31     struct X6 {
32         address currentReferrer;
33         address[] firstLevelReferrals;
34         address[] secondLevelReferrals;
35         bool blocked;
36         uint reinvestCount;
37 
38         address closedPart;
39     }
40 
41     // slot count
42     uint8 public constant LAST_LEVEL = 12;
43     
44     mapping(address => User) public users;
45     mapping(uint => address) public idToAddress;
46     mapping(uint => address) public userIds;
47     mapping(address => uint) public balances; 
48 
49     uint public lastUserId = 2;
50     address public owner;
51     DONDISlotHarvester public harvester = DONDISlotHarvester(0x7BF87882611c9A0FE92FdAAfFC9Ed0d241305EEe);
52 
53     mapping(uint8 => uint) public levelPrice;
54     
55     // signals
56     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
57     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
58     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
59     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
60     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
61     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
62 
63     // constructor of SmartContractDondi
64     constructor(address ownerAddress) public {
65         // initial price(ether) per each slot
66         levelPrice[1] = 0.025 ether;
67 
68         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
69             levelPrice[i] = levelPrice[i-1] * 2;
70         }
71         
72         owner = ownerAddress;
73         User memory user = User({
74             id: 1,
75             referrer: address(0),
76             partnersCount: uint(0)
77         });
78         
79         users[ownerAddress] = user;
80         idToAddress[1] = ownerAddress;
81         
82         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
83             users[ownerAddress].activeX3Levels[i] = true;
84             users[ownerAddress].activeX6Levels[i] = true;
85         }
86         userIds[1] = ownerAddress;
87     }
88 
89     // external payable functions
90     function() external payable {
91         if(msg.data.length == 0) {
92             return registration(msg.sender, owner);
93         }
94         
95         registration(msg.sender, bytesToAddress(msg.data));
96     }
97 
98     function getOwner() external view returns(address) {
99         return owner;
100     }
101 
102     // external payable functions
103     function registrationExt(address referrerAddress) external payable {
104         registration(msg.sender, referrerAddress);
105     }
106     
107     // external payable functions
108     function buyNewLevel(uint8 matrix, uint8 level) external payable {
109         require(isUserExists(msg.sender), "user is not exists. Register first.");
110         require(matrix == 1 || matrix == 2, "invalid matrix");
111         require(msg.value == levelPrice[level], "invalid price");
112         require(level > 1 && level <= LAST_LEVEL, "invalid level");
113 
114         if (matrix == 1) {
115             require(!users[msg.sender].activeX3Levels[level], "level already activated");
116 
117             if (users[msg.sender].x3Matrix[level-1].blocked) {
118                 users[msg.sender].x3Matrix[level-1].blocked = false;
119             }
120     
121             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
122             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
123             users[msg.sender].activeX3Levels[level] = true;
124             updateX3Referrer(msg.sender, freeX3Referrer, level);
125             
126             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
127 
128         } else {
129             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
130 
131             if (users[msg.sender].x6Matrix[level-1].blocked) {
132                 users[msg.sender].x6Matrix[level-1].blocked = false;
133             }
134 
135             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
136             
137             users[msg.sender].activeX6Levels[level] = true;
138             updateX6Referrer(msg.sender, freeX6Referrer, level);
139             
140             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
141         }
142     }
143 
144     // pure functions
145     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
146         assembly {
147             addr := mload(add(bys, 20))
148         }
149     }
150 
151     // private functions - find Ethereum Receiver
152     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
153         address receiver = userAddress;
154         bool isExtraDividends;
155         if (matrix == 1) {
156             while (true) {
157                 if (users[receiver].x3Matrix[level].blocked) {
158                     emit MissedEthReceive(receiver, _from, 1, level);
159                     isExtraDividends = true;
160                     receiver = users[receiver].x3Matrix[level].currentReferrer;
161                 } else {
162                     return (receiver, isExtraDividends);
163                 }
164             }
165         } else {
166             while (true) {
167                 if (users[receiver].x6Matrix[level].blocked) {
168                     emit MissedEthReceive(receiver, _from, 2, level);
169                     isExtraDividends = true;
170                     receiver = users[receiver].x6Matrix[level].currentReferrer;
171                 } else {
172                     return (receiver, isExtraDividends);
173                 }
174             }
175         }
176     }
177 
178     // private functions - send Ethereum Dividends
179     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
180         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
181 
182         // new fee logic
183         uint256 sendAmount = levelPrice[level] * 90 / 100;
184         uint256 feeAmount = levelPrice[level] * 10 / 100;
185         
186         
187         if (!address(uint160(owner)).send(feeAmount)) {
188             address(uint160(owner)).transfer(feeAmount);
189         }
190 
191         if (!address(uint160(receiver)).send(sendAmount)) {
192             return address(uint160(receiver)).transfer(sendAmount);
193         }
194     
195         // if (!address(uint160(receiver)).send(levelPrice[level])) {
196         //     return address(uint160(receiver)).transfer(address(this).balance);
197         // }
198         
199         
200         if (isExtraDividends) {
201             emit SentExtraEthDividends(_from, receiver, matrix, level);
202         }
203     }
204 
205     // user register function
206     function registration(address userAddress, address referrerAddress) private {
207         require(msg.value == 0.05 ether, "registration cost 0.05");
208         require(!isUserExists(userAddress), "user exists");
209         require(isUserExists(referrerAddress), "referrer not exists");
210         
211         uint32 size;
212         assembly {
213             size := extcodesize(userAddress)
214         }
215         require(size == 0, "cannot be a contract");
216         
217         User memory user = User({
218             id: lastUserId,
219             referrer: referrerAddress,
220             partnersCount: 0
221         });
222         
223         users[userAddress] = user;
224         idToAddress[lastUserId] = userAddress;
225         
226         users[userAddress].referrer = referrerAddress;
227         
228         users[userAddress].activeX3Levels[1] = true; 
229         users[userAddress].activeX6Levels[1] = true;
230         
231         
232         userIds[lastUserId] = userAddress;
233         lastUserId++;
234         
235         users[referrerAddress].partnersCount++;
236 
237         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
238         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
239         updateX3Referrer(userAddress, freeX3Referrer, 1);
240 
241         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
242         // havest
243         harvester.register(userAddress, referrerAddress);
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
438     function usersActiveX3Levels(address userAddress, uint8 level) external view returns(bool) {
439         return users[userAddress].activeX3Levels[level];
440     }
441 
442     function usersActiveX6Levels(address userAddress, uint8 level) external view returns(bool) {
443         return users[userAddress].activeX6Levels[level];
444     }
445 
446     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
447         while (true) {
448             if (users[users[userAddress].referrer].activeX3Levels[level]) {
449                 return users[userAddress].referrer;
450             }
451             userAddress = users[userAddress].referrer;
452         }
453     }
454     
455     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
456         while (true) {
457             if (users[users[userAddress].referrer].activeX6Levels[level]) {
458                 return users[userAddress].referrer;
459             }
460             userAddress = users[userAddress].referrer;
461         }
462     }
463 }