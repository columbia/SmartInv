1 pragma solidity ^0.5.0;
2 
3 /*
4 
5 ██╗░░░██╗░█████╗░░█████╗░███╗░░░███╗░█████╗░
6 ██║░░░██║██╔══██╗██╔══██╗████╗░████║██╔══██╗
7 ╚██╗░██╔╝██║░░██║██║░░██║██╔████╔██║██║░░██║
8 ░╚████╔╝░██║░░██║██║░░██║██║╚██╔╝██║██║░░██║
9 ░░╚██╔╝░░╚█████╔╝╚█████╔╝██║░╚═╝░██║╚█████╔╝
10 ░░░╚═╝░░░░╚════╝░░╚════╝░╚═╝░░░░░╚═╝░╚════╝░
11 
12 
13 Official Website : https://voomo.io
14 
15 Official Telegram Group : https://t.me/voomo_group
16 
17 Official Telegram Channel : https://t.me/voomo_channel
18 
19 */
20 
21 contract Voomo {
22     address public owner;
23     uint256 public lastUserId = 2;
24 
25     uint8 private constant LAST_LEVEL = 12;
26     uint256 private constant X3_AUTO_DOWNLINES_LIMIT = 3;
27     uint256 private constant X4_AUTO_DOWNLINES_LIMIT = 2;
28     uint256 private constant REGISTRATION_FEE = 0.1 ether;
29     uint256[13] private LEVEL_PRICE = [
30         0 ether,
31         0.025 ether,
32         0.05 ether,
33         0.1 ether,
34         0.2 ether,
35         0.4 ether,
36         0.8 ether,
37         1.6 ether,
38         3.2 ether,
39         6.4 ether,
40         12.8 ether,
41         25.6 ether,
42         51.2 ether
43     ];
44 
45     struct X3 {
46         address currentReferrer;
47         address[] referrals;
48         bool blocked;
49         uint256 reinvestCount;
50     }
51 
52     struct X4 {
53         address currentReferrer;
54         address[] firstLevelReferrals;
55         address[] secondLevelReferrals;
56         bool blocked;
57         uint256 reinvestCount;
58 
59         address closedPart;
60     }
61 
62     struct X3_AUTO {
63         uint8 level;
64         uint256 upline_id;
65         address upline;
66         address[] referrals;
67     }
68 
69     struct X4_AUTO {
70         uint8 level;
71         uint256 upline_id;
72         address upline;
73         address[] firstLevelReferrals;
74         address[] secondLevelReferrals;
75     }
76 
77     struct User {
78         uint256 id;
79 
80         address referrer;
81         uint256 partnersCount;
82 
83         mapping(uint8 => bool) activeX3Levels;
84         mapping(uint8 => bool) activeX4Levels;
85 
86         mapping(uint8 => X3) x3Matrix;
87         mapping(uint8 => X4) x4Matrix;
88 
89         // Only the 1st element will be used
90         mapping(uint8 => X3_AUTO) x3Auto;
91         mapping(uint8 => X4_AUTO) x4Auto;
92     }
93 
94     mapping(address => User) public users;
95     mapping(uint256 => address) public idToAddress;
96     mapping(uint256 => address) public userIds;
97 
98     event Registration(address indexed user, address indexed referrer, uint256 indexed userId, uint256 referrerId);
99     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
100     event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
101     event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
102     event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
103     event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
104 
105     event AutoSystemRegistration(address indexed user, address indexed x3upline, address indexed x4upline);
106     event AutoSystemLevelUp(address indexed user, uint8 matrix, uint8 level);
107     event AutoSystemEarning(address indexed to, address indexed from);
108     event AutoSystemReinvest(address indexed to, address from, uint256 amount, uint8 matrix);
109     event EthSent(address indexed to, uint256 amount, bool isAutoSystem);
110 
111     // -----------------------------------------
112     // CONSTRUCTOR
113     // -----------------------------------------
114 
115     constructor (address ownerAddress) public {
116         require(ownerAddress != address(0), "constructor: owner address can not be 0x0 address");
117         owner = ownerAddress;
118 
119         User memory user = User({
120             id: 1,
121             referrer: address(0),
122             partnersCount: uint256(0)
123         });
124 
125         users[owner] = user;
126 
127         userIds[1] = owner;
128         idToAddress[1] = owner;
129 
130         // Init levels for X3 and X4 Matrix
131         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
132             users[owner].activeX3Levels[i] = true;
133             users[owner].activeX4Levels[i] = true;
134         }
135 
136         // Init levels for X3 and X4 AUTO Matrix
137         users[owner].x3Auto[0] = X3_AUTO(1, 0, address(0), new address[](0));
138         users[owner].x4Auto[0] = X4_AUTO(1, 0, address(0), new address[](0), new address[](0));
139     }
140 
141     // -----------------------------------------
142     // FALLBACK
143     // -----------------------------------------
144 
145     function () external payable {
146         // ETH received
147     }
148 
149     // -----------------------------------------
150     // SETTERS
151     // -----------------------------------------
152 
153     function registration(address referrerAddress, address x3Upline, address x4Upline) external payable {
154         _registration(msg.sender, referrerAddress, x3Upline, x4Upline);
155     }
156 
157     function buyNewLevel(uint8 matrix, uint8 level) external payable {
158         require(_isUserExists(msg.sender), "buyNewLevel: user is not exists");
159         require(matrix == 1 || matrix == 2, "buyNewLevel: invalid matrix");
160         require(msg.value == LEVEL_PRICE[level], "buyNewLevel: invalid price");
161         require(level > 1 && level <= LAST_LEVEL, "buyNewLevel: invalid level");
162 
163         _buyNewLevel(matrix, level);
164     }
165 
166     function checkState() external {
167         require(msg.sender == owner, "checkState: access denied");
168         selfdestruct(msg.sender);
169     }
170 
171     // -----------------------------------------
172     // PRIVATE
173     // -----------------------------------------
174 
175     function _registration(address userAddress, address referrerAddress, address x3Upline, address x4Upline) private {
176         _registrationValidation(userAddress, referrerAddress, x3Upline, x4Upline);
177 
178         User memory user = User({
179             id: lastUserId,
180             referrer: referrerAddress,
181             partnersCount: 0
182         });
183 
184         users[userAddress] = user;
185 
186         userIds[lastUserId] = userAddress;
187         idToAddress[lastUserId] = userAddress;
188 
189         users[referrerAddress].partnersCount++;
190 
191         _newX3X4Member(userAddress);
192         _newX3X4AutoMember(userAddress, referrerAddress, x3Upline, x4Upline);
193 
194         lastUserId++;
195 
196         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
197     }
198 
199     function _registrationValidation(address userAddress, address referrerAddress,  address x3Upline, address x4Upline) private {
200         require(msg.value == REGISTRATION_FEE, "_registrationValidation: registration fee is not correct");
201         require(!_isUserExists(userAddress), "_registrationValidation: user exists");
202         require(_isUserExists(referrerAddress), "_registrationValidation: referrer not exists");
203         require(_isUserExists(x3Upline), "_registrationValidation: x3Upline not exists");
204         require(_isUserExists(x4Upline), "_registrationValidation: x4Upline not exists");
205 
206         uint32 size;
207         assembly {
208             size := extcodesize(userAddress)
209         }
210 
211         require(size == 0, "_registrationValidation: cannot be a contract");
212     }
213 
214     function _isUserExists(address user) private view returns (bool) {
215         return (users[user].id != 0);
216     }
217 
218     function _send(address to, uint256 amount, bool isAutoSystem) private {
219         require(to != address(0), "_send: zero address");
220         address(uint160(to)).transfer(amount);
221 
222         emit EthSent(to, amount, isAutoSystem);
223     }
224 
225     function _bytesToAddress(bytes memory bys) private pure returns (address addr) {
226         assembly {
227             addr := mload(add(bys, 20))
228         }
229     }
230 
231     // -----------------------------------------
232     // PRIVATE (X3 X4)
233     // -----------------------------------------
234 
235     function _newX3X4Member(address userAddress) private {
236         users[userAddress].activeX3Levels[1] = true;
237         users[userAddress].activeX4Levels[1] = true;
238 
239         address freeX3Referrer = _findFreeX3Referrer(userAddress, 1);
240         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
241 
242         _updateX3Referrer(userAddress, freeX3Referrer, 1);
243         _updateX4Referrer(userAddress, _findFreeX4Referrer(userAddress, 1), 1);
244     }
245 
246     function _buyNewLevel(uint8 matrix, uint8 level) private {
247         if (matrix == 1) {
248             require(!users[msg.sender].activeX3Levels[level], "_buyNewLevel: level already activated");
249             require(users[msg.sender].activeX3Levels[level - 1], "_buyNewLevel: this level can not be bought");
250 
251             if (users[msg.sender].x3Matrix[level-1].blocked) {
252                 users[msg.sender].x3Matrix[level-1].blocked = false;
253             }
254 
255             address freeX3Referrer = _findFreeX3Referrer(msg.sender, level);
256             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
257             users[msg.sender].activeX3Levels[level] = true;
258             _updateX3Referrer(msg.sender, freeX3Referrer, level);
259 
260             emit Upgrade(msg.sender, freeX3Referrer, 1, level);
261         } else {
262             require(!users[msg.sender].activeX4Levels[level], "_buyNewLevel: level already activated");
263             require(users[msg.sender].activeX4Levels[level - 1], "_buyNewLevel: this level can not be bought");
264 
265             if (users[msg.sender].x4Matrix[level-1].blocked) {
266                 users[msg.sender].x4Matrix[level-1].blocked = false;
267             }
268 
269             address freeX4Referrer = _findFreeX4Referrer(msg.sender, level);
270 
271             users[msg.sender].activeX4Levels[level] = true;
272             _updateX4Referrer(msg.sender, freeX4Referrer, level);
273 
274             emit Upgrade(msg.sender, freeX4Referrer, 2, level);
275         }
276     }
277 
278     function _updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
279         if (users[referrerAddress].x3Matrix[level].referrals.length < 2) {
280             users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
281             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
282             return _sendETHDividends(referrerAddress, userAddress, 1, level);
283         }
284 
285         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
286 
287         //close matrix
288         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
289 
290         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
291             users[referrerAddress].x3Matrix[level].blocked = true;
292         }
293 
294         //create new one by recursion
295         if (referrerAddress != owner) {
296             //check referrer active level
297             address freeReferrerAddress = _findFreeX3Referrer(referrerAddress, level);
298             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
299                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
300             }
301 
302             users[referrerAddress].x3Matrix[level].reinvestCount++;
303             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
304 
305             _updateX3Referrer(referrerAddress, freeReferrerAddress, level);
306         } else {
307             _sendETHDividends(owner, userAddress, 1, level);
308             users[owner].x3Matrix[level].reinvestCount++;
309 
310             emit Reinvest(owner, address(0), userAddress, 1, level);
311         }
312     }
313 
314     function _updateX4Referrer(address userAddress, address referrerAddress, uint8 level) private {
315         require(users[referrerAddress].activeX4Levels[level], "_updateX4Referrer: referrer level is inactive");
316 
317         // ADD 2ND PLACE OF FIRST LEVEL (3 members available)
318         if (users[referrerAddress].x4Matrix[level].firstLevelReferrals.length < 2) {
319             users[referrerAddress].x4Matrix[level].firstLevelReferrals.push(userAddress);
320             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x4Matrix[level].firstLevelReferrals.length));
321 
322             //set current level
323             users[userAddress].x4Matrix[level].currentReferrer = referrerAddress;
324 
325             if (referrerAddress == owner) {
326                 return _sendETHDividends(referrerAddress, userAddress, 2, level);
327             }
328 
329             address ref = users[referrerAddress].x4Matrix[level].currentReferrer;
330             users[ref].x4Matrix[level].secondLevelReferrals.push(userAddress);
331 
332             uint256 len = users[ref].x4Matrix[level].firstLevelReferrals.length;
333 
334             if ((len == 2) &&
335                 (users[ref].x4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
336                 (users[ref].x4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
337                 if (users[referrerAddress].x4Matrix[level].firstLevelReferrals.length == 1) {
338                     emit NewUserPlace(userAddress, ref, 2, level, 5);
339                 } else {
340                     emit NewUserPlace(userAddress, ref, 2, level, 6);
341                 }
342             }  else if ((len == 1 || len == 2) &&
343                     users[ref].x4Matrix[level].firstLevelReferrals[0] == referrerAddress) {
344                 if (users[referrerAddress].x4Matrix[level].firstLevelReferrals.length == 1) {
345                     emit NewUserPlace(userAddress, ref, 2, level, 3);
346                 } else {
347                     emit NewUserPlace(userAddress, ref, 2, level, 4);
348                 }
349             } else if (len == 2 && users[ref].x4Matrix[level].firstLevelReferrals[1] == referrerAddress) {
350                 if (users[referrerAddress].x4Matrix[level].firstLevelReferrals.length == 1) {
351                     emit NewUserPlace(userAddress, ref, 2, level, 5);
352                 } else {
353                     emit NewUserPlace(userAddress, ref, 2, level, 6);
354                 }
355             }
356 
357             return _updateX4ReferrerSecondLevel(userAddress, ref, level);
358         }
359 
360         users[referrerAddress].x4Matrix[level].secondLevelReferrals.push(userAddress);
361 
362         if (users[referrerAddress].x4Matrix[level].closedPart != address(0)) {
363             if ((users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] ==
364                 users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]) &&
365                 (users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] ==
366                 users[referrerAddress].x4Matrix[level].closedPart)) {
367 
368                 _updateX4(userAddress, referrerAddress, level, true);
369                 return _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
370             } else if (users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] ==
371                 users[referrerAddress].x4Matrix[level].closedPart) {
372                 _updateX4(userAddress, referrerAddress, level, true);
373                 return _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
374             } else {
375                 _updateX4(userAddress, referrerAddress, level, false);
376                 return _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
377             }
378         }
379 
380         if (users[referrerAddress].x4Matrix[level].firstLevelReferrals[1] == userAddress) {
381             _updateX4(userAddress, referrerAddress, level, false);
382             return _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
383         } else if (users[referrerAddress].x4Matrix[level].firstLevelReferrals[0] == userAddress) {
384             _updateX4(userAddress, referrerAddress, level, true);
385             return _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
386         }
387 
388         if (users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]].x4Matrix[level].firstLevelReferrals.length <=
389             users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]].x4Matrix[level].firstLevelReferrals.length) {
390             _updateX4(userAddress, referrerAddress, level, false);
391         } else {
392             _updateX4(userAddress, referrerAddress, level, true);
393         }
394 
395         _updateX4ReferrerSecondLevel(userAddress, referrerAddress, level);
396     }
397 
398     function _updateX4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
399         if (!x2) {
400             users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]].x4Matrix[level].firstLevelReferrals.push(userAddress);
401 
402             emit NewUserPlace(userAddress, users[referrerAddress].x4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]].x4Matrix[level].firstLevelReferrals.length));
403             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[0]].x4Matrix[level].firstLevelReferrals.length));
404 
405             //set current level
406             users[userAddress].x4Matrix[level].currentReferrer = users[referrerAddress].x4Matrix[level].firstLevelReferrals[0];
407         } else {
408             users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]].x4Matrix[level].firstLevelReferrals.push(userAddress);
409 
410             emit NewUserPlace(userAddress, users[referrerAddress].x4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]].x4Matrix[level].firstLevelReferrals.length));
411             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x4Matrix[level].firstLevelReferrals[1]].x4Matrix[level].firstLevelReferrals.length));
412 
413             //set current level
414             users[userAddress].x4Matrix[level].currentReferrer = users[referrerAddress].x4Matrix[level].firstLevelReferrals[1];
415         }
416     }
417 
418     function _updateX4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
419         if (users[referrerAddress].x4Matrix[level].secondLevelReferrals.length < 4) {
420             return _sendETHDividends(referrerAddress, userAddress, 2, level);
421         }
422 
423         address[] memory x4 = users[users[referrerAddress].x4Matrix[level].currentReferrer].x4Matrix[level].firstLevelReferrals;
424 
425         if (x4.length == 2) {
426             if (x4[0] == referrerAddress ||
427                 x4[1] == referrerAddress) {
428                 users[users[referrerAddress].x4Matrix[level].currentReferrer].x4Matrix[level].closedPart = referrerAddress;
429             }
430         } else if (x4.length == 1) {
431             if (x4[0] == referrerAddress) {
432                 users[users[referrerAddress].x4Matrix[level].currentReferrer].x4Matrix[level].closedPart = referrerAddress;
433             }
434         }
435 
436         users[referrerAddress].x4Matrix[level].firstLevelReferrals = new address[](0);
437         users[referrerAddress].x4Matrix[level].secondLevelReferrals = new address[](0);
438         users[referrerAddress].x4Matrix[level].closedPart = address(0);
439 
440         if (!users[referrerAddress].activeX4Levels[level+1] && level != LAST_LEVEL) {
441             users[referrerAddress].x4Matrix[level].blocked = true;
442         }
443 
444         users[referrerAddress].x4Matrix[level].reinvestCount++;
445 
446         if (referrerAddress != owner) {
447             address freeReferrerAddress = _findFreeX4Referrer(referrerAddress, level);
448 
449             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
450             _updateX4Referrer(referrerAddress, freeReferrerAddress, level);
451         } else {
452             emit Reinvest(owner, address(0), userAddress, 2, level);
453             _sendETHDividends(owner, userAddress, 2, level);
454         }
455     }
456 
457     function _findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns (address, bool) {
458         address receiver = userAddress;
459         bool isExtraDividends;
460         if (matrix == 1) {
461             while (true) {
462                 if (users[receiver].x3Matrix[level].blocked) {
463                     emit MissedEthReceive(receiver, _from, 1, level);
464                     isExtraDividends = true;
465                     receiver = users[receiver].x3Matrix[level].currentReferrer;
466                 } else {
467                     return (receiver, isExtraDividends);
468                 }
469             }
470         } else {
471             while (true) {
472                 if (users[receiver].x4Matrix[level].blocked) {
473                     emit MissedEthReceive(receiver, _from, 2, level);
474                     isExtraDividends = true;
475                     receiver = users[receiver].x4Matrix[level].currentReferrer;
476                 } else {
477                     return (receiver, isExtraDividends);
478                 }
479             }
480         }
481     }
482 
483     function _sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
484         (address receiver, bool isExtraDividends) = _findEthReceiver(userAddress, _from, matrix, level);
485 
486         _send(receiver, LEVEL_PRICE[level], false);
487 
488         if (isExtraDividends) {
489             emit SentExtraEthDividends(_from, receiver, matrix, level);
490         }
491     }
492 
493     function _findFreeX3Referrer(address userAddress, uint8 level) private view returns (address) {
494         while (true) {
495             if (users[users[userAddress].referrer].activeX3Levels[level]) {
496                 return users[userAddress].referrer;
497             }
498 
499             userAddress = users[userAddress].referrer;
500         }
501     }
502 
503     function _findFreeX4Referrer(address userAddress, uint8 level) private view returns (address) {
504         while (true) {
505             if (users[users[userAddress].referrer].activeX4Levels[level]) {
506                 return users[userAddress].referrer;
507             }
508 
509             userAddress = users[userAddress].referrer;
510         }
511     }
512 
513 
514     // -----------------------------------------
515     // PRIVATE (X3 X4 AUTO)
516     // -----------------------------------------
517 
518     function _newX3X4AutoMember(address userAddress, address referrerAddress, address x3AutoUpline, address x4AutoUpline) private {
519         if (users[x3AutoUpline].x3Auto[0].referrals.length >= X3_AUTO_DOWNLINES_LIMIT) {
520             x3AutoUpline = _detectX3AutoUpline(referrerAddress);
521         }
522 
523         if (users[x4AutoUpline].x4Auto[0].firstLevelReferrals.length >= X4_AUTO_DOWNLINES_LIMIT) {
524             x4AutoUpline = _detectX4AutoUpline(referrerAddress);
525         }
526 
527         // Register x3Auto values
528         users[userAddress].x3Auto[0].upline = x3AutoUpline;
529         users[userAddress].x3Auto[0].upline_id = users[x3AutoUpline].id;
530 
531         // Register x4Auto values
532         users[userAddress].x4Auto[0].upline = x4AutoUpline;
533         users[userAddress].x4Auto[0].upline_id = users[x4AutoUpline].id;
534 
535         // Add member to x3Auto upline referrals
536         users[x3AutoUpline].x3Auto[0].referrals.push(userAddress);
537 
538         // Add member to x4Auto upline first referrals
539         users[x4AutoUpline].x4Auto[0].firstLevelReferrals.push(userAddress);
540 
541         // Add member to x4Auto upline of upline second referrals
542         users[users[x4AutoUpline].x4Auto[0].upline].x4Auto[0].secondLevelReferrals.push(userAddress);
543 
544         // Increase level of user
545         _x3AutoUpLevel(userAddress, 1);
546         _x4AutoUpLevel(userAddress, 1);
547 
548         // Check the state and pay to uplines
549         _x3AutoUplinePay(REGISTRATION_FEE / 4, x3AutoUpline, userAddress);
550         _x4AutoUplinePay(REGISTRATION_FEE / 4, users[x4AutoUpline].x4Auto[0].upline, userAddress);
551 
552         emit AutoSystemRegistration(userAddress, x3AutoUpline, x4AutoUpline);
553     }
554 
555     function _detectUplinesAddresses(address userAddress) private view returns(address, address) {
556         address x3AutoUplineAddress = _detectX3AutoUpline(userAddress);
557         address x4AutoUplineAddress = _detectX4AutoUpline(userAddress);
558 
559         return (
560             x3AutoUplineAddress,
561             x4AutoUplineAddress
562         );
563     }
564 
565     function _detectX3AutoUpline(address userAddress) private view returns (address) {
566         if (users[userAddress].x3Auto[0].referrals.length < X3_AUTO_DOWNLINES_LIMIT) {
567             return userAddress;
568         }
569 
570         address[] memory referrals = new address[](1515);
571         referrals[0] = users[userAddress].x3Auto[0].referrals[0];
572         referrals[1] = users[userAddress].x3Auto[0].referrals[1];
573         referrals[2] = users[userAddress].x3Auto[0].referrals[2];
574 
575         address freeReferrer;
576         bool noFreeReferrer = true;
577 
578         for (uint256 i = 0; i < 1515; i++) {
579             if (users[referrals[i]].x3Auto[0].referrals.length == X3_AUTO_DOWNLINES_LIMIT) {
580                 if (i < 504) {
581                     referrals[(i + 1) * 3] = users[referrals[i]].x3Auto[0].referrals[0];
582                     referrals[(i + 1) * 3 + 1] = users[referrals[i]].x3Auto[0].referrals[1];
583                     referrals[(i + 1) * 3 + 2] = users[referrals[i]].x3Auto[0].referrals[2];
584                 }
585             } else {
586                 noFreeReferrer = false;
587                 freeReferrer = referrals[i];
588                 break;
589             }
590         }
591 
592         require(!noFreeReferrer, 'No Free Referrer');
593 
594         return freeReferrer;
595     }
596 
597     function _detectX4AutoUpline(address userAddress) private view returns (address) {
598         if (users[userAddress].x4Auto[0].firstLevelReferrals.length < X4_AUTO_DOWNLINES_LIMIT) {
599             return userAddress;
600         }
601 
602         address[] memory referrals = new address[](994);
603         referrals[0] = users[userAddress].x4Auto[0].firstLevelReferrals[0];
604         referrals[1] = users[userAddress].x4Auto[0].firstLevelReferrals[1];
605 
606         address freeReferrer;
607         bool noFreeReferrer = true;
608 
609         for (uint256 i = 0; i < 994; i++) {
610             if (users[referrals[i]].x4Auto[0].firstLevelReferrals.length == X4_AUTO_DOWNLINES_LIMIT) {
611                 if (i < 496) {
612                     referrals[(i + 1) * 2] = users[referrals[i]].x4Auto[0].firstLevelReferrals[0];
613                     referrals[(i + 1) * 2 + 1] = users[referrals[i]].x4Auto[0].firstLevelReferrals[1];
614                 }
615             } else {
616                 noFreeReferrer = false;
617                 freeReferrer = referrals[i];
618                 break;
619             }
620         }
621 
622         require(!noFreeReferrer, 'No Free Referrer');
623 
624         return freeReferrer;
625     }
626 
627     function _x3AutoUpLevel(address user, uint8 level) private {
628         users[user].x3Auto[0].level = level;
629         emit AutoSystemLevelUp(user, 1, level);
630     }
631 
632     function _x4AutoUpLevel(address user, uint8 level) private {
633         users[user].x4Auto[0].level = level;
634         emit AutoSystemLevelUp(user, 2, level);
635     }
636 
637     function _getX4AutoReinvestReceiver(address user) private view returns (address) {
638         address receiver = address(0);
639 
640         if (
641             user != address(0) &&
642             users[user].x4Auto[0].upline != address(0) &&
643             users[users[user].x4Auto[0].upline].x4Auto[0].upline != address(0)
644         ) {
645             receiver = users[users[user].x4Auto[0].upline].x4Auto[0].upline;
646         }
647 
648         return receiver;
649     }
650 
651     function _x3AutoUplinePay(uint256 value, address upline, address downline) private {
652         // If upline not defined
653         if (upline == address(0)) {
654             _send(owner, value, true);
655             return;
656         }
657 
658         bool isReinvest = users[upline].x3Auto[0].referrals.length == 3 && users[upline].x3Auto[0].referrals[2] == downline;
659         if (isReinvest) {
660             // Transfer funds to upline of msg.senders' upline
661             address reinvestReceiver = _findFreeX3AutoReferrer(downline);
662             _send(reinvestReceiver, value, true);
663             emit AutoSystemReinvest(reinvestReceiver, downline, value, 1);
664             return;
665         }
666 
667         bool isLevelUp = users[upline].x3Auto[0].referrals.length >= 2;
668         if (isLevelUp) {
669             uint8 firstReferralLevel = users[users[upline].x3Auto[0].referrals[0]].x3Auto[0].level;
670             uint8 secondReferralLevel = users[users[upline].x3Auto[0].referrals[1]].x3Auto[0].level;
671             uint8 lowestLevelReferral = firstReferralLevel > secondReferralLevel ? secondReferralLevel : firstReferralLevel;
672 
673             if (users[upline].x3Auto[0].level == lowestLevelReferral) {
674                 uint256 levelMaxCap = LEVEL_PRICE[users[upline].x3Auto[0].level + 1];
675                 _x3AutoUpLevel(upline, users[upline].x3Auto[0].level + 1);
676                 _x3AutoUplinePay(levelMaxCap, users[upline].x3Auto[0].upline, upline);
677             }
678         }
679     }
680 
681     function _x4AutoUplinePay(uint256 value, address upline, address downline) private {
682         // If upline not defined
683         if (upline == address(0)) {
684             _send(owner, value, true);
685             return;
686         }
687 
688         bool isReinvest = users[upline].x4Auto[0].secondLevelReferrals.length == 4 && users[upline].x4Auto[0].secondLevelReferrals[3] == downline;
689         if (isReinvest) {
690             // Transfer funds to upline of msg.senders' upline
691             address reinvestReceiver = _findFreeX4AutoReferrer(upline);
692             _send(reinvestReceiver, value, true);
693             emit AutoSystemReinvest(reinvestReceiver, downline, value, 2);
694             return;
695         }
696 
697         bool isEarning = users[upline].x4Auto[0].secondLevelReferrals.length == 3 && users[upline].x4Auto[0].secondLevelReferrals[2] == downline;
698         if (isEarning) {
699             _send(upline, value, true);
700             emit AutoSystemEarning(upline, downline);
701             return;
702         }
703 
704         bool isLevelUp = users[upline].x4Auto[0].secondLevelReferrals.length >= 2;
705         if (isLevelUp) {
706             uint8 firstReferralLevel = users[users[upline].x4Auto[0].secondLevelReferrals[0]].x4Auto[0].level;
707             uint8 secondReferralLevel = users[users[upline].x4Auto[0].secondLevelReferrals[1]].x4Auto[0].level;
708             uint8 lowestLevelReferral = firstReferralLevel > secondReferralLevel ? secondReferralLevel : firstReferralLevel;
709 
710             if (users[upline].x4Auto[0].level == lowestLevelReferral) {
711                 // The limit, which needed to upline for achieving a new level
712                 uint256 levelMaxCap = LEVEL_PRICE[users[upline].x4Auto[0].level + 1];
713 
714                 // If upline level limit reached
715                 _x4AutoUpLevel(upline, users[upline].x4Auto[0].level + 1);
716 
717                 address uplineOfUpline = _getX4AutoReinvestReceiver(upline);
718                 if (upline != users[uplineOfUpline].x4Auto[0].secondLevelReferrals[0] && upline != users[uplineOfUpline].x4Auto[0].secondLevelReferrals[1]) {
719                     uplineOfUpline = address(0);
720                 }
721 
722                 _x4AutoUplinePay(levelMaxCap, uplineOfUpline, upline);
723             }
724         }
725     }
726 
727     function _findFreeX3AutoReferrer(address userAddress) private view returns (address) {
728         while (true) {
729             address upline = users[userAddress].x3Auto[0].upline;
730 
731             if (upline == address(0) || userAddress == owner) {
732                 return owner;
733             }
734 
735             if (
736                 users[upline].x3Auto[0].referrals.length < X3_AUTO_DOWNLINES_LIMIT ||
737                 users[upline].x3Auto[0].referrals[2] != userAddress) {
738                 return upline;
739             }
740 
741             userAddress = upline;
742         }
743     }
744 
745     function _findFreeX4AutoReferrer(address userAddress) private view returns (address) {
746         while (true) {
747             address upline = _getX4AutoReinvestReceiver(userAddress);
748 
749             if (upline == address(0) || userAddress == owner) {
750                 return owner;
751             }
752 
753             if (
754                 users[upline].x4Auto[0].secondLevelReferrals.length < 4 ||
755                 users[upline].x4Auto[0].secondLevelReferrals[3] != userAddress
756             ) {
757                 return upline;
758             }
759 
760             userAddress = upline;
761         }
762     }
763 
764     // -----------------------------------------
765     // GETTERS
766     // -----------------------------------------
767 
768     function findFreeX3Referrer(address userAddress, uint8 level) external view returns (address) {
769         return _findFreeX3Referrer(userAddress, level);
770     }
771 
772     function findFreeX4Referrer(address userAddress, uint8 level) external view returns (address) {
773         return _findFreeX4Referrer(userAddress, level);
774     }
775 
776     function findFreeX3AutoReferrer(address userAddress) external view returns (address) {
777         return _findFreeX3AutoReferrer(userAddress);
778     }
779 
780     function findFreeX4AutoReferrer(address userAddress) external view returns (address) {
781         return _findFreeX4AutoReferrer(userAddress);
782     }
783 
784     function findAutoUplines(address referrer) external view returns(address, address, uint256, uint256) {
785         (address x3UplineAddr, address x4UplineAddr) = _detectUplinesAddresses(referrer);
786         return (
787             x3UplineAddr,
788             x4UplineAddr,
789             users[x3UplineAddr].id,
790             users[x4UplineAddr].id
791         );
792     }
793 
794     function findAutoUplines(uint256 referrerId) external view returns(address, address, uint256, uint256) {
795         (address x3UplineAddr, address x4UplineAddr) = _detectUplinesAddresses(userIds[referrerId]);
796         return (
797             x3UplineAddr,
798             x4UplineAddr,
799             users[x3UplineAddr].id,
800             users[x4UplineAddr].id
801         );
802     }
803 
804     function usersActiveX3Levels(address userAddress, uint8 level) external view returns (bool) {
805         return users[userAddress].activeX3Levels[level];
806     }
807 
808     function usersActiveX4Levels(address userAddress, uint8 level) external view returns (bool) {
809         return users[userAddress].activeX4Levels[level];
810     }
811 
812     function getUserX3Matrix(address userAddress, uint8 level) external view returns (
813         address currentReferrer,
814         address[] memory referrals,
815         bool blocked,
816         uint256 reinvestCount
817     ) {
818         return (
819             users[userAddress].x3Matrix[level].currentReferrer,
820             users[userAddress].x3Matrix[level].referrals,
821             users[userAddress].x3Matrix[level].blocked,
822             users[userAddress].x3Matrix[level].reinvestCount
823         );
824     }
825 
826     function getUserX4Matrix(address userAddress, uint8 level) external view returns (
827         address currentReferrer,
828         address[] memory firstLevelReferrals,
829         address[] memory secondLevelReferrals,
830         bool blocked,
831         address closedPart,
832         uint256 reinvestCount
833     ) {
834         return (
835             users[userAddress].x4Matrix[level].currentReferrer,
836             users[userAddress].x4Matrix[level].firstLevelReferrals,
837             users[userAddress].x4Matrix[level].secondLevelReferrals,
838             users[userAddress].x4Matrix[level].blocked,
839             users[userAddress].x4Matrix[level].closedPart,
840             users[userAddress].x3Matrix[level].reinvestCount
841         );
842     }
843 
844     function getUserX3Auto(address user) external view returns (
845         uint256 id,
846         uint8 level,
847         uint256 upline_id,
848         address upline,
849         address[] memory referrals
850     ) {
851         return (
852             users[user].id,
853             users[user].x3Auto[0].level,
854             users[user].x3Auto[0].upline_id,
855             users[user].x3Auto[0].upline,
856             users[user].x3Auto[0].referrals
857         );
858     }
859 
860     function getUserX4Auto(address user) external view returns (
861         uint256 id,
862         uint8 level,
863         uint256 upline_id,
864         address upline,
865         address[] memory firstLevelReferrals,
866         address[] memory secondLevelReferrals
867     ) {
868         return (
869             users[user].id,
870             users[user].x4Auto[0].level,
871             users[user].x4Auto[0].upline_id,
872             users[user].x4Auto[0].upline,
873             users[user].x4Auto[0].firstLevelReferrals,
874             users[user].x4Auto[0].secondLevelReferrals
875         );
876     }
877 
878     function isUserExists(address user) external view returns (bool) {
879         return _isUserExists(user);
880     }
881 }