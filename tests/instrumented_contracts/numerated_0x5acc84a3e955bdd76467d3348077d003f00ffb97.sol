1 /**
2 *
3 *   ,d8888b                                                    
4 *   88P'                                                       
5 *d888888P                                                      
6 *  ?88'     d8888b   88bd88b .d888b, d888b8b   d888b8b   d8888b
7 *  88P     d8P' ?88  88P'  ` ?8b,   d8P' ?88  d8P' ?88  d8b_,dP
8 * d88      88b  d88 d88        `?8b 88b  ,88b 88b  ,88b 88b    
9 *d88'      `?8888P'd88'     `?888P' `?88P'`88b`?88P'`88b`?888P'
10 *                                                    )88       
11 *                                                   ,88P       
12 *                                               `?8888P        
13 *
14 * 
15 * SmartWay Forsage
16 * https://forsage.smartway.run
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
55     uint8 public constant LAST_LEVEL = 12;
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
70     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
71     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
72     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
73     
74     
75     constructor(address ownerAddress) public {
76         levelPrice[1] = 0.025 ether;
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
95         }
96         
97         userIds[1] = ownerAddress;
98     }
99     
100     function() external payable {
101         if(msg.data.length == 0) {
102             return registration(msg.sender, owner);
103         }
104         
105         registration(msg.sender, bytesToAddress(msg.data));
106     }
107 
108     function registrationExt(address referrerAddress) external payable {
109         registration(msg.sender, referrerAddress);
110     }
111     
112     function buyNewLevel(uint8 matrix, uint8 level) external payable {
113         require(isUserExists(msg.sender), "user is not exists. Register first.");
114         require(matrix == 1 || matrix == 2, "invalid matrix");
115         require(msg.value == levelPrice[level], "invalid price");
116         require(level > 1 && level <= LAST_LEVEL, "invalid level");
117 
118         if (matrix == 1) {
119             require(!users[msg.sender].activeX3Levels[level], "level already activated");
120 
121             if (users[msg.sender].x3Matrix[level-1].blocked) {
122                 users[msg.sender].x3Matrix[level-1].blocked = false;
123             }
124     
125             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
126             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
127             users[msg.sender].activeX3Levels[level] = true;
128             updateX3Referrer(msg.sender, freeX3Referrer, level);
129             
130             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
131 
132         } else {
133             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
134 
135             if (users[msg.sender].x6Matrix[level-1].blocked) {
136                 users[msg.sender].x6Matrix[level-1].blocked = false;
137             }
138 
139             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
140             
141             users[msg.sender].activeX6Levels[level] = true;
142             updateX6Referrer(msg.sender, freeX6Referrer, level);
143             
144             emit Upgrade(msg.sender, freeX6Referrer, 2, level);
145         }
146     }    
147     
148     function registration(address userAddress, address referrerAddress) private {
149         require(msg.value == 0.05 ether, "registration cost 0.05");
150         require(!isUserExists(userAddress), "user exists");
151         require(isUserExists(referrerAddress), "referrer not exists");
152         
153         uint32 size;
154         assembly {
155             size := extcodesize(userAddress)
156         }
157         require(size == 0, "cannot be a contract");
158         
159         User memory user = User({
160             id: lastUserId,
161             referrer: referrerAddress,
162             partnersCount: 0
163         });
164         
165         users[userAddress] = user;
166         idToAddress[lastUserId] = userAddress;
167         
168         users[userAddress].referrer = referrerAddress;
169         
170         users[userAddress].activeX3Levels[1] = true; 
171         users[userAddress].activeX6Levels[1] = true;
172         
173         
174         userIds[lastUserId] = userAddress;
175         lastUserId++;
176         
177         users[referrerAddress].partnersCount++;
178 
179         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
180         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
181         updateX3Referrer(userAddress, freeX3Referrer, 1);
182 
183         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
184         
185         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
186     }
187     
188     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
189         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
190 
191         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
192             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
193             return sendETHDividends(referrerAddress, userAddress, 1, level);
194         }
195         
196         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
197         //close matrix
198         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
199         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
200             users[referrerAddress].x3Matrix[level].blocked = true;
201         }
202 
203         //create new one by recursion
204         if (referrerAddress != owner) {
205             //check referrer active level
206             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
207             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
208                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
209             }
210             
211             users[referrerAddress].x3Matrix[level].reinvestCount++;
212             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
213             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
214         } else {
215             sendETHDividends(owner, userAddress, 1, level);
216             users[owner].x3Matrix[level].reinvestCount++;
217             emit Reinvest(owner, address(0), userAddress, 1, level);
218         }
219     }
220 
221     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
222         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
223         
224         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
225             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
226             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
227             
228             //set current level
229             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
230 
231             if (referrerAddress == owner) {
232                 return sendETHDividends(referrerAddress, userAddress, 2, level);
233             }
234             
235             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
236             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
237             
238             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
239             
240             if ((len == 2) && 
241                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
242                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
243                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
244                     emit NewUserPlace(userAddress, ref, 2, level, 5);
245                 } else {
246                     emit NewUserPlace(userAddress, ref, 2, level, 6);
247                 }
248             }  else if ((len == 1 || len == 2) &&
249                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
250                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
251                     emit NewUserPlace(userAddress, ref, 2, level, 3);
252                 } else {
253                     emit NewUserPlace(userAddress, ref, 2, level, 4);
254                 }
255             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
256                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
257                     emit NewUserPlace(userAddress, ref, 2, level, 5);
258                 } else {
259                     emit NewUserPlace(userAddress, ref, 2, level, 6);
260                 }
261             }
262 
263             return updateX6ReferrerSecondLevel(userAddress, ref, level);
264         }
265         
266         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
267 
268         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
269             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
270                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
271                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
272                 users[referrerAddress].x6Matrix[level].closedPart)) {
273 
274                 updateX6(userAddress, referrerAddress, level, true);
275                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
276             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
277                 users[referrerAddress].x6Matrix[level].closedPart) {
278                 updateX6(userAddress, referrerAddress, level, true);
279                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
280             } else {
281                 updateX6(userAddress, referrerAddress, level, false);
282                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
283             }
284         }
285 
286         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
287             updateX6(userAddress, referrerAddress, level, false);
288             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
289         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
290             updateX6(userAddress, referrerAddress, level, true);
291             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
292         }
293         
294         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
295             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
296             updateX6(userAddress, referrerAddress, level, false);
297         } else {
298             updateX6(userAddress, referrerAddress, level, true);
299         }
300         
301         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
302     }
303 
304     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
305         if (!x2) {
306             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
307             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
308             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
309             //set current level
310             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
311         } else {
312             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
313             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
314             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
315             //set current level
316             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
317         }
318     }
319     
320     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
321         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
322             return sendETHDividends(referrerAddress, userAddress, 2, level);
323         }
324         
325         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
326         
327         if (x6.length == 2) {
328             if (x6[0] == referrerAddress ||
329                 x6[1] == referrerAddress) {
330                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
331             } else if (x6.length == 1) {
332                 if (x6[0] == referrerAddress) {
333                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
334                 }
335             }
336         }
337         
338         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
339         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
340         users[referrerAddress].x6Matrix[level].closedPart = address(0);
341 
342         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
343             users[referrerAddress].x6Matrix[level].blocked = true;
344         }
345 
346         users[referrerAddress].x6Matrix[level].reinvestCount++;
347         
348         if (referrerAddress != owner) {
349             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
350 
351             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
352             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
353         } else {
354             emit Reinvest(owner, address(0), userAddress, 2, level);
355             sendETHDividends(owner, userAddress, 2, level);
356         }
357     }
358     
359     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
360         while (true) {
361             if (users[users[userAddress].referrer].activeX3Levels[level]) {
362                 return users[userAddress].referrer;
363             }
364             
365             userAddress = users[userAddress].referrer;
366         }
367     }
368     
369     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
370         while (true) {
371             if (users[users[userAddress].referrer].activeX6Levels[level]) {
372                 return users[userAddress].referrer;
373             }
374             
375             userAddress = users[userAddress].referrer;
376         }
377     }
378         
379     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
380         return users[userAddress].activeX3Levels[level];
381     }
382 
383     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
384         return users[userAddress].activeX6Levels[level];
385     }
386 
387     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
388         return (users[userAddress].x3Matrix[level].currentReferrer,
389                 users[userAddress].x3Matrix[level].referrals,
390                 users[userAddress].x3Matrix[level].blocked);
391     }
392 
393     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
394         return (users[userAddress].x6Matrix[level].currentReferrer,
395                 users[userAddress].x6Matrix[level].firstLevelReferrals,
396                 users[userAddress].x6Matrix[level].secondLevelReferrals,
397                 users[userAddress].x6Matrix[level].blocked,
398                 users[userAddress].x6Matrix[level].closedPart);
399     }
400     
401     function isUserExists(address user) public view returns (bool) {
402         return (users[user].id != 0);
403     }
404 
405     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
406         address receiver = userAddress;
407         bool isExtraDividends;
408         if (matrix == 1) {
409             while (true) {
410                 if (users[receiver].x3Matrix[level].blocked) {
411                     emit MissedEthReceive(receiver, _from, 1, level);
412                     isExtraDividends = true;
413                     receiver = users[receiver].x3Matrix[level].currentReferrer;
414                 } else {
415                     return (receiver, isExtraDividends);
416                 }
417             }
418         } else {
419             while (true) {
420                 if (users[receiver].x6Matrix[level].blocked) {
421                     emit MissedEthReceive(receiver, _from, 2, level);
422                     isExtraDividends = true;
423                     receiver = users[receiver].x6Matrix[level].currentReferrer;
424                 } else {
425                     return (receiver, isExtraDividends);
426                 }
427             }
428         }
429     }
430 
431     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
432         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
433 
434         if (!address(uint160(receiver)).send(levelPrice[level])) {
435             return address(uint160(receiver)).transfer(address(this).balance);
436         }
437         
438         if (isExtraDividends) {
439             emit SentExtraEthDividends(_from, receiver, matrix, level);
440         }
441     }
442     
443     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
444         assembly {
445             addr := mload(add(bys, 20))
446         }
447     }
448 }