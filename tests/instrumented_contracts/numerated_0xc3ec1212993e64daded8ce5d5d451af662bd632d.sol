1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.10 <0.7.0;
3 
4 contract ETHPlusX3 {
5     address public creator;
6     uint256 public last_uid;
7     uint256 MAX_LEVEL = 9;
8     uint256 REFERRALS_LIMIT = 2;
9     uint256 LEVEL_EXPIRE_TIME = 90 days;
10     uint256 LEVEL_HIGHER_FOUR_EXPIRE_TIME = 180 days;
11     mapping(uint256 => address) public userAddresses;
12     mapping(uint256 => uint256) directPrice;
13     mapping(uint256 => uint256) levelPrice;
14     mapping(address => User) public users;
15 
16     struct User {
17         uint256 id;
18         uint256 referrerID;
19         address[] referrals;
20         mapping(uint256 => uint256) levelExpiresAt;
21     }
22 
23     modifier validLevelAmount(uint256 _level) {
24         require(msg.value == levelPrice[_level], "Invalid level amount sent");
25         _;
26     }
27 
28     modifier userRegistered() {
29         require(users[msg.sender].id != 0, "User does not exist");
30         _;
31     }
32 
33     modifier validReferrerID(uint256 _referrerID) {
34         require(
35             _referrerID > 0 && _referrerID <= last_uid,
36             "Invalid referrer ID"
37         );
38         _;
39     }
40 
41     modifier userNotRegistered() {
42         require(users[msg.sender].id == 0, "User is already registered");
43         _;
44     }
45 
46     modifier validLevel(uint256 _level) {
47         require(_level > 0 && _level <= MAX_LEVEL, "Invalid level entered");
48         _;
49     }
50 
51     event GetLevelProfitEvent(
52         address indexed user,
53         address indexed referral,
54         uint256 referralID,
55         uint256 amount
56     );
57 
58     constructor() public {
59         last_uid++;
60         creator = msg.sender;
61         levelPrice[1] = 0.05 ether;
62         levelPrice[2] = 0.15 ether;
63         levelPrice[3] = 0.30 ether;
64         levelPrice[4] = 0.60 ether;
65         levelPrice[5] = 1.20 ether;
66         levelPrice[6] = 2.40 ether;
67         levelPrice[7] = 4.80 ether;
68         levelPrice[8] = 9.60 ether;
69         levelPrice[9] = 19.20 ether;
70         directPrice[1] = 0.006 ether;
71         directPrice[2] = 0.018 ether;       
72         directPrice[3] = 0.037 ether;
73         directPrice[4] = 0.075 ether;
74         directPrice[5] = 0.150 ether;
75         directPrice[6] = 0.030 ether;       
76         directPrice[7] = 0.600 ether;
77         directPrice[8] = 1.200 ether;
78         directPrice[9] = 2.400 ether;
79 
80         users[creator] = User({
81             id: last_uid,
82             referrerID: 0,
83             referrals: new address[](0)
84         });
85         userAddresses[last_uid] = creator;
86 
87         for (uint256 i = 1; i <= MAX_LEVEL; i++) {
88             users[creator].levelExpiresAt[i] = 1 << 37;
89         }
90     }
91 
92     function registerUser(uint256 _referrerID)
93         public
94         payable
95         userNotRegistered()
96         validReferrerID(_referrerID)
97         validLevelAmount(1)
98     {
99         uint256 _level = 1;
100 
101         if (
102             users[userAddresses[_referrerID]].referrals.length >=
103             REFERRALS_LIMIT
104         ) {
105             _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
106         }
107         last_uid++;
108         users[msg.sender] = User({
109             id: last_uid,
110             referrerID: _referrerID,
111             referrals: new address[](0)
112         });
113         userAddresses[last_uid] = msg.sender;
114         users[msg.sender].levelExpiresAt[_level] =
115             now +
116             getLevelExpireTime(_level);
117         users[userAddresses[_referrerID]].referrals.push(msg.sender);
118 
119         transferLevelPayment(_level, msg.sender);
120     }
121 
122     function buyLevel(uint256 _level)
123         public
124         payable
125         userRegistered()
126         validLevel(_level)
127         validLevelAmount(_level)
128     {
129         for (uint256 l = _level - 1; l > 0; l--) {
130             require(
131                 getUserLevelExpiresAt(msg.sender, l) >= now,
132                 "Buy previous level first"
133             );
134         }
135 
136         if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
137             users[msg.sender].levelExpiresAt[_level] =
138                 now +
139                 getLevelExpireTime(_level);
140         } else {
141             users[msg.sender].levelExpiresAt[_level] += getLevelExpireTime(
142                 _level
143             );
144         }
145 
146         transferLevelPayment(_level, msg.sender);
147     }
148 
149     function getLevelExpireTime(uint256 _level)
150         internal
151         view
152         returns (uint256)
153     {
154         if (_level < 5) {
155             return LEVEL_EXPIRE_TIME;
156         } else {
157             return LEVEL_HIGHER_FOUR_EXPIRE_TIME;
158         }
159     }
160 
161     function findReferrer(address _user) internal view returns (address) {
162         if (users[_user].referrals.length < REFERRALS_LIMIT) {
163             return _user;
164         }
165 
166         address[1632] memory referrals;
167         referrals[0] = users[_user].referrals[0];
168         referrals[1] = users[_user].referrals[1];
169 
170         address referrer;
171 
172         for (uint256 i = 0; i < 16382; i++) {
173             if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
174                 referrer = referrals[i];
175                 break;
176             }
177 
178             if (i >= 8191) {
179                 continue;
180             }
181 
182             referrals[(i + 1) * 2] = users[referrals[i]].referrals[0];
183             referrals[(i + 1) * 2 + 1] = users[referrals[i]].referrals[1];
184         }
185 
186         require(referrer != address(0), "Referrer not found");
187         return referrer;
188     }
189 
190     function transferLevelPayment(uint256 _level, address _user) internal {
191         address referrer = getUserUpline(_user, _level);
192         address sender = msg.sender;
193 
194         if (referrer == address(0)) {
195             referrer = creator;
196         }
197 
198         uint256 uplines = 3;
199         uint256 eth = msg.value;
200         uint256 ethToReferrer = (eth - (directPrice[_level] * 2)) / uplines;
201 
202         for (uint256 i = 1; i <= uplines; i++) {
203             referrer = getUserUpline(_user, i);
204 
205             if (
206                 referrer != address(0) &&
207                 (users[_user].levelExpiresAt[_level] == 0 ||
208                     getUserLevelExpiresAt(referrer, _level) < now)
209             ) {
210                 uplines++;
211                 continue;
212             }
213 
214             if (referrer == address(0)) {
215                 referrer = creator;
216             }
217 
218             eth = eth - ethToReferrer;
219 
220             (bool success, ) = address(uint256(referrer)).call{
221                 value: ethToReferrer
222             }("");
223             require(success, "Transfer failed.");
224             emit GetLevelProfitEvent(
225                 referrer,
226                 sender,
227                 users[sender].id,
228                 ethToReferrer
229             );
230         }
231 
232         address directRefer = userAddresses[users[msg.sender].referrerID];
233 
234         eth = eth - directPrice[_level];
235         (bool success2, ) = address(uint256(directRefer)).call{
236             value: directPrice[_level]
237         }("");
238         require(success2, "Transfer failed.");
239         emit GetLevelProfitEvent(
240             directRefer,
241             sender,
242             users[sender].id,
243             directPrice[_level]
244         );
245 
246         (bool success3, ) = address(uint256(creator)).call{value: eth}("");
247         require(success3, "Transfer failed.");
248     }
249 
250     function getUserUpline(address _user, uint256 height)
251         public
252         view
253         returns (address)
254     {
255         if (height <= 0 || _user == address(0)) {
256             return _user;
257         }
258 
259         return
260             this.getUserUpline(
261                 userAddresses[users[_user].referrerID],
262                 height - 1
263             );
264     }
265 
266     function getUserLevelExpiresAt(address _user, uint256 _level)
267         public
268         view
269         returns (uint256)
270     {
271         return users[_user].levelExpiresAt[_level];
272     }
273 
274     function getUserReferrals(address _user)
275         public
276         view
277         returns (address[] memory)
278     {
279         return users[_user].referrals;
280     }
281 
282     function getUserLevel(address _user) public view returns (uint256) {
283         if (getUserLevelExpiresAt(_user, 1) < now) {
284             return (0);
285         } else if (getUserLevelExpiresAt(_user, 2) < now) {
286             return (1);
287         } else if (getUserLevelExpiresAt(_user, 3) < now) {
288             return (2);
289         } else if (getUserLevelExpiresAt(_user, 4) < now) {
290             return (3);
291         } else if (getUserLevelExpiresAt(_user, 5) < now) {
292             return (4);
293         } else if (getUserLevelExpiresAt(_user, 6) < now) {
294             return (5);
295         } else if (getUserLevelExpiresAt(_user, 7) < now) {
296             return (6);
297         } else if (getUserLevelExpiresAt(_user, 8) < now) {
298             return (7);
299         } else if (getUserLevelExpiresAt(_user, 9) < now) {
300             return (8);
301         } else if (getUserLevelExpiresAt(_user, 10) < now) {
302             return (9);
303         }
304     }
305 
306     receive() external payable {
307         revert();
308     }
309 }