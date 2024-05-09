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
50 contract ETHPAY {
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
77     mapping (address => uint) public createdDate;
78     
79     event regLevelEvent(address indexed UserAddress, address indexed ReferrerAddress, uint Time);
80     event buyLevelEvent(address indexed UserAddress, uint Levelno, uint Time);
81     event getMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
82     event lostMoneyForLevelEvent(address indexed UserAddress,uint UserId,address indexed ReferrerAddress, uint ReferrerId, uint Levelno, uint LevelPrice, uint Time);
83     
84     constructor(address _tokenAddress) public {
85         ownerAddress = msg.sender;
86         Token = ERC20(_tokenAddress);
87         
88         // Level_Price
89         LEVEL_PRICE[1] = 0.03 ether;
90         LEVEL_PRICE[2] = 0.05 ether;
91         LEVEL_PRICE[3] = 0.1 ether;
92         LEVEL_PRICE[4] = 0.5 ether;
93         LEVEL_PRICE[5] = 1 ether;
94         LEVEL_PRICE[6] = 3 ether;
95         LEVEL_PRICE[7] = 7 ether;
96         LEVEL_PRICE[8] = 12 ether;
97         LEVEL_PRICE[9] = 15 ether;
98         LEVEL_PRICE[10] = 25 ether;
99         LEVEL_PRICE[11] = 30 ether;
100         LEVEL_PRICE[12] = 39 ether;
101         
102         UserStruct memory userStruct;
103         currentId = currentId.add(1);
104 
105         userStruct = UserStruct({
106             isExist: true,
107             id: currentId,
108             referrerID: 0,
109             currentLevel:1,
110             totalEarningEth:0,
111             referral: new address[](0)
112         });
113         users[ownerAddress] = userStruct;
114         userList[currentId] = ownerAddress;
115 
116         for(uint i = 1; i <= 12; i++) {
117             users[ownerAddress].currentLevel = i;
118             users[ownerAddress].levelExpired[i] = 55555555555;
119         }
120     }
121     
122     /**
123      * @dev To register the User
124      * @param _referrerID id of user/referrer who is already in matrix
125      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
126      * @param _v  v of signature
127      */ 
128     function regUser(uint _referrerID, bytes32[3] calldata _mrs, uint8 _v) external payable {
129         require(lockStatus == false,"Contract Locked");
130         require(users[msg.sender].isExist == false, "User exist");
131         require(_referrerID > 0 && _referrerID <= currentId, "Incorrect referrer Id");
132         
133         require(msg.value == LEVEL_PRICE[1],"Incorrect Value");
134         
135         
136         if(users[userList[_referrerID]].referral.length >= referrer1Limit) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
137 
138         UserStruct memory userStruct;
139         currentId++;
140         
141         userStruct = UserStruct({
142             isExist: true,
143             id: currentId,
144             referrerID: _referrerID,
145             currentLevel: 1,
146             totalEarningEth:0,
147             referral: new address[](0)
148         });
149 
150         users[msg.sender] = userStruct;
151         userList[currentId] = msg.sender;
152 
153         users[msg.sender].levelExpired[1] = now.add(PERIOD_LENGTH);
154 
155         users[userList[_referrerID]].referral.push(msg.sender);
156         createdDate[msg.sender] = now;
157         loopCheck[msg.sender] = 0;
158 
159         payForLevel(0,1, msg.sender,((LEVEL_PRICE[1].mul(adminFee)).div(10**20)),_mrs,_v, msg.value);
160 
161         emit regLevelEvent(msg.sender, userList[_referrerID], now);
162     }
163     
164     /**
165      * @dev To update the admin fee percentage
166      * @param _adminFee  feePercentage (in ether)
167      */ 
168     function updateFeePercentage(uint256 _adminFee) public returns(bool) {
169         require(msg.sender == ownerAddress,"only OwnerWallet");
170         adminFee = _adminFee;
171         return true;  
172     }
173     
174     /**
175      * @dev To update the level price
176      * @param _level Level which wants to change
177      * @param _price Level price (in ether)
178      */ 
179     function updatePrice(uint _level, uint _price) external returns(bool) {
180           require(msg.sender == ownerAddress,"only OwnerWallet");
181           LEVEL_PRICE[_level] = _price;
182           return true;
183     }
184     
185     /**
186      * @dev To buy the next level by User
187      * @param _level level wants to buy
188      * @param _mrs _mrs[0] - message hash _mrs[1] - r of signature _mrs[2] - s of signature 
189      * @param _v  v of signature
190      */ 
191     function buyLevel(uint256 _level,bytes32[3] calldata _mrs,uint8 _v) external payable {
192         require(lockStatus == false,"Contract Locked");
193         require(users[msg.sender].isExist,"User not exist"); 
194         require(_level > 0 && _level <= 12,"Incorrect level");
195 
196         if(_level == 1) {
197             require(msg.value == LEVEL_PRICE[1],"Incorrect Value");
198             users[msg.sender].levelExpired[1] =  users[msg.sender].levelExpired[1].add(PERIOD_LENGTH);
199             users[msg.sender].currentLevel = 1;
200         }
201         else {
202             require(msg.value == LEVEL_PRICE[_level],"Incorrect Value");
203             
204             users[msg.sender].currentLevel = _level;
205 
206             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now,"Buy the previous level");
207             
208             if(users[msg.sender].levelExpired[_level] == 0)
209                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
210             else 
211                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
212         }
213        
214        loopCheck[msg.sender] = 0;
215        
216        payForLevel(0,_level, msg.sender,((LEVEL_PRICE[_level].mul(adminFee)).div(10**20)),_mrs,_v,msg.value);
217 
218         emit buyLevelEvent(msg.sender, _level, now);
219     }
220     
221     function payForLevel(uint _flag,uint _level,address _userAddress,uint _adminPrice,bytes32[3] memory _mrs,uint8 _v,uint256 _amt) internal {
222         
223         address[6] memory referer;
224         
225         if(_flag == 0) 
226         {
227             if(_level == 1 || _level == 7) {
228                 referer[0] = userList[users[_userAddress].referrerID];
229             }
230             else if(_level == 2 || _level == 8) {
231                 referer[1] = userList[users[_userAddress].referrerID];
232                 referer[0] = userList[users[referer[1]].referrerID];
233             }
234             else if(_level == 3 || _level == 9) {
235                 referer[1] = userList[users[_userAddress].referrerID];
236                 referer[2] = userList[users[referer[1]].referrerID];
237                 referer[0] = userList[users[referer[2]].referrerID];
238             }
239             else if(_level == 4 || _level == 10) {
240                 referer[1] = userList[users[_userAddress].referrerID];
241                 referer[2] = userList[users[referer[1]].referrerID];
242                 referer[3] = userList[users[referer[2]].referrerID];
243                 referer[0] = userList[users[referer[3]].referrerID];
244             }
245             else if(_level == 5 || _level == 11) {
246                 referer[1] = userList[users[_userAddress].referrerID];
247                 referer[2] = userList[users[referer[1]].referrerID];
248                 referer[3] = userList[users[referer[2]].referrerID];
249                 referer[4] = userList[users[referer[3]].referrerID];
250                 referer[0] = userList[users[referer[4]].referrerID];
251             }
252             else if(_level == 6 || _level == 12) {
253                 referer[1] = userList[users[_userAddress].referrerID];
254                 referer[2] = userList[users[referer[1]].referrerID];
255                 referer[3] = userList[users[referer[2]].referrerID];
256                 referer[4] = userList[users[referer[3]].referrerID];
257                 referer[5] = userList[users[referer[4]].referrerID];
258                 referer[0] = userList[users[referer[5]].referrerID];
259             }
260             
261         }
262         
263         else if(_flag == 1) {
264              referer[0] = userList[users[_userAddress].referrerID];
265         }
266 
267 
268         if(!users[referer[0]].isExist) referer[0] = userList[1];
269         
270         if(loopCheck[msg.sender] >= 12) {
271             referer[0] = userList[1];
272         }
273 
274         
275         if(users[referer[0]].levelExpired[_level] >= now) {
276           
277             uint256 tobeminted = ((_amt).mul(10**18)).div(0.01 ether);
278             
279             // transactions 
280             require((address(uint160(referer[0])).send(LEVEL_PRICE[_level].sub(_adminPrice))) && (address(uint160(ownerAddress)).send(_adminPrice)) &&   Token.mint(msg.sender,tobeminted,_mrs,_v), "Transaction Failure");
281            
282             users[referer[0]].totalEarningEth = users[referer[0]].totalEarningEth.add(LEVEL_PRICE[_level]);
283             EarnedEth[referer[0]][_level] =  EarnedEth[referer[0]][_level].add(LEVEL_PRICE[_level]);
284             
285             emit getMoneyForLevelEvent(msg.sender,users[msg.sender].id,referer[0],users[referer[0]].id, _level, LEVEL_PRICE[_level],now);
286         }
287         
288         else  {
289             if(loopCheck[msg.sender] < 12) {
290                 loopCheck[msg.sender] = loopCheck[msg.sender].add(1);
291                 emit lostMoneyForLevelEvent(msg.sender,users[msg.sender].id,referer[0],users[referer[0]].id, _level, LEVEL_PRICE[_level],now);
292                 payForLevel(1,_level, referer[0],_adminPrice,_mrs,_v,_amt);
293             }
294         }
295     }
296     
297     /**
298      * @dev To get the free Referrer Address
299      * @param _userAddress User address who is already in matrix  (mostly prefer ownerAddress)
300      */ 
301     function findFreeReferrer(address _userAddress) public view returns(address) {
302         if(users[_userAddress].referral.length < referrer1Limit) return _userAddress;
303 
304         address[] memory referrals = new address[](254);
305         referrals[0] = users[_userAddress].referral[0];
306         referrals[1] = users[_userAddress].referral[1];
307 
308         address freeReferrer;
309         bool noFreeReferrer = true;
310 
311         for(uint i = 0; i < 254; i++) { 
312             if(users[referrals[i]].referral.length == referrer1Limit) {
313                 if(i < 126) {
314                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
315                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
316                 }
317             }
318             else {
319                 noFreeReferrer = false;
320                 freeReferrer = referrals[i];
321                 break;
322             }
323         }
324 
325         require(!noFreeReferrer, "No Free Referrer");
326 
327         return freeReferrer;
328     }
329     
330    /**
331      * @dev To view the referrals
332      * @param _userAddress  User who is already in matrix
333      */ 
334     function viewUserReferral(address _userAddress) external view returns(address[] memory) {
335         return users[_userAddress].referral;
336     }
337     
338     /**
339      * @dev To view the level expired time
340      * @param _userAddress  User who is already in matrix
341      * @param _level Level which is wants to view
342      */ 
343     function viewUserLevelExpired(address _userAddress,uint _level) external view returns(uint) {
344         return users[_userAddress].levelExpired[_level];
345     }
346     
347     /**
348      * @dev To lock/unlock the contract
349      * @param _lockStatus  status in bool
350      */ 
351     function contractLock(bool _lockStatus) public returns(bool) {
352         require(msg.sender == ownerAddress, "Invalid User");
353         lockStatus = _lockStatus;
354         return true;
355     }
356     
357     /**
358      * @dev To update the token contract address
359      * @param _newToken  new Token Address 
360      */ 
361     function updateToken(address _newToken) public returns(bool) {
362         require(msg.sender == ownerAddress, "Invalid User");
363         Token = ERC20(_newToken);
364         return true;
365     }
366     
367     /**
368      * @dev To get the total earning ether till now
369      */
370     function getTotalEarnedEther() public view returns(uint) {
371         uint totalEth;
372         
373         for( uint i=1;i<=currentId;i++) {
374             totalEth = totalEth.add(users[userList[i]].totalEarningEth);
375         }
376         
377         return totalEth;
378     }
379     
380     /**
381      * @dev Contract balance withdraw
382      */ 
383     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
384         require(msg.sender == ownerAddress, "only Owner Wallet");
385         require(_toUser != address(0), "Invalid Address");
386         require(address(this).balance >= _amount, "Insufficient balance");
387         (_toUser).transfer(_amount);
388         return true;
389     }
390         
391     //fallback
392     function () external payable {
393         revert("Invalid Transaction");
394     }
395 }