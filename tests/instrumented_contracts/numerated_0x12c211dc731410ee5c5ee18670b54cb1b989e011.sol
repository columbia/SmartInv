1 pragma solidity 0.5.14;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a, "SafeMath: subtraction overflow");
13         uint256 c = a - b;
14         return c;
15     }
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0, "SafeMath: division by zero");
28         uint256 c = a / b;
29         return c;
30     }
31     
32     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b != 0, "SafeMath: modulo by zero");
34         return a % b;
35     }
36 }
37 
38 
39 contract ERC20 {
40     function mint(address reciever, uint256 value) public returns(bool);
41 }
42 
43 contract UtahSilver {
44     
45     struct User {
46         uint id;
47         address referrer;
48         uint partnersCount;
49         mapping(uint8 => bool) activeG3Levels;
50         mapping(uint8 => bool) activeG4Levels;
51         mapping(uint8 => G3Manual) G3Matrix;
52         mapping(uint8 => G4Auto) G4Matrix;
53     }
54     
55     struct G3Manual {
56         address currentReferrer;
57         address[] referrals;
58         bool blocked;
59         uint reinvestCount;
60     }
61     
62     struct G4Auto {
63         address currentReferrer;
64         address[] firstLevelReferrals;
65         address[] secondLevelReferrals;
66         bool blocked;
67         uint reinvestCount;
68         address closedPart;
69     }
70 
71     ERC20 Token;
72     using SafeMath for uint256;
73     bool public lockStatus;
74     uint8 public constant LAST_LEVEL = 9;
75     uint public lastUserId = 2;
76     address public ownerAddress;
77     
78     mapping(uint8 => uint) public levelPrice;
79     mapping(address => User) public users;
80     mapping(uint => address) public userIds;
81     
82     
83     modifier onlyOwner() {
84         require(msg.sender == ownerAddress,"only Owner");
85         _;
86     }
87     
88     modifier isLock() {
89         require(lockStatus == false,"Contract Locked");
90         _;
91     }
92     
93     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId, uint amount, uint time);
94     event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8  matrix, uint8 level, uint amount, uint time);
95     event Upgrade(address indexed user, address indexed referrer, uint8 indexed matrix, uint8 level,uint amount, uint time);
96     event NewUserPlace(address indexed user, address indexed referrer, uint8 indexed matrix, uint8 level, uint8 place);
97     event MissedEthReceive(address indexed receiver, address indexed _from, uint8 indexed matrix, uint8 level,uint amount, uint time);
98     event RecievedEth(address indexed receiver, address indexed _from, uint8 indexed matrix, uint8 level,uint amount, uint time);
99     event SentExtraEthDividends(address indexed _from, address indexed receiver, uint8 indexed matrix, uint8 level,uint amount, uint time);
100     
101     constructor(address _owner,address _tokenAddress) public {
102         require(_tokenAddress != address(0),"Invalid Token Address");
103         
104         levelPrice[1] = 0.02 ether;
105         levelPrice[2] = 0.04 ether;
106         levelPrice[3] = 0.08 ether;
107         levelPrice[4] = 0.16 ether;
108         levelPrice[5] = 0.32 ether;
109         levelPrice[6] = 0.64 ether;
110         levelPrice[7] = 1.28 ether;
111         levelPrice[8] = 2.56 ether;
112         levelPrice[9] = 6 ether;
113         
114         
115         ownerAddress = _owner;
116         Token = ERC20(_tokenAddress);
117         
118         User memory user = User({
119             id: 1,
120             referrer: address(0),
121             partnersCount: uint(0)
122         });
123         
124         users[ownerAddress] = user;
125         userIds[1] = ownerAddress;
126        
127         for (uint8 i = 1; i <= LAST_LEVEL; i++) {
128             users[ownerAddress].activeG3Levels[i] = true;
129             users[ownerAddress].activeG4Levels[i] = true;
130         }
131         
132     }
133     
134     // external functions
135     function() external payable {
136         revert("Invalid Contract Transaction");
137     }
138     
139     function registrationExt(address referrerAddress) isLock external payable {
140         registration(msg.sender, referrerAddress);
141     }
142     
143     function buyNewLevel(uint8 matrix, uint8 level) isLock external payable {
144         require(isUserExists(msg.sender), "user is not exists. Register first.");
145         require(matrix == 1 || matrix == 2, "invalid matrix");
146         require(msg.value == levelPrice[level], "invalid price");
147         require(level > 1 && level <= LAST_LEVEL, "invalid level");
148 
149         if (matrix == 1) {
150             require(!users[msg.sender].activeG3Levels[level], "level already activated");
151             if (users[msg.sender].G3Matrix[level-1].blocked) {
152                 users[msg.sender].G3Matrix[level-1].blocked = false;
153             }
154             address freeG3Referrer = findFreeG3Referrer(msg.sender, level);
155             users[msg.sender].G3Matrix[level].currentReferrer = freeG3Referrer;
156             users[msg.sender].activeG3Levels[level] = true;
157             updateG3Referrer(msg.sender, freeG3Referrer, level);
158             emit Upgrade(msg.sender, freeG3Referrer, 1, level, msg.value, now);
159         } else {
160             require(!users[msg.sender].activeG4Levels[level], "level already activated"); 
161             if (users[msg.sender].G4Matrix[level-1].blocked) {
162                 users[msg.sender].G4Matrix[level-1].blocked = false;
163             }
164             address freeG4Referrer = findFreeG4Referrer(msg.sender, level);
165             users[msg.sender].activeG4Levels[level] = true;
166             updateG4Referrer(msg.sender, freeG4Referrer, level);
167             emit Upgrade(msg.sender, freeG4Referrer, 2, level, msg.value, now);
168         }
169     }   
170     
171     // public functions
172     function failSafe(address payable _toUser, uint _amount) onlyOwner public returns (bool) {
173         require(_toUser != address(0), "Invalid Address");
174         require(address(this).balance >= _amount, "Insufficient balance");
175         (_toUser).transfer(_amount);
176         return true;
177     }
178     
179     function contractLock(bool _lockStatus) onlyOwner public returns(bool) {
180         lockStatus = _lockStatus;
181         return true;
182     }
183     
184     function findFreeG3Referrer(address userAddress, uint8 level) public view returns(address) {
185         while (true) {
186             if (users[users[userAddress].referrer].activeG3Levels[level]) {
187                 return users[userAddress].referrer;
188             }
189             
190             userAddress = users[userAddress].referrer;
191         }
192     }
193     
194     function findFreeG4Referrer(address userAddress, uint8 level) public view returns(address) {
195         while (true) {
196             if (users[users[userAddress].referrer].activeG4Levels[level]) {
197                 return users[userAddress].referrer;
198             }
199             
200             userAddress = users[userAddress].referrer;
201         }
202     }
203         
204     function usersActiveG3Levels(address userAddress, uint8 level) public view returns(bool) {
205         return users[userAddress].activeG3Levels[level];
206     }
207 
208     function usersActiveG4Levels(address userAddress, uint8 level) public view returns(bool) {
209         return users[userAddress].activeG4Levels[level];
210     }
211 
212     function usersG3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory,uint, bool) {
213         return (users[userAddress].G3Matrix[level].currentReferrer,
214                 users[userAddress].G3Matrix[level].referrals,
215                 users[userAddress].G3Matrix[level].reinvestCount,
216                 users[userAddress].G3Matrix[level].blocked);
217     }
218 
219     function usersG4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address,uint) {
220         return (users[userAddress].G4Matrix[level].currentReferrer,
221                 users[userAddress].G4Matrix[level].firstLevelReferrals,
222                 users[userAddress].G4Matrix[level].secondLevelReferrals,
223                 users[userAddress].G4Matrix[level].blocked,
224                 users[userAddress].G4Matrix[level].closedPart,
225                 users[userAddress].G4Matrix[level].reinvestCount);
226     }
227     
228     function isUserExists(address user) public view returns (bool) {
229         return (users[user].id != 0);
230     }
231     
232     //private functions
233     function registration(address userAddress, address referrerAddress) isLock private {
234         require(msg.value == levelPrice[1].mul(2), "registration cost 0.05");
235         require(!isUserExists(userAddress), "user exists");
236         require(isUserExists(referrerAddress), "referrer not exists");
237         
238         uint32 size;
239         assembly {
240             size := extcodesize(userAddress)
241         }
242         require(size == 0, "cannot be a contract");
243         
244         User memory user = User({
245             id: lastUserId,
246             referrer: referrerAddress,
247             partnersCount: 0
248         });
249         
250         users[userAddress] = user;
251         users[userAddress].referrer = referrerAddress;
252         users[userAddress].activeG3Levels[1] = true; 
253         users[userAddress].activeG4Levels[1] = true;
254         
255         userIds[lastUserId] = userAddress;
256         lastUserId = lastUserId.add(1);
257         users[referrerAddress].partnersCount = users[referrerAddress].partnersCount.add(1);
258 
259         address freeG3Referrer = findFreeG3Referrer(userAddress, 1);
260         users[userAddress].G3Matrix[1].currentReferrer = freeG3Referrer;
261         updateG3Referrer(userAddress, freeG3Referrer, 1);
262 
263         updateG4Referrer(userAddress, findFreeG4Referrer(userAddress, 1), 1);
264         
265         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id, msg.value, now);
266     }
267     
268     function updateG3Referrer(address userAddress, address referrerAddress, uint8 level) private {
269         users[referrerAddress].G3Matrix[level].referrals.push(userAddress);
270 
271         if (users[referrerAddress].G3Matrix[level].referrals.length < 3) {
272             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].G3Matrix[level].referrals.length));
273             return sendETHDividends(referrerAddress, userAddress, 1, level);
274         }
275         
276         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
277         //close matrix
278         users[referrerAddress].G3Matrix[level].referrals = new address[](0);
279         if (!users[referrerAddress].activeG3Levels[level+1] && level != LAST_LEVEL) {
280             users[referrerAddress].G3Matrix[level].blocked = true;
281         }
282 
283         //create new one by recursion
284         if (referrerAddress != ownerAddress) {
285             //check referrer active level
286             address freeReferrerAddress = findFreeG3Referrer(referrerAddress, level);
287             if (users[referrerAddress].G3Matrix[level].currentReferrer != freeReferrerAddress) {
288                 users[referrerAddress].G3Matrix[level].currentReferrer = freeReferrerAddress;
289             }
290             users[referrerAddress].G3Matrix[level].reinvestCount = users[referrerAddress].G3Matrix[level].reinvestCount.add(1);
291             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level, levelPrice[level], now);
292             updateG3Referrer(referrerAddress, freeReferrerAddress, level);
293         } else {
294             sendETHDividends(ownerAddress, userAddress, 1, level);
295             users[ownerAddress].G3Matrix[level].reinvestCount = users[ownerAddress].G3Matrix[level].reinvestCount.add(1);
296             emit Reinvest(ownerAddress, address(0), userAddress, 1, level, levelPrice[level], now);
297         }
298     }
299 
300     function updateG4Referrer(address userAddress, address referrerAddress, uint8 level) private {
301         require(users[referrerAddress].activeG4Levels[level], "500. Referrer level is inactive");
302         
303         if (users[referrerAddress].G4Matrix[level].firstLevelReferrals.length < 2) {
304             users[referrerAddress].G4Matrix[level].firstLevelReferrals.push(userAddress);
305             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].G4Matrix[level].firstLevelReferrals.length));
306             
307             //set current level
308             users[userAddress].G4Matrix[level].currentReferrer = referrerAddress;
309 
310             if (referrerAddress == ownerAddress) {
311                 return sendETHDividends(referrerAddress, userAddress, 2, level);
312             }
313             
314             address ref = users[referrerAddress].G4Matrix[level].currentReferrer;            
315             users[ref].G4Matrix[level].secondLevelReferrals.push(userAddress); 
316             uint len = users[ref].G4Matrix[level].firstLevelReferrals.length;
317             
318             if ((len == 2) && 
319                 (users[ref].G4Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
320                 (users[ref].G4Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
321                 if (users[referrerAddress].G4Matrix[level].firstLevelReferrals.length == 1) {
322                     emit NewUserPlace(userAddress, ref, 2, level, 5);
323                 } else {
324                     emit NewUserPlace(userAddress, ref, 2, level, 6);
325                 }
326             }  else if ((len == 1 || len == 2) &&
327                     users[ref].G4Matrix[level].firstLevelReferrals[0] == referrerAddress) {
328                 if (users[referrerAddress].G4Matrix[level].firstLevelReferrals.length == 1) {
329                     emit NewUserPlace(userAddress, ref, 2, level, 3);
330                 } else {
331                     emit NewUserPlace(userAddress, ref, 2, level, 4);
332                 }
333             } else if (len == 2 && users[ref].G4Matrix[level].firstLevelReferrals[1] == referrerAddress) {
334                 if (users[referrerAddress].G4Matrix[level].firstLevelReferrals.length == 1) {
335                     emit NewUserPlace(userAddress, ref, 2, level, 5);
336                 } else {
337                     emit NewUserPlace(userAddress, ref, 2, level, 6);
338                 }
339             }
340             return updateG4ReferrerSecondLevel(userAddress, ref, level);
341         }
342         
343         users[referrerAddress].G4Matrix[level].secondLevelReferrals.push(userAddress);
344 
345         if (users[referrerAddress].G4Matrix[level].closedPart != address(0)) {
346             if ((users[referrerAddress].G4Matrix[level].firstLevelReferrals[0] == 
347                 users[referrerAddress].G4Matrix[level].firstLevelReferrals[1]) &&
348                 (users[referrerAddress].G4Matrix[level].firstLevelReferrals[0] ==
349                 users[referrerAddress].G4Matrix[level].closedPart)) {
350                 updateG4(userAddress, referrerAddress, level, true);
351                 return updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
352             } else if (users[referrerAddress].G4Matrix[level].firstLevelReferrals[0] == 
353                 users[referrerAddress].G4Matrix[level].closedPart) {
354                 updateG4(userAddress, referrerAddress, level, true);
355                 return updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
356             } else {
357                 updateG4(userAddress, referrerAddress, level, false);
358                 return updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
359             }
360         }
361 
362         if (users[referrerAddress].G4Matrix[level].firstLevelReferrals[1] == userAddress) {
363             updateG4(userAddress, referrerAddress, level, false);
364             return updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
365         } else if (users[referrerAddress].G4Matrix[level].firstLevelReferrals[0] == userAddress) {
366             updateG4(userAddress, referrerAddress, level, true);
367             return updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
368         }
369         
370         if (users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[0]].G4Matrix[level].firstLevelReferrals.length <= 
371             users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[1]].G4Matrix[level].firstLevelReferrals.length) {
372             updateG4(userAddress, referrerAddress, level, false);
373         } else {
374             updateG4(userAddress, referrerAddress, level, true);
375         }
376         
377         updateG4ReferrerSecondLevel(userAddress, referrerAddress, level);
378     }
379 
380     function updateG4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
381         if (!x2) {
382             users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[0]].G4Matrix[level].firstLevelReferrals.push(userAddress);
383             emit NewUserPlace(userAddress, users[referrerAddress].G4Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[0]].G4Matrix[level].firstLevelReferrals.length));
384             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[0]].G4Matrix[level].firstLevelReferrals.length));
385             //set current level
386             users[userAddress].G4Matrix[level].currentReferrer = users[referrerAddress].G4Matrix[level].firstLevelReferrals[0];
387         } else {
388             users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[1]].G4Matrix[level].firstLevelReferrals.push(userAddress);
389             emit NewUserPlace(userAddress, users[referrerAddress].G4Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[1]].G4Matrix[level].firstLevelReferrals.length));
390             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].G4Matrix[level].firstLevelReferrals[1]].G4Matrix[level].firstLevelReferrals.length));
391             //set current level
392             users[userAddress].G4Matrix[level].currentReferrer = users[referrerAddress].G4Matrix[level].firstLevelReferrals[1];
393         }
394     }
395     
396     function updateG4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
397         if (users[referrerAddress].G4Matrix[level].secondLevelReferrals.length < 4) {
398             return sendETHDividends(referrerAddress, userAddress, 2, level);
399         }
400         
401         address[] memory G4 = users[users[referrerAddress].G4Matrix[level].currentReferrer].G4Matrix[level].firstLevelReferrals;
402         
403         if (G4.length == 2) {
404             if (G4[0] == referrerAddress ||
405                 G4[1] == referrerAddress) {
406                 users[users[referrerAddress].G4Matrix[level].currentReferrer].G4Matrix[level].closedPart = referrerAddress;
407             } else if (G4.length == 1) {
408                 if (G4[0] == referrerAddress) {
409                     users[users[referrerAddress].G4Matrix[level].currentReferrer].G4Matrix[level].closedPart = referrerAddress;
410                 }
411             }
412         }
413         users[referrerAddress].G4Matrix[level].firstLevelReferrals = new address[](0);
414         users[referrerAddress].G4Matrix[level].secondLevelReferrals = new address[](0);
415         users[referrerAddress].G4Matrix[level].closedPart = address(0);
416 
417         if (!users[referrerAddress].activeG4Levels[level+1] && level != LAST_LEVEL) {
418             users[referrerAddress].G4Matrix[level].blocked = true;
419         }
420 
421         users[referrerAddress].G4Matrix[level].reinvestCount = users[referrerAddress].G4Matrix[level].reinvestCount.add(1);
422         
423         if (referrerAddress != ownerAddress) {
424             address freeReferrerAddress = findFreeG4Referrer(referrerAddress, level);
425 
426             emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level, levelPrice[level], now);
427             updateG4Referrer(referrerAddress, freeReferrerAddress, level);
428         } else {
429             emit Reinvest(ownerAddress, address(0), userAddress, 2, level, levelPrice[level], now);
430             sendETHDividends(ownerAddress, userAddress, 2, level);
431         }
432     }
433     
434     function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
435         address receiver = userAddress;
436         bool isExtraDividends;
437         if (matrix == 1) {
438             while (true) {
439                 if (users[receiver].G3Matrix[level].blocked) {
440                     emit MissedEthReceive(receiver, _from, 1, level, levelPrice[level], now);
441                     isExtraDividends = true;
442                     receiver = users[receiver].G3Matrix[level].currentReferrer;
443                 } else {
444                     return (receiver, isExtraDividends);
445                 }
446             }
447         } else {
448             while (true) {
449                 if (users[receiver].G4Matrix[level].blocked) {
450                     emit MissedEthReceive(receiver, _from, 2, level, levelPrice[level], now);
451                     isExtraDividends = true;
452                     receiver = users[receiver].G4Matrix[level].currentReferrer;
453                 } else {
454                     return (receiver, isExtraDividends);
455                 }
456             }
457         }
458     }
459 
460     function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
461         (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);
462         uint256 tobeminted;
463         
464         tobeminted = 25 ether;
465         
466         require( (address(uint160(receiver)).send(levelPrice[level])) && 
467             Token.mint(msg.sender, tobeminted),"Invalid Transaction");
468         
469         if (isExtraDividends) {
470             emit SentExtraEthDividends(_from, receiver, matrix, level, levelPrice[level], now);
471         }
472         else {
473              emit RecievedEth(receiver, _from, matrix, level, levelPrice[level], now);
474         }
475     }
476     
477     
478 }