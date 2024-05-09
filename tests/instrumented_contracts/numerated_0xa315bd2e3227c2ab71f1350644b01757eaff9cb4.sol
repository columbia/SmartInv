1 /*
2  $$$$$$\                                 $$\               $$\   $$\                           $$\           
3 $$  __$$\                                $$ |              $$ |  $$ |                          $$ |          
4 $$ /  \__| $$$$$$\  $$\   $$\  $$$$$$\ $$$$$$\    $$$$$$\  $$ |  $$ | $$$$$$\  $$$$$$$\   $$$$$$$ | $$$$$$$\ 
5 $$ |      $$  __$$\ $$ |  $$ |$$  __$$\\_$$  _|  $$  __$$\ $$$$$$$$ | \____$$\ $$  __$$\ $$  __$$ |$$  _____|
6 $$ |      $$ |  \__|$$ |  $$ |$$ /  $$ | $$ |    $$ /  $$ |$$  __$$ | $$$$$$$ |$$ |  $$ |$$ /  $$ |\$$$$$$\  
7 $$ |  $$\ $$ |      $$ |  $$ |$$ |  $$ | $$ |$$\ $$ |  $$ |$$ |  $$ |$$  __$$ |$$ |  $$ |$$ |  $$ | \____$$\ 
8 \$$$$$$  |$$ |      \$$$$$$$ |$$$$$$$  | \$$$$  |\$$$$$$  |$$ |  $$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$ |$$$$$$$  |
9  \______/ \__|       \____$$ |$$  ____/   \____/  \______/ \__|  \__| \_______|\__|  \__| \_______|\_______/ 
10                     $$\   $$ |$$ |                                                                           
11                     \$$$$$$  |$$ |                                                                           
12                      \______/ \__|                                                                      
13 					 
14 					 
15 					 
16 telegram: @cryptohands
17 hashtag: #cryptohands
18 */
19 pragma solidity ^0.5.7;
20 
21 
22 library SafeMath {
23 
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a / b;
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 
46 }
47 
48 
49 contract Ownable {
50 
51   address public owner;
52   address public manager;
53   address public ownerWallet;
54 
55   constructor() public {
56     owner = msg.sender;
57     manager = msg.sender;
58     ownerWallet = 0xd5E9F24607CA70910973dC2149f9B780f84d8839;
59   }
60 
61   modifier onlyOwner() {
62     require(msg.sender == owner, "only for owner");
63     _;
64   }
65 
66   modifier onlyOwnerOrManager() {
67      require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
68       _;
69   }
70 
71   function transferOwnership(address newOwner) public onlyOwner {
72     owner = newOwner;
73   }
74 
75   function setManager(address _manager) public onlyOwnerOrManager {
76       manager = _manager;
77   }
78 }
79 
80 contract CryptoHands is Ownable {
81 
82     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
83     event buyLevelEvent(address indexed _user, uint _level, uint _time);
84     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
85     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
86     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
87     //------------------------------
88 
89     mapping (uint => uint) public LEVEL_PRICE;
90     uint REFERRER_1_LEVEL_LIMIT = 3;
91     uint PERIOD_LENGTH = 365 days;
92 
93 
94     struct UserStruct {
95         bool isExist;
96         uint id;
97         uint referrerID;
98         address[] referral;
99         mapping (uint => uint) levelExpired;
100     }
101 
102     mapping (address => UserStruct) public users;
103     mapping (uint => address) public userList;
104     uint public currUserID = 0;
105 
106 
107 
108 
109     constructor() public {
110 
111         LEVEL_PRICE[1] = 0.05 ether;
112         LEVEL_PRICE[2] = 0.15 ether;
113         LEVEL_PRICE[3] = 0.45 ether;
114         LEVEL_PRICE[4] = 1.35 ether;
115         LEVEL_PRICE[5] = 4.05 ether;
116         LEVEL_PRICE[6] = 12.15 ether;
117         LEVEL_PRICE[7] = 36.45 ether;
118         LEVEL_PRICE[8] = 109.35 ether;
119 
120         UserStruct memory userStruct;
121         currUserID++;
122 
123         userStruct = UserStruct({
124             isExist : true,
125             id : currUserID,
126             referrerID : 0,
127             referral : new address[](0)
128         });
129         users[ownerWallet] = userStruct;
130         userList[currUserID] = ownerWallet;
131 
132         users[ownerWallet].levelExpired[1] = 77777777777;
133         users[ownerWallet].levelExpired[2] = 77777777777;
134         users[ownerWallet].levelExpired[3] = 77777777777;
135         users[ownerWallet].levelExpired[4] = 77777777777;
136         users[ownerWallet].levelExpired[5] = 77777777777;
137         users[ownerWallet].levelExpired[6] = 77777777777;
138         users[ownerWallet].levelExpired[7] = 77777777777;
139         users[ownerWallet].levelExpired[8] = 77777777777;
140     }
141 
142     function () external payable {
143 
144         uint level;
145 
146         if(msg.value == LEVEL_PRICE[1]){
147             level = 1;
148         }else if(msg.value == LEVEL_PRICE[2]){
149             level = 2;
150         }else if(msg.value == LEVEL_PRICE[3]){
151             level = 3;
152         }else if(msg.value == LEVEL_PRICE[4]){
153             level = 4;
154         }else if(msg.value == LEVEL_PRICE[5]){
155             level = 5;
156         }else if(msg.value == LEVEL_PRICE[6]){
157             level = 6;
158         }else if(msg.value == LEVEL_PRICE[7]){
159             level = 7;
160         }else if(msg.value == LEVEL_PRICE[8]){
161             level = 8;
162         }else {
163             revert('Incorrect Value send');
164         }
165 
166         if(users[msg.sender].isExist){
167             buyLevel(level);
168         } else if(level == 1) {
169             uint refId = 0;
170             address referrer = bytesToAddress(msg.data);
171 
172             if (users[referrer].isExist){
173                 refId = users[referrer].id;
174             } else {
175                 revert('Incorrect referrer');
176             }
177 
178             regUser(refId);
179         } else {
180             revert("Please buy first level for 0.05 ETH");
181         }
182     }
183 
184     function regUser(uint _referrerID) public payable {
185         require(!users[msg.sender].isExist, 'User exist');
186 
187         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
188 
189         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
190 
191 
192         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
193         {
194             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
195         }
196 
197 
198         UserStruct memory userStruct;
199         currUserID++;
200 
201         userStruct = UserStruct({
202             isExist : true,
203             id : currUserID,
204             referrerID : _referrerID,
205             referral : new address[](0)
206         });
207 
208         users[msg.sender] = userStruct;
209         userList[currUserID] = msg.sender;
210 
211         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
212         users[msg.sender].levelExpired[2] = 0;
213         users[msg.sender].levelExpired[3] = 0;
214         users[msg.sender].levelExpired[4] = 0;
215         users[msg.sender].levelExpired[5] = 0;
216         users[msg.sender].levelExpired[6] = 0;
217         users[msg.sender].levelExpired[7] = 0;
218         users[msg.sender].levelExpired[8] = 0;
219 
220         users[userList[_referrerID]].referral.push(msg.sender);
221 
222         payForLevel(1, msg.sender);
223 
224         emit regLevelEvent(msg.sender, userList[_referrerID], now);
225     }
226 
227     function buyLevel(uint _level) public payable {
228         require(users[msg.sender].isExist, 'User not exist');
229 
230         require( _level>0 && _level<=8, 'Incorrect level');
231 
232         if(_level == 1){
233             require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
234             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
235         } else {
236             require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
237 
238             for(uint l =_level-1; l>0; l-- ){
239                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
240             }
241 
242             if(users[msg.sender].levelExpired[_level] == 0){
243                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
244             } else {
245                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
246             }
247         }
248         payForLevel(_level, msg.sender);
249         emit buyLevelEvent(msg.sender, _level, now);
250     }
251 
252     function payForLevel(uint _level, address _user) internal {
253 
254         address referer;
255         address referer1;
256         address referer2;
257         address referer3;
258         if(_level == 1 || _level == 5){
259             referer = userList[users[_user].referrerID];
260         } else if(_level == 2 || _level == 6){
261             referer1 = userList[users[_user].referrerID];
262             referer = userList[users[referer1].referrerID];
263         } else if(_level == 3 || _level == 7){
264             referer1 = userList[users[_user].referrerID];
265             referer2 = userList[users[referer1].referrerID];
266             referer = userList[users[referer2].referrerID];
267         } else if(_level == 4 || _level == 8){
268             referer1 = userList[users[_user].referrerID];
269             referer2 = userList[users[referer1].referrerID];
270             referer3 = userList[users[referer2].referrerID];
271             referer = userList[users[referer3].referrerID];
272         }
273 
274         if(!users[referer].isExist){
275             referer = userList[1];
276         }
277 
278         if(users[referer].levelExpired[_level] >= now ){
279             bool result;
280             result = address(uint160(referer)).send(LEVEL_PRICE[_level]);
281             emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
282         } else {
283             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
284             payForLevel(_level,referer);
285         }
286     }
287 
288     function findFreeReferrer(address _user) public view returns(address) {
289         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
290             return _user;
291         }
292 
293         address[] memory referrals = new address[](363);
294         referrals[0] = users[_user].referral[0]; 
295         referrals[1] = users[_user].referral[1];
296         referrals[2] = users[_user].referral[2];
297 
298         address freeReferrer;
299         bool noFreeReferrer = true;
300 
301         for(uint i =0; i<363;i++){
302             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
303                 if(i<120){
304                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
305                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
306                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
307                 }
308             }else{
309                 noFreeReferrer = false;
310                 freeReferrer = referrals[i];
311                 break;
312             }
313         }
314         require(!noFreeReferrer, 'No Free Referrer');
315         return freeReferrer;
316 
317     }
318 
319     function viewUserReferral(address _user) public view returns(address[] memory) {
320         return users[_user].referral;
321     }
322 
323     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
324         return users[_user].levelExpired[_level];
325     }
326     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
327         assembly {
328             addr := mload(add(bys, 20))
329         }
330     }
331 }