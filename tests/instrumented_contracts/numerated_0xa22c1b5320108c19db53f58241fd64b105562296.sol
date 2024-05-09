1 /*
2 
3 |       \                     |  \      |  \          |  \  _  |  \                    
4 | $$$$$$$\  ______   __    __ | $$____  | $$  ______  | $$ / \ | $$  ______   __    __ 
5 | $$  | $$ /      \ |  \  |  \| $$    \ | $$ /      \ | $$/  $\| $$ |      \ |  \  |  \
6 | $$  | $$|  $$$$$$\| $$  | $$| $$$$$$$\| $$|  $$$$$$\| $$  $$$\ $$  \$$$$$$\| $$  | $$
7 | $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$| $$    $$| $$ $$\$$\$$ /      $$| $$  | $$
8 | $$__/ $$| $$__/ $$| $$__/ $$| $$__/ $$| $$| $$$$$$$$| $$$$  \$$$$|  $$$$$$$| $$__/ $$
9 | $$    $$ \$$    $$ \$$    $$| $$    $$| $$ \$$     \| $$$    \$$$ \$$    $$ \$$    $$
10  \$$$$$$$   \$$$$$$   \$$$$$$  \$$$$$$$  \$$  \$$$$$$$ \$$      \$$  \$$$$$$$ _\$$$$$$$
11                                                                              |  \__| $$
12                                                                               \$$    $$
13                                                                                \$$$$$$ 
14 																			   
15 
16 Telegram Chat EN: @doublewaychat
17 Telegram Chat CN: @doublewaychatCN
18 Telegram Chat RU: @doublewaychatRU
19 Telegram Chat ES: @doublewaychatES
20 
21 Telegram Channel: @doubleway
22 Hashtag: #doubleway
23 
24 */
25 
26 pragma solidity ^0.5.14;
27 
28 contract DoubleWay  {
29 
30     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
31     event buyLevelEvent(address indexed _user, uint _level, uint _time);
32     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
33     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
34     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
35     event chUplineLogEvent(address indexed _chUpline, uint _idCh, uint _idDw);
36 
37     address ownerWallet = 0xd5E9F24607CA70910973dC2149f9B780f84d8839;//0x46B78099611d50e1b0d200Fb0d43e6B3dFBA81C7;//0xd5E9F24607CA70910973dC2149f9B780f84d8839;
38 
39     mapping (uint => uint) public LEVEL_PRICE;
40     uint REFERRER_1_LEVEL_LIMIT = 2;
41     uint PERIOD_LENGTH = 64 days;
42     uint RENEWAL_NOT_EARLIER = 64 days;
43 
44 
45     struct UserStruct {
46         bool isExist;
47         uint id;
48         uint referrerID;
49         address[] referral;
50         mapping (uint => uint) levelExpired;
51     }
52     
53     
54     mapping (address => UserStruct) public users;
55     mapping (uint => address) public userList;
56     uint public currUserID = 0;
57 
58     CryptoHands CRYPTO_HANDS = CryptoHands(0xA315bD2e3227C2ab71f1350644B01757EAFf9cb4);
59     
60     uint public START_TIME = 1576800000; //  Friday, 20 December 2019 г., 0:00:00
61     uint public END_OF_PERIOD_1 = START_TIME + 1 days;
62     uint public END_OF_PERIOD_2 = START_TIME + 2 days;
63     uint public END_OF_PERIOD_3 = START_TIME + 3 days;
64     uint public END_OF_PERIOD_4 = START_TIME + 5 days;
65     uint public END_OF_PERIOD_5 = START_TIME + 8 days;
66     uint public END_OF_PERIOD_6 = START_TIME + 13 days;
67     uint public END_OF_PERIOD_7 = START_TIME + 21 days;
68     
69     uint public ID_OF_PERIOD_1 = 16;
70     uint public ID_OF_PERIOD_2 = 32;
71     uint public ID_OF_PERIOD_3 = 64;
72     uint public ID_OF_PERIOD_4 = 128;
73     uint public ID_OF_PERIOD_5 = 256;
74     uint public ID_OF_PERIOD_6 = 512;
75 
76     
77     modifier priorityRegistration() {
78         require(now >= START_TIME, 'The time has not come yet');
79         
80         if(now <= END_OF_PERIOD_7){
81             (bool isExist, uint256 id, uint256 referrerID)  = viewCHUser(msg.sender);
82             
83             require(isExist, 'You must be registered in CryptoHands');
84             
85             if(now > END_OF_PERIOD_6){
86                require( ( CRYPTO_HANDS.viewUserLevelExpired(msg.sender,1) > now ), 'You must be registered in CryptoHands'); 
87             } else  if(now > END_OF_PERIOD_5){
88                require( ( id<=ID_OF_PERIOD_6 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,2) > now ), 'You must have level 2 in CryptoHands, or id <= 512'); 
89             } else  if(now > END_OF_PERIOD_4){
90                require( ( id<=ID_OF_PERIOD_5 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,3) > now ), 'You must have level 3 in CryptoHands, or id <= 256'); 
91             } else  if(now > END_OF_PERIOD_3){
92                require( ( id<=ID_OF_PERIOD_4 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,4) > now ), 'You must have level 4 in CryptoHands, or id <= 128'); 
93             } else  if(now > END_OF_PERIOD_2){
94                require( ( id<=ID_OF_PERIOD_3 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,5) > now ), 'You must have level 5 in CryptoHands, or id <= 64'); 
95             } else  if(now > END_OF_PERIOD_1){
96                require( ( id<=ID_OF_PERIOD_2 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,6) > now ), 'You must have level 6 in CryptoHands, or id <= 32'); 
97             } else{
98                require( ( id<=ID_OF_PERIOD_1 || CRYPTO_HANDS.viewUserLevelExpired(msg.sender,7) > now ), 'You must have level 7 in CryptoHands, or id <= 16'); 
99             } 
100         }
101 
102         _;
103     }
104 
105     constructor() public {
106 
107         LEVEL_PRICE[1] = 0.08 ether;
108         LEVEL_PRICE[2] = 0.16 ether;
109         LEVEL_PRICE[3] = 0.32 ether;
110         LEVEL_PRICE[4] = 0.64 ether;
111         LEVEL_PRICE[5] = 1.28 ether;
112         LEVEL_PRICE[6] = 2.56 ether;
113         LEVEL_PRICE[7] = 5.12 ether;
114         LEVEL_PRICE[8] = 10.24 ether;
115 
116         UserStruct memory userStruct;
117         currUserID++;
118 
119         userStruct = UserStruct({
120             isExist : true,
121             id : currUserID,
122             referrerID : 0,
123             referral : new address[](0)
124         });
125         users[ownerWallet] = userStruct;
126         userList[currUserID] = ownerWallet;
127 
128         users[ownerWallet].levelExpired[1] = 77777777777;
129         users[ownerWallet].levelExpired[2] = 77777777777;
130         users[ownerWallet].levelExpired[3] = 77777777777;
131         users[ownerWallet].levelExpired[4] = 77777777777;
132         users[ownerWallet].levelExpired[5] = 77777777777;
133         users[ownerWallet].levelExpired[6] = 77777777777;
134         users[ownerWallet].levelExpired[7] = 77777777777;
135         users[ownerWallet].levelExpired[8] = 77777777777;
136     }
137 
138     function () external payable priorityRegistration(){
139 
140         uint level;
141 
142         if(msg.value == LEVEL_PRICE[1]){
143             level = 1;
144         }else if(msg.value == LEVEL_PRICE[2]){
145             level = 2;
146         }else if(msg.value == LEVEL_PRICE[3]){
147             level = 3;
148         }else if(msg.value == LEVEL_PRICE[4]){
149             level = 4;
150         }else if(msg.value == LEVEL_PRICE[5]){
151             level = 5;
152         }else if(msg.value == LEVEL_PRICE[6]){
153             level = 6;
154         }else if(msg.value == LEVEL_PRICE[7]){
155             level = 7;
156         }else if(msg.value == LEVEL_PRICE[8]){
157             level = 8;
158         }else {
159             revert('Incorrect Value send');
160         }
161 
162         if(users[msg.sender].isExist){
163             buyLevel(level);
164         } else if(level == 1) {
165             uint refId = 0;
166             address referrer = bytesToAddress(msg.data);
167 
168             if (users[referrer].isExist){
169                 refId = users[referrer].id;
170             } else {
171                 (bool chIsExist, uint256 chId, uint256 chReferrerID)  = viewCHUser(msg.sender);
172                 
173                 if(chIsExist){
174                     referrer =  findCHReferrer(chReferrerID);   
175                     refId = users[referrer].id;
176                 }else {
177                     revert('Incorrect referrer');
178                 }
179             }
180 
181             regUser(refId);
182         } else {
183             revert("Please buy first level for 0.08 ETH");
184         }
185     }
186 
187     function regUser(uint _referrerID) internal {
188 
189         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
190         {
191             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
192         }
193 
194 
195         UserStruct memory userStruct;
196         currUserID++;
197 
198         userStruct = UserStruct({
199             isExist : true,
200             id : currUserID,
201             referrerID : _referrerID,
202             referral : new address[](0)
203         });
204 
205         users[msg.sender] = userStruct;
206         userList[currUserID] = msg.sender;
207 
208         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
209 
210         users[userList[_referrerID]].referral.push(msg.sender);
211 
212         payForLevel(1, msg.sender);
213 
214         emit regLevelEvent(msg.sender, userList[_referrerID], now);
215     }
216 
217     function buyLevel(uint _level) internal {
218         
219         require(users[msg.sender].levelExpired[_level] < now + RENEWAL_NOT_EARLIER, 'The level has already been extended for a long time. Try later');
220 
221         if(_level == 1){
222             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
223         } else {
224             for(uint l =_level-1; l>0; l-- ){
225                 require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
226             }
227 
228             if(users[msg.sender].levelExpired[_level] == 0){
229                 users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
230             } else {
231                 users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
232             }
233         }
234         payForLevel(_level, msg.sender);
235         emit buyLevelEvent(msg.sender, _level, now);
236     }
237 
238     function payForLevel(uint _level, address _user) internal {
239         
240         address referrer = getUserReferrer(_user, _level);
241 
242         if(!users[referrer].isExist){
243             referrer = userList[1];
244         }
245 
246         if(users[referrer].levelExpired[_level] >= now ){
247             bool result;
248             result = address(uint160(referrer)).send(LEVEL_PRICE[_level]);
249             emit getMoneyForLevelEvent(referrer, msg.sender, _level, now);
250         } else {
251             emit lostMoneyForLevelEvent(referrer, msg.sender, _level, now);
252             payForLevel(_level,referrer);
253         }
254     }
255 
256     function findFreeReferrer(address _user) public view returns(address) {
257         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
258             return _user;
259         }
260 
261         address[] memory referrals = new address[](2046);
262         referrals[0] = users[_user].referral[0]; 
263         referrals[1] = users[_user].referral[1];
264 
265         address freeReferrer;
266         bool noFreeReferrer = true;
267 
268         for(uint i =0; i<2046;i++){
269             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
270                 if(i<1022){
271                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
272                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
273                 }
274             }else{
275                 noFreeReferrer = false;
276                 freeReferrer = referrals[i];
277                 break;
278             }
279         }
280         require(!noFreeReferrer, 'No Free Referrer');
281         return freeReferrer;
282 
283     }
284     
285     function getUserReferrer(address _user, uint _level) public view returns (address) {
286       if (_level == 0 || _user == address(0)) {
287         return _user;
288       }
289 
290       return this.getUserReferrer(userList[users[_user].referrerID], _level - 1);
291     }    
292 
293     function viewUserReferral(address _user) public view returns(address[] memory) {
294         return users[_user].referral;
295     }
296 
297     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
298         return users[_user].levelExpired[_level];
299     }
300         
301     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
302         assembly {
303             addr := mload(add(bys, 20))
304         }
305     }
306     
307     function viewCHUser(address _user) public view returns (bool isExist, uint id,  uint referrerID) {
308         return CRYPTO_HANDS.users(_user);
309     }
310 
311     function viewCHLevelExpired(address _user, uint _level) public view returns (uint) {
312         CRYPTO_HANDS.viewUserLevelExpired(_user,_level);
313     }
314     
315     function findCHReferrer(uint _chUserId) internal returns(address) { //view
316 
317         address chReferrerAddress = CRYPTO_HANDS.userList(_chUserId);
318         
319         if(users[chReferrerAddress].isExist){
320             emit chUplineLogEvent(chReferrerAddress, _chUserId, users[chReferrerAddress].id);
321             return chReferrerAddress;
322         } else{
323             emit chUplineLogEvent(chReferrerAddress, _chUserId, 0);
324             (bool chIsExist, uint256 chId, uint256 chReferrerID)  = viewCHUser(chReferrerAddress); 
325             return findCHReferrer(chReferrerID);
326         }
327     }     
328 }
329 contract CryptoHands  {
330     struct UserStruct {
331         bool isExist;
332         uint id;
333         uint referrerID;
334         address[] referral;
335         mapping (uint => uint) levelExpired;
336     }    
337     
338     mapping (address => UserStruct) public users;
339     mapping (uint => address) public userList;
340     function viewUserLevelExpired(address _user, uint _level) public view returns(uint);
341     
342 }