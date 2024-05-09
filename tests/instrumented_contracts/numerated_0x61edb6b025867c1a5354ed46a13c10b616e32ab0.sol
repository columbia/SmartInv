1 /**
2 *
3 *  HHHHHHHHH     HHHHHHHHHPPPPPPPPPPPPPPPPP        UUUUUUUU     UUUUUUUUPPPPPPPPPPPPPPPPP
4 *  H:::::::H     H:::::::HP::::::::::::::::P       U::::::U     U::::::UP::::::::::::::::P
5 *  H:::::::H     H:::::::HP::::::PPPPPP:::::P      U::::::U     U::::::UP::::::PPPPPP:::::P
6 *  HH::::::H     H::::::HHPP:::::P     P:::::P     UU:::::U     U:::::UUPP:::::P     P:::::P
7 *    H:::::H     H:::::H    P::::P     P:::::P      U:::::U     U:::::U   P::::P     P:::::P
8 *    H:::::H     H:::::H    P::::P     P:::::P      U:::::D     D:::::U   P::::P     P:::::P
9 *    H::::::HHHHH::::::H    P::::PPPPPP:::::P       U:::::D     D:::::U   P::::PPPPPP:::::P
10 *    H:::::::::::::::::H    P:::::::::::::PP        U:::::D     D:::::U   P:::::::::::::PP
11 *    H:::::::::::::::::H    P::::PPPPPPPPP          U:::::D     D:::::U   P::::PPPPPPPPP
12 *    H::::::HHHHH::::::H    P::::P                  U:::::D     D:::::U   P::::P
13 *    H:::::H     H:::::H    P::::P                  U:::::D     D:::::U   P::::P
14 *    H:::::H     H:::::H    P::::P                  U::::::U   U::::::U   P::::P
15 *  HH::::::H     H::::::HHPP::::::PP                U:::::::UUU:::::::U PP::::::PP
16 *  H:::::::H     H:::::::HP::::::::P                 UU:::::::::::::UU  P::::::::P
17 *  H:::::::H     H:::::::HP::::::::P                   UU:::::::::UU    P::::::::P
18 *  HHHHHHHHH     HHHHHHHHHPPPPPPPPPP                     UUUUUUUUU      PPPPPPPPPP
19 *
20 */
21 
22 pragma solidity >=0.4.24;
23 
24 contract HPUP {
25     struct Matrix {
26         uint id;
27         address owner;
28         uint referrals_cnt;
29         mapping(uint => uint) referrals;
30         uint matrix_referrer;
31         address direct_referrer;
32         uint from_hp;
33         uint cycles;
34     }
35 
36     struct User {
37         uint id;
38         address referrer;
39         uint matrices_cnt;
40         uint current_matrix;
41         uint lastMatrix;
42         uint hp_cooldown_time;
43         uint hp_cooldown_num;
44         uint direct_referrals;
45     }
46 
47     struct HPLine {
48         address owner;
49         uint matrix_id;
50     }
51 
52     mapping(address => User) public users;
53     mapping(uint => address) public usersById;
54     mapping(uint => mapping(uint => uint)) public usersMatrices;
55     mapping(uint => Matrix) public matrices;
56     mapping(uint => HPLine) public HP;
57 
58     address public owner;
59     uint public lastUserId = 1;
60     uint public lastHPId = 1;
61     uint public lastMatrixId = 1;
62 
63     event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
64     event Transfer(address indexed user, uint indexed userId, uint indexed amount);
65 
66     function isUserExists(address user) public view returns (bool) {
67         return (users[user].id != 0);
68     }
69 
70     constructor(address ownerAddress) public {
71         owner = ownerAddress;
72 
73         users[owner] = User({
74             id: lastUserId,
75             referrer: address(0),
76             matrices_cnt: 0,
77             current_matrix: 0,
78             lastMatrix: 0,
79             hp_cooldown_time: 0,
80             hp_cooldown_num: 0,
81             direct_referrals: 0
82             });
83 
84         usersById[lastUserId] = owner;
85 
86         matrices[lastMatrixId] = Matrix({
87             id: lastUserId,
88             owner: owner,
89             referrals_cnt: 0,
90             matrix_referrer: 0,
91             direct_referrer: address(0),
92             from_hp: 0,
93             cycles: 0
94             });
95 
96         usersMatrices[users[owner].id][users[owner].matrices_cnt] = lastMatrixId;
97         users[owner].matrices_cnt++;
98         users[owner].current_matrix = 0;
99 
100         HP[lastHPId] = HPLine({
101             matrix_id: lastMatrixId,
102             owner: owner
103             });
104 
105         lastHPId++;
106         lastMatrixId++;
107         lastUserId++;
108 
109 
110     }
111 
112     function reg(address referrer) public payable {
113         registration(msg.sender, referrer);
114     }
115 
116     function registration(address userAddress, address referrerAddress) private {
117         require(msg.value == 0.15 ether, "registration cost 0.15");
118         require(!isUserExists(userAddress), "user exists");
119         require(isUserExists(referrerAddress), "referrer not exists");
120 
121         uint32 size;
122         assembly {
123             size := extcodesize(userAddress)
124         }
125         require(size == 0, "cannot be a contract");
126 
127         users[userAddress] = User({
128             id: lastUserId,
129             referrer: referrerAddress,
130             matrices_cnt: 0,
131             current_matrix: 0,
132             lastMatrix: 0,
133             hp_cooldown_time: 0,
134             hp_cooldown_num: 0,
135             direct_referrals: 0
136             });
137 
138         usersById[lastUserId] = userAddress;
139 
140         lastUserId++;
141 
142         users[referrerAddress].direct_referrals++;
143 
144         payUser(referrerAddress, 0.025 ether);
145         joinHP(lastMatrixId, userAddress);
146         fillMatrix(userAddress, referrerAddress, 0);
147 
148         emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
149     }
150 
151     function purchaseHPPosition() public payable {
152         require(msg.value == 0.125 ether, "purchase cost 0.125");
153         require(isUserExists(msg.sender), "user not exists");
154         require(users[msg.sender].matrices_cnt < 150, "max 150 hp allowed");
155 
156         if (users[msg.sender].hp_cooldown_time < now - 86400) {
157             users[msg.sender].hp_cooldown_time = now;
158             users[msg.sender].hp_cooldown_num = 1;
159         } else {
160             if (users[msg.sender].hp_cooldown_num < 3) {
161                 users[msg.sender].hp_cooldown_num++;
162             } else {
163                 revert("24h purchase limit");
164             }
165         }
166 
167         joinHP(lastMatrixId, msg.sender);
168         fillMatrix(msg.sender, users[msg.sender].referrer, 1);
169     }
170 
171     function payUser(address user, uint amount) private {
172         emit Transfer(user, users[user].id, amount);
173         address(uint160(user)).transfer(amount);
174     }
175 
176     function payHP(address user) private {
177         emit Transfer(user, users[user].id, 0.05 ether);
178         address(uint160(user)).transfer(0.05 ether);
179     }
180 
181     function payAdmin(uint amount) private {
182         emit Transfer(owner, 0, amount);
183         address(uint160(owner)).transfer(amount);
184     }
185 
186     function joinHP(uint matrixId, address matrixOwner) private {
187         HP[lastHPId] = HPLine({
188             matrix_id: matrixId,
189             owner: matrixOwner
190             });
191         lastHPId++;
192 
193         if (matrices[matrixId].id != 0) {
194             matrices[matrixId].cycles++;
195         }
196 
197         if (lastHPId % 2 == 0) {
198             if (lastHPId <= 2) {
199                 payHP(owner);
200             } else {
201                 payHP(HP[lastHPId / 2 - 1].owner);
202                 joinHP(HP[lastHPId / 2 - 1].matrix_id, HP[lastHPId / 2 - 1].owner);
203                 payForMatrix(matrices[HP[lastHPId / 2 - 1].matrix_id].matrix_referrer);
204             }
205         }
206     }
207 
208     function payForMatrix(uint slotId) private {
209         if (slotId == 0) {
210             payAdmin(0.0375 ether);
211             return;
212         }
213 
214         uint level1 = slotId;
215 
216         while (users[matrices[level1].owner].direct_referrals < 4) {
217             if (level1 == 0) {
218                 payAdmin(0.0375 ether);
219                 return;
220             }
221 
222             level1 = matrices[level1].matrix_referrer;
223         }
224 
225         payUser(matrices[level1].owner, 0.1 * 0.0375 ether);
226 
227         uint level2 = matrices[level1].matrix_referrer;
228 
229         while (users[matrices[level2].owner].direct_referrals < 4) {
230             if (level2 == 0) {
231                 payAdmin(0.9 * 0.0375 ether);
232                 return;
233             }
234 
235             level2 = matrices[level2].matrix_referrer;
236         }
237 
238         payUser(matrices[level2].owner, 0.2 * 0.0375 ether);
239 
240         uint level3 = matrices[level2].matrix_referrer;
241 
242         while (users[matrices[level3].owner].direct_referrals < 4) {
243             if (level3 == 0) {
244                 payAdmin(0.7 * 0.0375 ether);
245                 return;
246             }
247 
248             level3 = matrices[level3].matrix_referrer;
249         }
250 
251         payUser(matrices[level3].owner, 0.3 * 0.0375 ether);
252 
253         uint level4 = matrices[level3].matrix_referrer;
254 
255         while (users[matrices[level4].owner].direct_referrals < 4) {
256             if (level4 == 0) {
257                 payAdmin(0.4 * 0.0375 ether);
258                 return;
259             }
260             level4 = matrices[level4].matrix_referrer;
261         }
262 
263         payUser(matrices[level4].owner, 0.4 * 0.0375 ether);
264     }
265 
266     function fillMatrix(address user, address referrer, uint from_hp) private {
267         if (referrer == address(0)) {
268             referrer = usersById[1];
269         }
270 
271         uint slotId = findSlot(usersMatrices[users[referrer].id][users[referrer].current_matrix], 1, 4);
272 
273         if (slotId == 0) {
274             if (users[referrer].current_matrix == users[referrer].matrices_cnt-1) {
275                 revert("all matrices are full");
276             }
277 
278             users[referrer].current_matrix++;
279             slotId = findSlot(usersMatrices[users[referrer].id][users[referrer].current_matrix], 1, 4);
280         }
281 
282         payForMatrix(slotId);
283 
284         matrices[lastMatrixId] = Matrix({
285             id: lastMatrixId,
286             owner: user,
287             referrals_cnt: 0,
288             matrix_referrer: slotId,
289             from_hp: from_hp,
290             direct_referrer: referrer,
291             cycles: 0
292             });
293 
294         usersMatrices[users[user].id][users[user].matrices_cnt] = lastMatrixId;
295         users[user].matrices_cnt++;
296         users[user].lastMatrix = lastMatrixId;
297 
298         matrices[lastMatrixId].matrix_referrer = slotId;
299 
300         lastMatrixId++;
301 
302         matrices[slotId].referrals[matrices[slotId].referrals_cnt] = lastMatrixId-1;
303         matrices[slotId].referrals_cnt++;
304     }
305 
306     function findSlot(uint matrix, uint level, uint maxLevel) private returns (uint) {
307         if (level > maxLevel) {
308             return(0);
309         }
310 
311         if (matrices[matrix].referrals_cnt < 4) {
312             return(matrix);
313         }
314 
315         uint tmpMaxLevel = level+1;
316 
317         while (tmpMaxLevel <= maxLevel) {
318             uint i=0;
319 
320             do {
321                 uint slot = findSlot(matrices[matrix].referrals[i], level+1, tmpMaxLevel);
322                 if (slot != 0) {
323                     return(slot);
324                 }
325 
326                 i++;
327             } while (i<4);
328 
329             tmpMaxLevel++;
330         }
331 
332         return(0);
333     }
334 }