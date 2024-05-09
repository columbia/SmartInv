1 /**
2  * 
3  * ███╗   ███╗██╗██╗     ██╗     ██╗ ██████╗ ███╗   ██╗
4  * ████╗ ████║██║██║     ██║     ██║██╔═══██╗████╗  ██║
5  * ██╔████╔██║██║██║     ██║     ██║██║   ██║██╔██╗ ██║
6  * ██║╚██╔╝██║██║██║     ██║     ██║██║   ██║██║╚██╗██║
7  * ██║ ╚═╝ ██║██║███████╗███████╗██║╚██████╔╝██║ ╚████║
8  * ╚═╝     ╚═╝╚═╝╚══════╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝
9  *     ███╗   ███╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗ 
10  *     ████╗ ████║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝ 
11  *     ██╔████╔██║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝  
12  *     ██║╚██╔╝██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝   
13  *     ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║███████╗   ██║    
14  *     ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝    
15  *         ██████╗     ██████╗                         
16  *         ╚════██╗   ██╔═████╗                        
17  *          █████╔╝   ██║██╔██║                        
18  *         ██╔═══╝    ████╔╝██║                        
19  *         ███████╗██╗╚██████╔╝                        
20  *        ╚══════╝╚═╝ ╚═════╝                         
21  *                                                    
22  * Hello
23  * I am a MillionMoney 2.0 (fixed)
24  * My URL: https://million.money
25  * 
26  */
27 
28 pragma solidity 0.5.11;
29 
30 contract MillionMoney {
31     address public ownerWallet;
32 
33     MillionMoney public oldSC = MillionMoney(0x4Dcf60F0cb42c22Df36994CCBebd0b281C57003A);
34     uint oldSCUserId = 1;
35 
36     struct UserStruct {
37         bool isExist;
38         uint id;
39         uint referrerID;
40         address[] referral;
41         mapping(uint => uint) levelExpired;
42     }
43 
44     uint REFERRER_1_LEVEL_LIMIT = 2;
45     uint PERIOD_LENGTH = 100 days;
46 
47     mapping(uint => uint) public LEVEL_PRICE;
48 
49     mapping (address => UserStruct) public users;
50     mapping (uint => address) public userList;
51     uint public currUserID = 0;
52 
53     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
54     event buyLevelEvent(address indexed _user, uint _level, uint _time);
55     event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
56     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
57     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
58 
59     constructor() public {
60         ownerWallet = msg.sender;
61 
62         LEVEL_PRICE[1] = 0.03 ether;
63         LEVEL_PRICE[2] = 0.05 ether;
64         LEVEL_PRICE[3] = 0.1 ether;
65         LEVEL_PRICE[4] = 0.4 ether;
66         LEVEL_PRICE[5] = 1 ether;
67         LEVEL_PRICE[6] = 2.5 ether;
68         LEVEL_PRICE[7] = 5 ether;
69         LEVEL_PRICE[8] = 10 ether;
70         LEVEL_PRICE[9] = 20 ether;
71         LEVEL_PRICE[10] = 40 ether;
72 
73         UserStruct memory userStruct;
74         currUserID++;
75 
76         userStruct = UserStruct({
77             isExist: true,
78             id: currUserID,
79             referrerID: 0,
80             referral: new address[](0)
81         });
82         users[ownerWallet] = userStruct;
83         userList[currUserID] = ownerWallet;
84 
85         for(uint i = 1; i <= 10; i++) {
86             users[ownerWallet].levelExpired[i] = 55555555555;
87         }
88     }
89 
90     function () external payable {
91         uint level;
92 
93         if(msg.value == LEVEL_PRICE[1]) level = 1;
94         else if(msg.value == LEVEL_PRICE[2]) level = 2;
95         else if(msg.value == LEVEL_PRICE[3]) level = 3;
96         else if(msg.value == LEVEL_PRICE[4]) level = 4;
97         else if(msg.value == LEVEL_PRICE[5]) level = 5;
98         else if(msg.value == LEVEL_PRICE[6]) level = 6;
99         else if(msg.value == LEVEL_PRICE[7]) level = 7;
100         else if(msg.value == LEVEL_PRICE[8]) level = 8;
101         else if(msg.value == LEVEL_PRICE[9]) level = 9;
102         else if(msg.value == LEVEL_PRICE[10]) level = 10;
103         else revert('Incorrect Value send');
104 
105         if(users[msg.sender].isExist) buyLevel(level);
106         else if(level == 1) {
107             uint refId = 0;
108             address referrer = bytesToAddress(msg.data);
109 
110             if(users[referrer].isExist) refId = users[referrer].id;
111             else revert('Incorrect referrer');
112 
113             regUser(refId);
114         }
115         else revert('Please buy first level for 0.03 ETH');
116     }
117 
118     function regUser(uint _referrerID) public payable {
119         require(address(oldSC) == address(0), 'Initialize not finished');
120         require(!users[msg.sender].isExist, 'User exist');
121         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
122         require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
123 
124         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
125 
126         UserStruct memory userStruct;
127         currUserID++;
128 
129         userStruct = UserStruct({
130             isExist: true,
131             id: currUserID,
132             referrerID: _referrerID,
133             referral: new address[](0)
134         });
135 
136         users[msg.sender] = userStruct;
137         userList[currUserID] = msg.sender;
138 
139         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
140 
141         users[userList[_referrerID]].referral.push(msg.sender);
142 
143         payForLevel(1, msg.sender);
144 
145         emit regLevelEvent(msg.sender, userList[_referrerID], now);
146     }
147 
148     function buyLevel(uint _level) public payable {
149         require(users[msg.sender].isExist, 'User not exist'); 
150         require(_level > 0 && _level <= 10, 'Incorrect level');
151 
152         if(_level == 1) {
153             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
154             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
155         }
156         else {
157             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
158 
159             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
160 
161             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
162             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
163         }
164 
165         payForLevel(_level, msg.sender);
166 
167         emit buyLevelEvent(msg.sender, _level, now);
168     }
169     
170     function syncWithOldSC(uint limit) public {
171         require(address(oldSC) != address(0), 'Initialize closed');
172         require(msg.sender == ownerWallet, 'Access denied');
173 
174         for(uint i = 0; i < limit; i++) {
175             address user = oldSC.userList(oldSCUserId);
176             (bool isExist,, uint referrerID) = oldSC.users(user);
177 
178             if(isExist) {
179                 oldSCUserId++;
180                 
181                 address ref = oldSC.userList(referrerID);
182 
183                 if(!users[user].isExist && users[ref].isExist) {
184                     users[user].isExist = true;
185                     users[user].id = ++currUserID;
186                     users[user].referrerID = users[ref].id;
187 
188                     userList[currUserID] = user;
189                     users[ref].referral.push(user);
190 
191                     for(uint j = 1; j <= 8; j++) {
192                         users[user].levelExpired[j] = oldSC.viewUserLevelExpired(user, j);
193                     }
194 
195                     emit regLevelEvent(user, ref, block.timestamp);
196                 }
197             }
198             else break;
199         }
200     }
201 
202     function syncClose() external {
203         require(address(oldSC) != address(0), 'Initialize already closed');
204         require(msg.sender == ownerWallet, 'Access denied');
205 
206         oldSC = MillionMoney(0);
207     }
208 
209     function payForLevel(uint _level, address _user) internal {
210         address referer;
211         address referer1;
212         address referer2;
213         address referer3;
214         address referer4;
215 
216         if(_level == 1 || _level == 6) {
217             referer = userList[users[_user].referrerID];
218         }
219         else if(_level == 2 || _level == 7) {
220             referer1 = userList[users[_user].referrerID];
221             referer = userList[users[referer1].referrerID];
222         }
223         else if(_level == 3 || _level == 8) {
224             referer1 = userList[users[_user].referrerID];
225             referer2 = userList[users[referer1].referrerID];
226             referer = userList[users[referer2].referrerID];
227         }
228         else if(_level == 4 || _level == 9) {
229             referer1 = userList[users[_user].referrerID];
230             referer2 = userList[users[referer1].referrerID];
231             referer3 = userList[users[referer2].referrerID];
232             referer = userList[users[referer3].referrerID];
233         }
234         else if(_level == 5 || _level == 10) {
235             referer1 = userList[users[_user].referrerID];
236             referer2 = userList[users[referer1].referrerID];
237             referer3 = userList[users[referer2].referrerID];
238             referer4 = userList[users[referer3].referrerID];
239             referer = userList[users[referer4].referrerID];
240         }
241 
242         if(!users[referer].isExist) referer = userList[1];
243 
244         bool sent = false;
245         if(users[referer].levelExpired[_level] >= now) {
246             sent = address(uint160(referer)).send(LEVEL_PRICE[_level]);
247 
248             if (sent) {
249                 emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
250             }
251         }
252         if(!sent) {
253             emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);
254 
255             payForLevel(_level, referer);
256         }
257     }
258 
259     function findFreeReferrer(address _user) public view returns(address) {
260         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
261 
262         address[] memory referrals = new address[](126);
263         referrals[0] = users[_user].referral[0];
264         referrals[1] = users[_user].referral[1];
265 
266         address freeReferrer;
267         bool noFreeReferrer = true;
268 
269         for(uint i = 0; i < 126; i++) {
270             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
271                 if(i < 62) {
272                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
273                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
274                 }
275             }
276             else {
277                 noFreeReferrer = false;
278                 freeReferrer = referrals[i];
279                 break;
280             }
281         }
282 
283         require(!noFreeReferrer, 'No Free Referrer');
284 
285         return freeReferrer;
286     }
287 
288     function viewUserReferral(address _user) public view returns(address[] memory) {
289         return users[_user].referral;
290     }
291 
292     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
293         return users[_user].levelExpired[_level];
294     }
295 
296     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
297         assembly {
298             addr := mload(add(bys, 20))
299         }
300     }
301 }