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
50 contract OpenAlexalO {
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
64     uint public adminFee = 16 ether;
65     uint public currentId = 0;
66     uint referrer1Limit = 2;
67     uint public PERIOD_LENGTH = 60 days;
68     bool lockStatus;
69     ERC20 Token;
70     
71 
72     mapping(uint => uint) public LEVEL_PRICE;
73     mapping (address => UserStruct) public users;
74     mapping (uint => address) public userList;
75     mapping(address => mapping (uint => uint)) public EarnedEth;
76     mapping(address=> uint) loopCheck;
77     
78     event regLevelEvent(address indexed UserAddress, address indexed ReferrerAddress, uint Time);
79     event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
80     event getMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
81     event lostMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
82     
83     constructor(address _tokenAddress) public {
84         ownerAddress = msg.sender;
85         Token = ERC20(_tokenAddress);
86         
87         // Level_Price
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
100         
101         UserStruct memory userStruct;
102         currentId = currentId.add(1);
103 
104         userStruct = UserStruct({
105             isExist: true,
106             id: currentId,
107             referrerID: 0,
108             currentLevel:1,
109             totalEarningEth:0,
110             referral: new address[](0)
111         });
112         users[ownerAddress] = userStruct;
113         userList[currentId] = ownerAddress;
114 
115         for(uint i = 1; i <= 12; i++) {
116             users[ownerAddress].currentLevel = i;
117             users[ownerAddress].levelExpired[i] = 55555555555;
118         }
119     }
120     
121     /**
122      * @dev To register the User
123      * @param _referrerID id of user/referrer who is already in matrix
124      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
125      * @param _v  v of signature
126      */ 
127     function regUser(uint _referrerID, bytes32[3] calldata _mrs, uint8 _v) external payable {
128         require(lockStatus == false,"Contract Locked");
129         require(users[msg.sender].isExist == false, "User exist");
130         require(_referrerID > 0 && _referrerID <= currentId, "Incorrect referrer Id");
131         
132         require(msg.value == LEVEL_PRICE[1],"Incorrect Value");
133         
134         
135         if(users[userList[_referrerID]].referral.length >= referrer1Limit) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
136 
137         UserStruct memory userStruct;
138         currentId++;
139         
140         userStruct = UserStruct({
141             isExist: true,
142             id: currentId,
143             referrerID: _referrerID,
144             currentLevel: 1,
145             totalEarningEth:0,
146             referral: new address[](0)
147         });
148 
149         users[msg.sender] = userStruct;
150         userList[currentId] = msg.sender;
151 
152         users[msg.sender].levelExpired[1] = now.add(PERIOD_LENGTH);
153 
154         users[userList[_referrerID]].referral.push(msg.sender);
155         
156         loopCheck[msg.sender] = 0;
157 
158         payForLevel(0,1, msg.sender,((LEVEL_PRICE[1].mul(adminFee)).div(10**20)),_mrs,_v, msg.value);
159 
160         emit regLevelEvent(msg.sender, userList[_referrerID], now);
161     }
162     
163     /**
164      * @dev To update the admin fee percentage
165      * @param _adminFee  feePercentage (in ether)
166      */ 
167     function updateFeePercentage(uint256 _adminFee) public returns(bool) {
168         require(msg.sender == ownerAddress,"only OwnerWallet");
169         adminFee = _adminFee;
170         return true;  
171     }
172     
173     /**
174      * @dev To update the level price
175      * @param _level Level which wants to change
176      * @param _price Level price (in ether)
177      */ 
178     function updatePrice(uint _level, uint _price) external returns(bool) {
179           require(msg.sender == ownerAddress,"only OwnerWallet");
180           LEVEL_PRICE[_level] = _price;
181           return true;
182     }
183     
184     /**
185      * @dev To buy the next level by User
186      * @param _level level wants to buy
187      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
188      * @param _v  v of signature
189      */ 
190     function buyLevel(uint256 _level,bytes32[3] calldata _mrs,uint8 _v) external payable {
191         require(lockStatus == false,"Contract Locked");
192         require(users[msg.sender].isExist,"User not exist"); 
193         require(_level > 0 && _level <= 12,"Incorrect level");
194 
195         if(_level == 1) {
196             require(msg.value == LEVEL_PRICE[1],"Incorrect Value");
197             users[msg.sender].levelExpired[1] =  users[msg.sender].levelExpired[1].add(PERIOD_LENGTH);
198             users[msg.sender].currentLevel = 1;
199         }
200         else {
201             require(msg.value == LEVEL_PRICE[_level],"Incorrect Value");
202             
203             users[msg.sender].currentLevel = _level;
204 
205             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now,"Buy the previous level");
206             
207             if(users[msg.sender].levelExpired[_level] == 0)
208                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
209             else 
210                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
211         }
212        
213        loopCheck[msg.sender] = 0;
214        
215        payForLevel(0,_level, msg.sender,((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)),_mrs,_v,msg.value);
216 
217         emit buyLevelEvent(msg.sender, _level, now);
218     }
219     
220     function payForLevel(uint _flag,uint _level,address _userAddress,uint _adminPrice,bytes32[3] memory _mrs,uint8 _v,uint256 _amt) internal {
221         
222         address[6] memory referer;
223         
224         if(_flag == 0) 
225         {
226             if(_level == 1 || _level == 7) {
227                 referer[0] = userList[users[_userAddress].referrerID];
228             }
229             else if(_level == 2 || _level == 8) {
230                 referer[1] = userList[users[_userAddress].referrerID];
231                 referer[0] = userList[users[referer[1]].referrerID];
232             }
233             else if(_level == 3 || _level == 9) {
234                 referer[1] = userList[users[_userAddress].referrerID];
235                 referer[2] = userList[users[referer[1]].referrerID];
236                 referer[0] = userList[users[referer[2]].referrerID];
237             }
238             else if(_level == 4 || _level == 10) {
239                 referer[1] = userList[users[_userAddress].referrerID];
240                 referer[2] = userList[users[referer[1]].referrerID];
241                 referer[3] = userList[users[referer[2]].referrerID];
242                 referer[0] = userList[users[referer[3]].referrerID];
243             }
244             else if(_level == 5 || _level == 11) {
245                 referer[1] = userList[users[_userAddress].referrerID];
246                 referer[2] = userList[users[referer[1]].referrerID];
247                 referer[3] = userList[users[referer[2]].referrerID];
248                 referer[4] = userList[users[referer[3]].referrerID];
249                 referer[0] = userList[users[referer[4]].referrerID];
250             }
251             else if(_level == 6 || _level == 12) {
252                 referer[1] = userList[users[_userAddress].referrerID];
253                 referer[2] = userList[users[referer[1]].referrerID];
254                 referer[3] = userList[users[referer[2]].referrerID];
255                 referer[4] = userList[users[referer[3]].referrerID];
256                 referer[5] = userList[users[referer[4]].referrerID];
257                 referer[0] = userList[users[referer[5]].referrerID];
258             }
259             
260         }
261         
262         else if(_flag == 1) {
263              referer[0] = userList[users[_userAddress].referrerID];
264         }
265 
266 
267         if(!users[referer[0]].isExist) referer[0] = userList[1];
268         
269         if(loopCheck[msg.sender] >= 12) {
270             referer[0] = userList[1];
271         }
272 
273         
274         if(users[referer[0]].levelExpired[_level] >= now) {
275           
276             uint256 tobeminted = ((_amt).mul(10**18)).div(0.01 ether);
277             
278             
279             // transactions 
280             require((address(uint160(referer[0])).send(LEVEL_PRICE[_level].sub(_adminPrice))) && (address(uint160(ownerAddress)).send(_adminPrice)) &&   Token.mint(msg.sender,tobeminted,_mrs,_v), "Transaction Failure");
281            
282             users[referer[0]].totalEarningEth = users[referer[0]].totalEarningEth.add(LEVEL_PRICE[_level]);
283             EarnedEth[referer[0]][_level] =  EarnedEth[referer[0]][_level].add(LEVEL_PRICE[_level]);
284           
285             
286             emit getMoneyForLevelEvent(msg.sender,users[msg.sender].id,referer[0],users[referer[0]].id, _level, LEVEL_PRICE[_level],now);
287         }
288         
289         else  {
290             if(loopCheck[_userAddress] < 12) {
291                 loopCheck[_userAddress] = loopCheck[_userAddress].add(1);
292                 emit lostMoneyForLevelEvent(msg.sender,users[msg.sender].id,referer[0],users[referer[0]].id, _level, LEVEL_PRICE[_level],now);
293                 payForLevel(1,_level, referer[0],_adminPrice,_mrs,_v,_amt);
294             }
295         }
296     }
297     
298     /**
299      * @dev To get the free Referrer Address
300      * @param _userAddress User address who is already in matrix  (mostly prefer ownerAddress address)
301      */ 
302     function findFreeReferrer(address _userAddress) public view returns(address) {
303         if(users[_userAddress].referral.length < referrer1Limit) return _userAddress;
304 
305         address[] memory referrals = new address[](254);
306         referrals[0] = users[_userAddress].referral[0];
307         referrals[1] = users[_userAddress].referral[1];
308 
309         address freeReferrer;
310         bool noFreeReferrer = true;
311 
312         for(uint i = 0; i < 254; i++) { 
313             if(users[referrals[i]].referral.length == referrer1Limit) {
314                 if(i < 126) {
315                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
316                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
317                 }
318             }
319             else {
320                 noFreeReferrer = false;
321                 freeReferrer = referrals[i];
322                 break;
323             }
324         }
325 
326         require(!noFreeReferrer, "No Free Referrer");
327 
328         return freeReferrer;
329     }
330     
331     
332    /**
333      * @dev To view the referrals
334      * @param _userAddress  User who is already in matrix
335      */ 
336     function viewUserReferral(address _userAddress) external view returns(address[] memory) {
337         return users[_userAddress].referral;
338     }
339     
340     
341     /**
342      * @dev To view the level expired time
343      * @param _userAddress  User who is already in matrix
344      * @param _level Level which is wants to view
345      */ 
346     function viewUserLevelExpired(address _userAddress,uint _level) external view returns(uint) {
347         return users[_userAddress].levelExpired[_level];
348     }
349     
350     
351     /**
352      * @dev To lock/unlock the contract
353      * @param _lockStatus  status in bool
354      */ 
355     function contractLock(bool _lockStatus) public returns(bool) {
356         require(msg.sender == ownerAddress, "Invalid User");
357         lockStatus = _lockStatus;
358         return true;
359     }
360     
361     
362     /**
363      * @dev To update the token contract address
364      * @param _newToken  new Token Address 
365      */ 
366     function updateToken(address _newToken) public returns(bool) {
367         require(msg.sender == ownerAddress, "Invalid User");
368         Token = ERC20(_newToken);
369         return true;
370     }
371     
372     
373     /**
374      * @dev To get the total earning ether till now
375      */
376     function getTotalEarnedEther() public view returns(uint) {
377         uint totalEth;
378         
379         for( uint i=1;i<=currentId;i++) {
380             totalEth = totalEth.add(users[userList[i]].totalEarningEth);
381         }
382         
383         return totalEth;
384     }
385         
386     
387     function () external payable {
388         revert("Invalid Transaction");
389     }
390 }