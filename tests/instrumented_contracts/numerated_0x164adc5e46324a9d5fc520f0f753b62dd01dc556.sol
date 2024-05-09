1 pragma solidity ^0.5.7;
2 
3 // Official Website: www.etherwave.io
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29 }
30 
31 
32 contract Ownable {
33 
34   address public owner;
35   address public manager;
36   address public ownerWallet;
37 
38   constructor() public {
39     owner = msg.sender;
40     manager = msg.sender;
41     ownerWallet = 0xa516da2FdBEB58C82Ad0AE84Bf51669C0CA467d3;
42   }
43 
44   modifier onlyOwner() {
45     require(msg.sender == owner, "only for owner");
46     _;
47   }
48 
49   modifier onlyOwnerOrManager() {
50      require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
51       _;
52   }
53 
54   function transferOwnership(address newOwner) public onlyOwner {
55     owner = newOwner;
56   }
57 
58   function setManager(address _manager) public onlyOwnerOrManager {
59       manager = _manager;
60   }
61 }
62 
63 contract EtherWave is Ownable {
64 
65     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
66     event buyLevelEvent(address indexed _user, uint _level, uint _time);
67     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
68     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
69     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
70     //------------------------------
71 
72     mapping (uint => uint) public LEVEL_PRICE;
73     uint REFERRER_1_LEVEL_LIMIT = 3;
74     uint PERIOD_LENGTH = 365 days;
75 
76 
77     struct UserStruct {
78         bool isExist;
79         uint id;
80         uint referrerID;
81         address[] referral;
82         mapping (uint => uint) levelExpired;
83     }
84 
85     mapping (address => UserStruct) public users;
86     mapping (uint => address) public userList;
87     uint public currUserID = 0;
88 
89 
90 
91 
92     constructor() public {
93 
94         LEVEL_PRICE[1] = 0.10 ether;
95         LEVEL_PRICE[2] = 0.30 ether;
96         LEVEL_PRICE[3] = 0.90 ether;
97         LEVEL_PRICE[4] = 2.70 ether;
98         LEVEL_PRICE[5] = 8.10 ether;
99         LEVEL_PRICE[6] = 24.30 ether;
100         LEVEL_PRICE[7] = 72.90 ether;
101         LEVEL_PRICE[8] = 218.70 ether;
102 
103         UserStruct memory userStruct;
104         currUserID++;
105 
106         userStruct = UserStruct({
107             isExist : true,
108             id : currUserID,
109             referrerID : 0,
110             referral : new address[](0)
111         });
112         users[ownerWallet] = userStruct;
113         userList[currUserID] = ownerWallet;
114 
115         users[ownerWallet].levelExpired[1] = 77777777777;
116         users[ownerWallet].levelExpired[2] = 77777777777;
117         users[ownerWallet].levelExpired[3] = 77777777777;
118         users[ownerWallet].levelExpired[4] = 77777777777;
119         users[ownerWallet].levelExpired[5] = 77777777777;
120         users[ownerWallet].levelExpired[6] = 77777777777;
121         users[ownerWallet].levelExpired[7] = 77777777777;
122         users[ownerWallet].levelExpired[8] = 77777777777;
123     }
124 
125     function () external payable {
126 
127         uint level;
128 
129         if(msg.value == LEVEL_PRICE[1]){
130             level = 1;
131         }else if(msg.value == LEVEL_PRICE[2]){
132             level = 2;
133         }else if(msg.value == LEVEL_PRICE[3]){
134             level = 3;
135         }else if(msg.value == LEVEL_PRICE[4]){
136             level = 4;
137         }else if(msg.value == LEVEL_PRICE[5]){
138             level = 5;
139         }else if(msg.value == LEVEL_PRICE[6]){
140             level = 6;
141         }else if(msg.value == LEVEL_PRICE[7]){
142             level = 7;
143         }else if(msg.value == LEVEL_PRICE[8]){
144             level = 8;
145         }else {
146             revert('Incorrect Value send');
147         }
148 
149         if(users[msg.sender].isExist){
150             buyLevel(level);
151         } else if(level == 1) {
152             uint refId = 0;
153             address referrer = bytesToAddress(msg.data);
154 
155             if (users[referrer].isExist){
156                 refId = users[referrer].id;
157             } else {
158                 revert('Incorrect referrer');
159             }
160 
161             regUser(refId);
162         } else {
163             revert("Please buy first level for 0.05 ETH");
164         }
165     }
166 
167     function regUser(uint _referrerID) public payable {
168         require(!users[msg.sender].isExist, 'User exist');
169 
170         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
171 
172         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
173 
174 
175         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
176         {
177             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
178         }
179 
180 
181         UserStruct memory userStruct;
182         currUserID++;
183 
184         userStruct = UserStruct({
185             isExist : true,
186             id : currUserID,
187             referrerID : _referrerID,
188             referral : new address[](0)
189         });
190 
191         users[msg.sender] = userStruct;
192         userList[currUserID] = msg.sender;
193 
194         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
195         users[msg.sender].levelExpired[2] = 0;
196         users[msg.sender].levelExpired[3] = 0;
197         users[msg.sender].levelExpired[4] = 0;
198         users[msg.sender].levelExpired[5] = 0;
199         users[msg.sender].levelExpired[6] = 0;
200         users[msg.sender].levelExpired[7] = 0;
201         users[msg.sender].levelExpired[8] = 0;
202 
203         users[userList[_referrerID]].referral.push(msg.sender);
204 
205         payForLevel(1, msg.sender);
206 
207         emit regLevelEvent(msg.sender, userList[_referrerID], now);
208     }
209 
210     function buyLevel(uint _level) public payable {
211         require(users[msg.sender].isExist, 'User not exist');
212 
213         require( _level>0 && _level<=8, 'Incorrect level');
214 
215         if(_level == 1){
216             require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
217             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
218         } else {
219             require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
220 
221             for(uint l =_level-1; l>0; l-- ){
222                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
223             }
224 
225             if(users[msg.sender].levelExpired[_level] == 0){
226                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
227             } else {
228                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
229             }
230         }
231         payForLevel(_level, msg.sender);
232         emit buyLevelEvent(msg.sender, _level, now);
233     }
234 
235     function payForLevel(uint _level, address _user) internal {
236 
237         address referer;
238         address referer1;
239         address referer2;
240         address referer3;
241         if(_level == 1 || _level == 5){
242             referer = userList[users[_user].referrerID];
243         } else if(_level == 2 || _level == 6){
244             referer1 = userList[users[_user].referrerID];
245             referer = userList[users[referer1].referrerID];
246         } else if(_level == 3 || _level == 7){
247             referer1 = userList[users[_user].referrerID];
248             referer2 = userList[users[referer1].referrerID];
249             referer = userList[users[referer2].referrerID];
250         } else if(_level == 4 || _level == 8){
251             referer1 = userList[users[_user].referrerID];
252             referer2 = userList[users[referer1].referrerID];
253             referer3 = userList[users[referer2].referrerID];
254             referer = userList[users[referer3].referrerID];
255         }
256 
257         if(!users[referer].isExist){
258             referer = userList[1];
259         }
260 
261         if(users[referer].levelExpired[_level] >= now ){
262             bool result;
263             result = address(uint160(referer)).send(LEVEL_PRICE[_level]);
264             emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
265         } else {
266             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
267             payForLevel(_level,referer);
268         }
269     }
270 
271     function findFreeReferrer(address _user) public view returns(address) {
272         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
273             return _user;
274         }
275 
276         address[] memory referrals = new address[](363);
277         referrals[0] = users[_user].referral[0]; 
278         referrals[1] = users[_user].referral[1];
279         referrals[2] = users[_user].referral[2];
280 
281         address freeReferrer;
282         bool noFreeReferrer = true;
283 
284         for(uint i =0; i<363;i++){
285             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
286                 if(i<120){
287                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
288                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
289                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
290                 }
291             }else{
292                 noFreeReferrer = false;
293                 freeReferrer = referrals[i];
294                 break;
295             }
296         }
297         require(!noFreeReferrer, 'No Free Referrer');
298         return freeReferrer;
299 
300     }
301 
302     function viewUserReferral(address _user) public view returns(address[] memory) {
303         return users[_user].referral;
304     }
305 
306     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
307         return users[_user].levelExpired[_level];
308     }
309     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
310         assembly {
311             addr := mload(add(bys, 20))
312         }
313     }
314 }