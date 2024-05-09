1 pragma solidity ^0.5.7;
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
36   address public adminWallet;
37   uint adminPersent;
38   
39 
40   constructor() public {
41     owner = msg.sender;
42     manager = msg.sender;
43     ownerWallet =   0xa372Cf95f6D0a12b2f23c0E7826334345AB9FEA2;
44     adminWallet =   0xB6CD057eaD6cF0D1eF5B0b568B952162F5cc6106;
45     adminPersent =  10;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner, "only for owner");
50     _;
51   }
52 
53   modifier onlyOwnerOrManager() {
54      require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
55       _;
56   }
57 
58   function transferOwnership(address newOwner) public onlyOwner {
59     owner = newOwner;
60   }
61 
62   function setManager(address _manager) public onlyOwnerOrManager {
63       manager = _manager;
64   }
65 }
66 
67 contract Monetuum is Ownable {
68 
69     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
70     event buyLevelEvent(address indexed _user, uint _level, uint _time);
71     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
72     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _price);
73     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _price);
74     //------------------------------
75 
76     mapping (uint => uint) public LEVEL_PRICE;
77     uint REFERRER_1_LEVEL_LIMIT = 3;
78     uint PERIOD_LENGTH = 365 days;
79 
80 
81     struct UserStruct {
82         bool isExist;
83         uint id;
84         uint referrerID;
85         address[] referral;
86         mapping (uint => uint) levelExpired;
87     }
88 
89     mapping (address => UserStruct) public users;
90     mapping (uint => address) public userList;
91     uint public currUserID = 0;
92 
93 
94 
95 
96     constructor() public {
97 
98         LEVEL_PRICE[1] = 0.1 ether;
99         LEVEL_PRICE[2] = 0.2 ether;
100         LEVEL_PRICE[3] = 0.4 ether;
101         LEVEL_PRICE[4] = 0.8 ether;
102         LEVEL_PRICE[5] = 4.0 ether;
103         LEVEL_PRICE[6] = 8.0 ether;
104         LEVEL_PRICE[7] = 16.0 ether;
105         LEVEL_PRICE[8] = 32.0 ether;
106 
107         UserStruct memory userStruct;
108         currUserID++;
109 
110         userStruct = UserStruct({
111             isExist : true,
112             id : currUserID,
113             referrerID : 0,
114             referral : new address[](0)
115         });
116         users[ownerWallet] = userStruct;
117         userList[currUserID] = ownerWallet;
118 
119         users[ownerWallet].levelExpired[1] = 77777777777;
120         users[ownerWallet].levelExpired[2] = 77777777777;
121         users[ownerWallet].levelExpired[3] = 77777777777;
122         users[ownerWallet].levelExpired[4] = 77777777777;
123         users[ownerWallet].levelExpired[5] = 77777777777;
124         users[ownerWallet].levelExpired[6] = 77777777777;
125         users[ownerWallet].levelExpired[7] = 77777777777;
126         users[ownerWallet].levelExpired[8] = 77777777777;
127     }
128 
129     function () external payable {
130 
131         uint level;
132 
133         if(msg.value == LEVEL_PRICE[1]){
134             level = 1;
135         }else if(msg.value == LEVEL_PRICE[2]){
136             level = 2;
137         }else if(msg.value == LEVEL_PRICE[3]){
138             level = 3;
139         }else if(msg.value == LEVEL_PRICE[4]){
140             level = 4;
141         }else if(msg.value == LEVEL_PRICE[5]){
142             level = 5;
143         }else if(msg.value == LEVEL_PRICE[6]){
144             level = 6;
145         }else if(msg.value == LEVEL_PRICE[7]){
146             level = 7;
147         }else if(msg.value == LEVEL_PRICE[8]){
148             level = 8;
149         }else {
150             revert('Incorrect Value send');
151         }
152 
153         if(users[msg.sender].isExist){
154             buyLevel(level);
155         } else if(level == 1) {
156             uint refId = 0;
157             address referrer = bytesToAddress(msg.data);
158 
159             if (users[referrer].isExist){
160                 refId = users[referrer].id;
161             } else {
162                 revert('Incorrect referrer');
163             }
164 
165             regUser(refId);
166         } else {
167             revert("Please buy first level for 0.1 ETH");
168         }
169     }
170 
171     function regUser(uint _referrerID) public payable {
172         require(!users[msg.sender].isExist, 'User exist');
173 
174         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
175 
176         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
177 
178 
179         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
180         {
181             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
182         }
183 
184 
185         UserStruct memory userStruct;
186         currUserID++;
187 
188         userStruct = UserStruct({
189             isExist : true,
190             id : currUserID,
191             referrerID : _referrerID,
192             referral : new address[](0)
193         });
194 
195         users[msg.sender] = userStruct;
196         userList[currUserID] = msg.sender;
197 
198         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
199         users[msg.sender].levelExpired[2] = 0;
200         users[msg.sender].levelExpired[3] = 0;
201         users[msg.sender].levelExpired[4] = 0;
202         users[msg.sender].levelExpired[5] = 0;
203         users[msg.sender].levelExpired[6] = 0;
204         users[msg.sender].levelExpired[7] = 0;
205         users[msg.sender].levelExpired[8] = 0;
206 
207         users[userList[_referrerID]].referral.push(msg.sender);
208 
209         payForLevel(1, msg.sender);
210 
211         emit regLevelEvent(msg.sender, userList[_referrerID], now);
212     }
213 
214     function buyLevel(uint _level) public payable {
215         require(users[msg.sender].isExist, 'User not exist');
216 
217         require( _level>0 && _level<=8, 'Incorrect level');
218 
219         if(_level == 1){
220             require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
221             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
222         } else {
223             require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
224 
225             for(uint l =_level-1; l>0; l-- ){
226                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
227             }
228 
229             if(users[msg.sender].levelExpired[_level] == 0){
230                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
231             } else {
232                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
233             }
234         }
235         payForLevel(_level, msg.sender);
236         emit buyLevelEvent(msg.sender, _level, now);
237     }
238 
239     function payForLevel(uint _level, address _user) internal {
240 
241         address referer;
242         address referer1;
243         address referer2;
244         address referer3;
245         if(_level == 1 || _level == 5){
246             referer = userList[users[_user].referrerID];
247         } else if(_level == 2 || _level == 6){
248             referer1 = userList[users[_user].referrerID];
249             referer = userList[users[referer1].referrerID];
250         } else if(_level == 3 || _level == 7){
251             referer1 = userList[users[_user].referrerID];
252             referer2 = userList[users[referer1].referrerID];
253             referer = userList[users[referer2].referrerID];
254         } else if(_level == 4 || _level == 8){
255             referer1 = userList[users[_user].referrerID];
256             referer2 = userList[users[referer1].referrerID];
257             referer3 = userList[users[referer2].referrerID];
258             referer = userList[users[referer3].referrerID];
259         }
260 
261         if(!users[referer].isExist){
262             referer = userList[1];
263         }
264         
265         uint amountToUser;
266         uint amountToAdmin;
267         
268         amountToAdmin = LEVEL_PRICE[_level] / 100 * adminPersent;
269         amountToUser = LEVEL_PRICE[_level] - amountToAdmin;
270             
271         if(users[referer].levelExpired[_level] >= now ){
272             bool result;
273             
274             result = address(uint160(referer)).send(amountToUser);
275             result = address(uint160(adminWallet)).send(amountToAdmin);
276             
277             emit getMoneyForLevelEvent(referer, msg.sender, _level, now, amountToUser);
278         } else {
279             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now, amountToUser);
280             payForLevel(_level,referer);
281         }
282     }
283 
284     function findFreeReferrer(address _user) public view returns(address) {
285         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
286             return _user;
287         }
288 
289         address[] memory referrals = new address[](363);
290         referrals[0] = users[_user].referral[0]; 
291         referrals[1] = users[_user].referral[1];
292         referrals[2] = users[_user].referral[2];
293 
294         address freeReferrer;
295         bool noFreeReferrer = true;
296 
297         for(uint i =0; i<363;i++){
298             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
299                 if(i<120){
300                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
301                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
302                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
303                 }
304             }else{
305                 noFreeReferrer = false;
306                 freeReferrer = referrals[i];
307                 break;
308             }
309         }
310         require(!noFreeReferrer, 'No Free Referrer');
311         return freeReferrer;
312 
313     }
314 
315     function viewUserReferral(address _user) public view returns(address[] memory) {
316         return users[_user].referral;
317     }
318 
319     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
320         return users[_user].levelExpired[_level];
321     }
322     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
323         assembly {
324             addr := mload(add(bys, 20))
325         }
326     }
327 }