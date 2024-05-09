1 /**
2 *
3 *                                                                                                
4 * 88888888888           88                                                88                        
5 * 88             ,d     88                                                ""    ,d                  
6 * 88             88     88                                                      88                  
7 * 88aaaaa      MM88MMM  88,dPPYba,    ,adPPYba,  8b,dPPYba,  8b,dPPYba,   88  MM88MMM  8b       d8  
8 * 88"""""        88     88P'    "8a  a8P_____88  88P'   "Y8  88P'   `"8a  88    88     `8b     d8'  
9 * 88             88     88       88  8PP"""""""  88          88       88  88    88      `8b   d8'   
10 * 88             88,    88       88  "8b,   ,aa  88          88       88  88    88,      `8b,d8'    
11 * 88888888888    "Y888  88       88   `"Ybbd8"'  88          88       88  88    "Y888      Y88'     
12 *                                                                                          d8'      
13 *                                                                                         d8'        
14 * 
15 * Ethernity
16 * https://ethernitiy.digital
17 * 
18 **/
19 
20 
21 pragma solidity >=0.4.23 <0.6.0;
22 
23 contract Ethernity {
24     
25     struct User {
26         uint id;
27         uint partnersCount;
28         
29         address referrer;
30         address globalReferrer;
31         
32         mapping(uint8 => bool) activeX3Levels;
33         mapping(uint8 => bool) activeX6Levels;
34         mapping(uint8 => bool) activeGlobalX3Levels;
35         mapping(uint8 => bool) activeGlobalX6Levels;
36         
37         mapping(uint8 => X3) x3Matrix;
38         mapping(uint8 => X6) x6Matrix;
39         mapping(uint8 => X3) globalX3Matrix;
40         mapping(uint8 => X6) globalX6Matrix;
41     }
42     
43     struct X3 {
44         address currentReferrer;
45         address[] referrals;
46         bool blocked;
47         uint reinvestCount;
48     }
49     
50     struct X6 {
51         address currentReferrer;
52         address[] firstLevelReferrals;
53         address[] secondLevelReferrals;
54         bool blocked;
55         uint reinvestCount;
56 
57         address closedPart;
58     }
59     
60     address private owner;
61 
62     uint8 private constant LAST_LEVEL = 12;
63     uint8 private globalCurrentX3SponsorPartners = 0;
64     uint8 private globalCurrentX6SponsorPartners = 0;
65     uint private globalCurrentX3SponsorId = 1;
66     uint private globalCurrentX6SponsorId = 1;
67     uint private lastUserId = 2;
68    
69     mapping(uint8 => uint) private levelPrice;
70     mapping(uint => address) private idToAddress;
71     mapping(address => User) private users;
72     
73     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
74     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
75     event Upgraded(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
76     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
77     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
78     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
79     
80     
81     constructor(address ownerAddress) public {
82         levelPrice[1] = 0.01 ether;
83         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
84             levelPrice[i] = levelPrice[i-1] * 2;
85         }
86         
87         owner = ownerAddress;
88         
89         User memory user = User({
90             id: 1,
91             referrer: address(0),
92             globalReferrer: address(0),
93             partnersCount: uint(0)
94         });
95         
96         users[ownerAddress] = user;
97         idToAddress[1] = ownerAddress;
98         
99         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
100             users[ownerAddress].activeX3Levels[i] = true;
101             users[ownerAddress].activeX6Levels[i] = true;
102             users[ownerAddress].activeGlobalX3Levels[i] = true;
103             users[ownerAddress].activeGlobalX6Levels[i] = true;
104         }
105     }
106     
107     function() external payable {
108         if(msg.data.length == 0) {
109             return registration(msg.sender, owner);
110         }
111         
112         registration(msg.sender, bytesToAddress(msg.data));
113     }
114 
115     function join(address referrerAddress) external payable {
116         registration(msg.sender, referrerAddress);
117     }
118     
119     function upgrade(uint8 matrix, uint8 level) external payable {
120         require(isUserExists(msg.sender), "user is not exists. Register first.");
121         require(matrix == 1 || matrix == 2 || matrix == 3 || matrix == 4, "invalid matrix");
122         require(msg.value == levelPrice[level], "invalid price");
123         require(level > 1 && level <= LAST_LEVEL, "invalid level");
124 
125         if (matrix == 1) {
126             require(!users[msg.sender].activeX3Levels[level], "level already activated");
127 
128             if (users[msg.sender].x3Matrix[level-1].blocked) {
129                 users[msg.sender].x3Matrix[level-1].blocked = false;
130             }
131     
132             address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
133             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
134             users[msg.sender].activeX3Levels[level] = true;
135             updateX3Referrer(msg.sender, freeX3Referrer, level);
136             
137             emit Upgraded(msg.sender, freeX3Referrer, 1, level);
138 
139         } else if (matrix == 2) {
140             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
141 
142             if (users[msg.sender].x6Matrix[level-1].blocked) {
143                 users[msg.sender].x6Matrix[level-1].blocked = false;
144             }
145 
146             address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
147 
148             users[msg.sender].activeX6Levels[level] = true;
149             updateX6Referrer(msg.sender, freeX6Referrer, level);
150             
151             emit Upgraded(msg.sender, freeX6Referrer, 2, level);
152         } else if (matrix == 3) {
153             require(!users[msg.sender].activeGlobalX3Levels[level], "level already activated");
154 
155             if (users[msg.sender].globalX3Matrix[level-1].blocked) {
156                 users[msg.sender].globalX3Matrix[level-1].blocked = false;
157             }
158     
159             address freeX3Referrer = findFreeGlobalX3Referrer(msg.sender, level);
160             
161             users[msg.sender].globalX3Matrix[level].currentReferrer = freeX3Referrer;
162             users[msg.sender].activeGlobalX3Levels[level] = true;
163             updateGlobalX3Referrer(msg.sender, freeX3Referrer, level);
164             
165             emit Upgraded(msg.sender, freeX3Referrer, 3, level);
166 
167         } else if (matrix == 4) {
168             require(!users[msg.sender].activeGlobalX6Levels[level], "level already activated"); 
169 
170             if (users[msg.sender].globalX6Matrix[level-1].blocked) {
171                 users[msg.sender].globalX6Matrix[level-1].blocked = false;
172             }
173 
174             address freeX6Referrer = findFreeGlobalX6Referrer(msg.sender, level);
175             
176             users[msg.sender].activeGlobalX6Levels[level] = true;
177             updateGlobalX6Referrer(msg.sender, freeX6Referrer, level);
178             
179             emit Upgraded(msg.sender, freeX6Referrer, 4, level);
180 
181         }
182     }    
183     
184     function registration(address userAddress, address referrerAddress) private {
185         require(msg.value == 0.04 ether, "registration cost 0.04");
186         require(!isUserExists(userAddress), "user exists");
187         require(isUserExists(referrerAddress), "referrer not exists");
188         
189         uint32 size;
190         assembly {
191             size := extcodesize(userAddress)
192         }
193         require(size == 0, "cannot be a contract");
194         
195         User memory user = User({
196             id: lastUserId,
197             referrer: referrerAddress,
198             globalReferrer: idToAddress[globalCurrentX3SponsorId],
199             partnersCount: uint(0)
200         });
201         
202         users[userAddress] = user;
203         idToAddress[lastUserId] = userAddress;
204         
205         users[userAddress].activeX3Levels[1] = true; 
206         users[userAddress].activeX6Levels[1] = true;
207         users[userAddress].activeGlobalX3Levels[1] = true; 
208         users[userAddress].activeGlobalX6Levels[1] = true;
209         
210         lastUserId++;
211         users[referrerAddress].partnersCount++;
212 
213         address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
214         address freeX6Referrer = findFreeX6Referrer(userAddress, 1);
215         address globalX3ReferrerAddress = idToAddress[globalCurrentX3SponsorId];
216         address globalX6ReferrerAddress = idToAddress[globalCurrentX6SponsorId];
217         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
218         users[userAddress].globalX3Matrix[1].currentReferrer = globalX3ReferrerAddress;
219         
220         updateX3Referrer(userAddress, freeX3Referrer, 1);
221         updateGlobalX3Referrer(userAddress, globalX3ReferrerAddress, 1);
222         updateX6Referrer(userAddress, freeX6Referrer, 1);
223         updateGlobalX6Referrer(userAddress, globalX6ReferrerAddress, 1);
224         
225         globalCurrentX3SponsorPartners++;
226         globalCurrentX6SponsorPartners++;
227         
228         if (globalCurrentX3SponsorPartners == 3) {
229             globalCurrentX3SponsorPartners = 0;
230             globalCurrentX3SponsorId++;
231         }
232         
233         if (globalCurrentX6SponsorPartners == 2) {
234             globalCurrentX6SponsorPartners = 0;
235             globalCurrentX6SponsorId++;
236         }
237         
238         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
239     }
240     
241     function getAddressById(uint userId) external view returns(address) {
242         return idToAddress[userId];
243     }
244     
245     function getLastUserId() external view returns(uint) {
246         return lastUserId;
247     }
248     
249     function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
250         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
251 
252         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
253             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
254             return sendETHDividends(referrerAddress, userAddress, 1, level);
255         }
256         
257         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
258         //close matrix
259         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
260         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
261             users[referrerAddress].x3Matrix[level].blocked = true;
262         }
263 
264         //create new one by recursion
265         if (referrerAddress != owner) {
266             //check referrer active level
267             address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
268             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
269                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
270             }
271             
272             users[referrerAddress].x3Matrix[level].reinvestCount++;
273             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
274             updateX3Referrer(referrerAddress, freeReferrerAddress, level);
275         } else {
276             sendETHDividends(owner, userAddress, 1, level);
277             users[owner].x3Matrix[level].reinvestCount++;
278             emit Reinvest(owner, address(0), userAddress, 1, level);
279         }
280     }
281     
282     function updateGlobalX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
283         users[referrerAddress].globalX3Matrix[level].referrals.push(userAddress);
284 
285         if (users[referrerAddress].globalX3Matrix[level].referrals.length < 3) {
286             emit NewUserPlace(userAddress, referrerAddress, 3, level, uint8(users[referrerAddress].globalX3Matrix[level].referrals.length));
287             return sendETHDividends(referrerAddress, userAddress, 3, level);
288         }
289         
290         emit NewUserPlace(userAddress, referrerAddress, 3, level, 3);
291         //close matrix
292         users[referrerAddress].globalX3Matrix[level].referrals = new address[](0);
293         if (!users[referrerAddress].activeGlobalX3Levels[level+1] && level != LAST_LEVEL) {
294             users[referrerAddress].globalX3Matrix[level].blocked = true;
295         }
296 
297         //create new one by recursion
298         if (referrerAddress != owner) {
299             //check referrer active level
300             address freeReferrerAddress = findFreeGlobalX3Referrer(referrerAddress, level);
301             if (users[referrerAddress].globalX3Matrix[level].currentReferrer != freeReferrerAddress) {
302                 users[referrerAddress].globalX3Matrix[level].currentReferrer = freeReferrerAddress;
303             }
304             
305             users[referrerAddress].globalX3Matrix[level].reinvestCount++;
306             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 3, level);
307             updateGlobalX3Referrer(referrerAddress, freeReferrerAddress, level);
308         } else {
309             sendETHDividends(owner, userAddress, 3, level);
310             users[owner].globalX3Matrix[level].reinvestCount++;
311             emit Reinvest(owner, address(0), userAddress, 3, level);
312         }
313     }
314 
315     function updateX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
316         require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
317         
318         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
319             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
320             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
321             
322             //set current level
323             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
324 
325             if (referrerAddress == owner) {
326                 return sendETHDividends(referrerAddress, userAddress, 2, level);
327             }
328             
329             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
330             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
331             
332             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
333             
334             if ((len == 2) && 
335                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
336                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
337                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
338                     emit NewUserPlace(userAddress, ref, 2, level, 5);
339                 } else {
340                     emit NewUserPlace(userAddress, ref, 2, level, 6);
341                 }
342             }  else if ((len == 1 || len == 2) &&
343                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
344                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
345                     emit NewUserPlace(userAddress, ref, 2, level, 3);
346                 } else {
347                     emit NewUserPlace(userAddress, ref, 2, level, 4);
348                 }
349             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
350                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
351                     emit NewUserPlace(userAddress, ref, 2, level, 5);
352                 } else {
353                     emit NewUserPlace(userAddress, ref, 2, level, 6);
354                 }
355             }
356 
357             return updateX6ReferrerSecondLevel(userAddress, ref, level);
358         }
359         
360         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
361 
362         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
363             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
364                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
365                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
366                 users[referrerAddress].x6Matrix[level].closedPart)) {
367 
368                 updateX6(userAddress, referrerAddress, level, true);
369                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
370             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
371                 users[referrerAddress].x6Matrix[level].closedPart) {
372                 updateX6(userAddress, referrerAddress, level, true);
373                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
374             } else {
375                 updateX6(userAddress, referrerAddress, level, false);
376                 return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
377             }
378         }
379 
380         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
381             updateX6(userAddress, referrerAddress, level, false);
382             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
383         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
384             updateX6(userAddress, referrerAddress, level, true);
385             return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
386         }
387         
388         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
389             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
390             updateX6(userAddress, referrerAddress, level, false);
391         } else {
392             updateX6(userAddress, referrerAddress, level, true);
393         }
394         
395         updateX6ReferrerSecondLevel(userAddress, referrerAddress, level);
396     }
397 
398     function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
399         if (!x2) {
400             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
401             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
402             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
403             //set current level
404             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
405         } else {
406             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
407             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
408             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
409             //set current level
410             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
411         }
412     }
413     
414     function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
415         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
416             return sendETHDividends(referrerAddress, userAddress, 2, level);
417         }
418         
419         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
420         
421         if (x6.length == 2) {
422             if (x6[0] == referrerAddress ||
423                 x6[1] == referrerAddress) {
424                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
425             } else if (x6.length == 1) {
426                 if (x6[0] == referrerAddress) {
427                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
428                 }
429             }
430         }
431         
432         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
433         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
434         users[referrerAddress].x6Matrix[level].closedPart = address(0);
435 
436         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
437             users[referrerAddress].x6Matrix[level].blocked = true;
438         }
439 
440         users[referrerAddress].x6Matrix[level].reinvestCount++;
441         
442         if (referrerAddress != owner) {
443             address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);
444 
445             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
446             updateX6Referrer(referrerAddress, freeReferrerAddress, level);
447         } else {
448             emit Reinvest(owner, address(0), userAddress, 2, level);
449             sendETHDividends(owner, userAddress, 2, level);
450         }
451     }
452     
453     function updateGlobalX6Referrer(address userAddress, address referrerAddress, uint8 level) private {
454         require(users[referrerAddress].activeGlobalX6Levels[level], "500. Referrer level is inactive");
455         
456         if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.length < 2) {
457             users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.push(userAddress);
458             emit NewUserPlace(userAddress, referrerAddress, 4, level, uint8(users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.length));
459             
460             //set current level
461             users[userAddress].globalX6Matrix[level].currentReferrer = referrerAddress;
462 
463             if (referrerAddress == owner) {
464                 return sendETHDividends(referrerAddress, userAddress, 4, level);
465             }
466             
467             address ref = users[referrerAddress].globalX6Matrix[level].currentReferrer;            
468             users[ref].globalX6Matrix[level].secondLevelReferrals.push(userAddress); 
469             
470             uint len = users[ref].globalX6Matrix[level].firstLevelReferrals.length;
471             
472             if ((len == 2) && 
473                 (users[ref].globalX6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
474                 (users[ref].globalX6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
475                 if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.length == 1) {
476                     emit NewUserPlace(userAddress, ref, 4, level, 5);
477                 } else {
478                     emit NewUserPlace(userAddress, ref, 4, level, 6);
479                 }
480             }  else if ((len == 1 || len == 2) &&
481                     users[ref].globalX6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
482                 if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.length == 1) {
483                     emit NewUserPlace(userAddress, ref, 4, level, 3);
484                 } else {
485                     emit NewUserPlace(userAddress, ref, 4, level, 4);
486                 }
487             } else if (len == 2 && users[ref].globalX6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
488                 if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals.length == 1) {
489                     emit NewUserPlace(userAddress, ref, 4, level, 5);
490                 } else {
491                     emit NewUserPlace(userAddress, ref, 4, level, 6);
492                 }
493             }
494 
495             return updateGlobalX6ReferrerSecondLevel(userAddress, ref, level);
496         }
497         
498         users[referrerAddress].globalX6Matrix[level].secondLevelReferrals.push(userAddress);
499 
500         if (users[referrerAddress].globalX6Matrix[level].closedPart != address(0)) {
501             if ((users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0] == 
502                 users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1]) &&
503                 (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0] ==
504                 users[referrerAddress].globalX6Matrix[level].closedPart)) {
505 
506                 updateGlobalX6(userAddress, referrerAddress, level, true);
507                 return updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
508             } else if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0] == 
509                 users[referrerAddress].globalX6Matrix[level].closedPart) {
510                 updateGlobalX6(userAddress, referrerAddress, level, true);
511                 return updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
512             } else {
513                 updateGlobalX6(userAddress, referrerAddress, level, false);
514                 return updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
515             }
516         }
517 
518         if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1] == userAddress) {
519             updateGlobalX6(userAddress, referrerAddress, level, false);
520             return updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
521         } else if (users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0] == userAddress) {
522             updateGlobalX6(userAddress, referrerAddress, level, true);
523             return updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
524         }
525         
526         if (users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0]].globalX6Matrix[level].firstLevelReferrals.length <= 
527             users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1]].globalX6Matrix[level].firstLevelReferrals.length) {
528             updateGlobalX6(userAddress, referrerAddress, level, false);
529         } else {
530             updateGlobalX6(userAddress, referrerAddress, level, true);
531         }
532         
533         updateGlobalX6ReferrerSecondLevel(userAddress, referrerAddress, level);
534     }
535 
536     function updateGlobalX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
537         if (!x2) {
538             users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0]].globalX6Matrix[level].firstLevelReferrals.push(userAddress);
539             emit NewUserPlace(userAddress, users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0], 4, level, uint8(users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0]].globalX6Matrix[level].firstLevelReferrals.length));
540             emit NewUserPlace(userAddress, referrerAddress, 4, level, 2 + uint8(users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0]].globalX6Matrix[level].firstLevelReferrals.length));
541             //set current level
542             users[userAddress].globalX6Matrix[level].currentReferrer = users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[0];
543         } else {
544             users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1]].globalX6Matrix[level].firstLevelReferrals.push(userAddress);
545             emit NewUserPlace(userAddress, users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1], 4, level, uint8(users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1]].globalX6Matrix[level].firstLevelReferrals.length));
546             emit NewUserPlace(userAddress, referrerAddress, 4, level, 4 + uint8(users[users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1]].globalX6Matrix[level].firstLevelReferrals.length));
547             //set current level
548             users[userAddress].globalX6Matrix[level].currentReferrer = users[referrerAddress].globalX6Matrix[level].firstLevelReferrals[1];
549         }
550     }
551     
552     function updateGlobalX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
553         if (users[referrerAddress].globalX6Matrix[level].secondLevelReferrals.length < 4) {
554             return sendETHDividends(referrerAddress, userAddress, 4, level);
555         }
556         
557         address[] memory x6 = users[users[referrerAddress].globalX6Matrix[level].currentReferrer].globalX6Matrix[level].firstLevelReferrals;
558         
559         if (x6.length == 2) {
560             if (x6[0] == referrerAddress ||
561                 x6[1] == referrerAddress) {
562                 users[users[referrerAddress].globalX6Matrix[level].currentReferrer].globalX6Matrix[level].closedPart = referrerAddress;
563             } else if (x6.length == 1) {
564                 if (x6[0] == referrerAddress) {
565                     users[users[referrerAddress].globalX6Matrix[level].currentReferrer].globalX6Matrix[level].closedPart = referrerAddress;
566                 }
567             }
568         }
569         
570         users[referrerAddress].globalX6Matrix[level].firstLevelReferrals = new address[](0);
571         users[referrerAddress].globalX6Matrix[level].secondLevelReferrals = new address[](0);
572         users[referrerAddress].globalX6Matrix[level].closedPart = address(0);
573 
574         if (!users[referrerAddress].activeGlobalX6Levels[level+1] && level != LAST_LEVEL) {
575             users[referrerAddress].globalX6Matrix[level].blocked = true;
576         }
577 
578         users[referrerAddress].globalX6Matrix[level].reinvestCount++;
579         
580         if (referrerAddress != owner) {
581             address freeReferrerAddress = findFreeGlobalX6Referrer(referrerAddress, level);
582 
583             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 4, level);
584             updateGlobalX6Referrer(referrerAddress, freeReferrerAddress, level);
585         } else {
586             emit Reinvest(owner, address(0), userAddress, 4, level);
587             sendETHDividends(owner, userAddress, 4, level);
588         }
589     }
590     
591     function findFreeX3Referrer(address userAddress, uint8 level) private view returns(address) {
592         while (true) {
593             if (users[users[userAddress].referrer].activeX3Levels[level]) {
594                 return users[userAddress].referrer;
595             }
596             
597             userAddress = users[userAddress].referrer;
598         }
599     }
600     
601     function findFreeGlobalX3Referrer(address userAddress, uint8 level) private view returns(address) {
602         while (true) {
603             if (users[users[userAddress].globalReferrer].activeGlobalX3Levels[level]) {
604                 return users[userAddress].globalReferrer;
605             }
606             
607             userAddress = users[userAddress].globalReferrer;
608         }
609     }
610     
611     function findFreeX6Referrer(address userAddress, uint8 level) private view returns(address) {
612         while (true) {
613             if (users[users[userAddress].referrer].activeX6Levels[level]) {
614                 return users[userAddress].referrer;
615             }
616             
617             userAddress = users[userAddress].referrer;
618         }
619     }
620     
621     function findFreeGlobalX6Referrer(address userAddress, uint8 level) private view returns(address) {
622         while (true) {
623             if (users[users[userAddress].globalReferrer].activeGlobalX6Levels[level]) {
624                 return users[userAddress].globalReferrer;
625             }
626             
627             userAddress = users[userAddress].globalReferrer;
628         }
629     }
630         
631     function usersActiveX3Levels(address userAddress, uint8 level) external view returns(bool) {
632         return users[userAddress].activeX3Levels[level];
633     }
634     
635     function usersGlobalActiveX3Levels(address userAddress, uint8 level) external view returns(bool) {
636         return users[userAddress].activeGlobalX3Levels[level];
637     }
638 
639     function usersActiveX6Levels(address userAddress, uint8 level) external view returns(bool) {
640         return users[userAddress].activeX6Levels[level];
641     }
642     
643      function usersGlobalActiveX6Levels(address userAddress, uint8 level) external view returns(bool) {
644         return users[userAddress].activeGlobalX6Levels[level];
645     }
646 
647     function usersX3Matrix(address userAddress, uint8 level) external view returns(address, address[] memory, bool, uint) {
648         return (users[userAddress].x3Matrix[level].currentReferrer,
649                 users[userAddress].x3Matrix[level].referrals,
650                 users[userAddress].x3Matrix[level].blocked,
651                 users[userAddress].x3Matrix[level].reinvestCount);
652     }
653     
654     function usersGlobalX3Matrix(address userAddress, uint8 level) external view returns(address, address[] memory, bool, uint) {
655         return (users[userAddress].globalX3Matrix[level].currentReferrer,
656                 users[userAddress].globalX3Matrix[level].referrals,
657                 users[userAddress].globalX3Matrix[level].blocked,
658                 users[userAddress].globalX3Matrix[level].reinvestCount);
659     }
660 
661     function usersX6Matrix(address userAddress, uint8 level) external view returns(address, address[] memory, address[] memory, bool, uint, address) {
662         return (users[userAddress].x6Matrix[level].currentReferrer,
663                 users[userAddress].x6Matrix[level].firstLevelReferrals,
664                 users[userAddress].x6Matrix[level].secondLevelReferrals,
665                 users[userAddress].x6Matrix[level].blocked,
666                 users[userAddress].x6Matrix[level].reinvestCount,
667                 users[userAddress].x6Matrix[level].closedPart);
668     }
669     
670     function usersGlobalX6Matrix(address userAddress, uint8 level) external view returns(address, address[] memory, address[] memory, bool, uint, address) {
671         return (users[userAddress].globalX6Matrix[level].currentReferrer,
672                 users[userAddress].globalX6Matrix[level].firstLevelReferrals,
673                 users[userAddress].globalX6Matrix[level].secondLevelReferrals,
674                 users[userAddress].globalX6Matrix[level].blocked,
675                 users[userAddress].globalX6Matrix[level].reinvestCount,
676                 users[userAddress].globalX6Matrix[level].closedPart);
677     }
678     
679     function isUserExists(address user) public view returns (bool) {
680         return (users[user].id != 0);
681     }
682     
683     function userInfo(address userAddress) external view returns(uint, uint, address, address) {
684         return (users[userAddress].id,
685             users[userAddress].partnersCount,
686             users[userAddress].referrer,
687             users[userAddress].globalReferrer);
688     }
689 
690     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
691         address receiver = userAddress;
692         bool isExtraDividends;
693         if (matrix == 1) {
694             while (true) {
695                 if (users[receiver].x3Matrix[level].blocked) {
696                     emit MissedEthReceive(receiver, _from, 1, level);
697                     isExtraDividends = true;
698                     receiver = users[receiver].x3Matrix[level].currentReferrer;
699                 } else {
700                     return (receiver, isExtraDividends);
701                 }
702             }
703         } else if (matrix == 2) {
704             while (true) {
705                 if (users[receiver].x6Matrix[level].blocked) {
706                     emit MissedEthReceive(receiver, _from, 2, level);
707                     isExtraDividends = true;
708                     receiver = users[receiver].x6Matrix[level].currentReferrer;
709                 } else {
710                     return (receiver, isExtraDividends);
711                 }
712             }
713         } else if (matrix == 3) {
714             while (true) {
715                 if (users[receiver].globalX3Matrix[level].blocked) {
716                     emit MissedEthReceive(receiver, _from, 3, level);
717                     isExtraDividends = true;
718                     receiver = users[receiver].globalX3Matrix[level].currentReferrer;
719                 } else {
720                     return (receiver, isExtraDividends);
721                 }
722             }
723         } else if (matrix == 4) {
724             while (true) {
725                 if (users[receiver].globalX6Matrix[level].blocked) {
726                     emit MissedEthReceive(receiver, _from, 4, level);
727                     isExtraDividends = true;
728                     receiver = users[receiver].globalX6Matrix[level].currentReferrer;
729                 } else {
730                     return (receiver, isExtraDividends);
731                 }
732             }
733         }
734     }
735     
736     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
737         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
738 
739         if (!address(uint160(receiver)).send(levelPrice[level])) {
740             return address(uint160(receiver)).transfer(address(this).balance);
741         }
742         
743         if (isExtraDividends) {
744             emit SentExtraEthDividends(_from, receiver, matrix, level);
745         }
746     }
747 
748     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
749         assembly {
750             addr := mload(add(bys, 20))
751         }
752     }
753 }