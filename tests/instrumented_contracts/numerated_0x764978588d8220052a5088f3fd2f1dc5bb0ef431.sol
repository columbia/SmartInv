1 /**
2 * 
3 * 
4 *   /$$$$$$  /$$     /$$ /$$$$$$$$  /$$$$$$ 
5 *  /$$__  $$|  $$   /$$/| $$_____/ /$$__  $$
6 * | $$  \ $$ \  $$ /$$/ | $$      | $$  \__/
7 * | $$  | $$  \  $$$$/  | $$$$$   |  $$$$$$ 
8 * | $$  | $$   \  $$/   | $$__/    \____  $$
9 * | $$  | $$    | $$    | $$       /$$  \ $$
10 * |  $$$$$$/    | $$    | $$$$$$$$|  $$$$$$/
11 *  \______/     |__/    |________/ \______/ 
12 *                                           
13 *                                           
14 
15 **/
16 
17 
18 pragma solidity >=0.4.23 <0.6.0;
19 
20 contract OyesMatrix {
21     
22     struct User {
23         uint id;
24         address referrer;
25         uint partnersCount;
26         
27         mapping(uint8 => bool) activeO3Levels;
28         mapping(uint8 => bool) activeO6Levels;
29         
30         mapping(uint8 => O3) O3Matrix;
31         mapping(uint8 => O6) O6Matrix;
32     }
33     
34     struct O3 {
35         address currentReferrer;
36         address[] referrals;
37         bool blocked;
38         uint reinvestCount;
39     }
40     
41     struct O6 {
42         address currentReferrer;
43         address[] firstLevelReferrals;
44         address[] secondLevelReferrals;
45         bool blocked;
46         uint reinvestCount;
47 
48         address closedPart;
49     }
50 
51     uint8 public constant LAST_LEVEL = 12;
52     
53     mapping(address => User) public users;
54     mapping(uint => address) public idToAddress;
55     mapping(uint => address) public userIds;
56     mapping(address => uint) public balances; 
57 
58     uint public lastUserId = 2;
59     address public owner;
60     
61     mapping(uint8 => uint) public levelPrice;
62     
63     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
64     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
65     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
66     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
67     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
68     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
69     
70     
71     constructor(address ownerAddress) public {
72         levelPrice[1] = 0.025 ether;
73         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
74             levelPrice[i] = levelPrice[i-1] * 2;
75         }
76         
77         owner = ownerAddress;
78         
79         User memory user = User({
80             id: 1,
81             referrer: address(0),
82             partnersCount: uint(0)
83         });
84         
85         users[ownerAddress] = user;
86         idToAddress[1] = ownerAddress;
87         
88         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
89             users[ownerAddress].activeO3Levels[i] = true;
90             users[ownerAddress].activeO6Levels[i] = true;
91         }
92         
93         userIds[1] = ownerAddress;
94     }
95     
96     function() external payable {
97         if(msg.data.length == 0) {
98             return registration(msg.sender, owner);
99         }
100         
101         registration(msg.sender, bytesToAddress(msg.data));
102     }
103 
104     function registrationExt(address referrerAddress) external payable {
105         registration(msg.sender, referrerAddress);
106     }
107     
108     function buyNewLevel(uint8 matrix, uint8 level) external payable {
109         require(isUserExists(msg.sender), "user is not exists. Register first.");
110         require(matrix == 1 || matrix == 2, "invalid matrix");
111         require(msg.value == levelPrice[level], "invalid price");
112         require(level > 1 && level <= LAST_LEVEL, "invalid level");
113 
114         if (matrix == 1) {
115             require(!users[msg.sender].activeO3Levels[level], "level already activated");
116 
117             if (users[msg.sender].O3Matrix[level-1].blocked) {
118                 users[msg.sender].O3Matrix[level-1].blocked = false;
119             }
120     
121             address freeO3Referrer = findFreeO3Referrer(msg.sender, level);
122             users[msg.sender].O3Matrix[level].currentReferrer = freeO3Referrer;
123             users[msg.sender].activeO3Levels[level] = true;
124             updateO3Referrer(msg.sender, freeO3Referrer, level);
125             
126             emit Upgrade(msg.sender, freeO3Referrer, 1, level);
127 
128         } else {
129             require(!users[msg.sender].activeO6Levels[level], "level already activated"); 
130 
131             if (users[msg.sender].O6Matrix[level-1].blocked) {
132                 users[msg.sender].O6Matrix[level-1].blocked = false;
133             }
134 
135             address freeO6Referrer = findFreeO6Referrer(msg.sender, level);
136             
137             users[msg.sender].activeO6Levels[level] = true;
138             updateO6Referrer(msg.sender, freeO6Referrer, level);
139             
140             emit Upgrade(msg.sender, freeO6Referrer, 2, level);
141         }
142     }    
143     
144     function registration(address userAddress, address referrerAddress) private {
145         require(msg.value == 0.05 ether, "registration cost 0.05");
146         require(!isUserExists(userAddress), "user exists");
147         require(isUserExists(referrerAddress), "referrer not exists");
148         
149         uint32 size;
150         assembly {
151             size := extcodesize(userAddress)
152         }
153         require(size == 0, "cannot be a contract");
154         
155         User memory user = User({
156             id: lastUserId,
157             referrer: referrerAddress,
158             partnersCount: 0
159         });
160         
161         users[userAddress] = user;
162         idToAddress[lastUserId] = userAddress;
163         
164         users[userAddress].referrer = referrerAddress;
165         
166         users[userAddress].activeO3Levels[1] = true; 
167         users[userAddress].activeO6Levels[1] = true;
168         
169         
170         userIds[lastUserId] = userAddress;
171         lastUserId++;
172         
173         users[referrerAddress].partnersCount++;
174 
175         address freeO3Referrer = findFreeO3Referrer(userAddress, 1);
176         users[userAddress].O3Matrix[1].currentReferrer = freeO3Referrer;
177         updateO3Referrer(userAddress, freeO3Referrer, 1);
178 
179         updateO6Referrer(userAddress, findFreeO6Referrer(userAddress, 1), 1);
180         
181         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
182     }
183     
184     function updateO3Referrer(address userAddress, address referrerAddress, uint8 level) private {
185         users[referrerAddress].O3Matrix[level].referrals.push(userAddress);
186 
187         if (users[referrerAddress].O3Matrix[level].referrals.length < 3) {
188             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].O3Matrix[level].referrals.length));
189             return sendETHDividends(referrerAddress, userAddress, 1, level);
190         }
191         
192         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
193         //close matrix
194         users[referrerAddress].O3Matrix[level].referrals = new address[](0);
195         if (!users[referrerAddress].activeO3Levels[level+1] && level != LAST_LEVEL) {
196             users[referrerAddress].O3Matrix[level].blocked = true;
197         }
198 
199         //create new one by recursion
200         if (referrerAddress != owner) {
201             //check referrer active level
202             address freeReferrerAddress = findFreeO3Referrer(referrerAddress, level);
203             if (users[referrerAddress].O3Matrix[level].currentReferrer != freeReferrerAddress) {
204                 users[referrerAddress].O3Matrix[level].currentReferrer = freeReferrerAddress;
205             }
206             
207             users[referrerAddress].O3Matrix[level].reinvestCount++;
208             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
209             updateO3Referrer(referrerAddress, freeReferrerAddress, level);
210         } else {
211             sendETHDividends(owner, userAddress, 1, level);
212             users[owner].O3Matrix[level].reinvestCount++;
213             emit Reinvest(owner, address(0), userAddress, 1, level);
214         }
215     }
216 
217     function updateO6Referrer(address userAddress, address referrerAddress, uint8 level) private {
218         require(users[referrerAddress].activeO6Levels[level], "500. Referrer level is inactive");
219         
220         if (users[referrerAddress].O6Matrix[level].firstLevelReferrals.length < 2) {
221             users[referrerAddress].O6Matrix[level].firstLevelReferrals.push(userAddress);
222             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].O6Matrix[level].firstLevelReferrals.length));
223             
224             //set current level
225             users[userAddress].O6Matrix[level].currentReferrer = referrerAddress;
226 
227             if (referrerAddress == owner) {
228                 return sendETHDividends(referrerAddress, userAddress, 2, level);
229             }
230             
231             address ref = users[referrerAddress].O6Matrix[level].currentReferrer;            
232             users[ref].O6Matrix[level].secondLevelReferrals.push(userAddress); 
233             
234             uint len = users[ref].O6Matrix[level].firstLevelReferrals.length;
235             
236             if ((len == 2) && 
237                 (users[ref].O6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
238                 (users[ref].O6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
239                 if (users[referrerAddress].O6Matrix[level].firstLevelReferrals.length == 1) {
240                     emit NewUserPlace(userAddress, ref, 2, level, 5);
241                 } else {
242                     emit NewUserPlace(userAddress, ref, 2, level, 6);
243                 }
244             }  else if ((len == 1 || len == 2) &&
245                     users[ref].O6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
246                 if (users[referrerAddress].O6Matrix[level].firstLevelReferrals.length == 1) {
247                     emit NewUserPlace(userAddress, ref, 2, level, 3);
248                 } else {
249                     emit NewUserPlace(userAddress, ref, 2, level, 4);
250                 }
251             } else if (len == 2 && users[ref].O6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
252                 if (users[referrerAddress].O6Matrix[level].firstLevelReferrals.length == 1) {
253                     emit NewUserPlace(userAddress, ref, 2, level, 5);
254                 } else {
255                     emit NewUserPlace(userAddress, ref, 2, level, 6);
256                 }
257             }
258 
259             return updateO6ReferrerSecondLevel(userAddress, ref, level);
260         }
261         
262         users[referrerAddress].O6Matrix[level].secondLevelReferrals.push(userAddress);
263 
264         if (users[referrerAddress].O6Matrix[level].closedPart != address(0)) {
265             if ((users[referrerAddress].O6Matrix[level].firstLevelReferrals[0] == 
266                 users[referrerAddress].O6Matrix[level].firstLevelReferrals[1]) &&
267                 (users[referrerAddress].O6Matrix[level].firstLevelReferrals[0] ==
268                 users[referrerAddress].O6Matrix[level].closedPart)) {
269 
270                 updateO6(userAddress, referrerAddress, level, true);
271                 return updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
272             } else if (users[referrerAddress].O6Matrix[level].firstLevelReferrals[0] == 
273                 users[referrerAddress].O6Matrix[level].closedPart) {
274                 updateO6(userAddress, referrerAddress, level, true);
275                 return updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
276             } else {
277                 updateO6(userAddress, referrerAddress, level, false);
278                 return updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
279             }
280         }
281 
282         if (users[referrerAddress].O6Matrix[level].firstLevelReferrals[1] == userAddress) {
283             updateO6(userAddress, referrerAddress, level, false);
284             return updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
285         } else if (users[referrerAddress].O6Matrix[level].firstLevelReferrals[0] == userAddress) {
286             updateO6(userAddress, referrerAddress, level, true);
287             return updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
288         }
289         
290         if (users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[0]].O6Matrix[level].firstLevelReferrals.length <= 
291             users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[1]].O6Matrix[level].firstLevelReferrals.length) {
292             updateO6(userAddress, referrerAddress, level, false);
293         } else {
294             updateO6(userAddress, referrerAddress, level, true);
295         }
296         
297         updateO6ReferrerSecondLevel(userAddress, referrerAddress, level);
298     }
299 
300     function updateO6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
301         if (!x2) {
302             users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[0]].O6Matrix[level].firstLevelReferrals.push(userAddress);
303             emit NewUserPlace(userAddress, users[referrerAddress].O6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[0]].O6Matrix[level].firstLevelReferrals.length));
304             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[0]].O6Matrix[level].firstLevelReferrals.length));
305             //set current level
306             users[userAddress].O6Matrix[level].currentReferrer = users[referrerAddress].O6Matrix[level].firstLevelReferrals[0];
307         } else {
308             users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[1]].O6Matrix[level].firstLevelReferrals.push(userAddress);
309             emit NewUserPlace(userAddress, users[referrerAddress].O6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[1]].O6Matrix[level].firstLevelReferrals.length));
310             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].O6Matrix[level].firstLevelReferrals[1]].O6Matrix[level].firstLevelReferrals.length));
311             //set current level
312             users[userAddress].O6Matrix[level].currentReferrer = users[referrerAddress].O6Matrix[level].firstLevelReferrals[1];
313         }
314     }
315     
316     function updateO6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
317         if (users[referrerAddress].O6Matrix[level].secondLevelReferrals.length < 4) {
318             return sendETHDividends(referrerAddress, userAddress, 2, level);
319         }
320         
321         address[] memory O6 = users[users[referrerAddress].O6Matrix[level].currentReferrer].O6Matrix[level].firstLevelReferrals;
322         
323         if (O6.length == 2) {
324             if (O6[0] == referrerAddress ||
325                 O6[1] == referrerAddress) {
326                 users[users[referrerAddress].O6Matrix[level].currentReferrer].O6Matrix[level].closedPart = referrerAddress;
327             } else if (O6.length == 1) {
328                 if (O6[0] == referrerAddress) {
329                     users[users[referrerAddress].O6Matrix[level].currentReferrer].O6Matrix[level].closedPart = referrerAddress;
330                 }
331             }
332         }
333         
334         users[referrerAddress].O6Matrix[level].firstLevelReferrals = new address[](0);
335         users[referrerAddress].O6Matrix[level].secondLevelReferrals = new address[](0);
336         users[referrerAddress].O6Matrix[level].closedPart = address(0);
337 
338         if (!users[referrerAddress].activeO6Levels[level+1] && level != LAST_LEVEL) {
339             users[referrerAddress].O6Matrix[level].blocked = true;
340         }
341 
342         users[referrerAddress].O6Matrix[level].reinvestCount++;
343         
344         if (referrerAddress != owner) {
345             address freeReferrerAddress = findFreeO6Referrer(referrerAddress, level);
346 
347             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
348             updateO6Referrer(referrerAddress, freeReferrerAddress, level);
349         } else {
350             emit Reinvest(owner, address(0), userAddress, 2, level);
351             sendETHDividends(owner, userAddress, 2, level);
352         }
353     }
354     
355     function findFreeO3Referrer(address userAddress, uint8 level) public view returns(address) {
356         while (true) {
357             if (users[users[userAddress].referrer].activeO3Levels[level]) {
358                 return users[userAddress].referrer;
359             }
360             
361             userAddress = users[userAddress].referrer;
362         }
363     }
364     
365     function findFreeO6Referrer(address userAddress, uint8 level) public view returns(address) {
366         while (true) {
367             if (users[users[userAddress].referrer].activeO6Levels[level]) {
368                 return users[userAddress].referrer;
369             }
370             
371             userAddress = users[userAddress].referrer;
372         }
373     }
374         
375     function usersActiveO3Levels(address userAddress, uint8 level) public view returns(bool) {
376         return users[userAddress].activeO3Levels[level];
377     }
378 
379     function usersActiveO6Levels(address userAddress, uint8 level) public view returns(bool) {
380         return users[userAddress].activeO6Levels[level];
381     }
382 
383     function usersO3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
384         return (users[userAddress].O3Matrix[level].currentReferrer,
385                 users[userAddress].O3Matrix[level].referrals,
386                 users[userAddress].O3Matrix[level].blocked);
387     }
388 
389     function usersO6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
390         return (users[userAddress].O6Matrix[level].currentReferrer,
391                 users[userAddress].O6Matrix[level].firstLevelReferrals,
392                 users[userAddress].O6Matrix[level].secondLevelReferrals,
393                 users[userAddress].O6Matrix[level].blocked,
394                 users[userAddress].O6Matrix[level].closedPart);
395     }
396     
397     function isUserExists(address user) public view returns (bool) {
398         return (users[user].id != 0);
399     }
400 
401     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
402         address receiver = userAddress;
403         bool isExtraDividends;
404         if (matrix == 1) {
405             while (true) {
406                 if (users[receiver].O3Matrix[level].blocked) {
407                     emit MissedEthReceive(receiver, _from, 1, level);
408                     isExtraDividends = true;
409                     receiver = users[receiver].O3Matrix[level].currentReferrer;
410                 } else {
411                     return (receiver, isExtraDividends);
412                 }
413             }
414         } else {
415             while (true) {
416                 if (users[receiver].O6Matrix[level].blocked) {
417                     emit MissedEthReceive(receiver, _from, 2, level);
418                     isExtraDividends = true;
419                     receiver = users[receiver].O6Matrix[level].currentReferrer;
420                 } else {
421                     return (receiver, isExtraDividends);
422                 }
423             }
424         }
425     }
426 
427     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
428         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
429 
430         if (!address(uint160(receiver)).send(levelPrice[level])) {
431             return address(uint160(receiver)).transfer(address(this).balance);
432         }
433         
434         if (isExtraDividends) {
435             emit SentExtraEthDividends(_from, receiver, matrix, level);
436         }
437     }
438     
439     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
440         assembly {
441             addr := mload(add(bys, 20))
442         }
443     }
444 }