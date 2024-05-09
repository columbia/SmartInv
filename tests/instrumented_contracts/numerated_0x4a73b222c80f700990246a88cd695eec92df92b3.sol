1 pragma solidity 0.5.14;
2 
3 contract MineTree {
4     address public Wallet;
5     address public usirs;
6 
7     struct UserStruct {
8         bool isExist;
9         uint id;
10         uint referrerID;
11         uint totalEarning;
12         address[] referral;
13         mapping(uint => uint) levelExpired;
14     }
15 
16     uint public REFERRER_1_LEVEL_LIMIT = 2;
17     uint public PERIOD_LENGTH = 77 days;
18     uint public GRACE_PERIOD = 3 days;
19 
20     mapping(uint => uint) public LEVEL_PRICE;
21 
22     mapping (address => UserStruct) public users;
23     mapping (uint => address) public userList;
24     mapping(address => mapping (uint => uint)) public levelEarned;
25     mapping (address => uint) public loopCheck;
26     uint public currUserID = 0;
27     bool public lockStatus;
28 
29     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
30     event buyLevelEvent(address indexed _user, uint _level, uint _time);
31     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
32     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
33 
34     constructor(address _usirsAddress) public {
35         Wallet = msg.sender;
36         lockStatus = true;
37         usirs = _usirsAddress;
38         
39         //FOUNDATION
40         LEVEL_PRICE[1] = 0.07 ether;
41         LEVEL_PRICE[2] = 0.12 ether;
42         LEVEL_PRICE[3] = 0.24 ether;
43         LEVEL_PRICE[4] = 0.96 ether;
44         LEVEL_PRICE[5] = 3 ether;
45         LEVEL_PRICE[6] = 10 ether;
46         //PREMIUM
47         LEVEL_PRICE[7] = 20 ether;
48         LEVEL_PRICE[8] = 30 ether;
49         LEVEL_PRICE[9] = 40 ether;
50         LEVEL_PRICE[10] = 60 ether;
51         LEVEL_PRICE[11] = 120 ether;
52         LEVEL_PRICE[12] = 240 ether;
53         //ELITE
54         LEVEL_PRICE[13] = 100 ether;
55         LEVEL_PRICE[14] = 150 ether;
56         LEVEL_PRICE[15] = 300 ether;
57         LEVEL_PRICE[16] = 500 ether;
58         LEVEL_PRICE[17] = 1000 ether;
59         LEVEL_PRICE[18] = 2000 ether;
60 
61         UserStruct memory userStruct;
62         currUserID++;
63 
64         userStruct = UserStruct({
65             isExist: true,
66             id: currUserID,
67             totalEarning:0,
68             referrerID: 0,
69             referral: new address[](0)
70         });
71         users[Wallet] = userStruct;
72         userList[currUserID] = Wallet;
73 
74         for(uint i = 1; i <= 18; i++) {
75             users[Wallet].levelExpired[i] = 55555555555;
76         }
77     }
78     
79     modifier isUnlock(){
80         require(lockStatus == true,"Contract is locked");
81         _;
82     }
83 
84     function () external payable isUnlock {
85         uint level;
86 
87         if(msg.value == LEVEL_PRICE[1]) level = 1;
88         else if(msg.value == LEVEL_PRICE[2]) level = 2;
89         else if(msg.value == LEVEL_PRICE[3]) level = 3;
90         else if(msg.value == LEVEL_PRICE[4]) level = 4;
91         else if(msg.value == LEVEL_PRICE[5]) level = 5;
92         else if(msg.value == LEVEL_PRICE[6]) level = 6;
93         else if(msg.value == LEVEL_PRICE[7]) level = 7;
94         else if(msg.value == LEVEL_PRICE[8]) level = 8;
95         else if(msg.value == LEVEL_PRICE[9]) level = 9;
96         else if(msg.value == LEVEL_PRICE[10]) level = 10;
97         else if(msg.value == LEVEL_PRICE[11]) level = 11;
98         else if(msg.value == LEVEL_PRICE[12]) level = 12;
99         else if(msg.value == LEVEL_PRICE[13]) level = 13;
100         else if(msg.value == LEVEL_PRICE[14]) level = 14;
101         else if(msg.value == LEVEL_PRICE[15]) level = 15;
102         else if(msg.value == LEVEL_PRICE[16]) level = 16;
103         else if(msg.value == LEVEL_PRICE[17]) level = 17;
104         else if(msg.value == LEVEL_PRICE[18]) level = 18;
105         else revert("Incorrect Value send");
106 
107         if(users[msg.sender].isExist) buyLevel(level);
108         else if(level == 1) {
109             uint refId = 0;
110             address referrer = bytesToAddress(msg.data);
111 
112             if(users[referrer].isExist) refId = users[referrer].id;
113             else revert("Incorrect referrer");
114 
115             regUser(refId);
116         }
117         else revert("Please buy first level for 0.07 ETH");
118     }
119 
120     function regUser(uint _referrerID) public payable isUnlock {
121         require(!users[msg.sender].isExist, "User exist");
122         require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect referrer Id");
123         require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
124 
125         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
126 
127         UserStruct memory userStruct;
128         currUserID++;
129 
130         userStruct = UserStruct({
131             isExist: true,
132             id: currUserID,
133             totalEarning:0,
134             referrerID: _referrerID,
135             referral: new address[](0)
136         });
137 
138         users[msg.sender] = userStruct;
139         userList[currUserID] = msg.sender;
140 
141         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
142 
143         users[userList[_referrerID]].referral.push(msg.sender);
144         loopCheck[msg.sender] = 0;
145 
146         payForLevel(1, msg.sender);
147 
148         emit regLevelEvent(msg.sender, userList[_referrerID], now);
149     }
150 
151     function buyLevel(uint _level) public payable isUnlock {
152         require(users[msg.sender].isExist, "User not exist"); 
153         require(_level > 0 && _level <= 18, "Incorrect level");
154 
155         if(_level == 1) {
156             require(msg.value == LEVEL_PRICE[1], "Incorrect Value");
157             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
158         }
159         else {
160             require(msg.value == LEVEL_PRICE[_level], "Incorrect Value");
161 
162             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l]+GRACE_PERIOD >= now, "Buy the previous level");
163 
164             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
165             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
166         }
167         loopCheck[msg.sender] = 0;
168         payForLevel(_level, msg.sender);
169 
170         emit buyLevelEvent(msg.sender, _level, now);
171     }
172 
173 
174     function payForLevel(uint _level, address _user) internal {
175         address referer;
176         address referer1;
177         address referer2;
178         address referer3;
179         address referer4;
180         address referer5;
181 
182         if(_level == 1 || _level == 7 || _level == 13) {
183             referer = userList[users[_user].referrerID];
184         }
185         else if(_level == 2 || _level == 8 || _level == 14) {
186             referer1 = userList[users[_user].referrerID];
187             referer = userList[users[referer1].referrerID];
188         }
189         else if(_level == 3 || _level == 9 || _level == 15) {
190             referer1 = userList[users[_user].referrerID];
191             referer2 = userList[users[referer1].referrerID];
192             referer = userList[users[referer2].referrerID];
193         }
194         else if(_level == 4 || _level == 10 || _level == 16) {
195             referer1 = userList[users[_user].referrerID];
196             referer2 = userList[users[referer1].referrerID];
197             referer3 = userList[users[referer2].referrerID];
198             referer = userList[users[referer3].referrerID];
199         }
200         else if(_level == 5 || _level == 11 || _level == 17) {
201             referer1 = userList[users[_user].referrerID];
202             referer2 = userList[users[referer1].referrerID];
203             referer3 = userList[users[referer2].referrerID];
204             referer4 = userList[users[referer3].referrerID];
205             referer = userList[users[referer4].referrerID];
206         }
207         else if(_level == 6 || _level == 12 || _level == 18) {
208             referer1 = userList[users[_user].referrerID];
209             referer2 = userList[users[referer1].referrerID];
210             referer3 = userList[users[referer2].referrerID];
211             referer4 = userList[users[referer3].referrerID];
212             referer5 = userList[users[referer4].referrerID];
213             referer = userList[users[referer5].referrerID];
214         }
215 
216         if(!users[referer].isExist) referer = userList[1];
217 
218         if (loopCheck[msg.sender] >= 12) {
219             referer = userList[1];
220         }
221         
222         if(users[referer].levelExpired[_level] >= now) {
223             if(referer == Wallet) {
224                 require(address(uint160(usirs)).send(LEVEL_PRICE[_level]), "Transfer failed");
225                 emit getMoneyForLevelEvent(usirs, msg.sender, _level, now);
226             }    
227             else{    
228                 require(address(uint160(referer)).send(LEVEL_PRICE[_level]), "Referrer transfer failed");
229                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
230             }
231             users[referer].totalEarning += LEVEL_PRICE[_level];
232             levelEarned[referer][_level] +=  LEVEL_PRICE[_level];
233                 
234         }
235         else {
236             if (loopCheck[msg.sender] < 12) {
237                 loopCheck[msg.sender] += 1;
238                 
239             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
240 
241             payForLevel(_level, referer);
242             }
243         }
244     }
245 
246     function updateUsirs(address _usirsAddress) public returns (bool) {
247        require(msg.sender == Wallet, "Only Wallet");
248        
249        usirs = _usirsAddress;
250        return true;
251     }
252     
253     function updatePrice(uint _level, uint _price) public returns (bool) {
254         require(msg.sender == Wallet, "Only Wallet");
255 
256         LEVEL_PRICE[_level] = _price;
257         return true;
258     }
259     
260     function failSafe(address payable _toUser, uint _amount) public returns (bool) {
261         require(msg.sender == Wallet, "Only Owner Wallet");
262         require(_toUser != address(0), "Invalid Address");
263         require(address(this).balance >= _amount, "Insufficient balance");
264 
265         (_toUser).transfer(_amount);
266         return true;
267     }
268 
269     function contractLock(bool _lockStatus) public returns (bool) {
270         require(msg.sender == Wallet, "Invalid User");
271 
272         lockStatus = _lockStatus;
273         return true;
274     }
275 
276     function findFreeReferrer(address _user) public view returns(address) {
277         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
278 
279         address[] memory referrals = new address[](254);
280         referrals[0] = users[_user].referral[0];
281         referrals[1] = users[_user].referral[1];
282 
283         address freeReferrer;
284         bool noFreeReferrer = true;
285 
286         for(uint i = 0; i < 254; i++) {
287             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
288                 if(i < 126) {
289                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
290                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
291                 }
292             }
293             else {
294                 noFreeReferrer = false;
295                 freeReferrer = referrals[i];
296                 break;
297             }
298         }
299 
300         require(!noFreeReferrer, "No Free Referrer");
301 
302         return freeReferrer;
303     }
304 
305     function viewUserReferral(address _user) public view returns(address[] memory) {
306         return users[_user].referral;
307     }
308 
309     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
310         return users[_user].levelExpired[_level];
311     }
312 
313     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
314         assembly {
315             addr := mload(add(bys, 20))
316         }
317     }
318 }