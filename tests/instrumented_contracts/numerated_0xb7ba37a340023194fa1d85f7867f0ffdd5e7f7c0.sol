1 pragma solidity ^0.5.11;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 
31 contract Ownable {
32 
33   address public owner;
34   address public manager;
35   address public ownerWallet;
36 
37   constructor() public {
38     owner = msg.sender;
39     manager = msg.sender;
40     ownerWallet = 0x22B042529d91D17c8800fcf8063086ECD3fc691c;
41   }
42 
43   modifier onlyOwner() {
44     require(msg.sender == owner, "only for owner");
45     _;
46   }
47 
48   modifier onlyOwnerOrManager() {
49      require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
50       _;
51   }
52 
53   function transferOwnership(address newOwner) public onlyOwner {
54     owner = newOwner;
55   }
56 
57   function setManager(address _manager) public onlyOwnerOrManager {
58       manager = _manager;
59   }
60 }
61 
62 contract CryptoFriends is Ownable {
63 
64     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
65     event buyLevelEvent(address indexed _user, uint _level, uint _time);
66     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
67     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
68     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
69     //------------------------------
70 
71     mapping (uint => uint) public LEVEL_PRICE;
72     uint REFERRER_1_LEVEL_LIMIT = 3;
73     uint PERIOD_LENGTH = 365 days;
74 
75 
76     struct UserStruct {
77         bool isExist;
78         uint id;
79         uint referrerID;
80         address[] referral;
81         mapping (uint => uint) levelExpired;
82     }
83 
84     mapping (address => UserStruct) public users;
85     mapping (uint => address) public userList;
86     uint public currUserID = 0;
87 
88 
89 
90 
91     constructor() public {
92 
93         LEVEL_PRICE[1] = 0.05 ether;
94         LEVEL_PRICE[2] = 0.15 ether;
95         LEVEL_PRICE[3] = 0.45 ether;
96         LEVEL_PRICE[4] = 1.35 ether;
97         LEVEL_PRICE[5] = 4.05 ether;
98         LEVEL_PRICE[6] = 12.15 ether;
99         LEVEL_PRICE[7] = 36.45 ether;
100         LEVEL_PRICE[8] = 109.35 ether;
101 
102         UserStruct memory userStruct;
103         currUserID++;
104 
105         userStruct = UserStruct({
106             isExist : true,
107             id : currUserID,
108             referrerID : 0,
109             referral : new address[](0)
110         });
111         users[ownerWallet] = userStruct;
112         userList[currUserID] = ownerWallet;
113 
114         users[ownerWallet].levelExpired[1] = 77777777777;
115         users[ownerWallet].levelExpired[2] = 77777777777;
116         users[ownerWallet].levelExpired[3] = 77777777777;
117         users[ownerWallet].levelExpired[4] = 77777777777;
118         users[ownerWallet].levelExpired[5] = 77777777777;
119         users[ownerWallet].levelExpired[6] = 77777777777;
120         users[ownerWallet].levelExpired[7] = 77777777777;
121         users[ownerWallet].levelExpired[8] = 77777777777;
122     }
123 
124     function () external payable {
125 
126         uint level;
127 
128         if(msg.value == LEVEL_PRICE[1]){
129             level = 1;
130         }else if(msg.value == LEVEL_PRICE[2]){
131             level = 2;
132         }else if(msg.value == LEVEL_PRICE[3]){
133             level = 3;
134         }else if(msg.value == LEVEL_PRICE[4]){
135             level = 4;
136         }else if(msg.value == LEVEL_PRICE[5]){
137             level = 5;
138         }else if(msg.value == LEVEL_PRICE[6]){
139             level = 6;
140         }else if(msg.value == LEVEL_PRICE[7]){
141             level = 7;
142         }else if(msg.value == LEVEL_PRICE[8]){
143             level = 8;
144         }else {
145             revert('Incorrect Value send');
146         }
147 
148         if(users[msg.sender].isExist){
149             buyLevel(level);
150         } else if(level == 1) {
151             uint refId = 0;
152             address referrer = bytesToAddress(msg.data);
153 
154             if (users[referrer].isExist){
155                 refId = users[referrer].id;
156             } else {
157                 revert('Incorrect referrer');
158             }
159 
160             regUser(refId);
161         } else {
162             revert("Please buy first level for 0.05 ETH");
163         }
164     }
165 
166     function regUser(uint _referrerID) public payable {
167         require(!users[msg.sender].isExist, 'User exist');
168 
169         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
170 
171         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
172 
173 
174         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
175         {
176             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
177         }
178 
179 
180         UserStruct memory userStruct;
181         currUserID++;
182 
183         userStruct = UserStruct({
184             isExist : true,
185             id : currUserID,
186             referrerID : _referrerID,
187             referral : new address[](0)
188         });
189 
190         users[msg.sender] = userStruct;
191         userList[currUserID] = msg.sender;
192 
193         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
194         users[msg.sender].levelExpired[2] = 0;
195         users[msg.sender].levelExpired[3] = 0;
196         users[msg.sender].levelExpired[4] = 0;
197         users[msg.sender].levelExpired[5] = 0;
198         users[msg.sender].levelExpired[6] = 0;
199         users[msg.sender].levelExpired[7] = 0;
200         users[msg.sender].levelExpired[8] = 0;
201 
202         users[userList[_referrerID]].referral.push(msg.sender);
203 
204         payForLevel(1, msg.sender);
205 
206         emit regLevelEvent(msg.sender, userList[_referrerID], now);
207     }
208 
209     function buyLevel(uint _level) public payable {
210         require(users[msg.sender].isExist, 'User not exist');
211 
212         require( _level>0 && _level<=8, 'Incorrect level');
213 
214         if(_level == 1){
215             require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
216             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
217         } else {
218             require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
219 
220             for(uint l =_level-1; l>0; l-- ){
221                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
222             }
223 
224             if(users[msg.sender].levelExpired[_level] == 0){
225                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
226             } else {
227                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
228             }
229         }
230         payForLevel(_level, msg.sender);
231         emit buyLevelEvent(msg.sender, _level, now);
232     }
233 
234     function payForLevel(uint _level, address _user) internal {
235 
236         address referer;
237         address referer1;
238         address referer2;
239         address referer3;
240         if(_level == 1 || _level == 5){
241             referer = userList[users[_user].referrerID];
242         } else if(_level == 2 || _level == 6){
243             referer1 = userList[users[_user].referrerID];
244             referer = userList[users[referer1].referrerID];
245         } else if(_level == 3 || _level == 7){
246             referer1 = userList[users[_user].referrerID];
247             referer2 = userList[users[referer1].referrerID];
248             referer = userList[users[referer2].referrerID];
249         } else if(_level == 4 || _level == 8){
250             referer1 = userList[users[_user].referrerID];
251             referer2 = userList[users[referer1].referrerID];
252             referer3 = userList[users[referer2].referrerID];
253             referer = userList[users[referer3].referrerID];
254         }
255 
256         if(!users[referer].isExist){
257             referer = userList[1];
258         }
259 
260         if(users[referer].levelExpired[_level] >= now ){
261             bool result;
262             result = address(uint160(referer)).send(LEVEL_PRICE[_level]);
263             emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
264         } else {
265             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
266             payForLevel(_level,referer);
267         }
268     }
269 
270     function findFreeReferrer(address _user) public view returns(address) {
271         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
272             return _user;
273         }
274 
275         address[] memory referrals = new address[](363);
276         referrals[0] = users[_user].referral[0]; 
277         referrals[1] = users[_user].referral[1];
278         referrals[2] = users[_user].referral[2];
279 
280         address freeReferrer;
281         bool noFreeReferrer = true;
282 
283         for(uint i =0; i<363;i++){
284             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
285                 if(i<120){
286                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
287                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
288                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
289                 }
290             }else{
291                 noFreeReferrer = false;
292                 freeReferrer = referrals[i];
293                 break;
294             }
295         }
296         require(!noFreeReferrer, 'No Free Referrer');
297         return freeReferrer;
298 
299     }
300 
301     function viewUserReferral(address _user) public view returns(address[] memory) {
302         return users[_user].referral;
303     }
304 
305     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
306         return users[_user].levelExpired[_level];
307     }
308     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
309         assembly {
310             addr := mload(add(bys, 20))
311         }
312     }
313 }