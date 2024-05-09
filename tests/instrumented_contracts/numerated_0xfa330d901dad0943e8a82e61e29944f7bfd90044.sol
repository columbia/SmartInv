1 /**
2 
3 * ███████╗ ████████╗ ██╗  ██╗ ███████╗ ██████╗  ███████╗ ██╗   ██╗ ███╗   ███╗ ███████╗
4 * ██╔════╝ ╚══██╔══╝ ██║  ██║ ██╔════╝ ██╔══██╗ ██╔════╝ ██║   ██║ ████╗ ████║ ██╔════╝
5 * █████╗      ██║    ███████║ █████╗   ██████╔╝ █████╗   ██║   ██║ ██╔████╔██║ ███████╗
6 * ██╔══╝      ██║    ██╔══██║ ██╔══╝   ██╔══██╗ ██╔══╝   ██║   ██║ ██║╚██╔╝██║ ╚════██║
7 * ███████╗    ██║    ██║  ██║ ███████╗ ██║  ██║ ███████╗ ╚██████╔╝ ██║ ╚═╝ ██║ ███████║
8 * ╚══════╝    ╚═╝    ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝ ╚══════╝  ╚═════╝  ╚═╝     ╚═╝ ╚══════╝
9 
10 *                      ██████╗  █████╗  ███████╗ ██╗  ██╗
11 *                     ██╔════╝ ██╔══██╗ ██╔════╝ ██║  ██║
12 *                     ██║      ███████║ ███████╗ ███████║
13 *                     ██║      ██╔══██║ ╚════██║ ██╔══██║
14 *                     ╚██████╗ ██║  ██║ ███████║ ██║  ██║
15 *                      ╚═════╝ ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝
16 
17 * Hello
18  * This contract belongs to EthereumsCash (fixed)
19  * URL: https://ethereums.cash
20  * 
21  */
22 
23 pragma solidity  ^0.5.12;
24 
25 contract Ethereumscash {
26   address public creator;
27   uint MAX_LEVEL = 9;
28   uint REFERRALS_LIMIT = 2;
29   uint LEVEL_EXPIRE_TIME = 180 days;
30   mapping (address => User) public users;
31   mapping (uint => address) public userAddresses;
32   uint public last_uid;
33   mapping (uint => uint) public levelPrice;
34   mapping (uint => uint) public uplinesToRcvEth;
35   mapping (address => ProfitsRcvd) public rcvdProfits;
36   mapping (address => ProfitsGiven) public givenProfits;
37   mapping (address => LostProfits) public lostProfits;
38   
39   struct User {
40     uint id;
41     uint referrerID;
42     address[] referrals;
43     mapping (uint => uint) levelExpiresAt;
44   }
45   
46   struct ProfitsRcvd {
47     uint uid;
48     uint[] fromId;
49     address[] fromAddr;
50     uint[] amount;
51   }
52   
53   struct LostProfits {
54     uint uid;
55     uint[] toId;
56     address[] toAddr;
57     uint[] amount;
58     uint[] level;
59   }
60   
61   struct ProfitsGiven {
62     uint uid;
63     uint[] toId;
64     address[] toAddr;
65     uint[] amount;
66     uint[] level;
67     uint[] line;
68   }
69 
70   modifier validLevelAmount(uint _level) {
71     require(msg.value == levelPrice[_level], 'Invalid level amount sent');
72     _;
73   }
74   modifier userRegistered() {
75     require(users[msg.sender].id != 0, 'User does not exist');
76     _;
77   }
78   modifier validReferrerID(uint _referrerID) {
79     require(_referrerID > 0 && _referrerID <= last_uid, 'Invalid referrer ID');
80     _;
81   }
82   modifier userNotRegistered() {
83     require(users[msg.sender].id == 0, 'User is already registered');
84     _;
85   }
86   modifier validLevel(uint _level) {
87     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level entered');
88     _;
89   }
90   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
91   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
92   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
93   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
94 
95   constructor() public {
96     last_uid++;
97     creator = msg.sender;
98     levelPrice[1] = 0.025 ether;
99     levelPrice[2] = 0.06 ether;
100     levelPrice[3] = 0.28 ether;
101     levelPrice[4] = 0.64 ether;
102     levelPrice[5] = 1.44 ether;
103     levelPrice[6] = 3.2 ether;
104     levelPrice[7] = 7.04 ether;
105     levelPrice[8] = 15.36 ether;
106     levelPrice[9] = 33.28 ether;
107     uplinesToRcvEth[1] = 5;
108     uplinesToRcvEth[2] = 6;
109     uplinesToRcvEth[3] = 7;
110     uplinesToRcvEth[4] = 8;
111     uplinesToRcvEth[5] = 9;
112     uplinesToRcvEth[6] = 10;
113     uplinesToRcvEth[7] = 11;
114     uplinesToRcvEth[8] = 12;
115     uplinesToRcvEth[9] = 13;
116 
117     users[creator] = User({
118       id: last_uid,
119       referrerID: 0,
120       referrals: new address[](0)
121     });
122     userAddresses[last_uid] = creator;
123     // enter all levels expiry for creator
124     for (uint i = 1; i <= MAX_LEVEL; i++) {
125       users[creator].levelExpiresAt[i] = 1 << 37;
126     }
127   }
128 
129 
130   function registerUser(uint _referrerID)
131     public
132     payable
133     userNotRegistered()
134     validReferrerID(_referrerID)
135     validLevelAmount(1)
136   {
137     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
138       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
139     }
140     last_uid++;
141     users[msg.sender] = User({
142       id: last_uid,
143       referrerID: _referrerID,
144       referrals: new address[](0)
145     });
146     userAddresses[last_uid] = msg.sender;
147     users[msg.sender].levelExpiresAt[1] = now + LEVEL_EXPIRE_TIME;
148     users[userAddresses[_referrerID]].referrals.push(msg.sender);
149 
150     transferLevelPayment(1, msg.sender);
151     emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
152   }
153 
154   function buyLevel(uint _level)
155     public
156     payable
157     userRegistered()
158     validLevel(_level)
159     validLevelAmount(_level)
160   {
161     for (uint l = _level - 1; l > 0; l--) {
162       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy previous level first');
163     }
164     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
165       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_EXPIRE_TIME;
166     } else {
167       users[msg.sender].levelExpiresAt[_level] += LEVEL_EXPIRE_TIME;
168     }
169 
170     transferLevelPayment(_level, msg.sender);
171     emit BuyLevelEvent(msg.sender, _level, now);
172   }
173 
174   function findReferrer(address _user)
175     public
176     view
177     returns (address)
178   {
179     if (users[_user].referrals.length < REFERRALS_LIMIT) {
180       return _user;
181     }
182 
183     address[1632] memory referrals;
184     referrals[0] = users[_user].referrals[0];
185     referrals[1] = users[_user].referrals[1];
186 
187     address referrer;
188 
189     for (uint i = 0; i < 16382; i++) {
190       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
191         referrer = referrals[i];
192         break;
193       }
194 
195       if (i >= 8191) {
196         continue;
197       }
198 
199       referrals[(i+1)*2] = users[referrals[i]].referrals[0];
200       referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
201     }
202 
203     require(referrer != address(0), 'Referrer not found');
204     return referrer;
205   }
206 
207   function transferLevelPayment(uint _level, address _user) internal {
208     uint height = _level;
209     address referrer = getUserUpline(_user, height);
210 
211     if (referrer == address(0)) { referrer = creator; }
212    
213     uint uplines = uplinesToRcvEth[_level];
214     bool chkLostProfit = false;
215     address lostAddr;
216     for (uint i = 1; i <= uplines; i++) {
217       referrer = getUserUpline(_user, i);
218       
219       if(chkLostProfit){
220         lostProfits[lostAddr].uid = users[referrer].id;
221         lostProfits[lostAddr].toId.push(users[referrer].id);
222         lostProfits[lostAddr].toAddr.push(referrer);
223         lostProfits[lostAddr].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
224         lostProfits[lostAddr].level.push(getUserLevel(referrer));
225         chkLostProfit = false;
226         
227         emit LostLevelProfitEvent(referrer, msg.sender, _level, 0);
228       }
229       
230       if (referrer != address(0) && (users[_user].levelExpiresAt[_level] == 0 || getUserLevelExpiresAt(referrer, _level) < now)) {
231         chkLostProfit = true;
232         uplines++;
233         lostAddr = referrer;
234         continue;
235       }
236       else {chkLostProfit = false;}
237       
238       //add msg.value / uplinesToRcvEth[_level] in user's earned
239       
240       if (referrer == address(0)) { referrer = creator; }
241       if (address(uint160(referrer)).send( msg.value / uplinesToRcvEth[_level] )) {
242         rcvdProfits[referrer].uid = users[referrer].id;
243         rcvdProfits[referrer].fromId.push(users[msg.sender].id);
244         rcvdProfits[referrer].fromAddr.push(msg.sender);
245         rcvdProfits[referrer].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
246         
247         givenProfits[msg.sender].uid = users[msg.sender].id;
248         givenProfits[msg.sender].toId.push(users[referrer].id);
249         givenProfits[msg.sender].toAddr.push(referrer);
250         givenProfits[msg.sender].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
251         givenProfits[msg.sender].level.push(getUserLevel(referrer));
252         givenProfits[msg.sender].line.push(i);
253         
254         emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
255       }
256     }
257   }
258 
259   function getUserUpline(address _user, uint height)
260     public
261     view
262     returns (address)
263   {
264     if (height <= 0 || _user == address(0)) {
265       return _user;
266     }
267 
268     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
269   }
270 
271   function getUserReferrals(address _user)
272     public
273     view
274     returns (address[] memory)
275   {
276     return users[_user].referrals;
277   }
278   
279   
280   function getUserProfitsFromId(address _user)
281     public
282     view
283     returns (uint[] memory)
284   {
285       return rcvdProfits[_user].fromId;
286   }
287   
288   function getUserProfitsFromAddr(address _user)
289     public
290     view
291     returns (address[] memory)
292   {
293       return rcvdProfits[_user].fromAddr;
294   }
295   
296   function getUserProfitsAmount(address _user)
297     public
298     view
299     returns (uint256[] memory)
300   {
301       return rcvdProfits[_user].amount;
302   }
303   
304   
305   
306   function getUserProfitsGivenToId(address _user)
307     public
308     view
309     returns (uint[] memory)
310   {
311       return givenProfits[_user].toId;
312   }
313   
314   function getUserProfitsGivenToAddr(address _user)
315     public
316     view
317     returns (address[] memory)
318   {
319       return givenProfits[_user].toAddr;
320   }
321   
322   function getUserProfitsGivenToAmount(address _user)
323     public
324     view
325     returns (uint[] memory)
326   {
327       return givenProfits[_user].amount;
328   }
329   
330   function getUserProfitsGivenToLevel(address _user)
331     public
332     view
333     returns (uint[] memory)
334   {
335       return givenProfits[_user].level;
336   }
337   
338   function getUserProfitsGivenToLine(address _user)
339     public
340     view
341     returns (uint[] memory)
342   {
343       return givenProfits[_user].line;
344   }
345   
346   
347   function getUserLostsToId(address _user)
348     public
349     view
350     returns (uint[] memory)
351   {
352     return (lostProfits[_user].toId);
353   }
354   
355   function getUserLostsToAddr(address _user)
356     public
357     view
358     returns (address[] memory)
359   {
360     return (lostProfits[_user].toAddr);
361   }
362   
363   function getUserLostsAmount(address _user)
364     public
365     view
366     returns (uint[] memory)
367   {
368     return (lostProfits[_user].amount);
369   }
370   
371   function getUserLostsLevel(address _user)
372     public
373     view
374     returns (uint[] memory)
375   {
376     return (lostProfits[_user].level);
377   }
378   
379 
380   function getUserLevelExpiresAt(address _user, uint _level)
381     public
382     view
383     returns (uint)
384   {
385     return users[_user].levelExpiresAt[_level];
386   }
387 
388   
389 
390   function () external payable {
391     revert();
392   }
393   
394   
395   function getUserLevel (address _user) public view returns (uint) {
396       if (getUserLevelExpiresAt(_user, 1) < now) {
397           return (0);
398       }
399       else if (getUserLevelExpiresAt(_user, 2) < now) {
400           return (1);
401       }
402       else if (getUserLevelExpiresAt(_user, 3) < now) {
403           return (2);
404       }
405       else if (getUserLevelExpiresAt(_user, 4) < now) {
406           return (3);
407       }
408       else if (getUserLevelExpiresAt(_user, 5) < now) {
409           return (4);
410       }
411       else if (getUserLevelExpiresAt(_user, 6) < now) {
412           return (5);
413       }
414       else if (getUserLevelExpiresAt(_user, 7) < now) {
415           return (6);
416       }
417       else if (getUserLevelExpiresAt(_user, 8) < now) {
418           return (7);
419       }
420       else if (getUserLevelExpiresAt(_user, 9) < now) {
421           return (8);
422       }
423       else if (getUserLevelExpiresAt(_user, 10) < now) {
424           return (9);
425       }
426   }
427   
428   function getUserDetails (address _user) public view returns (uint, uint) {
429       if (getUserLevelExpiresAt(_user, 1) < now) {
430           return (1, users[_user].id);
431       }
432       else if (getUserLevelExpiresAt(_user, 2) < now) {
433           return (2, users[_user].id);
434       }
435       else if (getUserLevelExpiresAt(_user, 3) < now) {
436           return (3, users[_user].id);
437       }
438       else if (getUserLevelExpiresAt(_user, 4) < now) {
439           return (4, users[_user].id);
440       }
441       else if (getUserLevelExpiresAt(_user, 5) < now) {
442           return (5, users[_user].id);
443       }
444       else if (getUserLevelExpiresAt(_user, 6) < now) {
445           return (6, users[_user].id);
446       }
447       else if (getUserLevelExpiresAt(_user, 7) < now) {
448           return (7, users[_user].id);
449       }
450       else if (getUserLevelExpiresAt(_user, 8) < now) {
451           return (8, users[_user].id);
452       }
453       else if (getUserLevelExpiresAt(_user, 9) < now) {
454           return (9, users[_user].id);
455       }
456   }
457 
458 }