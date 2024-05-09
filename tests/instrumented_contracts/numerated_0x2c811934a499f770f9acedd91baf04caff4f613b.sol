1 pragma solidity 0.5.16; /*
2 
3     
4     
5     ███████╗████████╗██╗  ██╗     ██████╗  ██████╗            ██╗  ██╗██╗   ██╗███████╗
6     ██╔════╝╚══██╔══╝██║  ██║    ██╔════╝ ██╔═══██╗           ╚██╗██╔╝╚██╗ ██╔╝╚══███╔╝
7     █████╗     ██║   ███████║    ██║  ███╗██║   ██║            ╚███╔╝  ╚████╔╝   ███╔╝ 
8     ██╔══╝     ██║   ██╔══██║    ██║   ██║██║   ██║            ██╔██╗   ╚██╔╝   ███╔╝  
9     ███████╗   ██║   ██║  ██║    ╚██████╔╝╚██████╔╝    ██╗    ██╔╝ ██╗   ██║   ███████╗
10     ╚══════╝   ╚═╝   ╚═╝  ╚═╝     ╚═════╝  ╚═════╝     ╚═╝    ╚═╝  ╚═╝   ╚═╝   ╚══════╝
11                                                                                        
12 
13   
14 */
15 
16 
17 // Owner Handler
18 contract ownerShip    // Auction Contract Owner and OwherShip change
19 {
20     //Global storage declaration
21     address payable public ownerWallet;
22     address payable public newOwner;
23     //Event defined for ownership transfered
24     event OwnershipTransferredEv(address indexed previousOwner, address indexed newOwner);
25 
26     //Sets owner only on first run
27     constructor() public 
28     {
29         //Set contract owner
30         ownerWallet = msg.sender;
31     }
32 
33     function transferOwnership(address payable _newOwner) public onlyOwner 
34     {
35         newOwner = _newOwner;
36     }
37 
38     //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
39     function acceptOwnership() public 
40     {
41         require(msg.sender == newOwner);
42         emit OwnershipTransferredEv(ownerWallet, newOwner);
43         ownerWallet = newOwner;
44         newOwner = address(0);
45     }
46 
47     //This will restrict function only for owner where attached
48     modifier onlyOwner() 
49     {
50         require(msg.sender == ownerWallet);
51         _;
52     }
53 
54 }
55 
56 
57 contract ethGO is ownerShip {
58 
59     uint public defaultRefID = 1;   //this ref ID will be used if user joins without any ref ID
60     uint public constant maxDownLimit = 2;
61     uint public constant levelLifeTime = 3888000;  // = 45 days;
62     uint public lastIDCount = 0;
63 
64     struct userInfo {
65         bool joined;
66         uint id;
67         uint referrerID;
68         uint originalReferer;
69         address[] referral;
70         mapping(uint => uint) levelExpired;
71     }
72 
73     mapping(uint => uint) public priceOfLevel;
74 
75     mapping (address => userInfo) public userInfos;
76     mapping (uint => address) public userAddressByID;
77 
78 
79     event regLevelEv(uint indexed _userID, address indexed _userWallet, uint indexed _referrerID, address _refererWallet, uint _originalReferrer, uint _time);
80     event levelBuyEv(address indexed _user, uint _level, uint _amount, uint _time);
81     event paidForLevelEv(uint userID, address indexed _user, uint referralID, address indexed _referral, uint _level, uint _amount, uint _time);
82     event lostForLevelEv(uint userID, address indexed _user, uint referralID, address indexed _referral, uint _level, uint _amount, uint _time);
83 
84     constructor() public {
85 
86         priceOfLevel[1] = 0.2 ether;
87         priceOfLevel[2] = 0.4 ether;
88         priceOfLevel[3] = 0.8 ether;
89         priceOfLevel[4] = 1.6 ether;
90         priceOfLevel[5] = 3.2 ether;
91         priceOfLevel[6] = 6.4 ether;
92         priceOfLevel[7] = 12.8 ether;
93         priceOfLevel[8] = 25.6 ether;
94 
95         userInfo memory UserInfo;
96         lastIDCount++;
97 
98         UserInfo = userInfo({
99             joined: true,
100             id: lastIDCount,
101             referrerID: 0,
102             originalReferer:0,
103             referral: new address[](0)
104         });
105         userInfos[ownerWallet] = UserInfo;
106         userAddressByID[lastIDCount] = ownerWallet;
107 
108         for(uint i = 1; i <= 8; i++) {
109             userInfos[ownerWallet].levelExpired[i] = 99999999999;
110             emit paidForLevelEv(lastIDCount, ownerWallet, 0, address(0), i, priceOfLevel[i], now);
111         }
112         
113         emit regLevelEv(lastIDCount, msg.sender, 0, address(0), 0, now);
114     }
115     
116     function () external payable {
117         uint level;
118 
119         if(msg.value == priceOfLevel[1]) level = 1;
120         else if(msg.value == priceOfLevel[2]) level = 2;
121         else if(msg.value == priceOfLevel[3]) level = 3;
122         else if(msg.value == priceOfLevel[4]) level = 4;
123         else if(msg.value == priceOfLevel[5]) level = 5;
124         else if(msg.value == priceOfLevel[6]) level = 6;
125         else if(msg.value == priceOfLevel[7]) level = 7;
126         else if(msg.value == priceOfLevel[8]) level = 8;
127         else revert('Incorrect Value send');
128 
129         if(userInfos[msg.sender].joined) buyLevel(msg.sender, level);
130         else if(level == 1) {
131             uint refId = 0;
132             address referrer = bytesToAddress(msg.data);
133 
134             if(userInfos[referrer].joined) refId = userInfos[referrer].id;
135             else revert('Incorrect referrer');
136 
137             regUser(msg.sender, refId);
138         }
139         else revert('Please buy first level for 0.2 ETH');
140     }
141 
142     function regUser(address _user, uint _referrerID) public payable returns(bool) {
143         if(!(_referrerID > 0 && _referrerID <= lastIDCount)) _referrerID = defaultRefID;
144         uint originalReferer = _referrerID;
145         require(!userInfos[_user].joined, 'User exist');
146         
147         
148         
149         
150         if(userInfos[userAddressByID[_referrerID]].referral.length >= maxDownLimit) _referrerID = userInfos[findFreeReferrer(userAddressByID[_referrerID])].id;
151 
152         userInfo memory UserInfo;
153         lastIDCount++;
154 
155         UserInfo = userInfo({
156             joined: true,
157             id: lastIDCount,
158             referrerID: _referrerID,
159             originalReferer: originalReferer,
160             referral: new address[](0)
161         });
162 
163         userInfos[_user] = UserInfo;
164         userAddressByID[lastIDCount] = _user;
165 
166         userInfos[_user].levelExpired[1] = now + levelLifeTime;
167 
168         userInfos[userAddressByID[_referrerID]].referral.push(_user);
169 
170         //owner can buy levels without paying anything
171         if(msg.sender!=ownerWallet){
172             require(msg.value == priceOfLevel[1], 'Incorrect Value');
173             require(msg.sender == _user, 'Invalid user');
174             payForCycle(1, _user);  //it won't pay to uplines as this position is placed without paying anything.
175         }
176 
177         emit regLevelEv(lastIDCount, _user, _referrerID, userAddressByID[_referrerID], originalReferer, now);
178         return true;
179     }
180 
181     function buyLevel(address _user, uint _level) public payable {
182         require(userInfos[_user].joined, 'User not exist'); 
183         require(_level > 0 && _level <= 10, 'Incorrect level');
184         
185         
186         
187         
188         
189 
190         if(_level == 1) {
191             userInfos[_user].levelExpired[1] += levelLifeTime;
192         }
193         else {
194             
195 
196             for(uint l =_level - 1; l > 0; l--) require(userInfos[_user].levelExpired[l] >= now, 'Buy the previous level');
197 
198             if(userInfos[_user].levelExpired[_level] == 0) userInfos[_user].levelExpired[_level] = now + levelLifeTime;
199             else userInfos[_user].levelExpired[_level] += levelLifeTime;
200         }
201         
202         //owner can buy levels without paying anything
203         if(msg.sender!=ownerWallet){
204             require(msg.value == priceOfLevel[_level], 'Incorrect Value');
205             require(msg.sender == _user, 'Invalid user');
206             payForCycle(_level, _user);  //it won't pay to uplines as this position is placed without paying anything.
207         }
208 
209         emit levelBuyEv(_user, _level, msg.value, now);
210     }
211     
212 
213     function payForCycle(uint _level, address _user) internal {
214         address referer;
215         address referer1;
216         address def = userAddressByID[defaultRefID];
217         uint256 price = priceOfLevel[_level] * 4500 / 10000;
218         uint256 adminPart = price * 10000 / 45000;
219 
220         referer = findValidUpline(_user, _level);
221         referer1 = findValidUpline(referer, _level);
222 
223         if(!userInfos[referer].joined) 
224         {
225             address(uint160(def)).transfer(price);
226             emit lostForLevelEv(userInfos[referer].id, referer, userInfos[_user].id, _user, _level, price, now);
227         }
228         else
229         {
230             address(uint160(referer)).transfer(price);
231             emit paidForLevelEv(userInfos[referer].id, referer, userInfos[_user].id, _user, _level, price, now);
232         }
233 
234         if(!userInfos[referer1].joined  || !(userInfos[_user].levelExpired[_level] >= now ) ) 
235         {
236             address(uint160(def)).transfer(price);
237             emit lostForLevelEv(userInfos[referer1].id, referer1, userInfos[_user].id, _user, _level, price, now);
238         }
239         else
240         {
241             address(uint160(referer1)).transfer(price);
242             emit paidForLevelEv(userInfos[referer1].id, referer1, userInfos[_user].id, _user, _level, price, now);
243         }
244         ownerWallet.transfer(adminPart);
245     }
246 
247     function findValidUpline(address _user, uint _level) internal returns(address)
248     {
249         for(uint i=0;i<64;i++)
250         {
251            _user = userAddressByID[userInfos[_user].referrerID];
252            if(userInfos[_user].levelExpired[_level] >= now ) break;
253         }
254         if(!(userInfos[_user].levelExpired[_level] >= now ))  userAddressByID[defaultRefID];
255         return _user;
256     }
257 
258 
259 
260     function findFreeReferrer(address _user) public view returns(address) {
261         if(userInfos[_user].referral.length < maxDownLimit) return _user;
262 
263         address[] memory referrals = new address[](126);
264         referrals[0] = userInfos[_user].referral[0];
265         referrals[1] = userInfos[_user].referral[1];
266 
267         address freeReferrer;
268         bool noFreeReferrer = true;
269 
270         for(uint i = 0; i < 126; i++) {
271             if(userInfos[referrals[i]].referral.length == maxDownLimit) {
272                 if(i < 62) {
273                     referrals[(i+1)*2] = userInfos[referrals[i]].referral[0];
274                     referrals[(i+1)*2+1] = userInfos[referrals[i]].referral[1];
275                 }
276             }
277             else {
278                 noFreeReferrer = false;
279                 freeReferrer = referrals[i];
280                 break;
281             }
282         }
283 
284         require(!noFreeReferrer, 'No Free Referrer');
285 
286         return freeReferrer;
287     }
288 
289     function viewUserReferral(address _user) public view returns(address[] memory) {
290         return userInfos[_user].referral;
291     }
292 
293     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
294         return userInfos[_user].levelExpired[_level];
295     }
296 
297     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
298         assembly {
299             addr := mload(add(bys, 20))
300         }
301     }
302 
303         
304     function changeDefaultRefID(uint newDefaultRefID) onlyOwner public returns(string memory){
305         //this ref ID will be assigned to user who joins without any referral ID.
306         defaultRefID = newDefaultRefID;
307         return("Default Ref ID updated successfully");
308     }
309     
310     function viewTimestampSinceJoined(address usr) public view returns(uint256[8] memory timeSinceJoined )
311     {
312         if(userInfos[usr].joined)
313         {
314             for(uint256 i=0;i<8;i++)
315             {
316                 uint256 t = userInfos[usr].levelExpired[i+1];
317                 if(t>now)
318                 {
319                     timeSinceJoined[i] = (t-now);
320                 }
321             }
322         }
323         return timeSinceJoined;
324     }
325     
326     function ownerOnlyCreateUser(address[] memory _user ) public onlyOwner returns(bool)
327     {
328         require(_user.length <= 50, "invalid input");
329         for(uint i=0; i < _user.length; i++ )
330         {
331             require(regUser(_user[i], 1),"registration fail");
332         }
333         return true;
334     }
335     
336 }