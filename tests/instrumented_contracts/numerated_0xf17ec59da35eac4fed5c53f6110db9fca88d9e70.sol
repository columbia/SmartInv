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
40     function allowance(address owner, address spender) public view returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     function mint(address reciever, uint256 value,bytes32[3] memory _mrs, uint8 _v) public returns(bool);
44     function transfer(address to, uint256 value) public returns(bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 
50 contract EtokenLink {
51 
52     struct UserStruct {
53         bool isExist;
54         uint id;
55         uint referrerID;
56         uint currentLevel;
57         uint totalEarningEth;
58         address[] referral;
59         mapping(uint => uint) levelExpired;
60     }
61     
62     using SafeMath for uint256;
63     address public ownerAddress;
64     uint public adminFee = 15 ether;
65     uint public currentId = 0;
66     uint referrer1Limit = 2;
67     uint public PERIOD_LENGTH = 60 days;
68     bool public lockStatus;
69     ERC20 Token;
70 
71     mapping(uint => uint) public LEVEL_PRICE;
72     mapping(uint => uint) public UPLINE_PERCENTAGE;
73     mapping (address => UserStruct) public users;
74     mapping (uint => address) public userList;
75     mapping(address => mapping (uint => uint)) public EarnedEth;
76     mapping(address=> uint) public loopCheck;
77     mapping (address => uint) public createdDate;
78     mapping (bytes32 => bool) private hashConfirmation;
79     
80     event regLevelEvent(address indexed UserAddress, address indexed ReferrerAddress, uint Time);
81     event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
82     event getMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
83     event lostMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
84     
85     constructor(address _tokenAddress) public {
86         ownerAddress = msg.sender;
87         Token = ERC20(_tokenAddress);
88         
89         // Level_Price
90         LEVEL_PRICE[1] = 0.05 ether;
91         LEVEL_PRICE[2] = 0.07 ether;
92         LEVEL_PRICE[3] = 0.15 ether;
93         LEVEL_PRICE[4] = 0.6 ether;
94         LEVEL_PRICE[5] = 1.5 ether;
95         LEVEL_PRICE[6] = 3 ether;
96         LEVEL_PRICE[7] = 7 ether;
97         LEVEL_PRICE[8] = 15 ether;
98         LEVEL_PRICE[9] = 21 ether;
99         
100         UPLINE_PERCENTAGE[1] = 30 ether;
101         UPLINE_PERCENTAGE[2] = 15 ether;
102         UPLINE_PERCENTAGE[3] = 12 ether;
103         UPLINE_PERCENTAGE[4] = 9 ether;
104         UPLINE_PERCENTAGE[5] = 7 ether;
105         UPLINE_PERCENTAGE[6] = 6 ether;
106         UPLINE_PERCENTAGE[7] = 6 ether;
107         UPLINE_PERCENTAGE[8] = 3 ether;
108         UPLINE_PERCENTAGE[9] = 3 ether;
109         UPLINE_PERCENTAGE[10] = 3 ether;
110         UPLINE_PERCENTAGE[11] = 3 ether;
111         UPLINE_PERCENTAGE[12] = 3 ether;
112         
113         UserStruct memory userStruct;
114         currentId = currentId.add(1);
115 
116         userStruct = UserStruct({
117             isExist: true,
118             id: currentId,
119             referrerID: 0,
120             currentLevel:1,
121             totalEarningEth:0,
122             referral: new address[](0)
123         });
124         users[ownerAddress] = userStruct;
125         userList[currentId] = ownerAddress;
126 
127         for (uint i = 1; i <= 9; i++) {
128             users[ownerAddress].currentLevel = i;
129             users[ownerAddress].levelExpired[i] = 55555555555;
130         }
131     }
132     
133     /**
134      * @dev To register the User
135      * @param _referrerID id of user/referrer who is already in matrix
136      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
137      * @param _v  v of signature
138      */ 
139     function regUser(uint _referrerID, bytes32[3] calldata _mrs, uint8 _v) external payable {
140         require(lockStatus == false, "Contract Locked");
141         require(users[msg.sender].isExist == false, "User exist");
142         require(_referrerID > 0 && _referrerID <= currentId, "Incorrect referrer Id");
143         require(hashConfirmation[_mrs[0]] == false, "Hash Exits");
144         require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
145         
146         if(users[userList[_referrerID]].referral.length >= referrer1Limit) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
147 
148         UserStruct memory userStruct;
149         currentId++;
150         
151         userStruct = UserStruct({
152             isExist: true,
153             id: currentId,
154             referrerID: _referrerID,
155             currentLevel: 1,
156             totalEarningEth:0,
157             referral: new address[](0)
158         });
159 
160         users[msg.sender] = userStruct;
161         userList[currentId] = msg.sender;
162         users[msg.sender].levelExpired[1] = now.add(PERIOD_LENGTH);
163         users[userList[_referrerID]].referral.push(msg.sender);
164         createdDate[msg.sender] = now;
165         loopCheck[msg.sender] = 0;
166 
167         payForRegister(1, msg.sender, ((LEVEL_PRICE[1].mul(adminFee)).div(10**20)), _mrs, _v);
168         hashConfirmation[_mrs[0]] = true;
169 
170         emit regLevelEvent(msg.sender, userList[_referrerID], now);
171     }
172     
173     /**
174      * @dev To update the admin fee percentage
175      * @param _adminFee  feePercentage (in ether)
176      */ 
177     function updateFeePercentage(uint256 _adminFee) public returns(bool) {
178         require(msg.sender == ownerAddress, "Only OwnerWallet");
179         adminFee = _adminFee;
180         return true;  
181     }
182     
183     /**
184      * @dev To update the upline fee percentage
185      * @param _level Level which wants to change
186      * @param _upline  feePercentage (in ether)
187      */ 
188     function updateUplineFee(uint256 _level,uint256 _upline) public returns(bool) {
189         require(msg.sender == ownerAddress, "Only OwnerWallet");
190          require(_level > 0 && _level <= 12, "Incorrect level");
191         UPLINE_PERCENTAGE[_level] = _upline;
192         return true;  
193     }
194     
195     
196     /**
197      * @dev To update the level price
198      * @param _level Level which wants to change
199      * @param _price Level price (in ether)
200      */ 
201     function updatePrice(uint _level, uint _price) external returns(bool) {
202         require(msg.sender == ownerAddress, "Only OwnerWallet");
203         require(_level > 0 && _level <= 9, "Incorrect level");
204         LEVEL_PRICE[_level] = _price;
205         return true;
206     }
207     
208     /**
209      * @dev To buy the next level by User
210      * @param _level level wants to buy
211      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
212      * @param _v  v of signature
213      */ 
214     function buyLevel(uint256 _level, bytes32[3] calldata _mrs, uint8 _v) external payable {
215         require(lockStatus == false, "Contract Locked");
216         require(users[msg.sender].isExist, "User not exist");
217         require(hashConfirmation[_mrs[0]] == false, "Hash Exits");
218         require(_level > 0 && _level <= 9, "Incorrect level");
219 
220         if (_level == 1) {
221             require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
222             users[msg.sender].levelExpired[1] =  users[msg.sender].levelExpired[1].add(PERIOD_LENGTH);
223             users[msg.sender].currentLevel = 1;
224         }else {
225             require(msg.value == LEVEL_PRICE[_level], "Incorrect Value");
226             
227             users[msg.sender].currentLevel = _level;
228 
229             for (uint i =_level - 1; i > 0; i--) require(users[msg.sender].levelExpired[i] >= now, "Buy the previous level");
230             
231             if(users[msg.sender].levelExpired[_level] == 0)
232                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
233             else 
234                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
235         }
236        
237         loopCheck[msg.sender] = 0;
238        
239         payForLevels(_level, msg.sender, ((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)), _mrs, _v);
240        
241         hashConfirmation[_mrs[0]] = true;
242 
243         emit buyLevelEvent(msg.sender, _level, now);
244     }
245 
246     /**
247      * @dev Internal function
248      */ 
249     function payForRegister(uint _level,address _userAddress,uint _adminPrice,bytes32[3] memory _mrs,uint8 _v) internal {
250 
251         address referer;
252 
253         referer = userList[users[_userAddress].referrerID];
254 
255         if (!users[referer].isExist) referer = userList[1];
256 
257         if (users[referer].levelExpired[_level] >= now) {
258             uint256 tobeminted = ((LEVEL_PRICE[_level]).mul(10**3)).div(0.005 ether);
259             require((address(uint160(ownerAddress)).send(_adminPrice)) && address(uint160(referer)).send(LEVEL_PRICE[_level].sub(_adminPrice)) && Token.mint(msg.sender,tobeminted,_mrs,_v), "Transaction Failure");
260             users[referer].totalEarningEth = users[referer].totalEarningEth.add(LEVEL_PRICE[_level].sub(_adminPrice));
261             EarnedEth[referer][_level] =  EarnedEth[referer][_level].add(LEVEL_PRICE[_level].sub(_adminPrice));
262         }else {
263             emit lostMoneyForLevelEvent(msg.sender,users[msg.sender].id,referer,users[referer].id, _level, LEVEL_PRICE[_level],now);
264             revert("Referer Not Active");
265         }
266 
267     }
268     
269     /**
270      * @dev Internal function
271      */ 
272     function payForLevels(uint _level, address _userAddress, uint _adminPrice, bytes32[3] memory _mrs, uint8 _v) internal {
273 
274         address referer;
275 
276         referer = userList[users[_userAddress].referrerID];
277 
278         if (!users[referer].isExist) referer = userList[1];
279 
280         if (loopCheck[msg.sender] > 12) {
281             referer = userList[1];
282         }
283 
284         if (loopCheck[msg.sender] == 0) {
285             require((address(uint160(ownerAddress)).send(_adminPrice)), "Transaction Failure");
286             loopCheck[msg.sender] = loopCheck[msg.sender].add(1);
287         }
288 
289 
290         if (users[referer].levelExpired[_level] >= now) {
291 
292             if (loopCheck[msg.sender] <= 12) {
293 
294                 uint uplinePrice = LEVEL_PRICE[_level].sub(_adminPrice);
295 
296                 // transactions 
297                 uint256 tobeminted = ((_adminPrice).mul(10**3)).div(0.005 ether);
298                 require((address(uint160(referer)).send(uplinePrice.mul(UPLINE_PERCENTAGE[loopCheck[msg.sender]]).div(10**20)))
299                 && Token.mint(referer,tobeminted.mul(UPLINE_PERCENTAGE[loopCheck[msg.sender]]).div(10**20),_mrs,_v),"Transaction Failure");
300                 users[referer].totalEarningEth = users[referer].totalEarningEth.add(uplinePrice.mul(UPLINE_PERCENTAGE[loopCheck[msg.sender]]).div(10**20));
301                 EarnedEth[referer][_level] =  EarnedEth[referer][_level].add(uplinePrice.mul(UPLINE_PERCENTAGE[loopCheck[msg.sender]]).div(10**20));
302                 loopCheck[msg.sender] = loopCheck[msg.sender].add(1);
303                 emit getMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer, users[referer].id, _level, LEVEL_PRICE[_level], now);
304                 payForLevels(_level, referer, _adminPrice, _mrs, _v);
305             }
306         }else {
307             if (loopCheck[msg.sender] <= 12) {
308                 emit lostMoneyForLevelEvent(msg.sender, users[msg.sender].id, referer,users[referer].id, _level, LEVEL_PRICE[_level], now);
309                 payForLevels(_level, referer, _adminPrice, _mrs, _v);
310 
311             }
312         }
313     }
314 
315     /**
316      * @dev View free Referrer Address
317      */ 
318     function findFreeReferrer(address _userAddress) public view returns (address) {
319         if (users[_userAddress].referral.length < referrer1Limit) 
320             return _userAddress;
321 
322         address[] memory referrals = new address[](254);
323         referrals[0] = users[_userAddress].referral[0];
324         referrals[1] = users[_userAddress].referral[1];
325 
326         address freeReferrer;
327         bool noFreeReferrer = true;
328 
329         for (uint i = 0; i < 254; i++) { 
330             if (users[referrals[i]].referral.length == referrer1Limit) {
331                 if (i < 126) {
332                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
333                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
334                 }
335             } else {
336                 noFreeReferrer = false;
337                 freeReferrer = referrals[i];
338                 break;
339             }
340         }
341         require(!noFreeReferrer, "No Free Referrer");
342         return freeReferrer;
343     }
344     
345    /**
346      * @dev To view the referrals
347      * @param _userAddress  User who is already in matrix
348      */ 
349     function viewUserReferral(address _userAddress) external view returns(address[] memory) {
350         return users[_userAddress].referral;
351     }
352     
353     /**
354      * @dev To view the level expired time
355      * @param _userAddress  User who is already in matrix
356      * @param _level Level which is wants to view
357      */ 
358     function viewUserLevelExpired(address _userAddress,uint _level) external view returns(uint) {
359         return users[_userAddress].levelExpired[_level];
360     }
361     
362     /**
363      * @dev To lock/unlock the contract
364      * @param _lockStatus  status in bool
365      */ 
366     function contractLock(bool _lockStatus) public returns(bool) {
367         require(msg.sender == ownerAddress, "Invalid User");
368         lockStatus = _lockStatus;
369         return true;
370     }
371     
372     /**
373      * @dev To update the token contract address
374      * @param _newToken  new Token Address 
375      */ 
376     function updateToken(address _newToken) public returns(bool) {
377         require(msg.sender == ownerAddress, "Invalid User");
378         Token = ERC20(_newToken);
379         return true;
380     }
381     
382     
383     /**
384      * @dev To get the total earning ether till now
385      */
386     function getTotalEarnedEther() public view returns(uint) {
387         uint totalEth;
388         
389         for (uint i = 1; i <= currentId; i++) {
390             totalEth = totalEth.add(users[userList[i]].totalEarningEth);
391         }
392         
393         return totalEth;
394     }  
395 
396     /**
397      * @dev Revert statement
398      */ 
399     function () external payable {
400         revert("Invalid Transaction");
401     }
402     
403     /**
404      * @dev Contract balance withdraw
405      */ 
406     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
407         require(msg.sender == ownerAddress, "Only Owner Wallet");
408         require(_toUser != address(0), "Invalid Address");
409         require(address(this).balance >= _amount, "Insufficient balance");
410 
411         (_toUser).transfer(_amount);
412         return true;
413     }
414 }