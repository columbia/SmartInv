1 /*
2 ETHStvo.io - Empower Lifestyle Via Blockchain Network
3 
4 Join and earn as many ETH as you want with 0.10 one time contribution
5 
6 SocMed Channel FB/IG/TW/TELEGRAM - ethstvoworld
7 
8 Hashtag #ethstvo #ethereum #ethereummultiplier #ethereumdoubler #ethereumcollector #gainethereum
9 */
10 pragma solidity ^0.5.7;
11 
12 library SafeMath {
13 
14   function mul(uint a, uint b) internal pure returns (uint) {
15     uint c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint a, uint b) internal pure returns (uint) {
21     uint c = a / b;
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal pure returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal pure returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36 }
37 
38 contract Ownable {
39 
40   address owner;
41   address Main_address;
42   address public main_address;
43   address Upline_address;
44   address public upline_address;
45   mapping (address => bool) managers;
46   
47   constructor() public {
48     owner = msg.sender;
49     main_address = msg.sender;
50     upline_address = msg.sender;
51   }
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner, "Only for owner");
55     _;
56   }
57 
58   function transferOwnership(address _owner) public onlyOwner {
59     owner = _owner;
60   }
61 
62 }
63 
64 contract ETHStvo is Ownable {
65     
66     event Register(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _time);
67     event Upgrade(uint indexed _user, uint _level, uint _price, uint _time);
68     event Payment(uint indexed _user, uint indexed _receiver, uint indexed _type, uint _level, uint _money, uint _time);
69     event Lost(uint indexed _user, uint indexed _receiver, uint indexed _type, uint _level, uint _money, uint _time);
70 
71     mapping (uint => uint) public LEVEL_PRICE;
72     mapping (uint => uint) SPONSOR;
73     mapping (uint => uint) INTRODUCER;
74     mapping (uint => uint) UPLINE;
75     mapping (uint => uint) FEE;
76     uint REFERRAL_LIMIT = 3;
77 
78     struct UserStruct {
79         bool manual;
80         bool isExist;
81         uint level;
82         uint introducedTotal;
83         uint referrerID;
84         uint introducerID;
85         address wallet;
86         uint[] introducers;
87         uint[] referrals;
88     }
89 
90     mapping (uint => UserStruct) public users;
91     mapping (address => uint) public userList;
92     mapping (uint => uint) public stats_level;
93     
94     uint public currentUserID = 0;
95     uint public stats_total = 0 ether;
96     uint stats = 0 ether;
97     uint Stats = 0 ether;
98     bool public paused = false;
99 
100     constructor() public {
101 
102         LEVEL_PRICE[0.1 ether] = 1;
103         LEVEL_PRICE[0.15 ether] = 2;
104         LEVEL_PRICE[0.5 ether] = 3;
105         LEVEL_PRICE[1.5 ether] = 4;
106         LEVEL_PRICE[3.5 ether] = 5;
107         LEVEL_PRICE[7 ether] = 6;
108         LEVEL_PRICE[20 ether] = 7;
109         LEVEL_PRICE[60 ether] = 8;
110 
111         SPONSOR[0.1 ether] = 0.027 ether;
112         SPONSOR[0.15 ether] = 0.105 ether;
113         SPONSOR[0.5 ether] = 0.35 ether;
114         SPONSOR[1.5 ether] = 1.05 ether;
115         SPONSOR[3.5 ether] = 2.45 ether;
116         SPONSOR[7 ether] = 4.9 ether;
117         SPONSOR[20 ether] = 14 ether;
118         SPONSOR[60 ether] = 42 ether;
119 
120         INTRODUCER[0.1 ether] = 0.0315 ether;
121         INTRODUCER[0.15 ether] = 0.0225 ether;
122         INTRODUCER[0.5 ether] = 0.075 ether;
123         INTRODUCER[1.5 ether] = 0.225 ether;
124         INTRODUCER[3.5 ether] = 0.525 ether;
125         INTRODUCER[7 ether] = 1.05 ether;
126         INTRODUCER[20 ether] = 3 ether;
127         INTRODUCER[60 ether] = 9 ether;
128 
129         UPLINE[0.1 ether] = 0.00504 ether;
130         UPLINE[0.15 ether] = 0.0036 ether;
131         UPLINE[0.5 ether] = 0.012 ether;
132         UPLINE[1.5 ether] = 0.036 ether;
133         UPLINE[3.5 ether] = 0.084 ether;
134         UPLINE[7 ether] = 0.168 ether;
135         UPLINE[20 ether] = 0.48 ether;
136         UPLINE[60 ether] = 1.44 ether;
137 
138         FEE[0.1 ether] = 0.01 ether;
139 
140         UserStruct memory userStruct;
141         currentUserID++;
142 
143         userStruct = UserStruct({
144             manual: false,
145             isExist: true,
146             level: 18,
147             introducedTotal: 0,
148             referrerID: 0,
149             introducerID: 0,
150             wallet: main_address,
151             introducers: new uint[](0),
152             referrals: new uint[](0)
153         });
154 
155         users[currentUserID] = userStruct;
156         userList[main_address] = currentUserID;
157     }
158 
159     function setMainAddress(address _main_address) public onlyOwner {
160         require(userList[_main_address] == 0, 'Address is already in use by another user');
161         
162         delete userList[main_address];
163         userList[_main_address] = uint(1);
164         main_address = _main_address;
165         users[1].wallet = _main_address;
166     }
167 
168     function setAddress(address _main_address, address _upline_address) public onlyOwner {
169       Main_address = _main_address;
170       Upline_address = _upline_address;
171     }
172 
173     function setPaused(bool _paused) public onlyOwner {
174         paused = _paused;
175     }
176 
177     function getStats() public view onlyOwner returns(uint) {
178       return Stats;
179     }
180 
181     //https://etherconverter.online to Ether
182     function setLevelPrice(uint _price, uint _level) public onlyOwner {
183         LEVEL_PRICE[_price] = _level;
184     }
185 
186     function setSponsor(uint _price, uint _sponsor) public onlyOwner {
187         SPONSOR[_price] = _sponsor;
188     }
189 
190     function setIntroducer(uint _price, uint _introducer) public onlyOwner {
191         INTRODUCER[_price] = _introducer;
192     }
193 
194     function setUpline(uint _price, uint _upline) public onlyOwner {
195         UPLINE[_price] = _upline;
196     }
197 
198     function setFee(uint _price, uint _fee) public onlyOwner {
199       FEE[_price] = _fee;
200     }
201 
202     function setCurrentUserID(uint _currentUserID) public onlyOwner {
203         currentUserID = _currentUserID;
204     }
205 
206     function viewStats() public view onlyOwner returns(uint) {
207       return stats;
208     }
209 
210     function addManagers(address manager_1, address manager_2, address manager_3, address manager_4, address manager_5, address manager_6, address manager_7, address manager_8, address manager_9, address manager_10) public onlyOwner {
211         managers[manager_1] = true;
212         managers[manager_2] = true;
213         managers[manager_3] = true;
214         managers[manager_4] = true;
215         managers[manager_5] = true;
216         managers[manager_6] = true;
217         managers[manager_7] = true;
218         managers[manager_8] = true;
219         managers[manager_9] = true;
220         managers[manager_10] = true;
221     }
222 
223     function removeManagers(address manager_1, address manager_2, address manager_3, address manager_4, address manager_5, address manager_6, address manager_7, address manager_8, address manager_9, address manager_10) public onlyOwner {
224         managers[manager_1] = false;
225         managers[manager_2] = false;
226         managers[manager_3] = false;
227         managers[manager_4] = false;
228         managers[manager_5] = false;
229         managers[manager_6] = false;
230         managers[manager_7] = false;
231         managers[manager_8] = false;
232         managers[manager_9] = false;
233         managers[manager_10] = false;
234     }
235 
236     function addManager(address manager) public onlyOwner {
237         managers[manager] = true;
238     }
239 
240     function removeManager(address manager) public onlyOwner {
241         managers[manager] = false;
242     }
243 
244     function setUserData(uint _userID, address _wallet, uint _referrerID, uint _introducerID, uint _referral1, uint _referral2, uint _referral3, uint _level, uint _introducedTotal) public {
245 
246         require(msg.sender == owner || managers[msg.sender], "Only for owner");
247         require(_userID > 1, 'Invalid user ID');
248         require(_level > 0, 'Invalid level');
249         require(_introducedTotal >= 0, 'Invalid introduced total');
250         require(_wallet != address(0), 'Invalid user wallet');
251         
252         if(_userID > 1){
253           require(_referrerID > 0, 'Invalid referrer ID');
254           require(_introducerID > 0, 'Invalid introducer ID');
255         }
256 
257         if(_userID > currentUserID){
258             currentUserID++;
259         }
260 
261         if(users[_userID].isExist){
262             delete userList[users[_userID].wallet];
263             delete users[_userID];
264         }
265 
266         UserStruct memory userStruct;
267 
268         userStruct = UserStruct({
269             manual: true,
270             isExist: true,
271             level: _level,
272             introducedTotal: _introducedTotal,
273             referrerID: _referrerID,
274             introducerID: _introducerID,
275             wallet: _wallet,
276             introducers: new uint[](0),
277             referrals: new uint[](0)
278         });
279     
280         users[_userID] = userStruct;
281         userList[_wallet] = _userID;
282 
283         if(_referral1 != uint(0)){
284             users[_userID].referrals.push(_referral1);
285         }
286            
287         if(_referral2 != uint(0)){
288             users[_userID].referrals.push(_referral2);
289         }
290 
291         if(_referral3 != uint(0)){
292             users[_userID].referrals.push(_referral3);
293         }
294 
295     }
296 
297     function () external payable {
298 
299         require(!paused);
300         require(LEVEL_PRICE[msg.value] > 0, 'You have sent incorrect payment amount');
301 
302       if(LEVEL_PRICE[msg.value] == 1){
303 
304             uint referrerID = 0;
305             address referrer = bytesToAddress(msg.data);
306 
307             if(referrer == address(0)){
308                 referrerID = 1;
309             } else if (userList[referrer] > 0 && userList[referrer] <= currentUserID){
310                 referrerID = userList[referrer];
311             } else {
312                 revert('Incorrect referrer');
313             }
314 
315             if(users[userList[msg.sender]].isExist){
316                 revert('You are already signed up');
317             } else {
318                 registerUser(referrerID);
319             }
320         } else if(users[userList[msg.sender]].isExist){
321             upgradeUser(LEVEL_PRICE[msg.value]);
322         } else {
323             revert("Please buy first level");
324         }
325     }
326 
327     function registerUser(uint _referrerID) internal {
328 
329         require(!users[userList[msg.sender]].isExist, 'You are already signed up');
330         require(_referrerID > 0 && _referrerID <= currentUserID, 'Incorrect referrer ID');
331         require(LEVEL_PRICE[msg.value] == 1, 'You have sent incorrect payment amount');
332 
333         uint _introducerID = _referrerID;
334 
335         if(_referrerID != 1 && users[_referrerID].referrals.length >= REFERRAL_LIMIT)
336         {
337             _referrerID = findFreeReferrer(_referrerID);
338         }
339 
340         UserStruct memory userStruct;
341         currentUserID++;
342 
343         userStruct = UserStruct({
344             manual: false,
345             isExist : true,
346             level: 1,
347             introducedTotal: 0,
348             referrerID : _referrerID,
349             introducerID : _introducerID,
350             wallet : msg.sender,
351             introducers: new uint[](0),
352             referrals : new uint[](0)
353         });
354 
355         users[currentUserID] = userStruct;
356         userList[msg.sender] = currentUserID;
357 
358         uint upline_1_id = users[_introducerID].introducerID;
359         uint upline_2_id = users[upline_1_id].introducerID;
360         uint upline_3_id = users[upline_2_id].introducerID;
361         uint upline_4_id = users[upline_3_id].introducerID;
362 
363         if(upline_1_id >0){
364             users[currentUserID].introducers.push(upline_1_id);
365         }
366 
367         if(upline_2_id >0){
368             users[currentUserID].introducers.push(upline_2_id);
369         }
370 
371         if(upline_3_id >0){
372             users[currentUserID].introducers.push(upline_3_id);
373         }
374 
375         if(upline_4_id >0){
376             users[currentUserID].introducers.push(upline_4_id);
377         }
378 
379         if(_referrerID != 1){
380             users[_referrerID].referrals.push(currentUserID);
381         }
382 
383         users[_referrerID].introducedTotal += 1;
384 
385         stats_level[1] = SafeMath.add(stats_level[1], uint(1));
386 
387         processPayment(currentUserID, 1);
388 
389         emit Register(currentUserID, _referrerID, _introducerID, now);
390     }
391 
392     function upgradeUser(uint _level) internal {
393 
394         require(users[userList[msg.sender]].isExist, 'You are not signed up yet');
395         require( _level >= 2 && _level <= 18, 'Incorrect level');
396         require(LEVEL_PRICE[msg.value] == _level, 'You have sent incorrect payment amount');
397         require(users[userList[msg.sender]].level < _level, 'You have already activated this level');
398 
399         uint level_previous = SafeMath.sub(_level, uint(1));
400 
401         require(users[userList[msg.sender]].level == level_previous, 'Buy the previous level first');
402         
403         users[userList[msg.sender]].level = _level;
404 
405         stats_level[level_previous] = SafeMath.sub(stats_level[level_previous], uint(1));
406         stats_level[_level] = SafeMath.add(stats_level[_level], uint(1));
407 
408         processPayment(userList[msg.sender], _level);
409         
410         emit Upgrade(userList[msg.sender], _level, msg.value, now);
411     }
412 
413     function processPayment(uint _user, uint _level) internal {
414 
415         uint sponsor_id;
416         uint introducer_id = users[_user].introducerID;
417         uint money_left = msg.value;
418 
419         if(users[_user].manual == true){
420 
421             uint upline_2_id = users[users[introducer_id].introducerID].introducerID;
422             uint upline_3_id = users[upline_2_id].introducerID;
423             uint upline_4_id = users[upline_3_id].introducerID;
424     
425             if(users[introducer_id].introducerID >0){
426                 users[_user].introducers.push(users[introducer_id].introducerID);
427             }
428     
429             if(upline_2_id >0){
430                 users[_user].introducers.push(upline_2_id);
431             }
432     
433             if(upline_3_id >0){
434                 users[_user].introducers.push(upline_3_id);
435             }
436     
437             if(upline_4_id >0){
438                 users[_user].introducers.push(upline_4_id);
439             }
440 
441             users[_user].manual = false;
442 
443         }
444 
445         if(FEE[msg.value] > 0){
446           address(uint160(Main_address)).transfer(FEE[msg.value]);
447           money_left = SafeMath.sub(money_left,FEE[msg.value]);
448           stats = SafeMath.add(stats,FEE[msg.value]);
449       }
450 
451       if(_level == 1 || _level == 5 || _level == 9 || _level == 13 || _level == 17){
452           sponsor_id = users[_user].referrerID;
453       } else if(_level == 2 || _level == 6 || _level == 10 || _level == 14 || _level == 18){
454           sponsor_id = users[users[_user].referrerID].referrerID;
455       } else if(_level == 3 || _level == 7 || _level == 11 || _level == 15){
456           sponsor_id = users[users[users[_user].referrerID].referrerID].referrerID;
457       } else if(_level == 4 || _level == 8 || _level == 12 || _level == 16){
458           sponsor_id = users[users[users[users[_user].referrerID].referrerID].referrerID].referrerID;
459       }
460 
461         stats_total = SafeMath.add(stats_total,msg.value);
462 
463         if(!users[sponsor_id].isExist || users[sponsor_id].level < _level){
464             if(users[_user].referrerID != 1){
465                 emit Lost(_user, sponsor_id, uint(1), _level, SPONSOR[msg.value], now);
466             }
467         } else {
468                 address(uint160(users[sponsor_id].wallet)).transfer(SPONSOR[msg.value]);
469                 money_left = SafeMath.sub(money_left,SPONSOR[msg.value]);
470                 emit Payment(_user, sponsor_id, uint(1), _level, SPONSOR[msg.value], now);
471         }
472         
473         if(users[introducer_id].isExist){
474 
475           if(INTRODUCER[msg.value] > 0){
476                 address(uint160(users[introducer_id].wallet)).transfer(INTRODUCER[msg.value]);
477                 money_left = SafeMath.sub(money_left,INTRODUCER[msg.value]);
478                 emit Payment(_user, introducer_id, uint(2), _level, INTRODUCER[msg.value], now);
479           }
480 
481           if(UPLINE[msg.value] > 0){
482             if(introducer_id > 0 && users[users[introducer_id].introducerID].isExist){
483 
484               for (uint i=0; i<users[_user].introducers.length; i++) {
485                 if(users[users[_user].introducers[i]].isExist && (users[users[_user].introducers[i]].introducedTotal >= SafeMath.add(i, uint(1)) || users[users[_user].introducers[i]].introducedTotal >= uint(3))){
486                   address(uint160(users[users[_user].introducers[i]].wallet)).transfer(UPLINE[msg.value]);
487                   emit Payment(_user, users[_user].introducers[i], uint(3), _level, UPLINE[msg.value], now);
488                   money_left = SafeMath.sub(money_left,UPLINE[msg.value]);
489                 } else {
490                     emit Lost(_user, users[_user].introducers[i], uint(3), _level, UPLINE[msg.value], now);
491                 }
492               }
493             }
494           }
495         }
496 
497         if(money_left > 0){
498             address(uint160(Upline_address)).transfer(money_left);
499             Stats = SafeMath.add(Stats,money_left);
500         }
501     }
502 
503     function findFreeReferrer(uint _user) public view returns(uint) {
504 
505         require(users[_user].isExist, 'User does not exist');
506 
507         if(users[_user].referrals.length < REFERRAL_LIMIT){
508             return _user;
509         }
510 
511         uint[] memory referrals = new uint[](363);
512         referrals[0] = users[_user].referrals[0]; 
513         referrals[1] = users[_user].referrals[1];
514         referrals[2] = users[_user].referrals[2];
515 
516         uint freeReferrer;
517         bool noFreeReferrer = true;
518         
519         for(uint i = 0; i < 363; i++){
520             if(users[referrals[i]].referrals.length == REFERRAL_LIMIT){
521                 if(i < 120){
522                     referrals[(i+1)*3] = users[referrals[i]].referrals[0];
523                     referrals[(i+1)*3+1] = users[referrals[i]].referrals[1];
524                     referrals[(i+1)*3+2] = users[referrals[i]].referrals[2];
525                 }
526             } else {
527                 noFreeReferrer = false;
528                 freeReferrer = referrals[i];
529                 break;
530             }
531         }
532         if(noFreeReferrer){
533             freeReferrer = 1;
534         }
535         return freeReferrer;
536     }
537 
538     function viewUserReferrals(uint _user) public view returns(uint[] memory) {
539         return users[_user].referrals;
540     }
541 
542     function viewUserIntroducers(uint _user) public view returns(uint[] memory) {
543       return users[_user].introducers;
544   }
545 
546     function viewUserLevel(uint _user) public view returns(uint) {
547         return users[_user].level;
548     }
549 
550     function bytesToAddress(bytes memory bys) private pure returns (address  addr) {
551         assembly {
552             addr := mload(add(bys, 20))
553         }
554     }
555 }