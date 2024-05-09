1 pragma solidity 0.5.16;
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
39 contract EEEMoney{
40     // SafeMath
41     using SafeMath for uint;
42     
43     // User struct
44     struct UserStruct {
45         bool isExist;
46         uint id;
47         uint referrerID;
48         uint totalEarnedETH;
49         uint previousShare;
50         uint sharesHoldings;
51         uint directShare;
52         uint referralShare;
53         uint poolHoldings;
54         uint created;
55         address[] referral;
56     }
57     
58     // Public variables
59     address public ownerWallet;
60     address public splitOverWallet;
61     uint public poolMoney;
62     uint public qualifiedPoolHolding = 0.5 ether;
63     uint public invest = 0.25 ether;
64     uint public feePercentage = 0.0125 ether; 
65     uint public currUserID = 0;
66     uint public qualify = 86400;
67     bool public lockStatus;
68     
69     // Mapping
70     mapping(address => UserStruct) public users;
71     mapping(address => uint) public userMoney;
72     mapping (uint => address) public userList;
73     
74     // Events
75     event regEvent(address indexed _user, address indexed _referrer, uint _time);
76     event poolMoneyEvent(address indexed _user, uint _money, uint _time);
77     event splitOverEvent(address indexed _user, uint _shareAmount, uint _userShares, uint _money, uint _time);
78     event userInversement(address indexed _user, uint _noOfShares, uint _amount, uint _time, uint investType);
79     event userWalletTransferEvent(address indexed _user, uint _amount, uint _percentage, uint _gasFee, uint _time);
80     event ownerWalletTransferEvent(address indexed _user, uint _percentage, uint _gasFee, uint _time);
81     
82     // On Deploy
83     constructor(address _splitOverWallet)public{
84         ownerWallet = msg.sender;
85         splitOverWallet = _splitOverWallet;
86         
87         UserStruct memory userStruct;
88         currUserID++;
89         
90         userStruct = UserStruct({
91             isExist: true,
92             id: currUserID,
93             referrerID: 0,
94             totalEarnedETH: 0,
95             previousShare: 0,
96             sharesHoldings: 1000,
97             directShare: 0,
98             referralShare: 0,
99             poolHoldings: 0,
100             created:now.add(qualify),
101             referral: new address[](0)
102         });
103         users[ownerWallet] = userStruct;
104         userList[currUserID] = ownerWallet;
105     }
106     
107     /**
108      * @dev Fallback
109      */ 
110     function () external payable {
111         revert("Invalid Transaction");
112     }
113     
114     /**
115      * @dev To register the User
116      * @param _referrerID id of user/referrer 
117      */
118     function regUser(uint _referrerID) public payable returns(bool){
119         require(
120             lockStatus == false,
121             "Contract is locked"
122         );
123         require(
124             !users[msg.sender].isExist,
125             "User exist"
126         );
127         require(
128             _referrerID > 0 && _referrerID <= currUserID,
129             "Incorrect referrer Id"
130         );
131         require(
132             msg.value == invest,
133             "Incorrect Value"
134         );
135         
136         UserStruct memory userStruct;
137         currUserID++;
138 
139         userStruct = UserStruct({
140             isExist: true,
141             id: currUserID,
142             referrerID: _referrerID,
143             totalEarnedETH: 0,
144             previousShare: 0,
145             sharesHoldings: 1,
146             directShare: 0,
147             referralShare: 0,
148             poolHoldings: 0,
149             created:now.add(qualify),
150             referral: new address[](0)
151         });
152 
153         users[msg.sender] = userStruct;
154         userList[currUserID] = msg.sender;
155         
156         users[userList[_referrerID]].sharesHoldings = users[userList[_referrerID]].sharesHoldings.add(1);
157         users[userList[_referrerID]].referralShare = users[userList[_referrerID]].referralShare.add(1);
158         users[userList[_referrerID]].referral.push(msg.sender);
159     
160         uint _value = invest.div(2);
161         
162         require(
163             address(uint160(userList[_referrerID])).send(_value),
164             "Transaction failed"
165         );
166         users[userList[_referrerID]].totalEarnedETH = users[userList[_referrerID]].totalEarnedETH.add(_value);
167         
168         poolMoney = poolMoney.add(_value);
169         
170         emit poolMoneyEvent( msg.sender, _value, now);
171         emit regEvent(msg.sender, userList[_referrerID], now);
172         
173         return true;
174     }
175 
176     /**
177      * @dev To invest on shares
178      * @param _noOfShares No of shares 
179      */
180     function investOnShare(uint _noOfShares) public payable returns(bool){
181         require(
182             lockStatus == false,
183             "Contract is locked"
184         );
185         require(
186             users[msg.sender].isExist,
187             "User not exist"
188         );
189         require(
190             msg.value == invest.mul(_noOfShares),
191             "Incorrect Value"
192         );
193         
194         uint _value = (msg.value).div(2);
195         address _referer = userList[users[msg.sender].referrerID];
196         require(
197             address(uint160(_referer)).send(_value),
198             "Transaction failed"
199         ); 
200         
201         users[_referer].totalEarnedETH = users[_referer].totalEarnedETH.add(_value);
202         
203         users[msg.sender].directShare = users[msg.sender].directShare.add(_noOfShares);
204         users[msg.sender].sharesHoldings = users[msg.sender].sharesHoldings.add(_noOfShares);
205         
206         poolMoney = poolMoney.add(_value);
207         
208         emit poolMoneyEvent( msg.sender, _value, now);
209         emit userInversement( msg.sender, _noOfShares, msg.value, now, 1);
210         
211         return true;
212     }
213     
214     /**
215      * @dev To splitOver pool money
216      * @param _gasFee Gas fee 
217      */
218     function splitOver(uint _gasFee) public returns(bool){
219         require(
220            splitOverWallet == msg.sender,
221             "Invalid splitOverWallet"
222         );
223         require(
224             poolMoney > 0,
225             "pool money is zero"
226         );
227         uint _totalShare = getQualfiedUsers(1, 0);
228         uint shareAmount = poolMoney.div(_totalShare);
229         
230         sendSplitShares( 1, shareAmount, _gasFee);
231         
232         return true;
233     }
234     
235     /**
236      * @dev Contract balance withdraw
237      * @param _toUser  receiver addrress
238      * @param _amount  withdraw amount
239      */ 
240     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
241         require(msg.sender == ownerWallet, "Only Owner Wallet");
242         require(_toUser != address(0), "Invalid Address");
243         require(address(this).balance >= _amount, "Insufficient balance");
244 
245         (_toUser).transfer(_amount);
246         return true;
247     }
248 
249     /**
250      * @dev To lock/unlock the contract
251      * @param _lockStatus  status in bool
252      */
253     function contractLock(bool _lockStatus) public returns (bool) {
254         require(msg.sender == ownerWallet, "Invalid ownerWallet");
255 
256         lockStatus = _lockStatus;
257         return true;
258     }
259     
260     /**
261      * @dev To get qualified user
262      * @param _userIndex  User ID 
263      * @param _totalShare  Users total share
264      */ 
265     function getQualfiedUsers(uint _userIndex, uint _totalShare) public view returns(uint){
266         address _userAddress = userList[_userIndex];
267         if((users[_userAddress].sharesHoldings > users[_userAddress].previousShare) && (users[_userAddress].created < now)){
268            _totalShare = _totalShare.add((users[_userAddress].sharesHoldings.sub(users[_userAddress].previousShare)));
269            
270         }
271         _userIndex++;
272         if(_userIndex <= currUserID){
273            return this.getQualfiedUsers(_userIndex, _totalShare);
274         }
275         else{
276             return _totalShare;
277         }
278     }
279     
280     /**
281      * @dev To view the referrals
282      * @param _user  User address
283      */ 
284     function viewUserReferral(address _user) public view returns(address[] memory) {
285         return users[_user].referral;
286     }
287     
288     function getTotalEarnedEther() public view returns(uint) {
289         uint totalEth;
290         
291         for( uint _userIndex=1;_userIndex<= currUserID;_userIndex++) {
292             totalEth = totalEth.add(users[userList[_userIndex]].totalEarnedETH);
293         }
294         
295         return totalEth;
296     }
297     
298     function sendSplitShares(uint _userIndex, uint _shareAmount, uint _gasFee) internal {
299         
300         address _userAddress = userList[_userIndex];
301         if((users[_userAddress].sharesHoldings > users[_userAddress].previousShare) && (users[_userAddress].created < now)){
302             uint _shares = users[_userAddress].sharesHoldings.sub(users[_userAddress].previousShare);
303             uint _userShareAmount = _shareAmount.mul(_shares);
304             
305             poolMoney = poolMoney.sub(_userShareAmount);
306             users[_userAddress].poolHoldings = users[_userAddress].poolHoldings.add(_userShareAmount);
307             users[_userAddress].previousShare = users[_userAddress].sharesHoldings;
308             
309             if(users[_userAddress].poolHoldings >= qualifiedPoolHolding){
310                 // re-Inversement
311                 reInvest(_userAddress, _gasFee);
312             }
313             
314             
315             emit splitOverEvent( _userAddress, _shareAmount, _shares, _userShareAmount, now);
316             
317             
318         }
319         _userIndex++;
320         if(_userIndex <= currUserID){
321             sendSplitShares(_userIndex, _shareAmount, _gasFee);
322         }
323         
324     }
325     
326     function reInvest(address _userAddress, uint _gasFee) internal returns(bool) {
327         
328         uint _totalInvestingShare = users[_userAddress].poolHoldings.div(qualifiedPoolHolding);
329         uint _referervalue = invest.div(2);
330         uint _value = (_referervalue.mul(_totalInvestingShare));
331         
332         address _referer = userList[users[_userAddress].referrerID];
333 
334         uint adminFee = feePercentage.mul(2);
335         uint gasFee = _gasFee.mul(2);
336         
337         if(_referer == address(0))
338             _referer = userList[1];
339         
340         require(
341             address(uint160(_referer)).send(_value),
342             "re-inverset referer 50 percentage failed"
343         );
344         
345         users[_referer].totalEarnedETH = users[_referer].totalEarnedETH.add(_value);
346         
347         users[_userAddress].directShare = users[_userAddress].directShare.add(_totalInvestingShare);
348         users[_userAddress].sharesHoldings = users[_userAddress].sharesHoldings.add(_totalInvestingShare);
349         
350         poolMoney = poolMoney.add(_value);
351         
352         // wallet
353         uint _walletAmount = invest.mul(_totalInvestingShare);
354         _walletAmount = _walletAmount.sub(adminFee.add(gasFee));
355         
356         require(
357             address(uint160(_userAddress)).send(_walletAmount) &&
358             address(uint160(ownerWallet)).send(adminFee.add(gasFee)),
359             "user wallet transfer failed"
360         );  
361         
362         users[_userAddress].poolHoldings = users[_userAddress].poolHoldings.sub(qualifiedPoolHolding.mul(_totalInvestingShare));
363         
364         emit userInversement( _userAddress, _totalInvestingShare, invest.mul(_totalInvestingShare), now, 2);
365         emit poolMoneyEvent( _userAddress, _value, now);
366         emit userWalletTransferEvent(_userAddress, _walletAmount, adminFee, gasFee, now);
367         emit ownerWalletTransferEvent(_userAddress, adminFee, gasFee, now);
368         
369         return true;
370     }
371     
372 }