1 pragma solidity >=0.4.23 <0.7.0;
2 
3 contract X365 {
4     
5     struct UserAccount {
6         uint id;
7         address referrer;
8         uint partnersCount;
9          
10         mapping(uint8 => bool) activeZ3Levels;
11         mapping(uint8 => bool) activeZ6Levels;
12         
13         mapping(uint8 => Z3) Z3Matrix;
14         mapping(uint8 => Z4) Z6Matrix;
15     }
16     
17     struct Z3 {
18         address currentReferrer;
19         address[] referrals;
20         bool blocked;
21         uint reinvestCount;
22     }
23     
24     struct Z4{
25         address currentReferrer;
26         address[] firstLevelReferrals;
27         address[] secondLevelReferrals;
28         bool blocked;
29         uint reinvestCount;
30         address closedPart;
31     }
32 
33     uint8 public constant LAST_LEVEL = 12;
34     
35     mapping(address => UserAccount) public users;
36     mapping(uint => address) public idToAddress;
37     mapping(uint => address) public userIds;
38 
39     uint public lastUserId = 2;
40     address public  owner;
41     address public partner;
42     mapping(uint8 => uint) public levelPrice;
43 
44     event UserRegistration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
45     event Recycle(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
46     event UpgradeLevel(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
47     event NewReferral(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
48     event MissedRewardsReceived(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
49     event RewardsSent(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
50     event IncomeTransferred(address indexed user,address indexed from,uint256 value,uint8 matrix, uint8 level);
51     
52     constructor(address ownerAddress, address partnerAddress) public {
53         levelPrice[1] = 0.025 ether;
54         for (uint8 i = 2; i <= LAST_LEVEL; i++) {
55             levelPrice[i] = levelPrice[i-1] * 2;
56         }
57            owner = ownerAddress;
58            partner = partnerAddress;
59       UserAccount memory user ;
60           user= UserAccount({
61             id: 1,
62             referrer: address(0),
63             partnersCount: uint(0)
64         });   
65         users[ownerAddress] = user;
66         idToAddress[1] = ownerAddress;
67         for (uint8 j = 1; j <= LAST_LEVEL; j++) {
68             users[ownerAddress].activeZ3Levels[j] = true;
69             users[ownerAddress].activeZ6Levels[j] = true;
70         }
71         userIds[1] = ownerAddress;
72         
73     }
74   
75     
76     function regUserExternal(address referrerAddress) external payable {
77         userRegistration(msg.sender, referrerAddress);
78     }
79     
80     function buyLevel(uint8 matrix, uint8 level) external payable {
81         require(msg.value == levelPrice[level] ,"invalid price");
82         require(isUserExists(msg.sender), "user is not exists. Register first.");
83         require(matrix == 1 || matrix == 2, "invalid matrix");
84      
85        
86         require(level > 1 && level <= LAST_LEVEL, "invalid level");
87        
88         if (matrix == 1) {
89             require(!users[msg.sender].activeZ3Levels[level], "level already activated");
90 
91             if (users[msg.sender].Z3Matrix[level-1].blocked) {
92                 users[msg.sender].Z3Matrix[level-1].blocked = false;
93             }
94     
95             address freeZ3Referrer = nextFreeZ3Referrer(msg.sender, level);
96             users[msg.sender].Z3Matrix[level].currentReferrer = freeZ3Referrer;
97             users[msg.sender].activeZ3Levels[level] = true;
98             newZ3Referrer(msg.sender, freeZ3Referrer, level);
99             
100             emit UpgradeLevel(msg.sender, freeZ3Referrer, 1, level);
101 
102         } else {
103             require(!users[msg.sender].activeZ6Levels[level], "level already activated"); 
104 
105             if (users[msg.sender].Z6Matrix[level-1].blocked) {
106                 users[msg.sender].Z6Matrix[level-1].blocked = false;
107             }
108 
109             address freeZ6Referrer = nextFreeZ4Referrer(msg.sender, level);
110             
111             users[msg.sender].activeZ6Levels[level] = true;
112             newZ4Referrer(msg.sender, freeZ6Referrer, level);
113             
114             emit UpgradeLevel(msg.sender, freeZ6Referrer, 2, level);
115         }
116     }    
117     
118     function userRegistration(address userAddress, address referrerAddress) private {
119         require(msg.value == 0.05 ether, "Invalid Cost");
120         require(!isUserExists(userAddress), "user exists");
121         require(isUserExists(referrerAddress), "referrer not exists");
122     
123         uint32 size;
124         assembly {
125             size := extcodesize(userAddress)
126         }
127         require(size == 0, "cc");
128         
129         UserAccount memory user = UserAccount({
130             id: lastUserId,
131             referrer: referrerAddress,
132             partnersCount: 0
133         });
134         
135         users[userAddress] = user;
136         idToAddress[lastUserId] = userAddress;
137         
138         users[userAddress].referrer = referrerAddress;
139         
140         users[userAddress].activeZ3Levels[1] = true; 
141         users[userAddress].activeZ6Levels[1] = true;
142         
143         
144         userIds[lastUserId] = userAddress;
145         lastUserId++;
146         
147         users[referrerAddress].partnersCount++;
148 
149         address freeZ3Referrer = nextFreeZ3Referrer(userAddress, 1);
150         users[userAddress].Z3Matrix[1].currentReferrer = freeZ3Referrer;
151         newZ3Referrer(userAddress, freeZ3Referrer, 1);
152 
153         newZ4Referrer(userAddress, nextFreeZ4Referrer(userAddress, 1), 1);
154         
155         emit UserRegistration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
156     }
157     
158     function newZ3Referrer(address userAddress, address referrerAddress, uint8 level) private {
159         users[referrerAddress].Z3Matrix[level].referrals.push(userAddress);
160 
161         if (users[referrerAddress].Z3Matrix[level].referrals.length < 3) {
162             emit NewReferral(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].Z3Matrix[level].referrals.length));
163             return sendRewards(referrerAddress, userAddress, 1, level);
164         }
165         
166         emit NewReferral(userAddress, referrerAddress, 1, level, 3);
167         //close matrix
168         users[referrerAddress].Z3Matrix[level].referrals = new address[](0);
169         if (!users[referrerAddress].activeZ3Levels[level+1] && level != LAST_LEVEL) {
170             users[referrerAddress].Z3Matrix[level].blocked = true;
171         }
172 
173         //create new one by recursion
174         if (referrerAddress != owner) {
175             //check referrer active level
176             address freeReferrerAddress = nextFreeZ3Referrer(referrerAddress, level);
177             if (users[referrerAddress].Z3Matrix[level].currentReferrer != freeReferrerAddress) {
178                 users[referrerAddress].Z3Matrix[level].currentReferrer = freeReferrerAddress;
179             }
180             
181             users[referrerAddress].Z3Matrix[level].reinvestCount++;
182             emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 1, level);
183             newZ3Referrer(referrerAddress, freeReferrerAddress, level);
184         } else {
185             sendRewards(owner, userAddress, 1, level);
186             users[owner].Z3Matrix[level].reinvestCount++;
187             emit Recycle(owner, address(0), userAddress, 1, level);
188         }
189     }
190 
191     function newZ4Referrer(address userAddress, address referrerAddress, uint8 level) private {
192         require(users[referrerAddress].activeZ6Levels[level], "500");
193         
194         if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length < 2) {
195             users[referrerAddress].Z6Matrix[level].firstLevelReferrals.push(userAddress);
196             emit NewReferral(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length));
197             
198             //set current level
199             users[userAddress].Z6Matrix[level].currentReferrer = referrerAddress;
200 
201             if (referrerAddress == owner) {
202                 return sendRewards(referrerAddress, userAddress, 2, level);
203             }
204             
205             address ref = users[referrerAddress].Z6Matrix[level].currentReferrer;            
206             users[ref].Z6Matrix[level].secondLevelReferrals.push(userAddress); 
207             
208             uint len = users[ref].Z6Matrix[level].firstLevelReferrals.length;
209             
210             if ((len == 2) && 
211                 (users[ref].Z6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
212                 (users[ref].Z6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
213                 if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
214                     emit NewReferral(userAddress, ref, 2, level, 5);
215                 } else {
216                     emit NewReferral(userAddress, ref, 2, level, 6);
217                 }
218             }  else if ((len == 1 || len == 2) &&
219                     users[ref].Z6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
220                 if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
221                     emit NewReferral(userAddress, ref, 2, level, 3);
222                 } else {
223                     emit NewReferral(userAddress, ref, 2, level, 4);
224                 }
225             } else if (len == 2 && users[ref].Z6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
226                 if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
227                     emit NewReferral(userAddress, ref, 2, level, 5);
228                 } else {
229                     emit NewReferral(userAddress, ref, 2, level, 6);
230                 }
231             }
232 
233             return newZ4ReferrerSecondLevel(userAddress, ref, level);
234         }
235         
236         users[referrerAddress].Z6Matrix[level].secondLevelReferrals.push(userAddress);
237 
238         if (users[referrerAddress].Z6Matrix[level].closedPart != address(0)) {
239             if ((users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == 
240                 users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]) &&
241                 (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] ==
242                 users[referrerAddress].Z6Matrix[level].closedPart)) {
243 
244                 newZ4(userAddress, referrerAddress, level, true);
245                 return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
246             } else if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == 
247                 users[referrerAddress].Z6Matrix[level].closedPart) {
248             newZ4(userAddress, referrerAddress, level, true);
249                 return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
250             } else {
251                 newZ4(userAddress, referrerAddress, level, false);
252                 return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
253             }
254         }
255 
256         if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1] == userAddress) {
257             newZ4(userAddress, referrerAddress, level, false);
258             return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
259         } else if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == userAddress) {
260             newZ4(userAddress, referrerAddress, level, true);
261             return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
262         }
263         
264         if (users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length <= 
265             users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length) {
266             newZ4(userAddress, referrerAddress, level, false);
267         } else {
268             newZ4(userAddress, referrerAddress, level, true);
269         }
270         
271         newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
272     }
273 
274     function newZ4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
275         if (!x2) {
276             users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.push(userAddress);
277             emit NewReferral(userAddress, users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length));
278             emit NewReferral(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length));
279             //set current level
280             users[userAddress].Z6Matrix[level].currentReferrer = users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0];
281         } else {
282             users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.push(userAddress);
283             emit NewReferral(userAddress, users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length));
284             emit NewReferral(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length));
285             //set current level
286             users[userAddress].Z6Matrix[level].currentReferrer = users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1];
287         }
288     }
289     
290     function newZ4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
291         if (users[referrerAddress].Z6Matrix[level].secondLevelReferrals.length < 4) {
292             return sendRewards(referrerAddress, userAddress, 2, level);
293         }
294         
295         address[] memory Z6 = users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].firstLevelReferrals;
296         
297         if (Z6.length == 2) {
298             if (Z6[0] == referrerAddress ||
299                 Z6[1] == referrerAddress) {
300                 users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].closedPart = referrerAddress;
301             } else if (Z6.length == 1) {
302                 if (Z6[0] == referrerAddress) {
303                     users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].closedPart = referrerAddress;
304                 }
305             }
306         }
307         
308         users[referrerAddress].Z6Matrix[level].firstLevelReferrals = new address[](0);
309         users[referrerAddress].Z6Matrix[level].secondLevelReferrals = new address[](0);
310         users[referrerAddress].Z6Matrix[level].closedPart = address(0);
311 
312         if (!users[referrerAddress].activeZ6Levels[level+1] && level != LAST_LEVEL) {
313             users[referrerAddress].Z6Matrix[level].blocked = true;
314         }
315 
316         users[referrerAddress].Z6Matrix[level].reinvestCount++;
317         
318         if (referrerAddress != owner) {
319             address freeReferrerAddress = nextFreeZ4Referrer(referrerAddress, level);
320 
321             emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 2, level);
322             newZ4Referrer(referrerAddress, freeReferrerAddress, level);
323         } else {
324             emit Recycle(owner, address(0), userAddress, 2, level);
325             sendRewards(owner, userAddress, 2, level);
326         }
327     }
328     
329     function nextFreeZ3Referrer(address userAddress, uint8 level) public view returns(address) {
330         while (true) {
331             if (users[users[userAddress].referrer].activeZ3Levels[level]) {
332                 return users[userAddress].referrer;
333             }
334             
335             userAddress = users[userAddress].referrer;
336         }
337     }
338     
339     
340     function nextFreeZ4Referrer(address userAddress, uint8 level) public view returns(address) {
341         while (true) {
342             if (users[users[userAddress].referrer].activeZ6Levels[level]) {
343                 return users[userAddress].referrer;
344             }
345             
346             userAddress = users[userAddress].referrer;
347         }
348     }
349 
350     function usersZ3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, bool) {
351         return (users[userAddress].Z3Matrix[level].currentReferrer,
352                 users[userAddress].Z3Matrix[level].referrals,
353                 users[userAddress].Z3Matrix[level].blocked,
354                 users[userAddress].activeZ3Levels[level]);
355     }
356 
357     function usersZ4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, bool, address) {
358         return (users[userAddress].Z6Matrix[level].currentReferrer,
359                 users[userAddress].Z6Matrix[level].firstLevelReferrals,
360                 users[userAddress].Z6Matrix[level].secondLevelReferrals,
361                 users[userAddress].Z6Matrix[level].blocked,
362                 users[userAddress].activeZ6Levels[level],
363                 users[userAddress].Z6Matrix[level].closedPart);
364     }
365     
366     function isUserExists(address user) public view returns (bool) {
367         return (users[user].id != 0);
368     }
369 
370     function getRewardRecipient(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
371         address receiver = userAddress;
372         bool isExtraDividends;
373         if (matrix == 1) {
374             while (true) {
375                 if (users[receiver].Z3Matrix[level].blocked) {
376                     emit MissedRewardsReceived(receiver, _from, 1, level);
377                     isExtraDividends = true;
378                     receiver = users[receiver].Z3Matrix[level].currentReferrer;
379                 } else {
380                     return (receiver, isExtraDividends);
381                 }
382             }
383         } else {
384             while (true) {
385                 if (users[receiver].Z6Matrix[level].blocked) {
386                     emit MissedRewardsReceived(receiver, _from, 2, level);
387                     isExtraDividends = true;
388                     receiver = users[receiver].Z6Matrix[level].currentReferrer;
389                 } else {
390                     return (receiver, isExtraDividends);
391                 }
392             }
393         }
394     }
395 
396     function sendRewards(address userAddress, address _from, uint8 matrix, uint8 level) private {
397         (address receiver, bool isExtraDividends) = getRewardRecipient(userAddress, _from, matrix, level);
398         
399        if (receiver == owner) {
400            if (!address(uint160(partner)).send(levelPrice[level] * 10/100)) {
401             address(uint160(partner)).transfer(address(this).balance*10/100);    
402         }
403            if (!address(uint160(receiver)).send(levelPrice[level] * 90/100)) {
404              emit  IncomeTransferred(receiver,_from,address(this).balance * 90/100, matrix,level);
405             address(uint160(receiver)).transfer(address(this).balance*90/100);
406             return;              
407         }
408         
409          emit  IncomeTransferred(receiver,_from,levelPrice[level]*90/100,matrix,level);
410         if (isExtraDividends) {
411             emit RewardsSent(_from, receiver, matrix, level);
412         }
413        } else {
414             if (!address(uint160(receiver)).send(levelPrice[level])) {
415              emit  IncomeTransferred(receiver,_from,address(this).balance, matrix,level);
416             return address(uint160(receiver)).transfer(address(this).balance);
417         }
418          emit  IncomeTransferred(receiver,_from,levelPrice[level],matrix,level);
419         if (isExtraDividends) {
420             emit RewardsSent(_from, receiver, matrix, level);
421         }
422        }  
423     }
424     
425     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
426         assembly {
427             addr := mload(add(bys, 20))
428         }
429     }
430 }