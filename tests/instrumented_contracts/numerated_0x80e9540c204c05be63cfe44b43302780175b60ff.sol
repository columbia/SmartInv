1 /**
2  *
3  * Updated OpenAlexa v1.2 (Fixed)
4  * URL: https://openalexa.io 
5  *
6 */
7 
8 pragma solidity 0.5.14;
9 
10 
11 library SafeMath {
12 
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a, "SafeMath: addition overflow");
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a, "SafeMath: subtraction overflow");
21         uint256 c = a - b;
22         return c;
23     }
24 
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         require(b > 0, "SafeMath: division by zero");
36         uint256 c = a / b;
37         return c;
38     }
39 }
40 
41 
42 contract ERC20 {
43     function mint(address reciever, uint256 value, bytes32[3] memory _mrs, uint8 _v) public returns(bool);
44     function transfer(address to, uint256 value) public returns(bool);
45 }
46 
47 
48 contract OpenAlexalO {
49     using SafeMath for uint256;
50 
51     struct UserStruct {
52         bool isExist;
53         uint id;
54         uint referrerID;
55         uint currentLevel;
56         uint totalEarningEth;
57         address[] referral;
58         mapping(uint => uint) levelExpired;
59     }
60     
61     ERC20 Token;
62     OpenAlexalO public oldAlexa;
63     address public ownerAddress;
64     uint public adminFee = 16 ether;
65     uint public currentId = 0;
66     uint public oldAlexaId = 1;
67     uint public PERIOD_LENGTH = 60 days;
68     uint referrer1Limit = 2;
69     bool public lockStatus;
70     
71     mapping (uint => uint) public LEVEL_PRICE;
72     mapping (address => UserStruct) public users;
73     mapping (uint => address) public userList;
74     mapping (address => mapping (uint => uint)) public EarnedEth;
75     mapping (address => uint) public loopCheck;
76     mapping (address => uint) public createdDate;
77     
78     event regLevelEvent(address indexed UserAddress, address indexed ReferrerAddress, uint Time);
79     event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
80     event getMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
81     event lostMoneyForLevelEvent(address indexed UserAddress, uint UserId, address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);    
82     
83     constructor() public {
84         ownerAddress = msg.sender;
85         Token = ERC20(0x1788430620960F9a70e3DC14202a3A35ddE1A316);
86         oldAlexa = OpenAlexalO(0xaB3FB81f8660788997CFD379f7A87e9527F1301b);
87 
88         LEVEL_PRICE[1] = 0.03 ether;
89         LEVEL_PRICE[2] = 0.05 ether;
90         LEVEL_PRICE[3] = 0.1 ether;
91         LEVEL_PRICE[4] = 0.5 ether;
92         LEVEL_PRICE[5] = 1 ether;
93         LEVEL_PRICE[6] = 3 ether;
94         LEVEL_PRICE[7] = 7 ether;
95         LEVEL_PRICE[8] = 12 ether;
96         LEVEL_PRICE[9] = 15 ether;
97         LEVEL_PRICE[10] = 25 ether;
98         LEVEL_PRICE[11] = 30 ether;
99         LEVEL_PRICE[12] = 39 ether;
100     } 
101 
102     /**
103      * @dev User registration
104      */ 
105     function regUser(uint _referrerID, bytes32[3] calldata _mrs, uint8 _v) external payable {
106         require(lockStatus == false, "Contract Locked");
107         require(users[msg.sender].isExist == false, "User exist");
108         require(_referrerID > 0 && _referrerID <= currentId, "Incorrect referrer Id");
109         require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
110         
111         if (users[userList[_referrerID]].referral.length >= referrer1Limit) 
112             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
113 
114         UserStruct memory userStruct;
115         currentId++;
116         
117         userStruct = UserStruct({
118             isExist: true,
119             id: currentId,
120             referrerID: _referrerID,
121             currentLevel: 1,
122             totalEarningEth:0,
123             referral: new address[](0)
124         });
125 
126         users[msg.sender] = userStruct;
127         userList[currentId] = msg.sender;
128         users[msg.sender].levelExpired[1] = now.add(PERIOD_LENGTH);
129         users[userList[_referrerID]].referral.push(msg.sender);
130         loopCheck[msg.sender] = 0;
131         createdDate[msg.sender] = now;
132 
133         payForLevel(0, 1, msg.sender, ((LEVEL_PRICE[1].mul(adminFee)).div(10**20)), _mrs, _v, msg.value);
134 
135         emit regLevelEvent(msg.sender, userList[_referrerID], now);
136     }
137     
138     /**
139      * @dev To buy the next level by User
140      */ 
141     function buyLevel(uint256 _level, bytes32[3] calldata _mrs, uint8 _v) external payable {
142         require(lockStatus == false, "Contract Locked");
143         require(users[msg.sender].isExist, "User not exist"); 
144         require(_level > 0 && _level <= 12, "Incorrect level");
145 
146         if (_level == 1) {
147             require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
148             users[msg.sender].levelExpired[1] = users[msg.sender].levelExpired[1].add(PERIOD_LENGTH);
149             users[msg.sender].currentLevel = 1;
150         } else {
151             require(msg.value == LEVEL_PRICE[_level], "Incorrect Value");
152             users[msg.sender].currentLevel = _level;
153             for (uint i = _level - 1; i > 0; i--) 
154                 require(users[msg.sender].levelExpired[i] >= now, "Buy the previous level");
155             
156             if (users[msg.sender].levelExpired[_level] == 0)
157                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
158             else 
159                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
160         }
161         loopCheck[msg.sender] = 0;
162        
163         payForLevel(0, _level, msg.sender, ((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)), _mrs, _v, msg.value);
164 
165         emit buyLevelEvent(msg.sender, _level, now);
166     }
167     
168     /**
169      * @dev Internal function for payment
170      */ 
171     function payForLevel(uint _flag, uint _level, address _userAddress, uint _adminPrice, bytes32[3] memory _mrs, uint8 _v, uint256 _amt) internal {
172         address[6] memory referer;
173         
174         if (_flag == 0) {
175             if (_level == 1 || _level == 7) {
176                 referer[0] = userList[users[_userAddress].referrerID];
177             } else if (_level == 2 || _level == 8) {
178                 referer[1] = userList[users[_userAddress].referrerID];
179                 referer[0] = userList[users[referer[1]].referrerID];
180             } else if (_level == 3 || _level == 9) {
181                 referer[1] = userList[users[_userAddress].referrerID];
182                 referer[2] = userList[users[referer[1]].referrerID];
183                 referer[0] = userList[users[referer[2]].referrerID];
184             } else if (_level == 4 || _level == 10) {
185                 referer[1] = userList[users[_userAddress].referrerID];
186                 referer[2] = userList[users[referer[1]].referrerID];
187                 referer[3] = userList[users[referer[2]].referrerID];
188                 referer[0] = userList[users[referer[3]].referrerID];
189             } else if (_level == 5 || _level == 11) {
190                 referer[1] = userList[users[_userAddress].referrerID];
191                 referer[2] = userList[users[referer[1]].referrerID];
192                 referer[3] = userList[users[referer[2]].referrerID];
193                 referer[4] = userList[users[referer[3]].referrerID];
194                 referer[0] = userList[users[referer[4]].referrerID];
195             } else if (_level == 6 || _level == 12) {
196                 referer[1] = userList[users[_userAddress].referrerID];
197                 referer[2] = userList[users[referer[1]].referrerID];
198                 referer[3] = userList[users[referer[2]].referrerID];
199                 referer[4] = userList[users[referer[3]].referrerID];
200                 referer[5] = userList[users[referer[4]].referrerID];
201                 referer[0] = userList[users[referer[5]].referrerID];
202             }
203         } else if (_flag == 1) {
204             referer[0] = userList[users[_userAddress].referrerID];
205         }
206         if (!users[referer[0]].isExist) referer[0] = userList[1];
207         
208         if (loopCheck[msg.sender] >= 12) {
209             referer[0] = userList[1];
210         }
211         if (users[referer[0]].levelExpired[_level] >= now) {
212           
213             uint256 tobeminted = ((_amt).mul(10**18)).div(0.01 ether);
214             // transactions 
215             require((address(uint160(referer[0])).send(LEVEL_PRICE[_level].sub(_adminPrice))) && 
216                     (address(uint160(ownerAddress)).send(_adminPrice)) &&   
217                     Token.mint(msg.sender, tobeminted, _mrs, _v), "Transaction Failure");
218            
219             users[referer[0]].totalEarningEth = users[referer[0]].totalEarningEth.add(LEVEL_PRICE[_level]);
220             EarnedEth[referer[0]][_level] = EarnedEth[referer[0]][_level].add(LEVEL_PRICE[_level]);
221           
222             emit getMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level], now);
223         } else {
224             if (loopCheck[msg.sender] < 12) {
225                 loopCheck[msg.sender] = loopCheck[msg.sender].add(1);
226 
227             emit lostMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer[0], users[referer[0]].id, _level, LEVEL_PRICE[_level],now);
228                 
229             payForLevel(1, _level, referer[0], _adminPrice, _mrs, _v, _amt);
230             }
231         }
232     }
233 
234     /**
235      * @dev Update old contract data
236      */ 
237     function oldAlexaSync(uint limit) public {
238         require(address(oldAlexa) != address(0), "Initialize closed");
239         require(msg.sender == ownerAddress, "Access denied");
240         
241         for (uint i = 0; i <= limit; i++) {
242             UserStruct  memory olduser;
243             address oldusers = oldAlexa.userList(oldAlexaId);
244             (olduser.isExist, 
245             olduser.id, 
246             olduser.referrerID, 
247             olduser.currentLevel,  
248             olduser.totalEarningEth) = oldAlexa.users(oldusers);
249             address ref = oldAlexa.userList(olduser.referrerID);
250 
251             if (olduser.isExist) {
252                 if (!users[oldusers].isExist) {
253                     users[oldusers].isExist = true;
254                     users[oldusers].id = oldAlexaId;
255                     users[oldusers].referrerID = olduser.referrerID;
256                     users[oldusers].currentLevel = olduser.currentLevel;
257                     users[oldusers].totalEarningEth = olduser.totalEarningEth;
258                     userList[oldAlexaId] = oldusers;
259                     users[ref].referral.push(oldusers);
260                     createdDate[oldusers] = now;
261                     
262                     emit regLevelEvent(oldusers, ref, now);
263                     
264                     for (uint j = 1; j <= 12; j++) {
265                         users[oldusers].levelExpired[j] = oldAlexa.viewUserLevelExpired(oldusers, j);
266                         EarnedEth[oldusers][j] = oldAlexa.EarnedEth(oldusers, j);
267                     } 
268                 }
269                 oldAlexaId++;
270             } else {
271                 currentId = oldAlexaId.sub(1);
272                 break;
273                 
274             }
275         }
276     }
277     
278     /**
279      * @dev Update old contract data
280      */ 
281     function setOldAlexaID(uint _id) public returns(bool) {
282         require(ownerAddress == msg.sender, "Access Denied");
283         
284         oldAlexaId = _id;
285         return true;
286     }
287 
288     /**
289      * @dev Close old contract interaction
290      */ 
291     function oldAlexaSyncClosed() external {
292         require(address(oldAlexa) != address(0), "Initialize already closed");
293         require(msg.sender == ownerAddress, "Access denied");
294 
295         oldAlexa = OpenAlexalO(0);
296     }
297     
298     /**
299      * @dev Contract balance withdraw
300      */ 
301     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
302         require(msg.sender == ownerAddress, "only Owner Wallet");
303         require(_toUser != address(0), "Invalid Address");
304         require(address(this).balance >= _amount, "Insufficient balance");
305 
306         (_toUser).transfer(_amount);
307         return true;
308     }
309             
310     /**
311      * @dev Update admin fee percentage
312      */ 
313     function updateFeePercentage(uint256 _adminFee) public returns (bool) {
314         require(msg.sender == ownerAddress, "only OwnerWallet");
315 
316         adminFee = _adminFee;
317         return true;  
318     }
319     
320     /**
321      * @dev Update level price
322      */ 
323     function updatePrice(uint _level, uint _price) public returns (bool) {
324         require(msg.sender == ownerAddress, "only OwnerWallet");
325 
326         LEVEL_PRICE[_level] = _price;
327         return true;
328     }
329 
330     /**
331      * @dev Update contract status
332      */ 
333     function contractLock(bool _lockStatus) public returns (bool) {
334         require(msg.sender == ownerAddress, "Invalid User");
335 
336         lockStatus = _lockStatus;
337         return true;
338     }
339     
340     /**
341     * @dev Update token contract
342     */ 
343     function updateToken(address _newToken) public returns (bool) {
344         require(msg.sender == ownerAddress, "Invalid User");
345         require(_newToken != address(0), "Invalid Token Address");
346         
347         Token = ERC20(_newToken);
348         return true;
349     }
350         
351     /**
352      * @dev View free Referrer Address
353      */ 
354     function findFreeReferrer(address _userAddress) public view returns (address) {
355         if (users[_userAddress].referral.length < referrer1Limit) 
356             return _userAddress;
357 
358         address[] memory referrals = new address[](254);
359         referrals[0] = users[_userAddress].referral[0];
360         referrals[1] = users[_userAddress].referral[1];
361 
362         address freeReferrer;
363         bool noFreeReferrer = true;
364 
365         for (uint i = 0; i < 254; i++) { 
366             if (users[referrals[i]].referral.length == referrer1Limit) {
367                 if (i < 126) {
368                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
369                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
370                 }
371             } else {
372                 noFreeReferrer = false;
373                 freeReferrer = referrals[i];
374                 break;
375             }
376         }
377         require(!noFreeReferrer, "No Free Referrer");
378         return freeReferrer;
379     }
380     
381     /**
382      * @dev Total earned ETH
383      */
384     function getTotalEarnedEther() public view returns (uint) {
385         uint totalEth;
386         for (uint i = 1; i <= currentId; i++) {
387             totalEth = totalEth.add(users[userList[i]].totalEarningEth);
388         }
389         return totalEth;
390     }
391         
392    /**
393      * @dev View referrals
394      */ 
395     function viewUserReferral(address _userAddress) external view returns (address[] memory) {
396         return users[_userAddress].referral;
397     }
398     
399     /**
400      * @dev View level expired time
401      */ 
402     function viewUserLevelExpired(address _userAddress,uint _level) external view returns (uint) {
403         return users[_userAddress].levelExpired[_level];
404     }
405 
406     // fallback
407     function () external payable {
408         revert("Invalid Transaction");
409     }
410 }