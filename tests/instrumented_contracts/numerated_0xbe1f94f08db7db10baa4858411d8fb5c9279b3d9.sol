1 pragma solidity 0.5.16; 
2 
3 
4 // Owner Handler
5 contract ownerShip    // Auction Contract Owner and OwherShip change
6 {
7     //Global storage declaration
8     address public ownerWallet;
9     address private newOwner;
10     //Event defined for ownership transfered
11     event OwnershipTransferredEv(address indexed previousOwner, address indexed newOwner);
12 
13     //Sets owner only on first run
14     constructor() public 
15     {
16         //Set contract owner
17         ownerWallet = msg.sender;
18         emit OwnershipTransferredEv(address(0), msg.sender);
19     }
20 
21     function transferOwnership(address _newOwner) public onlyOwner 
22     {
23         newOwner = _newOwner;
24     }
25 
26     //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
27     function acceptOwnership() public 
28     {
29         require(msg.sender == newOwner);
30         emit OwnershipTransferredEv(ownerWallet, newOwner);
31         ownerWallet = newOwner;
32         newOwner = address(0);
33     }
34 
35     //This will restrict function only for owner where attached
36     modifier onlyOwner() 
37     {
38         require(msg.sender == ownerWallet);
39         _;
40     }
41 
42 }
43 
44 
45 contract Ethbull is ownerShip {
46 
47 
48     uint maxDownLimit = 2;
49     uint levelLifeTime = 8640000;  // = 100 days;
50     uint public lastIDCount = 0;
51 
52 
53     struct userInfo {
54         bool joined;
55         uint id;
56         uint referrerID;
57         address[] referral;
58         mapping(uint => uint) levelExpired;
59     }
60 
61     mapping(uint => uint) public priceOfLevel;
62 
63     mapping (address => userInfo) public userInfos;
64     mapping (uint => address) public userAddressByID;
65 
66 
67     event regLevelEv(uint indexed _userID, address indexed _userWallet, uint indexed _referrerID, address _refererWallet, uint _originalReferrer, uint _time);
68     event levelBuyEv(address indexed _user, uint _level, uint _amount, uint _time);
69     event paidForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
70     event lostForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
71 
72     constructor() public {
73 
74         priceOfLevel[1] = 0.07 ether;
75         priceOfLevel[2] = 0.1 ether;
76         priceOfLevel[3] = 0.2 ether;
77         priceOfLevel[4] = 0.4 ether;
78         priceOfLevel[5] = 1 ether;
79         priceOfLevel[6] = 2.5 ether;
80         priceOfLevel[7] = 5 ether;
81         priceOfLevel[8] = 10 ether;
82         priceOfLevel[9] = 20 ether;
83         priceOfLevel[10] = 40 ether;
84 
85         userInfo memory UserInfo;
86         lastIDCount++;
87 
88         UserInfo = userInfo({
89             joined: true,
90             id: lastIDCount,
91             referrerID: 0,
92             referral: new address[](0)
93         });
94         userInfos[ownerWallet] = UserInfo;
95         userAddressByID[lastIDCount] = ownerWallet;
96 
97         for(uint i = 1; i <= 10; i++) {
98             userInfos[ownerWallet].levelExpired[i] = 99999999999;
99             emit paidForLevelEv(ownerWallet, address(0), i, priceOfLevel[i], now);
100         }
101         
102         emit regLevelEv(lastIDCount, msg.sender, 0, address(0), 0, now);
103 
104     }
105 
106     function () external payable {
107         uint level;
108 
109         if(msg.value == priceOfLevel[1]) level = 1;
110         else if(msg.value == priceOfLevel[2]) level = 2;
111         else if(msg.value == priceOfLevel[3]) level = 3;
112         else if(msg.value == priceOfLevel[4]) level = 4;
113         else if(msg.value == priceOfLevel[5]) level = 5;
114         else if(msg.value == priceOfLevel[6]) level = 6;
115         else if(msg.value == priceOfLevel[7]) level = 7;
116         else if(msg.value == priceOfLevel[8]) level = 8;
117         else if(msg.value == priceOfLevel[9]) level = 9;
118         else if(msg.value == priceOfLevel[10]) level = 10;
119         else revert('Incorrect Value send');
120 
121         if(userInfos[msg.sender].joined) buyLevel(level);
122         else if(level == 1) {
123             uint refId = 1;
124             address referrer = bytesToAddress(msg.data);
125 
126             if(userInfos[referrer].joined) refId = userInfos[referrer].id;
127 
128             regUser(refId);
129         }
130         else revert('Please buy first level for 0.03 ETH');
131     }
132 
133     function regUser(uint _referrerID) public payable {
134         uint originalReferrerID = _referrerID;
135         require(!userInfos[msg.sender].joined, 'User exist');
136         require(_referrerID > 0 && _referrerID <= lastIDCount, 'Incorrect referrer Id');
137         require(msg.value == priceOfLevel[1], 'Incorrect Value');
138 
139         if(userInfos[userAddressByID[_referrerID]].referral.length >= maxDownLimit) _referrerID = userInfos[findFreeReferrer(userAddressByID[_referrerID])].id;
140 
141         userInfo memory UserInfo;
142         lastIDCount++;
143 
144         UserInfo = userInfo({
145             joined: true,
146             id: lastIDCount,
147             referrerID: _referrerID,
148             referral: new address[](0)
149         });
150 
151         userInfos[msg.sender] = UserInfo;
152         userAddressByID[lastIDCount] = msg.sender;
153 
154         userInfos[msg.sender].levelExpired[1] = now + levelLifeTime;
155 
156         userInfos[userAddressByID[_referrerID]].referral.push(msg.sender);
157 
158         payForLevel(1, msg.sender);
159 
160         emit regLevelEv(lastIDCount, msg.sender, _referrerID, userAddressByID[_referrerID], originalReferrerID, now);
161         emit levelBuyEv(msg.sender, 1, msg.value, now);
162     }
163 
164     function buyLevel(uint _level) public payable {
165         require(userInfos[msg.sender].joined, 'User not exist'); 
166         require(_level > 0 && _level <= 10, 'Incorrect level');
167         
168         //owner can buy levels without paying anything
169         if(msg.sender!=ownerWallet){
170             require(msg.value == priceOfLevel[_level], 'Incorrect Value');
171         }
172         
173         if(_level == 1) {
174             userInfos[msg.sender].levelExpired[1] += levelLifeTime;
175         }
176         else {
177             
178             for(uint l =_level - 1; l > 0; l--) require(userInfos[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
179 
180             if(userInfos[msg.sender].levelExpired[_level] == 0) userInfos[msg.sender].levelExpired[_level] = now + levelLifeTime;
181             else userInfos[msg.sender].levelExpired[_level] += levelLifeTime;
182         }
183 
184         payForLevel(_level, msg.sender);
185 
186         emit levelBuyEv(msg.sender, _level, msg.value, now);
187     }
188     
189 
190     function payForLevel(uint _level, address _user) internal {
191         address referer;
192         address referer1;
193         address referer2;
194         address referer3;
195         address referer4;
196 
197         if(_level == 1 || _level == 6) {
198             referer = userAddressByID[userInfos[_user].referrerID];
199         }
200         else if(_level == 2 || _level == 7) {
201             referer1 = userAddressByID[userInfos[_user].referrerID];
202             referer = userAddressByID[userInfos[referer1].referrerID];
203         }
204         else if(_level == 3 || _level == 8) {
205             referer1 = userAddressByID[userInfos[_user].referrerID];
206             referer2 = userAddressByID[userInfos[referer1].referrerID];
207             referer = userAddressByID[userInfos[referer2].referrerID];
208         }
209         else if(_level == 4 || _level == 9) {
210             referer1 = userAddressByID[userInfos[_user].referrerID];
211             referer2 = userAddressByID[userInfos[referer1].referrerID];
212             referer3 = userAddressByID[userInfos[referer2].referrerID];
213             referer = userAddressByID[userInfos[referer3].referrerID];
214         }
215         else if(_level == 5 || _level == 10) {
216             referer1 = userAddressByID[userInfos[_user].referrerID];
217             referer2 = userAddressByID[userInfos[referer1].referrerID];
218             referer3 = userAddressByID[userInfos[referer2].referrerID];
219             referer4 = userAddressByID[userInfos[referer3].referrerID];
220             referer = userAddressByID[userInfos[referer4].referrerID];
221         }
222 
223         if(!userInfos[referer].joined) referer = userAddressByID[1];
224 
225         bool sent = false;
226         if(userInfos[referer].levelExpired[_level] >= now) {
227             sent = address(uint160(referer)).send(priceOfLevel[_level]);
228 
229             if (sent) {
230                 emit paidForLevelEv(referer, msg.sender, _level, msg.value, now);
231             }
232         }
233         if(!sent) {
234             emit lostForLevelEv(referer, msg.sender, _level, msg.value, now);
235 
236             payForLevel(_level, referer);
237         }
238     }
239 
240     function findFreeReferrer(address _user) public view returns(address) {
241         if(userInfos[_user].referral.length < maxDownLimit) return _user;
242 
243         address[] memory referrals = new address[](126);
244         referrals[0] = userInfos[_user].referral[0];
245         referrals[1] = userInfos[_user].referral[1];
246 
247         address freeReferrer;
248         bool noFreeReferrer = true;
249 
250         for(uint i = 0; i < 126; i++) {
251             if(userInfos[referrals[i]].referral.length == maxDownLimit) {
252                 if(i < 62) {
253                     referrals[(i+1)*2] = userInfos[referrals[i]].referral[0];
254                     referrals[(i+1)*2+1] = userInfos[referrals[i]].referral[1];
255                 }
256             }
257             else {
258                 noFreeReferrer = false;
259                 freeReferrer = referrals[i];
260                 break;
261             }
262         }
263 
264         require(!noFreeReferrer, 'No Free Referrer');
265 
266         return freeReferrer;
267     }
268 
269     function viewUserReferral(address _user) public view returns(address[] memory) {
270         return userInfos[_user].referral;
271     }
272 
273     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
274         return userInfos[_user].levelExpired[_level];
275     }
276 
277     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
278         assembly {
279             addr := mload(add(bys, 20))
280         }
281     }
282     
283     function viewTimestampSinceJoined(address usr) public view returns(uint256[10] memory timeSinceJoined )
284     {
285         if(userInfos[usr].joined)
286         {
287             for(uint256 i=0;i<10;i++)
288             {
289                 uint256 t = userInfos[usr].levelExpired[i+1];
290                 if(t>now)
291                 {
292                     timeSinceJoined[i] = (t-now);
293                 }
294             }
295         }
296         return timeSinceJoined;
297     }
298     
299 }