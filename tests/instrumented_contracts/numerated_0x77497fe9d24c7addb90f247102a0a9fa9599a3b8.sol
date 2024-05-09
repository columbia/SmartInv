1 /**
2 * 
3 *   ██╗ ██████╗ ██████╗ ██╗███╗   ██╗███████╗████████╗██╗  ██╗███████╗██████╗ 
4 *  ███║██╔════╝██╔═══██╗██║████╗  ██║██╔════╝╚══██╔══╝██║  ██║██╔════╝██╔══██╗
5 *  ╚██║██║     ██║   ██║██║██╔██╗ ██║█████╗     ██║   ███████║█████╗  ██████╔╝
6 *   ██║██║     ██║   ██║██║██║╚██╗██║██╔══╝     ██║   ██╔══██║██╔══╝  ██╔══██╗
7 *   ██║╚██████╗╚██████╔╝██║██║ ╚████║███████╗   ██║   ██║  ██║███████╗██║  ██║
8 *   ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
9 * 
10 * 1CoinEther
11 * https://1coinether.io
12 * 
13 * 
14 **/
15 
16 
17 pragma solidity >=0.4.23 <0.6.0;
18 
19 contract OneCoinEther {
20     
21     struct User {
22         uint id;
23         address referrer;
24         uint partnersCount;
25         
26         mapping(uint8 => bool) activeE3Levels;
27         mapping(uint8 => bool) activeE6Levels;
28         
29         mapping(uint8 => E3) e3Matrix;
30         mapping(uint8 => E6) e6Matrix;
31     }
32     
33     struct E3 {
34         address currentReferrer;
35         address[] referrals;
36         bool blocked;
37         uint reinvestCount;
38     }
39     
40     struct E6 {
41         address currentReferrer;
42         address[] firstLevelReferrals;
43         address[] secondLevelReferrals;
44         bool blocked;
45         uint reinvestCount;
46 
47         address closedPart;
48     }
49 
50     uint8 public constant LAST_LEVEL = 12;
51     
52     mapping(address => User) public users;
53     mapping(uint => address) public idToAddress;
54     mapping(uint => address) public userIds;
55     mapping(address => uint) public balances; 
56 
57     uint public lastUserId = 2;
58     address public owner;
59     
60     mapping(uint8 => uint) public levelPrice;
61     
62     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
63     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
64     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
65     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
66     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
67     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
68     
69     
70     constructor(address ownerAddress) public {
71         levelPrice[1] = 0.025 ether;
72         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
73             levelPrice[i] = levelPrice[i-1] * 2;
74         }
75         
76         owner = ownerAddress;
77         
78         User memory user = User({
79             id: 1,
80             referrer: address(0),
81             partnersCount: uint(0)
82         });
83         
84         users[ownerAddress] = user;
85         idToAddress[1] = ownerAddress;
86         
87         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
88             users[ownerAddress].activeE3Levels[i] = true;
89             users[ownerAddress].activeE6Levels[i] = true;
90         }
91         
92         userIds[1] = ownerAddress;
93     }
94     
95     function() external payable {
96         if(msg.data.length == 0) {
97             return registration(msg.sender, owner);
98         }
99         
100         registration(msg.sender, bytesToAddress(msg.data));
101     }
102 
103     function registrationExt(address referrerAddress) external payable {
104         registration(msg.sender, referrerAddress);
105     }
106     
107     function buyNewLevel(uint8 matrix, uint8 level) external payable {
108         require(isUserExists(msg.sender), "user is not exists. Register first.");
109         require(matrix == 1 || matrix == 2, "invalid matrix");
110         require(msg.value == levelPrice[level], "invalid price");
111         require(level > 1 && level <= LAST_LEVEL, "invalid level");
112 
113         if (matrix == 1) {
114             require(!users[msg.sender].activeE3Levels[level], "level already activated");
115 
116             if (users[msg.sender].e3Matrix[level-1].blocked) {
117                 users[msg.sender].e3Matrix[level-1].blocked = false;
118             }
119     
120             address freeE3Referrer = findFreeE3Referrer(msg.sender, level);
121             users[msg.sender].e3Matrix[level].currentReferrer = freeE3Referrer;
122             users[msg.sender].activeE3Levels[level] = true;
123             updateE3Referrer(msg.sender, freeE3Referrer, level);
124             
125             emit Upgrade(msg.sender, freeE3Referrer, 1, level);
126 
127         } else {
128             require(!users[msg.sender].activeE6Levels[level], "level already activated"); 
129 
130             if (users[msg.sender].e6Matrix[level-1].blocked) {
131                 users[msg.sender].e6Matrix[level-1].blocked = false;
132             }
133 
134             address freeE6Referrer = findFreeE6Referrer(msg.sender, level);
135             
136             users[msg.sender].activeE6Levels[level] = true;
137             updateE6Referrer(msg.sender, freeE6Referrer, level);
138             
139             emit Upgrade(msg.sender, freeE6Referrer, 2, level);
140         }
141     }    
142     
143     function registration(address userAddress, address referrerAddress) private {
144         require(msg.value == 0.05 ether, "registration cost 0.05");
145         require(!isUserExists(userAddress), "user exists");
146         require(isUserExists(referrerAddress), "referrer not exists");
147         
148         uint32 size;
149         assembly {
150             size := extcodesize(userAddress)
151         }
152         require(size == 0, "cannot be a contract");
153         
154         User memory user = User({
155             id: lastUserId,
156             referrer: referrerAddress,
157             partnersCount: 0
158         });
159         
160         users[userAddress] = user;
161         idToAddress[lastUserId] = userAddress;
162         
163         users[userAddress].referrer = referrerAddress;
164         
165         users[userAddress].activeE3Levels[1] = true; 
166         users[userAddress].activeE6Levels[1] = true;
167         
168         
169         userIds[lastUserId] = userAddress;
170         lastUserId++;
171         
172         users[referrerAddress].partnersCount++;
173 
174         address freeE3Referrer = findFreeE3Referrer(userAddress, 1);
175         users[userAddress].e3Matrix[1].currentReferrer = freeE3Referrer;
176         updateE3Referrer(userAddress, freeE3Referrer, 1);
177 
178         updateE6Referrer(userAddress, findFreeE6Referrer(userAddress, 1), 1);
179         
180         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
181     }
182     
183     function updateE3Referrer(address userAddress, address referrerAddress, uint8 level) private {
184         users[referrerAddress].e3Matrix[level].referrals.push(userAddress);
185 
186         if (users[referrerAddress].e3Matrix[level].referrals.length < 3) {
187             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].e3Matrix[level].referrals.length));
188             return sendETHDividends(referrerAddress, userAddress, 1, level);
189         }
190         
191         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
192         //close matrix
193         users[referrerAddress].e3Matrix[level].referrals = new address[](0);
194         if (!users[referrerAddress].activeE3Levels[level+1] && level != LAST_LEVEL) {
195             users[referrerAddress].e3Matrix[level].blocked = true;
196         }
197 
198         //create new one by recursion
199         if (referrerAddress != owner) {
200             //check referrer active level
201             address freeReferrerAddress = findFreeE3Referrer(referrerAddress, level);
202             if (users[referrerAddress].e3Matrix[level].currentReferrer != freeReferrerAddress) {
203                 users[referrerAddress].e3Matrix[level].currentReferrer = freeReferrerAddress;
204             }
205             
206             users[referrerAddress].e3Matrix[level].reinvestCount++;
207             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
208             updateE3Referrer(referrerAddress, freeReferrerAddress, level);
209         } else {
210             sendETHDividends(owner, userAddress, 1, level);
211             users[owner].e3Matrix[level].reinvestCount++;
212             emit Reinvest(owner, address(0), userAddress, 1, level);
213         }
214     }
215 
216     function updateE6Referrer(address userAddress, address referrerAddress, uint8 level) private {
217         require(users[referrerAddress].activeE6Levels[level], "500. Referrer level is inactive");
218         
219         if (users[referrerAddress].e6Matrix[level].firstLevelReferrals.length < 2) {
220             users[referrerAddress].e6Matrix[level].firstLevelReferrals.push(userAddress);
221             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].e6Matrix[level].firstLevelReferrals.length));
222             
223             //set current level
224             users[userAddress].e6Matrix[level].currentReferrer = referrerAddress;
225 
226             if (referrerAddress == owner) {
227                 return sendETHDividends(referrerAddress, userAddress, 2, level);
228             }
229             
230             address ref = users[referrerAddress].e6Matrix[level].currentReferrer;            
231             users[ref].e6Matrix[level].secondLevelReferrals.push(userAddress); 
232             
233             uint len = users[ref].e6Matrix[level].firstLevelReferrals.length;
234             
235             if ((len == 2) && 
236                 (users[ref].e6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
237                 (users[ref].e6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
238                 if (users[referrerAddress].e6Matrix[level].firstLevelReferrals.length == 1) {
239                     emit NewUserPlace(userAddress, ref, 2, level, 5);
240                 } else {
241                     emit NewUserPlace(userAddress, ref, 2, level, 6);
242                 }
243             }  else if ((len == 1 || len == 2) &&
244                     users[ref].e6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
245                 if (users[referrerAddress].e6Matrix[level].firstLevelReferrals.length == 1) {
246                     emit NewUserPlace(userAddress, ref, 2, level, 3);
247                 } else {
248                     emit NewUserPlace(userAddress, ref, 2, level, 4);
249                 }
250             } else if (len == 2 && users[ref].e6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
251                 if (users[referrerAddress].e6Matrix[level].firstLevelReferrals.length == 1) {
252                     emit NewUserPlace(userAddress, ref, 2, level, 5);
253                 } else {
254                     emit NewUserPlace(userAddress, ref, 2, level, 6);
255                 }
256             }
257 
258             return updateE6ReferrerSecondLevel(userAddress, ref, level);
259         }
260         
261         users[referrerAddress].e6Matrix[level].secondLevelReferrals.push(userAddress);
262 
263         if (users[referrerAddress].e6Matrix[level].closedPart != address(0)) {
264             if ((users[referrerAddress].e6Matrix[level].firstLevelReferrals[0] == 
265                 users[referrerAddress].e6Matrix[level].firstLevelReferrals[1]) &&
266                 (users[referrerAddress].e6Matrix[level].firstLevelReferrals[0] ==
267                 users[referrerAddress].e6Matrix[level].closedPart)) {
268 
269                 updateE6(userAddress, referrerAddress, level, true);
270                 return updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
271             } else if (users[referrerAddress].e6Matrix[level].firstLevelReferrals[0] == 
272                 users[referrerAddress].e6Matrix[level].closedPart) {
273                 updateE6(userAddress, referrerAddress, level, true);
274                 return updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
275             } else {
276                 updateE6(userAddress, referrerAddress, level, false);
277                 return updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
278             }
279         }
280 
281         if (users[referrerAddress].e6Matrix[level].firstLevelReferrals[1] == userAddress) {
282             updateE6(userAddress, referrerAddress, level, false);
283             return updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
284         } else if (users[referrerAddress].e6Matrix[level].firstLevelReferrals[0] == userAddress) {
285             updateE6(userAddress, referrerAddress, level, true);
286             return updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
287         }
288         
289         if (users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[0]].e6Matrix[level].firstLevelReferrals.length <= 
290             users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[1]].e6Matrix[level].firstLevelReferrals.length) {
291             updateE6(userAddress, referrerAddress, level, false);
292         } else {
293             updateE6(userAddress, referrerAddress, level, true);
294         }
295         
296         updateE6ReferrerSecondLevel(userAddress, referrerAddress, level);
297     }
298 
299     function updateE6(address userAddress, address referrerAddress, uint8 level, bool e2) private {
300         if (!e2) {
301             users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[0]].e6Matrix[level].firstLevelReferrals.push(userAddress);
302             emit NewUserPlace(userAddress, users[referrerAddress].e6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[0]].e6Matrix[level].firstLevelReferrals.length));
303             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[0]].e6Matrix[level].firstLevelReferrals.length));
304             //set current level
305             users[userAddress].e6Matrix[level].currentReferrer = users[referrerAddress].e6Matrix[level].firstLevelReferrals[0];
306         } else {
307             users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[1]].e6Matrix[level].firstLevelReferrals.push(userAddress);
308             emit NewUserPlace(userAddress, users[referrerAddress].e6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[1]].e6Matrix[level].firstLevelReferrals.length));
309             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].e6Matrix[level].firstLevelReferrals[1]].e6Matrix[level].firstLevelReferrals.length));
310             //set current level
311             users[userAddress].e6Matrix[level].currentReferrer = users[referrerAddress].e6Matrix[level].firstLevelReferrals[1];
312         }
313     }
314     
315     function updateE6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
316         if (users[referrerAddress].e6Matrix[level].secondLevelReferrals.length < 4) {
317             return sendETHDividends(referrerAddress, userAddress, 2, level);
318         }
319         
320         address[] memory e6 = users[users[referrerAddress].e6Matrix[level].currentReferrer].e6Matrix[level].firstLevelReferrals;
321         
322         if (e6.length == 2) {
323             if (e6[0] == referrerAddress ||
324                 e6[1] == referrerAddress) {
325                 users[users[referrerAddress].e6Matrix[level].currentReferrer].e6Matrix[level].closedPart = referrerAddress;
326             } else if (e6.length == 1) {
327                 if (e6[0] == referrerAddress) {
328                     users[users[referrerAddress].e6Matrix[level].currentReferrer].e6Matrix[level].closedPart = referrerAddress;
329                 }
330             }
331         }
332         
333         users[referrerAddress].e6Matrix[level].firstLevelReferrals = new address[](0);
334         users[referrerAddress].e6Matrix[level].secondLevelReferrals = new address[](0);
335         users[referrerAddress].e6Matrix[level].closedPart = address(0);
336 
337         if (!users[referrerAddress].activeE6Levels[level+1] && level != LAST_LEVEL) {
338             users[referrerAddress].e6Matrix[level].blocked = true;
339         }
340 
341         users[referrerAddress].e6Matrix[level].reinvestCount++;
342         
343         if (referrerAddress != owner) {
344             address freeReferrerAddress = findFreeE6Referrer(referrerAddress, level);
345 
346             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
347             updateE6Referrer(referrerAddress, freeReferrerAddress, level);
348         } else {
349             emit Reinvest(owner, address(0), userAddress, 2, level);
350             sendETHDividends(owner, userAddress, 2, level);
351         }
352     }
353     
354     function findFreeE3Referrer(address userAddress, uint8 level) public view returns(address) {
355         while (true) {
356             if (users[users[userAddress].referrer].activeE3Levels[level]) {
357                 return users[userAddress].referrer;
358             }
359             
360             userAddress = users[userAddress].referrer;
361         }
362     }
363     
364     function findFreeE6Referrer(address userAddress, uint8 level) public view returns(address) {
365         while (true) {
366             if (users[users[userAddress].referrer].activeE6Levels[level]) {
367                 return users[userAddress].referrer;
368             }
369             
370             userAddress = users[userAddress].referrer;
371         }
372     }
373         
374     function usersActiveE3Levels(address userAddress, uint8 level) public view returns(bool) {
375         return users[userAddress].activeE3Levels[level];
376     }
377 
378     function usersActiveE6Levels(address userAddress, uint8 level) public view returns(bool) {
379         return users[userAddress].activeE6Levels[level];
380     }
381 
382     function usersE3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
383         return (users[userAddress].e3Matrix[level].currentReferrer,
384                 users[userAddress].e3Matrix[level].referrals,
385                 users[userAddress].e3Matrix[level].blocked);
386     }
387 
388     function usersE6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
389         return (users[userAddress].e6Matrix[level].currentReferrer,
390                 users[userAddress].e6Matrix[level].firstLevelReferrals,
391                 users[userAddress].e6Matrix[level].secondLevelReferrals,
392                 users[userAddress].e6Matrix[level].blocked,
393                 users[userAddress].e6Matrix[level].closedPart);
394     }
395     
396     function isUserExists(address user) public view returns (bool) {
397         return (users[user].id != 0);
398     }
399 
400     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
401         address receiver = userAddress;
402         bool isExtraDividends;
403         if (matrix == 1) {
404             while (true) {
405                 if (users[receiver].e3Matrix[level].blocked) {
406                     emit MissedEthReceive(receiver, _from, 1, level);
407                     isExtraDividends = true;
408                     receiver = users[receiver].e3Matrix[level].currentReferrer;
409                 } else {
410                     return (receiver, isExtraDividends);
411                 }
412             }
413         } else {
414             while (true) {
415                 if (users[receiver].e6Matrix[level].blocked) {
416                     emit MissedEthReceive(receiver, _from, 2, level);
417                     isExtraDividends = true;
418                     receiver = users[receiver].e6Matrix[level].currentReferrer;
419                 } else {
420                     return (receiver, isExtraDividends);
421                 }
422             }
423         }
424     }
425 
426     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
427         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
428 
429         if (!address(uint160(receiver)).send(levelPrice[level])) {
430             return address(uint160(receiver)).transfer(address(this).balance);
431         }
432         
433         if (isExtraDividends) {
434             emit SentExtraEthDividends(_from, receiver, matrix, level);
435         }
436     }
437     
438     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
439         assembly {
440             addr := mload(add(bys, 20))
441         }
442     }
443 }