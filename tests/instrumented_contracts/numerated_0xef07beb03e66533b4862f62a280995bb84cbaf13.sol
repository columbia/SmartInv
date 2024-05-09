1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-25
3 */
4 
5 /**
6 *
7 
8 
9 ██╗    ██╗███████╗ █████╗ ██╗  ████████╗██╗  ██╗██╗  ██╗
10 ██║    ██║██╔════╝██╔══██╗██║  ╚══██╔══╝██║  ██║╚██╗██╔╝
11 ██║ █╗ ██║█████╗  ███████║██║     ██║   ███████║ ╚███╔╝ 
12 ██║███╗██║██╔══╝  ██╔══██║██║     ██║   ██╔══██║ ██╔██╗ 
13 ╚███╔███╔╝███████╗██║  ██║███████╗██║   ██║  ██║██╔╝ ██╗
14  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝
15                                                         
16 
17      
18 *
19 * 
20 * 
21 * http://wealthx.network/
22 * (only for WealthX members)
23 * 
24 **/
25 
26 
27 pragma solidity >=0.4.23 <0.6.0;
28 
29 
30 interface tokenInterface
31 {
32     function transfer(address _to, uint256 _amount) external returns (bool);
33 }
34 
35 
36 
37 
38 contract WealthExchangeNetwork {
39     
40     struct User {
41         uint id;
42         address referrer;
43         uint partnersCount;
44         
45         mapping(uint8 => bool) activeX3Levels;
46         mapping(uint8 => bool) activeX6Levels;
47         
48         mapping(uint8 => X3) x3Matrix;
49         mapping(uint8 => X6) x6Matrix;
50     }
51     
52     struct X3 {
53         address currentReferrer;
54         address[] referrals;
55         bool blocked;
56         uint reinvestCount;
57     }
58     
59     struct X6 {
60         address currentReferrer;
61         address[] firstLevelReferrals;
62         address[] secondLevelReferrals;
63         bool blocked;
64         uint reinvestCount;
65 
66         address closedPart;
67     }
68 
69     uint8 public constant LAST_LEVEL = 12;
70     
71     mapping(address => User) public users;
72     mapping(uint => address) public idToAddress;
73     mapping(uint => address) public userIds;
74     mapping(address => uint) public balances; 
75 
76     uint public lastUserId = 2;
77     address public owner;
78     uint256 public contractDeployTime;
79     
80     mapping(uint8 => uint) public levelPrice;
81 
82     uint public tokenReward = 1000 * (10 ** 18);
83     address public tokenAddress = 0xfA68bfE953efA64b021719bF617aFB5AE73C0d98;
84     
85     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId, uint amount);
86     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
87     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint amount);
88     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
89     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
90     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
91     
92     
93     constructor() public {
94 
95         contractDeployTime = now;
96         levelPrice[1] = 0.05 ether;
97         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
98             levelPrice[i] = levelPrice[i-1] * 2;
99         }
100         
101         owner = msg.sender;
102         
103         User memory user = User({
104             id: 1,
105             referrer: address(0),
106             partnersCount: uint(0)
107         });
108         
109         users[owner] = user;
110         idToAddress[1] = owner;
111         
112         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
113             users[owner].activeX3Levels[i] = true;
114             users[owner].activeX6Levels[i] = true;
115         }
116         
117         userIds[1] = owner;
118     }
119     
120     function() external payable {
121         if(msg.data.length == 0) {
122             return registration(msg.sender, owner);
123         }
124         
125         registration(msg.sender, bytesToAddress(msg.data));
126     }
127 
128     function registrationExt(address referrerAddress) external payable returns(string memory) {
129         registration(msg.sender, referrerAddress);
130         return "registration successful";
131     }
132     
133     function registrationCreator(address userAddress, address referrerAddress) external returns(string memory) {
134         require(msg.sender==owner, 'Invalid Donor');
135         require(contractDeployTime+86400 > now, 'This function is only available for first 24 hours' );
136         registration(userAddress, referrerAddress);
137         return "registration successful";
138     }
139     
140     function buyLevelCreator(address userAddress, uint8 matrix, uint8 level) external returns(string memory) {
141         require(msg.sender==owner, 'Invalid Donor');
142         require(contractDeployTime+86400 > now, 'This function is only available for first 24 hours' );
143         buyNewLevelInternal(userAddress, matrix, level);
144         return "Level bought successfully";
145     }
146     
147     function buyNewLevel(uint8 matrix, uint8 level) external payable returns(string memory) {
148         buyNewLevelInternal(msg.sender, matrix, level);
149         return "Level bought successfully";
150     }
151     
152   
153     function buyNewLevelInternal(address user, uint8 matrix, uint8 level) private {
154         require(isUserExists(user), "user is not exists. Register first.");
155         require(matrix == 1 || matrix == 2, "invalid matrix");
156         if(!(msg.sender==owner)) require(msg.value == levelPrice[level], "invalid price");
157         require(level > 1 && level <= LAST_LEVEL, "invalid level");
158 
159         require(tokenInterface(tokenAddress).transfer(user, tokenReward), "token sending fail" );
160 
161         if (matrix == 1) {
162             require(!users[user].activeX3Levels[level], "level already activated");
163 
164             if (users[user].x3Matrix[level-1].blocked) {
165                 users[user].x3Matrix[level-1].blocked = false;
166             }
167     
168             address freeX3Referrer = findFreeX3Referrer(user, level);
169             users[user].x3Matrix[level].currentReferrer = freeX3Referrer;
170             users[user].activeX3Levels[level] = true;
171             updateX3Referrer(user, freeX3Referrer, level);
172             
173             emit Upgrade(user, freeX3Referrer, 1, level, msg.value);
174 
175         } else {
176             require(!users[user].activeX6Levels[level], "level already activated"); 
177 
178             if (users[user].x6Matrix[level-1].blocked) {
179                 users[user].x6Matrix[level-1].blocked = false;
180             }
181 
182             address freeX6Referrer = findFreeX6Referrer(user, level);
183             
184             users[user].activeX6Levels[level] = true;
185             updateX6Referrer(user, freeX6Referrer, level);
186             
187             emit Upgrade(user, freeX6Referrer, 2, level, msg.value);
188         }
189     }    
190     
191     function registration(address userAddress, address referrerAddress) private {
192         if(!(msg.sender==owner)) require(msg.value == (levelPrice[1]*2), "Invalid registration amount");       
193         require(!isUserExists(userAddress), "user exists");
194         require(isUserExists(referrerAddress), "referrer not exists");
195 
196         require(tokenInterface(tokenAddress).transfer(msg.sender, tokenReward), "token sending fail" );
197 
198         uint32 size;
199         assembly {
200             size := extcodesize(userAddress)
201         }
202         require(size == 0, "cannot be a contract");
203         
204 		lastUserId++;
205 		
206         User memory user = User({
207             id: lastUserId,
208             referrer: referrerAddress,
209             partnersCount: 0
210         });
211         
212         users[userAddress] = user;
213         idToAddress[lastUserId] = userAddress;
214         
215         users[userAddress].referrer = referrerAddress;
216         
217         users[userAddress].activeX3Levels[1] = true; 
218         users[userAddress].activeX6Levels[1] = true;
219         
220         
221         userIds[lastUserId] = userAddress;
222         
223         
224         users[referrerAddress].partnersCount++;
225 
226         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
227         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
228         updateX3Referrer(userAddress, freeX3Referrer, 1);
229 
230         updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1);
231         
232         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id, msg.value);
233     }
234     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
235         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
236 
237         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
238             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
239             return sendETHDividends(referrerAddress, userAddress, 1, level);
240         }
241         
242         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
243         //close matrix
244         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
245         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
246             users[referrerAddress].x3Matrix[level].blocked = true;
247         }
248 
249         //create new one by recursion
250         if (referrerAddress != owner) {
251             //check referrer active level
252             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
253             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
254                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
255             }
256             
257             users[referrerAddress].x3Matrix[level].reinvestCount++;
258             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
259             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
260         } else {
261             sendETHDividends(owner, userAddress, 1, level);
262             users[owner].x3Matrix[level].reinvestCount++;
263             emit Reinvest(owner, address(0), userAddress, 1, level);
264         }
265     }
266 
267     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
268         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
269         
270         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
271             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
272             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
273             
274             //set current level
275             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
276 
277             if (referrerAddress == owner) {
278                 return sendETHDividends(referrerAddress, userAddress, 2, level);
279             }
280             
281             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
282             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
283             
284             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
285             
286             if ((len == 2) && 
287                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
288                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
289                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
290                     emit NewUserPlace(userAddress, ref, 2, level, 5);
291                 } else {
292                     emit NewUserPlace(userAddress, ref, 2, level, 6);
293                 }
294             }  else if ((len == 1 || len == 2) &&
295                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
296                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
297                     emit NewUserPlace(userAddress, ref, 2, level, 3);
298                 } else {
299                     emit NewUserPlace(userAddress, ref, 2, level, 4);
300                 }
301             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
302                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
303                     emit NewUserPlace(userAddress, ref, 2, level, 5);
304                 } else {
305                     emit NewUserPlace(userAddress, ref, 2, level, 6);
306                 }
307             }
308 
309             return updateX6ReferrerSecondLevel(userAddress, ref, level);
310         }
311         
312         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
313 
314         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
315             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
316                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
317                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
318                 users[referrerAddress].x6Matrix[level].closedPart)) {
319 
320                 updateX6(userAddress, referrerAddress, level, true);
321                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
322             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
323                 users[referrerAddress].x6Matrix[level].closedPart) {
324                 updateX6(userAddress, referrerAddress, level, true);
325                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
326             } else {
327                 updateX6(userAddress, referrerAddress, level, false);
328                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
329             }
330         }
331 
332         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
333             updateX6(userAddress, referrerAddress, level, false);
334             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
335         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
336             updateX6(userAddress, referrerAddress, level, true);
337             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
338         }
339         
340         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
341             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
342             updateX6(userAddress, referrerAddress, level, false);
343         } else {
344             updateX6(userAddress, referrerAddress, level, true);
345         }
346         
347         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
348     }
349 
350     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
351         if (!x2) {
352             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
353             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
354             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
355             //set current level
356             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
357         } else {
358             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
359             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
360             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
361             //set current level
362             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
363         }
364     }
365     
366     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
367         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
368             return sendETHDividends(referrerAddress, userAddress, 2, level);
369         }
370         
371         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
372         
373         if (x6.length == 2) {
374             if (x6[0] == referrerAddress ||
375                 x6[1] == referrerAddress) {
376                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
377             } else if (x6.length == 1) {
378                 if (x6[0] == referrerAddress) {
379                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
380                 }
381             }
382         }
383         
384         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
385         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
386         users[referrerAddress].x6Matrix[level].closedPart = address(0);
387 
388         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
389             users[referrerAddress].x6Matrix[level].blocked = true;
390         }
391 
392         users[referrerAddress].x6Matrix[level].reinvestCount++;
393         
394         if (referrerAddress != owner) {
395             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
396 
397             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
398             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
399         } else {
400             emit Reinvest(owner, address(0), userAddress, 2, level);
401             sendETHDividends(owner, userAddress, 2, level);
402         }
403     }
404     
405     function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
406         while (true) {
407             if (users[users[userAddress].referrer].activeX3Levels[level]) {
408                 return users[userAddress].referrer;
409             }
410             
411             userAddress = users[userAddress].referrer;
412         }
413     }
414     
415     function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
416         while (true) {
417             if (users[users[userAddress].referrer].activeX6Levels[level]) {
418                 return users[userAddress].referrer;
419             }
420             
421             userAddress = users[userAddress].referrer;
422         }
423     }
424         
425     function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
426         return users[userAddress].activeX3Levels[level];
427     }
428 
429     function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
430         return users[userAddress].activeX6Levels[level];
431     }
432 
433     function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
434         return (users[userAddress].x3Matrix[level].currentReferrer,
435                 users[userAddress].x3Matrix[level].referrals,
436                 users[userAddress].x3Matrix[level].blocked);
437     }
438 
439     function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
440         return (users[userAddress].x6Matrix[level].currentReferrer,
441                 users[userAddress].x6Matrix[level].firstLevelReferrals,
442                 users[userAddress].x6Matrix[level].secondLevelReferrals,
443                 users[userAddress].x6Matrix[level].blocked,
444                 users[userAddress].x6Matrix[level].closedPart);
445     }
446     
447     function isUserExists(address user) public view returns (bool) {
448         return (users[user].id != 0);
449     }
450 
451     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
452         address receiver = userAddress;
453         bool isExtraDividends;
454         if (matrix == 1) {
455             while (true) {
456                 if (users[receiver].x3Matrix[level].blocked) {
457                     emit MissedEthReceive(receiver, _from, 1, level);
458                     isExtraDividends = true;
459                     receiver = users[receiver].x3Matrix[level].currentReferrer;
460                 } else {
461                     return (receiver, isExtraDividends);
462                 }
463             }
464         } else {
465             while (true) {
466                 if (users[receiver].x6Matrix[level].blocked) {
467                     emit MissedEthReceive(receiver, _from, 2, level);
468                     isExtraDividends = true;
469                     receiver = users[receiver].x6Matrix[level].currentReferrer;
470                 } else {
471                     return (receiver, isExtraDividends);
472                 }
473             }
474         }
475     }
476 
477     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
478         if(msg.sender!=owner)
479         {
480             (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
481 
482             if (!address(uint160(receiver)).send(levelPrice[level])) {
483                 return address(uint160(receiver)).transfer(address(this).balance);
484             }
485         
486             if (isExtraDividends) {
487                 emit SentExtraEthDividends(_from, receiver, matrix, level);
488             }
489         }
490     }
491     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
492         assembly {
493             addr := mload(add(bys, 20))
494         }
495     }
496 
497     function viewLevels(address user) public view returns (bool[12] memory x3Levels, bool[12] memory x6Levels,uint8 x3LastTrue, uint8 x6LastTrue)
498     {
499         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
500             x3Levels[i] = users[user].activeX3Levels[i];
501             if(x3Levels[i]) x3LastTrue = i;
502             x6Levels[i] = users[user].activeX6Levels[i];
503             if(x6Levels[i]) x6LastTrue = i;
504         }
505     }
506 
507     function withdrawExtraToken(uint amount) public returns(bool)
508     {
509         require(msg.sender == owner, "Invalid caller");
510         require(tokenInterface(tokenAddress).transfer(msg.sender, amount), "token sending fail" );
511         return true;
512     }
513 }