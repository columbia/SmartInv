1 /*
2 
3 ___________________________________________________________________
4   _      _                                        ______           
5   |  |  /          /                                /              
6 --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7   |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
8 __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10     
11     
12      ██████╗ ██████╗     ██████╗  █████╗ ██╗     
13     ██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗██║     
14     ██║   ██║██████╔╝    ██████╔╝███████║██║     
15     ██║▄▄ ██║██╔══██╗    ██╔═══╝ ██╔══██║██║     
16     ╚██████╔╝██║  ██║    ██║     ██║  ██║███████╗
17      ╚══▀▀═╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝╚══════╝
18                                                  
19 
20 
21 -------------------------------------------------------------------
22  Copyright (c) 2020 onwards QR PAL Inc. ( https://qrpal.money )
23 -------------------------------------------------------------------
24 
25 */
26 
27 pragma solidity 0.5.16; 
28 
29 
30 // Owner Handler
31 contract ownerShip    // Auction Contract Owner and OwherShip change
32 {
33     //Global storage declaration
34     address public ownerWallet;
35     address public newOwner;
36     //Event defined for ownership transfered
37     event OwnershipTransferredEv(address indexed previousOwner, address indexed newOwner);
38 
39     //Sets owner only on first run
40     constructor() public 
41     {
42         //Set contract owner
43         ownerWallet = msg.sender;
44         emit OwnershipTransferredEv(address(0), msg.sender);
45     }
46 
47     function transferOwnership(address _newOwner) external onlyOwner 
48     {
49         newOwner = _newOwner;
50     }
51 
52     //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
53     function acceptOwnership() external 
54     {
55         require(msg.sender == newOwner);
56         emit OwnershipTransferredEv(ownerWallet, newOwner);
57         ownerWallet = newOwner;
58         newOwner = address(0);
59     }
60 
61     //This will restrict function only for owner where attached
62     modifier onlyOwner() 
63     {
64         require(msg.sender == ownerWallet);
65         _;
66     }
67 
68 }
69 
70 
71 
72 interface usdtInterface
73 {
74     function transfer(address _to, uint256 _amount) external returns(bool);
75     function transferFrom(address _from, address _to, uint256 _amount) external returns(bool);    
76 }
77 
78 interface multiadminInterface
79 {
80     function payamount(uint256 _amount) external;
81     function partner(address _add) external view returns(uint256);
82 }
83 
84 
85 
86 contract QRPal is ownerShip {
87 
88     //public variables
89     uint public maxDownLimit = 2;
90     uint public levelLifeTime = 8640000;  // = 100 days;
91     uint public lastIDCount = 0;
92     address public usdtTokenAddress;
93 
94     struct userInfo {
95         bool joined;
96         uint id;
97         uint referrerID;
98         address[] referral;
99         mapping(uint => uint) levelExpired;
100     }
101 
102     mapping(uint => uint) public priceOfLevel;
103     mapping (address => userInfo) public userInfos;
104     mapping (uint => address) public userAddressByID;
105     
106     address public multiadminaddress;
107 
108 
109     //events
110     event regLevelEv(uint indexed _userID, address indexed _userWallet, uint indexed _referrerID, address _refererWallet, uint _originalReferrer, uint _time);
111     event levelBuyEv(address indexed _user, uint _level, uint _amount, uint _time);
112     event paidForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
113     event lostForLevelEv(address indexed _user, address indexed _referral, uint _level, uint _amount, uint _time);
114     
115     /**
116      * constructor makes all the levels upgraded of ID 1 - owner
117      */
118     constructor(address _usdtTokenAddress, address _multiadminAddress) public {
119         require(_usdtTokenAddress!=address(0));
120         require(_multiadminAddress!=address(0));
121         
122         usdtTokenAddress = _usdtTokenAddress;
123         multiadminaddress=_multiadminAddress;
124         
125         
126         priceOfLevel[1] = 2999*(10**16);//PAX
127         priceOfLevel[2] = 4499*(10**16);//PAX
128         priceOfLevel[3] = 8997*(10**16);//PAX
129         priceOfLevel[4] = 26991*(10**16);//PAX
130         priceOfLevel[5] = 131956*(10**16);//PAX
131         priceOfLevel[6] = 923692*(10**16);//PAX
132         priceOfLevel[7] = 1247584*(10**16);//PAX
133         priceOfLevel[8] = 1991336*(10**16);//PAX
134         priceOfLevel[9] = 2435188*(10**16);//PAX
135         priceOfLevel[10] = 4444518*(10**16);//PAX
136 
137         userInfo memory UserInfo;
138         lastIDCount++;
139 
140         UserInfo = userInfo({
141             joined: true,
142             id: lastIDCount,
143             referrerID: 0,
144             referral: new address[](0)
145         });
146         userInfos[multiadminaddress] = UserInfo;
147         userAddressByID[lastIDCount] = multiadminaddress;
148 
149         for(uint i = 1; i <= 10; i++) {
150             userInfos[multiadminaddress].levelExpired[i] = 99999999999;
151             emit paidForLevelEv(multiadminaddress, address(0), i, priceOfLevel[i], now);
152         }
153         
154         emit regLevelEv(lastIDCount, multiadminaddress, 0, address(0), 0, now);
155 
156     }
157     
158     
159     /**
160      * no incoming ether, as all process happening in USDT
161      */
162     function () external payable {
163         revert();
164     }
165     
166     
167     /**
168      * This function register the user in the system. He has to provide referrer ID.
169      * User should have USDT balance as well approval of this smart contract in order for this function to work.
170      */
171     function regUser(uint _referrerID) external {
172         uint originalReferrerID = _referrerID;
173         require(!userInfos[msg.sender].joined, 'User exist');
174         require(_referrerID > 0 && _referrerID <= lastIDCount, 'Incorrect referrer Id');
175         //require(msg.value == priceOfLevel[1], 'Incorrect Value');
176 
177         if(userInfos[userAddressByID[_referrerID]].referral.length >= maxDownLimit) _referrerID = userInfos[findFreeReferrer(userAddressByID[_referrerID])].id;
178 
179         userInfo memory UserInfo;
180         lastIDCount++;
181 
182         UserInfo = userInfo({
183             joined: true,
184             id: lastIDCount,
185             referrerID: _referrerID,
186             referral: new address[](0)
187         });
188 
189         userInfos[msg.sender] = UserInfo;
190         userAddressByID[lastIDCount] = msg.sender;
191 
192         userInfos[msg.sender].levelExpired[1] = now + levelLifeTime;
193 
194         userInfos[userAddressByID[_referrerID]].referral.push(msg.sender);
195 
196         payForLevel(1, msg.sender);
197 
198         emit regLevelEv(lastIDCount, msg.sender, _referrerID, userAddressByID[_referrerID], originalReferrerID, now);
199         emit levelBuyEv(msg.sender, 1, priceOfLevel[1], now);
200     }
201     
202     
203     /**
204      * This function to buy any level. User has to specify level number to buy it.
205      * User should have USDT balance as well approval of this smart contract in order for this function to work.
206      */
207     function buyLevel(uint _level) external returns(bool) {
208         require(userInfos[msg.sender].joined, 'User not exist'); 
209         require(_level > 0 && _level <= 10, 'Incorrect level');
210         
211         //owner can buy levels without paying anything
212        
213         
214         if(_level == 1) {
215             userInfos[msg.sender].levelExpired[1] += levelLifeTime;
216         }
217         else {
218             
219             for(uint l =_level - 1; l > 0; l--) require(userInfos[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
220 
221             if(userInfos[msg.sender].levelExpired[_level] == 0) userInfos[msg.sender].levelExpired[_level] = now + levelLifeTime;
222             else userInfos[msg.sender].levelExpired[_level] += levelLifeTime;
223         }
224 
225         payForLevel(_level, msg.sender);
226 
227         emit levelBuyEv(msg.sender, _level, priceOfLevel[_level], now);
228         return true;
229     }
230     
231     
232     /**
233      * Internal function to which distributes fund.
234      */
235     function payForLevel(uint _level, address _user) internal {
236         
237         if(multiadminInterface(multiadminaddress).partner(_user)!=0)
238         {
239             emit paidForLevelEv(ownerWallet, _user, _level, 0, now);
240         }
241         else
242         {
243             address referer;
244             address referer1;
245             address referer2;
246             address referer3;
247             address referer4;
248     
249             if(_level == 1 || _level == 6) {
250                 referer = userAddressByID[userInfos[_user].referrerID];
251             }
252             else if(_level == 2 || _level == 7) {
253                 referer1 = userAddressByID[userInfos[_user].referrerID];
254                 referer = userAddressByID[userInfos[referer1].referrerID];
255             }
256             else if(_level == 3 || _level == 8) {
257                 referer1 = userAddressByID[userInfos[_user].referrerID];
258                 referer2 = userAddressByID[userInfos[referer1].referrerID];
259                 referer = userAddressByID[userInfos[referer2].referrerID];
260             }
261             else if(_level == 4 || _level == 9) {
262                 referer1 = userAddressByID[userInfos[_user].referrerID];
263                 referer2 = userAddressByID[userInfos[referer1].referrerID];
264                 referer3 = userAddressByID[userInfos[referer2].referrerID];
265                 referer = userAddressByID[userInfos[referer3].referrerID];
266             }
267             else if(_level == 5 || _level == 10) {
268                 referer1 = userAddressByID[userInfos[_user].referrerID];
269                 referer2 = userAddressByID[userInfos[referer1].referrerID];
270                 referer3 = userAddressByID[userInfos[referer2].referrerID];
271                 referer4 = userAddressByID[userInfos[referer3].referrerID];
272                 referer = userAddressByID[userInfos[referer4].referrerID];
273             }
274     
275             if(!userInfos[referer].joined) referer = userAddressByID[1];
276     
277             bool sent = false;
278             if(userInfos[referer].levelExpired[_level] >= now) {
279                 //sent = address(uint160(referer)).transfer(priceOfLevel[_level]);
280                 
281                 if(referer==multiadminaddress)
282                 {
283                     referer=ownerWallet;
284                 }
285                 
286                 usdtInterface(usdtTokenAddress).transferFrom(_user,referer, priceOfLevel[_level]);
287     
288                 
289                 emit paidForLevelEv(referer, _user, _level, priceOfLevel[_level], now);
290                 
291                 sent = true;
292                 
293             }
294             if(!sent) {
295                 emit lostForLevelEv(referer, _user, _level, priceOfLevel[_level], now);
296                 
297                 // if(userAddressByID[userInfos[referer].referrerID]==multiadminaddress)
298                 // {
299                     multiadminInterface(multiadminaddress).payamount(priceOfLevel[_level]);
300                     usdtInterface(usdtTokenAddress).transferFrom(_user,multiadminaddress, priceOfLevel[_level]);
301                     
302                     emit paidForLevelEv(multiadminaddress, _user, _level, priceOfLevel[_level], now);
303                     
304                 // }
305                 // else
306                 // {
307                 //     payForLevel(_level, referer);
308                 // }
309                 
310             }
311         }
312         
313     }
314     
315     
316     /**
317      * Find available free referrer in the matrix. It search maximum 126 positions.
318      * For any chances where matrix goes beyond 126 position, then UI should supply correct referrer ID, to avoid hitting this limit.
319      */
320     function findFreeReferrer(address _user) public view returns(address) {
321         if(userInfos[_user].referral.length < maxDownLimit) return _user;
322 
323         address[] memory referrals = new address[](126);
324         referrals[0] = userInfos[_user].referral[0];
325         referrals[1] = userInfos[_user].referral[1];
326 
327         address freeReferrer;
328         bool noFreeReferrer = true;
329 
330         for(uint i = 0; i < 126; i++) {
331             if(userInfos[referrals[i]].referral.length == maxDownLimit) {
332                 if(i < 62) {
333                     referrals[(i+1)*2] = userInfos[referrals[i]].referral[0];
334                     referrals[(i+1)*2+1] = userInfos[referrals[i]].referral[1];
335                 }
336             }
337             else {
338                 noFreeReferrer = false;
339                 freeReferrer = referrals[i];
340                 break;
341             }
342         }
343 
344         require(!noFreeReferrer, 'No Free Referrer');
345 
346         return freeReferrer;
347     }
348     
349     
350     /**
351      * Owner can set/change USDT contract address.
352      * Owner can set 0x0 address to pause this network. Owner can set correct USDT address and it should start working again.
353      * This contract does not hold any fund, so no scam is every possible.
354      */
355     function changeUSDTaddress(address _add) external onlyOwner{
356         usdtTokenAddress=_add;
357     }
358 
359 
360     /**
361      * View function to see referrals of user.
362      */
363     function viewUserReferral(address _user) external view returns(address[] memory) {
364         return userInfos[_user].referral;
365     }
366 
367 
368     /**
369      * See user's level expire.
370      */
371     function viewUserLevelExpired(address _user, uint _level) external view returns(uint) {
372         return userInfos[_user].levelExpired[_level];
373     }
374 
375     
376     /**
377      * assembly function which converts buytes to address.
378      */
379     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
380         assembly {
381             addr := mload(add(bys, 20))
382         }
383     }
384     
385     
386     /**
387      * output the array of timestamp of user last joined. This is used to see the expiration of all the levels.
388      */
389     function viewTimestampSinceJoined(address usr) external view returns(uint256[10] memory timeSinceJoined )
390     {
391         if(userInfos[usr].joined)
392         {
393             for(uint256 i=0;i<10;i++)
394             {
395                 uint256 t = userInfos[usr].levelExpired[i+1];
396                 if(t>now)
397                 {
398                     timeSinceJoined[i] = (t-now);
399                 }
400             }
401         }
402         return timeSinceJoined;
403     }
404     
405     function changeMultiadminAddress(address _add) public onlyOwner{
406         require(_add!=address(0));
407         
408         multiadminaddress=_add;
409     }
410     
411 }