1 /**
2 *
3 * Hello
4  * This contract belongs to MILLIONAIRECLUB
5  * URL: https://millionaireclub.money
6  * 
7  */
8 
9 pragma solidity  ^0.5.12;
10 
11 contract MILLIONAIRECLUB {
12   address public creator;
13   uint MAX_LEVEL = 9;
14   uint REFERRALS_LIMIT = 2;
15   uint LEVEL_EXPIRE_TIME = 3650 days;
16   mapping (address => User) public users;
17   mapping (uint => address) public userAddresses;
18   uint public last_uid;
19   mapping (uint => uint) public levelPrice;
20   mapping (uint => uint) public uplinesToRcvEth;
21   mapping (address => ProfitsRcvd) public rcvdProfits;
22   mapping (address => ProfitsGiven) public givenProfits;
23   mapping (address => LostProfits) public lostProfits;
24   
25   struct User {
26     uint id;
27     uint referrerID;
28     address[] referrals;
29     mapping (uint => uint) levelExpiresAt;
30   }
31   
32   struct ProfitsRcvd {
33     uint uid;
34     uint[] fromId;
35     address[] fromAddr;
36     uint[] amount;
37   }
38   
39   struct LostProfits {
40     uint uid;
41     uint[] toId;
42     address[] toAddr;
43     uint[] amount;
44     uint[] level;
45   }
46   
47   struct ProfitsGiven {
48     uint uid;
49     uint[] toId;
50     address[] toAddr;
51     uint[] amount;
52     uint[] level;
53     uint[] line;
54   }
55 
56   modifier validLevelAmount(uint _level) {
57     require(msg.value == levelPrice[_level], 'Invalid level amount sent');
58     _;
59   }
60   modifier userRegistered() {
61     require(users[msg.sender].id != 0, 'User does not exist');
62     _;
63   }
64   modifier validReferrerID(uint _referrerID) {
65     require(_referrerID > 0 && _referrerID <= last_uid, 'Invalid referrer ID');
66     _;
67   }
68   modifier userNotRegistered() {
69     require(users[msg.sender].id == 0, 'User is already registered');
70     _;
71   }
72   modifier validLevel(uint _level) {
73     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level entered');
74     _;
75   }
76   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
77   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
78   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
79   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
80 
81   constructor() public {
82     last_uid++;
83     creator = msg.sender;
84     levelPrice[1] = 0.0 ether;
85     levelPrice[2] = 0.10 ether;
86     levelPrice[3] = 0.20 ether;
87     levelPrice[4] = 0.40 ether;
88     levelPrice[5] = 0.80 ether;
89     levelPrice[6] = 1.60 ether;
90     levelPrice[7] = 3.20 ether;
91     levelPrice[8] = 6.40 ether;
92     levelPrice[9] = 12.28 ether;
93     uplinesToRcvEth[1] = 0;
94     uplinesToRcvEth[2] = 20;
95     uplinesToRcvEth[3] = 20;
96     uplinesToRcvEth[4] = 20;
97     uplinesToRcvEth[5] = 20;
98     uplinesToRcvEth[6] = 20;
99     uplinesToRcvEth[7] = 20;
100     uplinesToRcvEth[8] = 20;
101     uplinesToRcvEth[9] = 20;
102    
103 
104     users[creator] = User({
105       id: last_uid,
106       referrerID: 0,
107       referrals: new address[](0)
108     });
109     userAddresses[last_uid] = creator;
110     // enter all levels expiry for creator
111     for (uint i = 1; i <= MAX_LEVEL; i++) {
112       users[creator].levelExpiresAt[i] = 1 << 37;
113     }
114   }
115 
116 
117   function registerUser(uint _referrerID)
118     public
119     payable
120     userNotRegistered()
121     validReferrerID(_referrerID)
122     validLevelAmount(1)
123   {
124     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
125       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
126     }
127     last_uid++;
128     users[msg.sender] = User({
129       id: last_uid,
130       referrerID: _referrerID,
131       referrals: new address[](0)
132     });
133     userAddresses[last_uid] = msg.sender;
134     users[msg.sender].levelExpiresAt[1] = now + LEVEL_EXPIRE_TIME;
135     users[userAddresses[_referrerID]].referrals.push(msg.sender);
136 
137     transferLevelPayment(1, msg.sender);
138     emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
139   }
140 
141   function buyLevel(uint _level)
142     public
143     payable
144     userRegistered()
145     validLevel(_level)
146     validLevelAmount(_level)
147   {
148     for (uint l = _level - 1; l > 0; l--) {
149       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy previous level first');
150     }
151     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
152       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_EXPIRE_TIME;
153     } else {
154       users[msg.sender].levelExpiresAt[_level] += LEVEL_EXPIRE_TIME;
155     }
156 
157     transferLevelPayment(_level, msg.sender);
158     emit BuyLevelEvent(msg.sender, _level, now);
159   }
160 
161   function findReferrer(address _user)
162     public
163     view
164     returns (address)
165   {
166     if (users[_user].referrals.length < REFERRALS_LIMIT) {
167       return _user;
168     }
169 
170     address[1632] memory referrals;
171     referrals[0] = users[_user].referrals[0];
172     referrals[1] = users[_user].referrals[1];
173 
174     address referrer;
175 
176     for (uint i = 0; i < 16382; i++) {
177       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
178         referrer = referrals[i];
179         break;
180       }
181 
182       if (i >= 8191) {
183         continue;
184       }
185 
186       referrals[(i+1)*2] = users[referrals[i]].referrals[0];
187       referrals[(i+1)*2+1] = users[referrals[i]].referrals[1];
188     }
189 
190     require(referrer != address(0), 'Referrer not found');
191     return referrer;
192   }
193 
194   function transferLevelPayment(uint _level, address _user) internal {
195     uint height = _level;
196     address referrer = getUserUpline(_user, height);
197 
198     if (referrer == address(0)) { referrer = creator; }
199    
200     uint uplines = uplinesToRcvEth[_level];
201     bool chkLostProfit = false;
202     address lostAddr;
203     for (uint i = 1; i <= uplines; i++) {
204       referrer = getUserUpline(_user, i);
205       
206       if(chkLostProfit){
207         lostProfits[lostAddr].uid = users[referrer].id;
208         lostProfits[lostAddr].toId.push(users[referrer].id);
209         lostProfits[lostAddr].toAddr.push(referrer);
210         lostProfits[lostAddr].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
211         lostProfits[lostAddr].level.push(getUserLevel(referrer));
212         chkLostProfit = false;
213         
214         emit LostLevelProfitEvent(referrer, msg.sender, _level, 0);
215       }
216       
217       if (referrer != address(0) && (users[_user].levelExpiresAt[_level] == 0 || getUserLevelExpiresAt(referrer, _level) < now)) {
218         chkLostProfit = true;
219         uplines++;
220         lostAddr = referrer;
221         continue;
222       }
223       else {chkLostProfit = false;}
224       
225       //add msg.value / uplinesToRcvEth[_level] in user's earned
226       
227       if (referrer == address(0)) { referrer = creator; }
228       if (address(uint160(referrer)).send( msg.value / uplinesToRcvEth[_level] )) {
229         rcvdProfits[referrer].uid = users[referrer].id;
230         rcvdProfits[referrer].fromId.push(users[msg.sender].id);
231         rcvdProfits[referrer].fromAddr.push(msg.sender);
232         rcvdProfits[referrer].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
233         
234         givenProfits[msg.sender].uid = users[msg.sender].id;
235         givenProfits[msg.sender].toId.push(users[referrer].id);
236         givenProfits[msg.sender].toAddr.push(referrer);
237         givenProfits[msg.sender].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
238         givenProfits[msg.sender].level.push(getUserLevel(referrer));
239         givenProfits[msg.sender].line.push(i);
240         
241         emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
242       }
243     }
244   }
245 
246   function getUserUpline(address _user, uint height)
247     public
248     view
249     returns (address)
250   {
251     if (height <= 0 || _user == address(0)) {
252       return _user;
253     }
254 
255     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
256   }
257 
258   function getUserReferrals(address _user)
259     public
260     view
261     returns (address[] memory)
262   {
263     return users[_user].referrals;
264   }
265   
266   
267   function getUserProfitsFromId(address _user)
268     public
269     view
270     returns (uint[] memory)
271   {
272       return rcvdProfits[_user].fromId;
273   }
274   
275   function getUserProfitsFromAddr(address _user)
276     public
277     view
278     returns (address[] memory)
279   {
280       return rcvdProfits[_user].fromAddr;
281   }
282   
283   function getUserProfitsAmount(address _user)
284     public
285     view
286     returns (uint256[] memory)
287   {
288       return rcvdProfits[_user].amount;
289   }
290   
291   
292   
293   function getUserProfitsGivenToId(address _user)
294     public
295     view
296     returns (uint[] memory)
297   {
298       return givenProfits[_user].toId;
299   }
300   
301   function getUserProfitsGivenToAddr(address _user)
302     public
303     view
304     returns (address[] memory)
305   {
306       return givenProfits[_user].toAddr;
307   }
308   
309   function getUserProfitsGivenToAmount(address _user)
310     public
311     view
312     returns (uint[] memory)
313   {
314       return givenProfits[_user].amount;
315   }
316   
317   function getUserProfitsGivenToLevel(address _user)
318     public
319     view
320     returns (uint[] memory)
321   {
322       return givenProfits[_user].level;
323   }
324   
325   function getUserProfitsGivenToLine(address _user)
326     public
327     view
328     returns (uint[] memory)
329   {
330       return givenProfits[_user].line;
331   }
332   
333   
334   function getUserLostsToId(address _user)
335     public
336     view
337     returns (uint[] memory)
338   {
339     return (lostProfits[_user].toId);
340   }
341   
342   function getUserLostsToAddr(address _user)
343     public
344     view
345     returns (address[] memory)
346   {
347     return (lostProfits[_user].toAddr);
348   }
349   
350   function getUserLostsAmount(address _user)
351     public
352     view
353     returns (uint[] memory)
354   {
355     return (lostProfits[_user].amount);
356   }
357   
358   function getUserLostsLevel(address _user)
359     public
360     view
361     returns (uint[] memory)
362   {
363     return (lostProfits[_user].level);
364   }
365   
366 
367   function getUserLevelExpiresAt(address _user, uint _level)
368     public
369     view
370     returns (uint)
371   {
372     return users[_user].levelExpiresAt[_level];
373   }
374 
375   
376 
377   function () external payable {
378     revert();
379   }
380   
381   
382   function getUserLevel (address _user) public view returns (uint) {
383       if (getUserLevelExpiresAt(_user, 1) < now) {
384           return (0);
385       }
386       else if (getUserLevelExpiresAt(_user, 2) < now) {
387           return (1);
388       }
389       else if (getUserLevelExpiresAt(_user, 3) < now) {
390           return (2);
391       }
392       else if (getUserLevelExpiresAt(_user, 4) < now) {
393           return (3);
394       }
395       else if (getUserLevelExpiresAt(_user, 5) < now) {
396           return (4);
397       }
398       else if (getUserLevelExpiresAt(_user, 6) < now) {
399           return (5);
400       }
401       else if (getUserLevelExpiresAt(_user, 7) < now) {
402           return (6);
403       }
404       else if (getUserLevelExpiresAt(_user, 8) < now) {
405           return (7);
406       }
407       else if (getUserLevelExpiresAt(_user, 9) < now) {
408           return (8);
409       }
410       else if (getUserLevelExpiresAt(_user, 10) < now) {
411           return (9);
412       
413       }
414   }
415   
416   function getUserDetails (address _user) public view returns (uint, uint) {
417       if (getUserLevelExpiresAt(_user, 1) < now) {
418           return (1, users[_user].id);
419       }
420       else if (getUserLevelExpiresAt(_user, 2) < now) {
421           return (2, users[_user].id);
422       }
423       else if (getUserLevelExpiresAt(_user, 3) < now) {
424           return (3, users[_user].id);
425       }
426       else if (getUserLevelExpiresAt(_user, 4) < now) {
427           return (4, users[_user].id);
428       }
429       else if (getUserLevelExpiresAt(_user, 5) < now) {
430           return (5, users[_user].id);
431       }
432       else if (getUserLevelExpiresAt(_user, 6) < now) {
433           return (6, users[_user].id);
434       }
435       else if (getUserLevelExpiresAt(_user, 7) < now) {
436           return (7, users[_user].id);
437       }
438       else if (getUserLevelExpiresAt(_user, 8) < now) {
439           return (8, users[_user].id);
440       }
441       else if (getUserLevelExpiresAt(_user, 9) < now) {
442           return (9, users[_user].id);
443       }
444   }
445       }