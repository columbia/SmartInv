1 /*
2 
3 
4 ███████╗████████╗██╗░░██╗██████╗░██╗░░░██╗███╗░░██╗    ██████╗░░░░░█████╗░
5 ██╔════╝╚══██╔══╝██║░░██║██╔══██╗██║░░░██║████╗░██║    ╚════██╗░░░██╔══██╗
6 █████╗░░░░░██║░░░███████║██████╔╝██║░░░██║██╔██╗██║    ░░███╔═╝░░░██║░░██║
7 ██╔══╝░░░░░██║░░░██╔══██║██╔══██╗██║░░░██║██║╚████║    ██╔══╝░░░░░██║░░██║
8 ███████╗░░░██║░░░██║░░██║██║░░██║╚██████╔╝██║░╚███║    ███████╗██╗╚█████╔╝
9 ╚══════╝░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚══╝    ╚══════╝╚═╝░╚════╝░
10 
11 WEBSITE URL: https://ethrun.io/
12 
13 */
14 
15 
16 pragma solidity 0.5.11;
17 
18 contract ETHRUN {
19     address public ownerWallet;
20 
21     ETHRUN public oldSC = ETHRUN(0x1b27AB139a92D1522DC8511612dB197d0E2e53c8);
22     uint oldSCUserId = 1;
23 
24     struct UserStruct {
25         bool isExist;
26         uint id;
27         uint referrerID;
28         address[] referral;
29         mapping(uint => uint) levelExpired;
30     }
31 
32     uint REFERRER_1_LEVEL_LIMIT = 2;
33     uint PERIOD_LENGTH = 30 days;
34 
35     mapping(uint => uint) public LEVEL_PRICE;
36 
37     mapping (address => UserStruct) public users;
38     mapping (uint => address) public userList;
39     uint public currUserID = 0;
40 
41     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
42     event buyLevelEvent(address indexed _user, uint _level, uint _time);
43     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
44     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
45     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
46 
47     constructor() public {
48         ownerWallet = 0x174b16CC1af3A9E9b0AA89E3d50598b1593c2084;
49 
50         LEVEL_PRICE[1] = 0.10 ether;
51         LEVEL_PRICE[2] = 0.20 ether;
52         LEVEL_PRICE[3] = 0.40 ether;
53         LEVEL_PRICE[4] = 0.80 ether;
54         LEVEL_PRICE[5] = 1.60 ether;
55         LEVEL_PRICE[6] = 3.20 ether;
56         LEVEL_PRICE[7] = 6.40 ether;
57         LEVEL_PRICE[8] = 12.80 ether;
58         LEVEL_PRICE[9] = 25.60 ether;
59         LEVEL_PRICE[10] = 51.20 ether;
60 
61         UserStruct memory userStruct;
62         currUserID++;
63 
64         userStruct = UserStruct({
65             isExist: true,
66             id: currUserID,
67             referrerID: 0,
68             referral: new address[](0)
69         });
70         users[ownerWallet] = userStruct;
71         userList[currUserID] = ownerWallet;
72 
73         for(uint i = 1; i <= 10; i++) {
74             users[ownerWallet].levelExpired[i] = 55555555555;
75         }
76     }
77 
78     function () external payable {
79         uint level;
80 
81         if(msg.value == LEVEL_PRICE[1]) level = 1;
82         else if(msg.value == LEVEL_PRICE[2]) level = 2;
83         else if(msg.value == LEVEL_PRICE[3]) level = 3;
84         else if(msg.value == LEVEL_PRICE[4]) level = 4;
85         else if(msg.value == LEVEL_PRICE[5]) level = 5;
86         else if(msg.value == LEVEL_PRICE[6]) level = 6;
87         else if(msg.value == LEVEL_PRICE[7]) level = 7;
88         else if(msg.value == LEVEL_PRICE[8]) level = 8;
89         else if(msg.value == LEVEL_PRICE[9]) level = 9;
90         else if(msg.value == LEVEL_PRICE[10]) level = 10;
91         else revert('Incorrect Value send');
92 
93         if(users[msg.sender].isExist) buyLevel(level);
94         else if(level == 1) {
95             uint refId = 0;
96             address referrer = bytesToAddress(msg.data);
97 
98             if(users[referrer].isExist) refId = users[referrer].id;
99             else revert('Incorrect referrer');
100 
101             regUser(refId);
102         }
103         else revert('Please buy first level for 0.03 ETH');
104     }
105 
106     function regUser(uint _referrerID) public payable {
107         require(address(oldSC) == address(0), 'Initialize not finished');
108         require(!users[msg.sender].isExist, 'User exist');
109         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
110         require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
111 
112         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
113 
114         UserStruct memory userStruct;
115         currUserID++;
116 
117         userStruct = UserStruct({
118             isExist: true,
119             id: currUserID,
120             referrerID: _referrerID,
121             referral: new address[](0)
122         });
123 
124         users[msg.sender] = userStruct;
125         userList[currUserID] = msg.sender;
126 
127         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
128 
129         users[userList[_referrerID]].referral.push(msg.sender);
130 
131         payForLevel(1, msg.sender);
132 
133         emit regLevelEvent(msg.sender, userList[_referrerID], now);
134     }
135 
136     function buyLevel(uint _level) public payable {
137         require(users[msg.sender].isExist, 'User not exist'); 
138         require(_level > 0 && _level <= 10, 'Incorrect level');
139 
140         if(_level == 1) {
141             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
142             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
143         }
144         else {
145             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
146 
147             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
148 
149             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
150             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
151         }
152 
153         payForLevel(_level, msg.sender);
154 
155         emit buyLevelEvent(msg.sender, _level, now);
156     }
157     
158     function syncWithOldSC(uint limit) public {
159         require(address(oldSC) != address(0), 'Initialize closed');
160         require(msg.sender == ownerWallet, 'Access denied');
161 
162         for(uint i = 0; i < limit; i++) {
163             address user = oldSC.userList(oldSCUserId);
164             (bool isExist,, uint referrerID) = oldSC.users(user);
165 
166             if(isExist) {
167                 oldSCUserId++;
168                 
169                 address ref = oldSC.userList(referrerID);
170 
171                 if(!users[user].isExist && users[ref].isExist) {
172                     users[user].isExist = true;
173                     users[user].id = ++currUserID;
174                     users[user].referrerID = users[ref].id;
175 
176                     userList[currUserID] = user;
177                     users[ref].referral.push(user);
178 
179                     for(uint j = 1; j <= 8; j++) {
180                         users[user].levelExpired[j] = oldSC.viewUserLevelExpired(user, j);
181                     }
182 
183                     emit regLevelEvent(user, ref, block.timestamp);
184                 }
185             }
186             else break;
187         }
188     }
189 
190     function syncClose() external {
191         require(address(oldSC) != address(0), 'Initialize already closed');
192         require(msg.sender == ownerWallet, 'Access denied');
193 
194         oldSC = ETHRUN(0);
195     }
196 
197     function payForLevel(uint _level, address _user) internal {
198         address referer;
199         address referer1;
200         address referer2;
201         address referer3;
202         address referer4;
203 
204         if(_level == 1 || _level == 6) {
205             referer = userList[users[_user].referrerID];
206         }
207         else if(_level == 2 || _level == 7) {
208             referer1 = userList[users[_user].referrerID];
209             referer = userList[users[referer1].referrerID];
210         }
211         else if(_level == 3 || _level == 8) {
212             referer1 = userList[users[_user].referrerID];
213             referer2 = userList[users[referer1].referrerID];
214             referer = userList[users[referer2].referrerID];
215         }
216         else if(_level == 4 || _level == 9) {
217             referer1 = userList[users[_user].referrerID];
218             referer2 = userList[users[referer1].referrerID];
219             referer3 = userList[users[referer2].referrerID];
220             referer = userList[users[referer3].referrerID];
221         }
222         else if(_level == 5 || _level == 10) {
223             referer1 = userList[users[_user].referrerID];
224             referer2 = userList[users[referer1].referrerID];
225             referer3 = userList[users[referer2].referrerID];
226             referer4 = userList[users[referer3].referrerID];
227             referer = userList[users[referer4].referrerID];
228         }
229 
230         if(!users[referer].isExist) referer = userList[1];
231 
232         bool sent = false;
233         if(users[referer].levelExpired[_level] >= now) {
234             sent = address(uint160(referer)).send(LEVEL_PRICE[_level]);
235 
236             if (sent) {
237                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
238             }
239         }
240         if(!sent) {
241             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
242 
243             payForLevel(_level, referer);
244         }
245     }
246 
247     function findFreeReferrer(address _user) public view returns(address) {
248         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
249 
250         address[] memory referrals = new address[](126);
251         referrals[0] = users[_user].referral[0];
252         referrals[1] = users[_user].referral[1];
253 
254         address freeReferrer;
255         bool noFreeReferrer = true;
256 
257         for(uint i = 0; i < 126; i++) {
258             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
259                 if(i < 62) {
260                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
261                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
262                 }
263             }
264             else {
265                 noFreeReferrer = false;
266                 freeReferrer = referrals[i];
267                 break;
268             }
269         }
270 
271         require(!noFreeReferrer, 'No Free Referrer');
272 
273         return freeReferrer;
274     }
275 
276     function viewUserReferral(address _user) public view returns(address[] memory) {
277         return users[_user].referral;
278     }
279 
280     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
281         return users[_user].levelExpired[_level];
282     }
283 
284     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
285         assembly {
286             addr := mload(add(bys, 20))
287         }
288     }
289 }