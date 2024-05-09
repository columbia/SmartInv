1 pragma solidity >=0.4.23 <0.7.0;
2 
3 contract EtherGlobeToken {
4 
5     address public owner;
6     string  public name = "Ether Globe Decentralised Token";
7     string  public symbol = "EGDT";
8     string  public standard = "EGDT Token v1.0";
9     uint256 public totalSupply;
10     uint256  public decimals = 18;
11     uint256 public  decimalFactor = 10 ** uint256(decimals);
12      uint256 public  TOTAL_COIN_MINT = 2500000000 * decimalFactor;
13      
14 
15     event Transfer(
16         address indexed _from,
17         address indexed _to,
18         uint256 _value
19     );
20 
21     event Approval(
22         address indexed _owner,
23         address indexed _spender,
24         uint256 _value
25     );
26 
27     mapping(address => uint256) public balanceOf;
28 
29     constructor(uint256 _initialSupply) public {
30         owner=msg.sender;
31         balanceOf[msg.sender] = _initialSupply;
32         totalSupply = _initialSupply;
33     }
34   function mint(address _to, uint256 _value) public returns (bool success) {
35        require(msg.sender==owner,"Only Owner Can Mint");
36         totalSupply +=_value;
37         if(totalSupply<=TOTAL_COIN_MINT){
38              balanceOf[msg.sender] += _value;
39         require(balanceOf[msg.sender] >= _value);
40 
41         balanceOf[msg.sender] -= _value;
42         balanceOf[_to] += _value;
43 
44         emit Transfer(msg.sender, _to, _value); 
45 
46         }
47        
48 
49         return true;
50     }
51   
52 
53     function transfer( address _to, uint256 _value) public returns (bool success) {
54          
55         require(_value <= balanceOf[msg.sender]);
56       
57 
58         balanceOf[msg.sender] -= _value;
59         balanceOf[_to] += _value;
60 
61       
62 
63         emit Transfer(msg.sender, _to, _value);
64 
65         return true;
66     }
67 }
68 
69 contract EtherGlobe {
70     
71     EtherGlobeToken public token;
72     
73     struct UserAccount {
74         uint id;
75         address referrer;
76         uint partnersCount;
77         uint totalTokens;
78          
79         mapping(uint256 => bool) activeX3Levels;
80         mapping(uint256 => bool) activeX6Levels;
81         
82         mapping(uint256 => X3) x3Matrix;
83         mapping(uint256 => X4) x6Matrix;
84     }
85     
86     struct X3 {
87         address currentReferrer;
88         address[] referrals;
89         bool blocked;
90         uint reinvestCount;
91     }
92     
93     struct X4{
94         address currentReferrer;
95         address[] firstLevelReferrals;
96         address[] secondLevelReferrals;
97         bool blocked;
98         uint reinvestCount;
99         address closedPart;
100     }
101 
102     uint256 public constant LAST_LEVEL = 12;
103     uint256  public decimals = 18;
104     uint256 public  decimalFactor = 10 ** uint256(decimals);
105     uint256 tokenReward = 100 * decimalFactor;
106     uint256 ownerReward = 625000000 * decimalFactor;
107     
108     mapping(address => UserAccount) public users;
109     mapping(uint => address) public idToAddress;
110     mapping(uint => address) public userIds;
111 
112     uint public lastUserId = 2;
113     address public owner;
114     mapping(uint256 => uint) public levelPrice;
115 
116     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
117     event Recycle(address indexed user, address indexed currentReferrer, address indexed caller, uint256 matrix, uint256 level);
118     event UpgradeLevel(address indexed user, address indexed referrer, uint256 matrix, uint256 level);
119     event NewUserPlace(address indexed user, address indexed referrer, uint256 matrix, uint256 level, uint256 place);
120     event UserActiveLevels(address indexed user, uint8 indexed matrix, uint256 indexed level);
121     event IncomeReceived(address indexed user,address indexed from,uint256 value,uint256 matrix, uint256 level);
122     event TokenMinted(address indexed receiver, uint indexed totalTokens, uint256 value, uint256 supply);
123     
124     constructor(address ownerAddress) public {
125         levelPrice[1] = 0.05 ether;
126         for (uint256 i = 2; i <= LAST_LEVEL; i++) {
127             levelPrice[i] = levelPrice[i-1] * 2;
128         }
129            owner = ownerAddress;
130            token = new EtherGlobeToken(0);
131       UserAccount memory user;
132           user= UserAccount({
133             id: 1,
134             referrer: address(0),
135             partnersCount: uint(0),
136             totalTokens: uint(0)
137         });   
138         users[ownerAddress] = user;
139         idToAddress[1] = ownerAddress;
140         for (uint256 j = 1; j <= LAST_LEVEL; j++) {
141             users[ownerAddress].activeX3Levels[j] = true;
142             emit UserActiveLevels(owner, 1, j);
143             users[ownerAddress].activeX6Levels[j] = true;
144             emit UserActiveLevels(owner, 2, j);
145         }
146         userIds[1] = ownerAddress;
147         
148         token.mint(owner, ownerReward);
149         
150     }
151     
152     function regUserExt(address referrerAddress) external payable {
153         registration(msg.sender, referrerAddress);
154         token.mint(msg.sender, tokenReward);
155         users[msg.sender].totalTokens += tokenReward;
156         emit TokenMinted(msg.sender, ((users[msg.sender].totalTokens) / decimalFactor), tokenReward, (token.totalSupply() / decimalFactor));
157     }
158     
159     function buyNewLevel(uint256 matrix, uint256 level) external payable {
160         uint256 buyNewLevelReward = (50 * (2 ** (level - 1))) * decimalFactor;
161         require(msg.value == levelPrice[level] ,"invalid price");
162         require(isUserExists(msg.sender), "user is not exists. Register first.");
163         require(matrix == 1 || matrix == 2, "invalid matrix");
164      
165        
166         require(level > 1 && level <= LAST_LEVEL, "invalid level");
167        
168         if (matrix == 1) {
169             require(!users[msg.sender].activeX3Levels[level], "level already activated");
170 
171             if (users[msg.sender].x3Matrix[level-1].blocked) {
172                 users[msg.sender].x3Matrix[level-1].blocked = false;
173             }
174     
175             address freeX3Referrer = nextFreeX3Referrer(msg.sender, level);
176             users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
177             users[msg.sender].activeX3Levels[level] = true;
178             emit UserActiveLevels(msg.sender, 1, level);
179             newX3Referrer(msg.sender, freeX3Referrer, level);
180             
181             emit UpgradeLevel(msg.sender, freeX3Referrer, 1, level);
182 
183         } else {
184             require(!users[msg.sender].activeX6Levels[level], "level already activated"); 
185 
186             if (users[msg.sender].x6Matrix[level-1].blocked) {
187                 users[msg.sender].x6Matrix[level-1].blocked = false;
188             }
189 
190             address freeX6Referrer = nextFreeX4Referrer(msg.sender, level);
191             
192             users[msg.sender].activeX6Levels[level] = true;
193             emit UserActiveLevels(msg.sender, 2, level);
194             newX4Referrer(msg.sender, freeX6Referrer, level);
195             
196             emit UpgradeLevel(msg.sender, freeX6Referrer, 2, level);
197         }
198         
199         token.mint(msg.sender, buyNewLevelReward);
200         users[msg.sender].totalTokens += buyNewLevelReward;
201         emit TokenMinted(msg.sender, ((users[msg.sender].totalTokens) / decimalFactor), buyNewLevelReward, (token.totalSupply() / decimalFactor));
202     }
203     
204     function registration(address userAddress, address referrerAddress) private {
205         require(msg.value == (levelPrice[1] * 2), "Invalid Cost");
206         require(!isUserExists(userAddress), "user exists");
207         require(isUserExists(referrerAddress), "referrer not exists");
208     
209         uint32 size;
210         assembly {
211             size := extcodesize(userAddress)
212         }
213         require(size == 0, "cc");
214         
215         UserAccount memory user = UserAccount({
216             id: lastUserId,
217             referrer: referrerAddress,
218             partnersCount: uint(0),
219             totalTokens: uint(0)
220         });
221         
222         users[userAddress] = user;
223         idToAddress[lastUserId] = userAddress;
224         
225         users[userAddress].referrer = referrerAddress;
226         
227         users[userAddress].activeX3Levels[1] = true;
228         emit UserActiveLevels(userAddress, 1, 1);
229         users[userAddress].activeX6Levels[1] = true;
230         emit UserActiveLevels(userAddress, 2, 1);
231         
232         
233         userIds[lastUserId] = userAddress;
234         lastUserId++;
235         
236         users[referrerAddress].partnersCount++;
237 
238         address freeX3Referrer = nextFreeX3Referrer(userAddress, 1);
239         users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
240         newX3Referrer(userAddress, freeX3Referrer, 1);
241 
242         newX4Referrer(userAddress, nextFreeX4Referrer(userAddress, 1), 1);
243         
244         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
245     }
246     
247     function newX3Referrer(address userAddress, address referrerAddress, uint256 level) private {
248         users[referrerAddress].x3Matrix[level].referrals.push(userAddress);
249 
250         if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
251             emit NewUserPlace(userAddress, referrerAddress, 1, level, uint256(users[referrerAddress].x3Matrix[level].referrals.length));
252             return sendRewards(referrerAddress, userAddress, 1, level);
253         }
254         
255         emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
256         
257         users[referrerAddress].x3Matrix[level].referrals = new address[](0);
258         if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
259             users[referrerAddress].x3Matrix[level].blocked = true;
260         }
261 
262         if (referrerAddress != owner) {
263 
264             address freeReferrerAddress = nextFreeX3Referrer(referrerAddress, level);
265             if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
266                 users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
267             }
268             
269             users[referrerAddress].x3Matrix[level].reinvestCount++;
270             emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 1, level);
271             newX3Referrer(referrerAddress, freeReferrerAddress, level);
272         } else {
273             sendRewards(owner, userAddress, 1, level);
274             users[owner].x3Matrix[level].reinvestCount++;
275             emit Recycle(owner, address(0), userAddress, 1, level);
276         }
277     }
278 
279     function newX4Referrer(address userAddress, address referrerAddress, uint256 level) private {
280         require(users[referrerAddress].activeX6Levels[level], "500");
281         
282         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
283             users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
284             emit NewUserPlace(userAddress, referrerAddress, 2, level, uint256(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
285             
286             users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;
287 
288             if (referrerAddress == owner) {
289                 return sendRewards(referrerAddress, userAddress, 2, level);
290             }
291             
292             address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
293             users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
294             
295             uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
296             
297             if ((len == 2) && 
298                 (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
299                 (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
300                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
301                     emit NewUserPlace(userAddress, ref, 2, level, 5);
302                 } else {
303                     emit NewUserPlace(userAddress, ref, 2, level, 6);
304                 }
305             }  else if ((len == 1 || len == 2) &&
306                     users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
307                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
308                     emit NewUserPlace(userAddress, ref, 2, level, 3);
309                 } else {
310                     emit NewUserPlace(userAddress, ref, 2, level, 4);
311                 }
312             } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
313                 if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
314                     emit NewUserPlace(userAddress, ref, 2, level, 5);
315                 } else {
316                     emit NewUserPlace(userAddress, ref, 2, level, 6);
317                 }
318             }
319 
320             return newX4ReferrerSecondLevel(userAddress, ref, level);
321         }
322         
323         users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);
324 
325         if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
326             if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
327                 users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
328                 (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
329                 users[referrerAddress].x6Matrix[level].closedPart)) {
330 
331                 newX4(userAddress, referrerAddress, level, true);
332                 return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
333             } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
334                 users[referrerAddress].x6Matrix[level].closedPart) {
335             newX4(userAddress, referrerAddress, level, true);
336                 return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
337             } else {
338                 newX4(userAddress, referrerAddress, level, false);
339                 return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
340             }
341         }
342 
343         if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
344             newX4(userAddress, referrerAddress, level, false);
345             return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
346         } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
347             newX4(userAddress, referrerAddress, level, true);
348             return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
349         }
350         
351         if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
352             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
353             newX4(userAddress, referrerAddress, level, false);
354         } else {
355             newX4(userAddress, referrerAddress, level, true);
356         }
357         
358         newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
359     }
360 
361     function newX4(address userAddress, address referrerAddress, uint256 level, bool x2) private {
362         if (!x2) {
363             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
364             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
365             emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
366             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
367         } else {
368             users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
369             emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
370             emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
371             users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
372         }
373     }
374     
375     function newX4ReferrerSecondLevel(address userAddress, address referrerAddress, uint256 level) private {
376         if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
377             return sendRewards(referrerAddress, userAddress, 2, level);
378         }
379         
380         address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
381         
382         if (x6.length == 2) {
383             if (x6[0] == referrerAddress ||
384                 x6[1] == referrerAddress) {
385                 users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
386             } else if (x6.length == 1) {
387                 if (x6[0] == referrerAddress) {
388                     users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
389                 }
390             }
391         }
392         
393         users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
394         users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
395         users[referrerAddress].x6Matrix[level].closedPart = address(0);
396 
397         if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
398             users[referrerAddress].x6Matrix[level].blocked = true;
399         }
400 
401         users[referrerAddress].x6Matrix[level].reinvestCount++;
402         
403         if (referrerAddress != owner) {
404             address freeReferrerAddress = nextFreeX4Referrer(referrerAddress, level);
405 
406             emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 2, level);
407             newX4Referrer(referrerAddress, freeReferrerAddress, level);
408         } else {
409             emit Recycle(owner, address(0), userAddress, 2, level);
410             sendRewards(owner, userAddress, 2, level);
411         }
412     }
413     
414     function nextFreeX3Referrer(address userAddress, uint256 level) public view returns(address) {
415         while (true) {
416             if (users[users[userAddress].referrer].activeX3Levels[level]) {
417                 return users[userAddress].referrer;
418             }
419             
420             userAddress = users[userAddress].referrer;
421         }
422     }
423     
424     
425     function nextFreeX4Referrer(address userAddress, uint256 level) public view returns(address) {
426         while (true) {
427             if (users[users[userAddress].referrer].activeX6Levels[level]) {
428                 return users[userAddress].referrer;
429             }
430             
431             userAddress = users[userAddress].referrer;
432         }
433     }
434 
435     function usersX3Matrix(address userAddress, uint256 level) public view returns(address, address[] memory, bool, bool) {
436         return (users[userAddress].x3Matrix[level].currentReferrer,
437                 users[userAddress].x3Matrix[level].referrals,
438                 users[userAddress].x3Matrix[level].blocked,
439                 users[userAddress].activeX3Levels[level]);
440     }
441 
442     function usersX4Matrix(address userAddress, uint256 level) public view returns(address, address[] memory, address[] memory, bool, bool, address) {
443         return (users[userAddress].x6Matrix[level].currentReferrer,
444                 users[userAddress].x6Matrix[level].firstLevelReferrals,
445                 users[userAddress].x6Matrix[level].secondLevelReferrals,
446                 users[userAddress].x6Matrix[level].blocked,
447                 users[userAddress].activeX6Levels[level],
448                 users[userAddress].x6Matrix[level].closedPart);
449     }
450     
451     function isUserExists(address user) public view returns (bool) {
452         return (users[user].id != 0);
453     }
454 
455     function getRewardReceiver(address userAddress, address _from, uint256 matrix, uint256 level) private returns(address, bool) {
456         address receiver = userAddress;
457         bool isExtraDividends;
458         if (matrix == 1) {
459             while (true) {
460                 if (users[receiver].x3Matrix[level].blocked) {
461                     isExtraDividends = true;
462                     receiver = users[receiver].x3Matrix[level].currentReferrer;
463                 } else {
464                     return (receiver, isExtraDividends);
465                 }
466             }
467         } else {
468             while (true) {
469                 if (users[receiver].x6Matrix[level].blocked) {
470                     isExtraDividends = true;
471                     receiver = users[receiver].x6Matrix[level].currentReferrer;
472                 } else {
473                     return (receiver, isExtraDividends);
474                 }
475             }
476         }
477     }
478 
479     function sendRewards(address userAddress, address _from, uint256 matrix, uint256 level) private {
480         (address receiver, bool isExtraDividends) = getRewardReceiver(userAddress, _from, matrix, level);
481         
482        
483         if (!address(uint160(receiver)).send(levelPrice[level])) {
484             emit  IncomeReceived(receiver,_from,address(this).balance, matrix,level);
485             return address(uint160(receiver)).transfer(address(this).balance);
486         }
487          emit  IncomeReceived(receiver,_from,levelPrice[level],matrix,level);
488     }
489     
490     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
491         assembly {
492             addr := mload(add(bys, 20))
493         }
494     }
495 }