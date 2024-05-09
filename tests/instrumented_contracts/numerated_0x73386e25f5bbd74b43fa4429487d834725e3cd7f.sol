1 /**
2 *
3 * ███████╗ ████████╗ ██╗  ██╗ ███████╗ ██████╗   █████╗ 
4 * ██╔════╝ ╚══██╔══╝ ██║  ██║ ██╔════╝ ██╔══██╗ ██╔══██╗
5 * █████╗      ██║    ███████║ █████╗   ██████╔╝ ███████║
6 * ██╔══╝      ██║    ██╔══██║ ██╔══╝   ██╔══██╗ ██╔══██║
7 * ███████╗    ██║    ██║  ██║ ███████╗ ██║  ██║ ██║  ██║
8 * ╚══════╝    ╚═╝    ╚═╝  ╚═╝ ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝
9 * Hello
10  * This contract belongs to ETHERAUK (fixed)
11  * URL: https://ethera.live
12  * Telegram : @ethera_live
13  */
14 
15 pragma solidity  ^0.5.12;
16 
17 contract ETHERAUK {
18   address public creator;
19   uint MAX_LEVEL = 9;
20   uint REFERRALS_LIMIT = 2;
21   uint LEVEL_EXPIRE_TIME = 180 days;
22   mapping (address => User) public users;
23   mapping (uint => address) public userAddresses;
24   uint public last_uid;
25   mapping (uint => uint) public levelPrice;
26   mapping (uint => uint) public uplinesToRcvEth;
27   mapping (address => ProfitsRcvd) public rcvdProfits;
28   mapping (address => ProfitsGiven) public givenProfits;
29   mapping (address => LostProfits) public lostProfits;
30   
31   struct User {
32     uint id;
33     uint referrerID;
34     address[] referrals;
35     mapping (uint => uint) levelExpiresAt;
36   }
37   
38   struct ProfitsRcvd {
39     uint uid;
40     uint[] fromId;
41     address[] fromAddr;
42     uint[] amount;
43   }
44   
45   struct LostProfits {
46     uint uid;
47     uint[] toId;
48     address[] toAddr;
49     uint[] amount;
50     uint[] level;
51   }
52   
53   struct ProfitsGiven {
54     uint uid;
55     uint[] toId;
56     address[] toAddr;
57     uint[] amount;
58     uint[] level;
59     uint[] line;
60   }
61 
62   modifier validLevelAmount(uint _level) {
63     require(msg.value == levelPrice[_level], 'Invalid level amount sent');
64     _;
65   }
66   modifier userRegistered() {
67     require(users[msg.sender].id != 0, 'User does not exist');
68     _;
69   }
70   modifier validReferrerID(uint _referrerID) {
71     require(_referrerID > 0 && _referrerID <= last_uid, 'Invalid referrer ID');
72     _;
73   }
74   modifier userNotRegistered() {
75     require(users[msg.sender].id == 0, 'User is already registered');
76     _;
77   }
78   modifier validLevel(uint _level) {
79     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level entered');
80     _;
81   }
82   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
83   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
84   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
85   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
86 
87   constructor() public {
88     last_uid++;
89     creator = msg.sender;
90     levelPrice[1] = 0.04 ether;
91     levelPrice[2] = 0.06 ether;
92     levelPrice[3] = 0.08 ether;
93     levelPrice[4] = 0.10 ether;
94     levelPrice[5] = 0.12 ether;
95     levelPrice[6] = 0.14 ether;
96     levelPrice[7] = 0.16 ether;
97     levelPrice[8] = 0.18 ether;
98     levelPrice[9] = 0.20 ether;
99     uplinesToRcvEth[1] = 8;
100     uplinesToRcvEth[2] = 8;
101     uplinesToRcvEth[3] = 8;
102     uplinesToRcvEth[4] = 8;
103     uplinesToRcvEth[5] = 8;
104     uplinesToRcvEth[6] = 8;
105     uplinesToRcvEth[7] = 8;
106     uplinesToRcvEth[8] = 8;
107     uplinesToRcvEth[9] = 8;
108  
109    
110 
111     users[creator] = User({
112       id: last_uid,
113       referrerID: 0,
114       referrals: new address[](0)
115     });
116     userAddresses[last_uid] = creator;
117     // enter all levels expiry for creator
118     for (uint i = 1; i <= MAX_LEVEL; i++) {
119       users[creator].levelExpiresAt[i] = 1 << 37;
120     }
121   }
122 
123 
124   function registerUser(uint _referrerID)
125     public
126     payable
127     userNotRegistered()
128     validReferrerID(_referrerID)
129     validLevelAmount(1)
130   {
131     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
132       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
133     }
134     last_uid++;
135     users[msg.sender] = User({
136       id: last_uid,
137       referrerID: _referrerID,
138       referrals: new address[](0)
139     });
140     userAddresses[last_uid] = msg.sender;
141     users[msg.sender].levelExpiresAt[1] = now + LEVEL_EXPIRE_TIME;
142     users[userAddresses[_referrerID]].referrals.push(msg.sender);
143 
144     transferLevelPayment(1, msg.sender);
145     emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
146   }
147 
148   function buyLevel(uint _level)
149     public
150     payable
151     userRegistered()
152     validLevel(_level)
153     validLevelAmount(_level)
154   {
155     for (uint l = _level - 1; l > 0; l--) {
156       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy previous level first');
157     }
158     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
159       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_EXPIRE_TIME;
160     } else {
161       users[msg.sender].levelExpiresAt[_level] += LEVEL_EXPIRE_TIME;
162     }
163 
164     transferLevelPayment(_level, msg.sender);
165     emit BuyLevelEvent(msg.sender, _level, now);
166   }
167 
168   function findReferrer(address _user)
169     public
170     view
171     returns (address)
172   {
173     if (users[_user].referrals.length < REFERRALS_LIMIT) {
174       return _user;
175     }
176 
177     address[1632] memory referrals;
178     referrals[0] = users[_user].referrals[0];
179     referrals[1] = users[_user].referrals[1];
180 
181     address referrer;
182 
183     for (uint i = 0; i < 16382; i++) {
184       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
185         referrer = referrals[i];
186         break;
187       }
188 
189       if (i >= 8191) {
190         continue;
191       }
192 
193       referrals[(i+1)*2] = users[referrals[i]].referrals[0];
194       referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
195     }
196 
197     require(referrer != address(0), 'Referrer not found');
198     return referrer;
199   }
200 
201   function transferLevelPayment(uint _level, address _user) internal {
202     uint height = _level;
203     address referrer = getUserUpline(_user, height);
204 
205     if (referrer == address(0)) { referrer = creator; }
206    
207     uint uplines = uplinesToRcvEth[_level];
208     bool chkLostProfit = false;
209     address lostAddr;
210     for (uint i = 1; i <= uplines; i++) {
211       referrer = getUserUpline(_user, i);
212       
213       if(chkLostProfit){
214         lostProfits[lostAddr].uid = users[referrer].id;
215         lostProfits[lostAddr].toId.push(users[referrer].id);
216         lostProfits[lostAddr].toAddr.push(referrer);
217         lostProfits[lostAddr].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
218         lostProfits[lostAddr].level.push(getUserLevel(referrer));
219         chkLostProfit = false;
220         
221         emit LostLevelProfitEvent(referrer, msg.sender, _level, 0);
222       }
223       
224       if (referrer != address(0) && (users[_user].levelExpiresAt[_level] == 0 || getUserLevelExpiresAt(referrer, _level) < now)) {
225         chkLostProfit = true;
226         uplines++;
227         lostAddr = referrer;
228         continue;
229       }
230       else {chkLostProfit = false;}
231       
232       //add msg.value / uplinesToRcvEth[_level] in user's earned
233       
234       if (referrer == address(0)) { referrer = creator; }
235       if (address(uint160(referrer)).send( msg.value / uplinesToRcvEth[_level] )) {
236         rcvdProfits[referrer].uid = users[referrer].id;
237         rcvdProfits[referrer].fromId.push(users[msg.sender].id);
238         rcvdProfits[referrer].fromAddr.push(msg.sender);
239         rcvdProfits[referrer].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
240         
241         givenProfits[msg.sender].uid = users[msg.sender].id;
242         givenProfits[msg.sender].toId.push(users[referrer].id);
243         givenProfits[msg.sender].toAddr.push(referrer);
244         givenProfits[msg.sender].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
245         givenProfits[msg.sender].level.push(getUserLevel(referrer));
246         givenProfits[msg.sender].line.push(i);
247         
248         emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
249       }
250     }
251   }
252 
253   function getUserUpline(address _user, uint height)
254     public
255     view
256     returns (address)
257   {
258     if (height <= 0 || _user == address(0)) {
259       return _user;
260     }
261 
262     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
263   }
264 
265   function getUserReferrals(address _user)
266     public
267     view
268     returns (address[] memory)
269   {
270     return users[_user].referrals;
271   }
272   
273   
274   function getUserProfitsFromId(address _user)
275     public
276     view
277     returns (uint[] memory)
278   {
279       return rcvdProfits[_user].fromId;
280   }
281   
282   function getUserProfitsFromAddr(address _user)
283     public
284     view
285     returns (address[] memory)
286   {
287       return rcvdProfits[_user].fromAddr;
288   }
289   
290   function getUserProfitsAmount(address _user)
291     public
292     view
293     returns (uint256[] memory)
294   {
295       return rcvdProfits[_user].amount;
296   }
297   
298   
299   
300   function getUserProfitsGivenToId(address _user)
301     public
302     view
303     returns (uint[] memory)
304   {
305       return givenProfits[_user].toId;
306   }
307   
308   function getUserProfitsGivenToAddr(address _user)
309     public
310     view
311     returns (address[] memory)
312   {
313       return givenProfits[_user].toAddr;
314   }
315   
316   function getUserProfitsGivenToAmount(address _user)
317     public
318     view
319     returns (uint[] memory)
320   {
321       return givenProfits[_user].amount;
322   }
323   
324   function getUserProfitsGivenToLevel(address _user)
325     public
326     view
327     returns (uint[] memory)
328   {
329       return givenProfits[_user].level;
330   }
331   
332   function getUserProfitsGivenToLine(address _user)
333     public
334     view
335     returns (uint[] memory)
336   {
337       return givenProfits[_user].line;
338   }
339   
340   
341   function getUserLostsToId(address _user)
342     public
343     view
344     returns (uint[] memory)
345   {
346     return (lostProfits[_user].toId);
347   }
348   
349   function getUserLostsToAddr(address _user)
350     public
351     view
352     returns (address[] memory)
353   {
354     return (lostProfits[_user].toAddr);
355   }
356   
357   function getUserLostsAmount(address _user)
358     public
359     view
360     returns (uint[] memory)
361   {
362     return (lostProfits[_user].amount);
363   }
364   
365   function getUserLostsLevel(address _user)
366     public
367     view
368     returns (uint[] memory)
369   {
370     return (lostProfits[_user].level);
371   }
372   
373 
374   function getUserLevelExpiresAt(address _user, uint _level)
375     public
376     view
377     returns (uint)
378   {
379     return users[_user].levelExpiresAt[_level];
380   }
381 
382   
383 
384   function () external payable {
385     revert();
386   }
387   
388   
389   function getUserLevel (address _user) public view returns (uint) {
390       if (getUserLevelExpiresAt(_user, 1) < now) {
391           return (0);
392       }
393       else if (getUserLevelExpiresAt(_user, 2) < now) {
394           return (1);
395       }
396       else if (getUserLevelExpiresAt(_user, 3) < now) {
397           return (2);
398       }
399       else if (getUserLevelExpiresAt(_user, 4) < now) {
400           return (3);
401       }
402       else if (getUserLevelExpiresAt(_user, 5) < now) {
403           return (4);
404       }
405       else if (getUserLevelExpiresAt(_user, 6) < now) {
406           return (5);
407       }
408       else if (getUserLevelExpiresAt(_user, 7) < now) {
409           return (6);
410       }
411       else if (getUserLevelExpiresAt(_user, 8) < now) {
412           return (7);
413       }
414       else if (getUserLevelExpiresAt(_user, 9) < now) {
415           return (8);
416       }
417       else if (getUserLevelExpiresAt(_user, 10) < now) {
418           return (9);
419       }
420   }
421   
422   function getUserDetails (address _user) public view returns (uint, uint) {
423       if (getUserLevelExpiresAt(_user, 1) < now) {
424           return (1, users[_user].id);
425       }
426       else if (getUserLevelExpiresAt(_user, 2) < now) {
427           return (2, users[_user].id);
428       }
429       else if (getUserLevelExpiresAt(_user, 3) < now) {
430           return (3, users[_user].id);
431       }
432       else if (getUserLevelExpiresAt(_user, 4) < now) {
433           return (4, users[_user].id);
434       }
435       else if (getUserLevelExpiresAt(_user, 5) < now) {
436           return (5, users[_user].id);
437       }
438       else if (getUserLevelExpiresAt(_user, 6) < now) {
439           return (6, users[_user].id);
440       }
441       else if (getUserLevelExpiresAt(_user, 7) < now) {
442           return (7, users[_user].id);
443       }
444       else if (getUserLevelExpiresAt(_user, 8) < now) {
445           return (8, users[_user].id);
446       }
447       else if (getUserLevelExpiresAt(_user, 9) < now) {
448           return (9, users[_user].id);
449       }
450   }
451       }