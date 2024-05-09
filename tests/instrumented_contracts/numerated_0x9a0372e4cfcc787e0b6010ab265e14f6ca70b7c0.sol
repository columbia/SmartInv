1 /*
2  * ACE RETURNS
3  * DECENTRALIZED MATRIX SYSTEM
4  * URL: https://www.acereturns.io
5  */
6 
7 pragma solidity  ^0.5.12;
8 
9 contract AceReturns {
10   address public creator;
11   uint MAX_LEVEL = 9;
12   uint REFERRALS_LIMIT = 4;
13   uint LEVEL_EXPIRE_TIME = 180 days;
14   mapping (address => User) public users;
15   mapping (uint => address) public userAddresses;
16   uint public last_uid;
17   mapping (uint => uint) public levelPrice;
18   mapping (uint => uint) public levelnetPrice;
19   mapping (uint => uint) public uplinesToRcvEth;
20   mapping (address => ProfitsRcvd) public rcvdProfits;
21   mapping (address => ProfitsGiven) public givenProfits;
22   mapping (address => LostProfits) public lostProfits;
23   address payable private contract1 = msg.sender;
24   address payable private contract2 = msg.sender;
25   uint256 public launchtime = 1590168600;
26   
27   struct User {
28     uint id;
29     uint referrerID;
30     address[] referrals;
31     mapping (uint => uint) levelExpiresAt;
32   }
33 
34     struct ProfitsRcvd {
35     uint uid;
36     uint[] fromId;
37     address[] fromAddr;
38     uint[] amount;
39   }
40   
41   struct LostProfits {
42     uint uid;
43     uint[] toId;
44     address[] toAddr;
45     uint[] amount;
46     uint[] level;
47   }
48   
49   struct ProfitsGiven {
50     uint uid;
51     uint[] toId;
52     address[] toAddr;
53     uint[] amount;
54     uint[] level;
55     uint[] line;
56   }
57 
58   modifier validLevelAmount(uint _level) {
59     require(msg.value == levelPrice[_level], 'Invalid pool amount sent');
60     _;
61   }
62   modifier userRegistered() {
63     require(users[msg.sender].id != 0, 'User does not exist');
64     _;
65   }
66   modifier validReferrerID(uint _referrerID) {
67     require(_referrerID > 0 && _referrerID <= last_uid, 'Invalid referrer ID');
68     _;
69   }
70   modifier userNotRegistered() {
71     require(users[msg.sender].id == 0, 'User is already registered');
72     _;
73   }
74   modifier validLevel(uint _level) {
75     require(_level > 0 && _level <= MAX_LEVEL, 'Invalid level entered');
76     _;
77   }
78   event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
79   event BuyLevelEvent(address indexed user, uint indexed level, uint time);
80   event GetLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
81   event LostLevelProfitEvent(address indexed user, address indexed referral, uint indexed level, uint time);
82 
83   constructor() public {
84     last_uid++;
85     creator = msg.sender;
86     levelPrice[1] = 0.03 ether;
87     levelPrice[2] = 0.06 ether;
88     levelPrice[3] = 0.30 ether;
89     levelPrice[4] = 0.70 ether;
90     levelPrice[5] = 1.50 ether;
91     levelPrice[6] = 3.00 ether;
92     levelPrice[7] = 5.00 ether;
93     levelPrice[8] = 7.00 ether;
94     levelPrice[9] = 10.00 ether;
95     
96     levelnetPrice[1] = 0.0294 ether;
97     levelnetPrice[2] = 0.0588 ether;
98     levelnetPrice[3] = 0.294 ether;
99     levelnetPrice[4] = 0.686 ether;
100     levelnetPrice[5] = 1.47 ether;
101     levelnetPrice[6] = 2.94 ether;
102     levelnetPrice[7] = 4.90 ether;
103     levelnetPrice[8] = 6.86 ether;
104     levelnetPrice[9] = 9.80 ether;
105     
106     uplinesToRcvEth[1] = 1;
107     uplinesToRcvEth[2] = 2;
108     uplinesToRcvEth[3] = 3;
109     uplinesToRcvEth[4] = 4;
110     uplinesToRcvEth[5] = 5;
111     uplinesToRcvEth[6] = 6;
112     uplinesToRcvEth[7] = 7;
113     uplinesToRcvEth[8] = 8;
114     uplinesToRcvEth[9] = 9;
115 
116     users[creator] = User({
117       id: last_uid,
118       referrerID: 0,
119       referrals: new address[](0)
120     });
121     userAddresses[last_uid] = creator;
122     // enter all levels expiry for creator
123     for (uint i = 1; i <= MAX_LEVEL; i++) {
124       users[creator].levelExpiresAt[i] = 1 << 37;
125     }
126   }
127 
128 
129   function registerUser(uint _referrerID) public payable userNotRegistered() validReferrerID(_referrerID) validLevelAmount(1)
130   {
131     require(now >= launchtime);
132     if (users[userAddresses[_referrerID]].referrals.length >= REFERRALS_LIMIT) {
133       _referrerID = users[findReferrer(userAddresses[_referrerID])].id;
134     }
135     last_uid++;
136     users[msg.sender] = User({
137       id: last_uid,
138       referrerID: _referrerID,
139       referrals: new address[](0)
140     });
141     
142 
143     userAddresses[last_uid] = msg.sender;
144     users[msg.sender].levelExpiresAt[1] = now + LEVEL_EXPIRE_TIME;
145     users[userAddresses[_referrerID]].referrals.push(msg.sender);
146       uint256 _txns = SafeMath.mul(msg.value, 2);
147       uint256 _txn = SafeMath.div(_txns, 100);
148       uint256 _txnfinal = SafeMath.div(_txn, 2);
149       contract1.transfer(_txnfinal);
150       contract2.transfer(_txnfinal);
151       transferLevelPayment(1, msg.sender);
152       emit RegisterUserEvent(msg.sender, userAddresses[_referrerID], now);
153   }
154 
155   function buyLevel(uint _level)
156     public
157     payable
158     userRegistered()
159     validLevel(_level)
160     validLevelAmount(_level)
161   {
162     require(now >= launchtime);
163     for (uint l = _level - 1; l > 0; l--) {
164       require(getUserLevelExpiresAt(msg.sender, l) >= now, 'Buy previous level first');
165     }
166     if (getUserLevelExpiresAt(msg.sender, _level) == 0) {
167       users[msg.sender].levelExpiresAt[_level] = now + LEVEL_EXPIRE_TIME;
168     } else {
169       users[msg.sender].levelExpiresAt[_level] += LEVEL_EXPIRE_TIME;
170     }
171 
172       uint256 _txns = SafeMath.mul(msg.value, 2);
173       uint256 _txn = SafeMath.div(_txns, 100);
174       uint256 _txnfinal = SafeMath.div(_txn, 2);
175       contract1.transfer(_txnfinal);
176       contract2.transfer(_txnfinal);
177       
178     transferLevelPayment(_level, msg.sender);
179     emit BuyLevelEvent(msg.sender, _level, now);
180   }
181 
182   function findReferrer(address _user) public view returns(address)
183   {
184     if (users[_user].referrals.length < REFERRALS_LIMIT) {
185       return _user;
186     }
187 
188     address[21844] memory referrals;
189     referrals[0] = users[_user].referrals[0];
190     referrals[1] = users[_user].referrals[1];
191     referrals[2] = users[_user].referrals[2];
192     referrals[3] = users[_user].referrals[3];
193 
194     address referrer;
195 
196     for (uint i = 0; i < 349524; i++) {
197       if (users[referrals[i]].referrals.length < REFERRALS_LIMIT) {
198         referrer = referrals[i];
199         break;
200       }
201 
202       if (i >= 87381) {
203         continue;
204       }
205 
206       referrals[(i+1)*4] = users[referrals[i]].referrals[0];
207       referrals[(i+1)*4+1] = users[referrals[i]].referrals[1];
208       referrals[(i+1)*4+2] = users[referrals[i]].referrals[2];
209       referrals[(i+1)*4+3] = users[referrals[i]].referrals[3];
210     }
211 
212     require(referrer != address(0), 'Referrer not found');
213     return referrer;
214   }
215 
216 
217   function transferLevelPayment(uint _level, address _user) internal {
218     uint height = _level;
219     address referrer = getUserUpline(_user, height);
220 
221     if (referrer == address(0)) { referrer = creator; }
222    
223     uint uplines = uplinesToRcvEth[_level];
224     bool chkLostProfit = false;
225     address lostAddr;
226     for (uint i = 1; i <= uplines; i++) {
227       referrer = getUserUpline(_user, i);
228       
229       if(chkLostProfit){
230         lostProfits[lostAddr].uid = users[referrer].id;
231         lostProfits[lostAddr].toId.push(users[referrer].id);
232         lostProfits[lostAddr].toAddr.push(referrer);
233         //lostProfits[lostAddr].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
234         lostProfits[lostAddr].amount.push(levelnetPrice[_level] / uplinesToRcvEth[_level]);
235         lostProfits[lostAddr].level.push(getUserLevel(referrer));
236         chkLostProfit = false;
237         
238         emit LostLevelProfitEvent(referrer, msg.sender, _level, 0);
239       }
240       
241       if (referrer != address(0) && (users[_user].levelExpiresAt[_level] == 0 || getUserLevelExpiresAt(referrer, _level) < now)) {
242         chkLostProfit = true;
243         uplines++;
244         lostAddr = referrer;
245         continue;
246       }
247       else {chkLostProfit = false;}
248       
249       //add msg.value / uplinesToRcvEth[_level] in user's earned
250       
251       if (referrer == address(0)) { referrer = creator; }
252       uint256 _txns = SafeMath.mul(msg.value, 2);
253       uint256 _txn = SafeMath.div(_txns, 100);
254       uint256 _taxedEthereum = SafeMath.sub(msg.value, _txn);
255       if (address(uint160(referrer)).send( _taxedEthereum / uplinesToRcvEth[_level] )) {
256         rcvdProfits[referrer].uid = users[referrer].id;
257         rcvdProfits[referrer].fromId.push(users[msg.sender].id);
258         rcvdProfits[referrer].fromAddr.push(msg.sender);
259         //rcvdProfits[referrer].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
260         rcvdProfits[referrer].amount.push(levelnetPrice[_level] / uplinesToRcvEth[_level]);
261         
262         givenProfits[msg.sender].uid = users[msg.sender].id;
263         givenProfits[msg.sender].toId.push(users[referrer].id);
264         givenProfits[msg.sender].toAddr.push(referrer);
265         //givenProfits[msg.sender].amount.push(levelPrice[_level] / uplinesToRcvEth[_level]);
266         givenProfits[msg.sender].amount.push(levelnetPrice[_level] / uplinesToRcvEth[_level]);
267         givenProfits[msg.sender].level.push(getUserLevel(referrer));
268         givenProfits[msg.sender].line.push(i);
269         
270         emit GetLevelProfitEvent(referrer, msg.sender, _level, now);
271       }
272     }
273   }
274 
275     function setContract1(address payable _contract1) public {
276       require(msg.sender==creator);
277       contract1 = _contract1;
278     }
279     
280       function setContract2(address payable _contract2) public {
281       require(msg.sender==creator);
282       contract2 = _contract2;
283     }
284     
285       function setLaunchTime(uint256 _LaunchTime) public {
286       require(msg.sender==creator);
287       launchtime = _LaunchTime;
288     }
289 
290   function getUserUpline(address _user, uint height)
291     public
292     view
293     returns (address)
294   {
295     if (height <= 0 || _user == address(0)) {
296       return _user;
297     }
298 
299     return this.getUserUpline(userAddresses[users[_user].referrerID], height - 1);
300   }
301 
302   function getUserReferrals(address _user)
303     public
304     view
305     returns (address[] memory)
306   {
307     return users[_user].referrals;
308   }
309   
310   
311   function getUserProfitsFromId(address _user)
312     public
313     view
314     returns (uint[] memory)
315   {
316       return rcvdProfits[_user].fromId;
317   }
318   
319   function getUserProfitsFromAddr(address _user)
320     public
321     view
322     returns (address[] memory)
323   {
324       return rcvdProfits[_user].fromAddr;
325   }
326   
327   function getUserProfitsAmount(address _user)
328     public
329     view
330     returns (uint256[] memory)
331   {
332       return rcvdProfits[_user].amount;
333   }
334   
335   
336   
337   function getUserProfitsGivenToId(address _user)
338     public
339     view
340     returns (uint[] memory)
341   {
342       return givenProfits[_user].toId;
343   }
344   
345   function getUserProfitsGivenToAddr(address _user)
346     public
347     view
348     returns (address[] memory)
349   {
350       return givenProfits[_user].toAddr;
351   }
352   
353   function getUserProfitsGivenToAmount(address _user)
354     public
355     view
356     returns (uint[] memory)
357   {
358       return givenProfits[_user].amount;
359   }
360   
361   function getUserProfitsGivenToLevel(address _user)
362     public
363     view
364     returns (uint[] memory)
365   {
366       return givenProfits[_user].level;
367   }
368   
369   function getUserProfitsGivenToLine(address _user)
370     public
371     view
372     returns (uint[] memory)
373   {
374       return givenProfits[_user].line;
375   }
376   
377   
378   function getUserLostsToId(address _user)
379     public
380     view
381     returns (uint[] memory)
382   {
383     return (lostProfits[_user].toId);
384   }
385   
386   function getUserLostsToAddr(address _user)
387     public
388     view
389     returns (address[] memory)
390   {
391     return (lostProfits[_user].toAddr);
392   }
393   
394   function getUserLostsAmount(address _user)
395     public
396     view
397     returns (uint[] memory)
398   {
399     return (lostProfits[_user].amount);
400   }
401   
402   function getUserLostsLevel(address _user)
403     public
404     view
405     returns (uint[] memory)
406   {
407     return (lostProfits[_user].level);
408   }
409   
410 
411   function getUserLevelExpiresAt(address _user, uint _level)
412     public
413     view
414     returns (uint)
415   {
416     return users[_user].levelExpiresAt[_level];
417   }
418 
419   
420 
421   function () external payable {
422     revert();
423   }
424   
425   
426   function getUserLevel (address _user) public view returns (uint) {
427       if (getUserLevelExpiresAt(_user, 1) < now) {
428           return (0);
429       }
430       else if (getUserLevelExpiresAt(_user, 2) < now) {
431           return (1);
432       }
433       else if (getUserLevelExpiresAt(_user, 3) < now) {
434           return (2);
435       }
436       else if (getUserLevelExpiresAt(_user, 4) < now) {
437           return (3);
438       }
439       else if (getUserLevelExpiresAt(_user, 5) < now) {
440           return (4);
441       }
442       else if (getUserLevelExpiresAt(_user, 6) < now) {
443           return (5);
444       }
445       else if (getUserLevelExpiresAt(_user, 7) < now) {
446           return (6);
447       }
448       else if (getUserLevelExpiresAt(_user, 8) < now) {
449           return (7);
450       }
451       else if (getUserLevelExpiresAt(_user, 9) < now) {
452           return (8);
453       }
454       else if (getUserLevelExpiresAt(_user, 10) < now) {
455           return (9);
456       }
457   }
458   
459   function getUserDetails (address _user) public view returns (uint, uint) {
460       if (getUserLevelExpiresAt(_user, 1) < now) {
461           return (1, users[_user].id);
462       }
463       else if (getUserLevelExpiresAt(_user, 2) < now) {
464           return (2, users[_user].id);
465       }
466       else if (getUserLevelExpiresAt(_user, 3) < now) {
467           return (3, users[_user].id);
468       }
469       else if (getUserLevelExpiresAt(_user, 4) < now) {
470           return (4, users[_user].id);
471       }
472       else if (getUserLevelExpiresAt(_user, 5) < now) {
473           return (5, users[_user].id);
474       }
475       else if (getUserLevelExpiresAt(_user, 6) < now) {
476           return (6, users[_user].id);
477       }
478       else if (getUserLevelExpiresAt(_user, 7) < now) {
479           return (7, users[_user].id);
480       }
481       else if (getUserLevelExpiresAt(_user, 8) < now) {
482           return (8, users[_user].id);
483       }
484       else if (getUserLevelExpiresAt(_user, 9) < now) {
485           return (9, users[_user].id);
486       }
487   }
488   
489 }
490 
491 library SafeMath {
492     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
493         if (a == 0) {
494             return 0;
495         }
496         uint256 c = a * b;
497         assert(c / a == b);
498         return c;
499     }
500 
501     function div(uint256 a, uint256 b) internal pure returns (uint256) {
502         uint256 c = a / b;
503         return c;
504     }
505 
506     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
507         assert(b <= a);
508         return a - b;
509     }
510 
511     function add(uint256 a, uint256 b) internal pure returns (uint256) {
512         uint256 c = a + b;
513         assert(c >= a);
514         return c;
515     }
516 }