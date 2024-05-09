1 pragma solidity ^0.5.7;
2 
3 
4 library SafeMath {
5 
6   function mul(uint a, uint b) internal pure returns (uint) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint a, uint b) internal pure returns (uint) {
13     uint c = a / b;
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal pure returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal pure returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 
31 contract Ownable {
32 
33   address public owner;
34   address public mainAddress;
35 
36   constructor() public {
37     owner = msg.sender;
38     mainAddress = msg.sender;
39   }
40 
41   modifier onlyOwner() {
42     require(msg.sender == owner, "Only for owner");
43     _;
44   }
45 
46   function transferOwnership(address _owner) public onlyOwner {
47     owner = _owner;
48   }
49 
50 }
51 
52 contract ETHStvo is Ownable {
53     
54     event Register(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _time);
55     event SponsorChange(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _time);
56     event Upgrade(uint indexed _user, uint _star, uint _price, uint _time);
57     event Payment(uint indexed _user, uint indexed _referrer, uint indexed _introducer, uint _star, uint _money, uint _fee, uint _time);
58     event LostMoney(uint indexed _referrer, uint indexed _referral, uint _star, uint _money, uint _time);
59 
60     mapping (uint => uint) public STAR_PRICE;
61     mapping (uint => uint) public STAR_FEE;
62     uint REFERRER_1_STAR_LIMIT = 3;
63 
64     struct UserStruct {
65         bool isExist;
66         address wallet;
67         uint referrerID;
68         uint introducerID;
69         address[] referral;
70         mapping (uint => bool) starActive;
71     }
72 
73     mapping (uint => UserStruct) public users;
74     mapping (address => uint) public userList;
75 
76     uint public currentUserID = 0;
77     uint public total = 0 ether;
78     uint public totalFees = 0 ether;
79     bool public paused = false;
80     bool public allowSponsorChange = true;
81 
82     constructor() public {
83 
84         //Cycle 1
85         STAR_PRICE[1] = 0.05 ether;
86         STAR_PRICE[2] = 0.15 ether;
87         STAR_PRICE[3] = 0.60 ether;
88         STAR_PRICE[4] = 2.70 ether;
89         STAR_PRICE[5] = 24.75 ether;
90         STAR_PRICE[6] = 37.50 ether;
91         STAR_PRICE[7] = 72.90 ether;
92         STAR_PRICE[8] = 218.70 ether;
93 
94         //Cycle 2
95         STAR_PRICE[9] = 385.00 ether;
96         STAR_PRICE[10] = 700.00 ether;
97         STAR_PRICE[11] = 1250.00 ether;
98         STAR_PRICE[12] = 2500.00 ether;
99         STAR_PRICE[13] = 5500.00 ether;
100         STAR_PRICE[14] = 7500.00 ether;
101         STAR_PRICE[15] = 10000.00 ether;
102         STAR_PRICE[16] = 15000.00 ether;
103 
104         STAR_FEE[5] = 2.25 ether;
105         STAR_FEE[9] = 35.00 ether;
106         STAR_FEE[13] = 500.00 ether;
107 
108         UserStruct memory userStruct;
109         currentUserID++;
110 
111         userStruct = UserStruct({
112             isExist : true,
113             wallet : mainAddress,
114             referrerID : 0,
115             introducerID : 0,
116             referral : new address[](0)
117         });
118 
119         users[currentUserID] = userStruct;
120         userList[mainAddress] = currentUserID;
121 
122         users[currentUserID].starActive[1] = true;
123         users[currentUserID].starActive[2] = true;
124         users[currentUserID].starActive[3] = true;
125         users[currentUserID].starActive[4] = true;
126         users[currentUserID].starActive[5] = true;
127         users[currentUserID].starActive[6] = true;
128         users[currentUserID].starActive[7] = true;
129         users[currentUserID].starActive[8] = true;
130         users[currentUserID].starActive[9] = true;
131         users[currentUserID].starActive[10] = true;
132         users[currentUserID].starActive[11] = true;
133         users[currentUserID].starActive[12] = true;
134         users[currentUserID].starActive[13] = true;
135         users[currentUserID].starActive[14] = true;
136         users[currentUserID].starActive[15] = true;
137         users[currentUserID].starActive[16] = true;
138     }
139 
140     function setMainAddress(address _mainAddress) public onlyOwner {
141 
142         require(userList[_mainAddress] == 0, 'Address is already in use by another user');
143         
144         delete userList[mainAddress];
145         userList[_mainAddress] = uint(1);
146         mainAddress = _mainAddress;
147         users[1].wallet = _mainAddress;
148       }
149 
150     function setPaused(bool _paused) public onlyOwner {
151         paused = _paused;
152       }
153 
154       function setAllowSponsorChange(bool _allowSponsorChange) public onlyOwner {
155         allowSponsorChange = _allowSponsorChange;
156       }
157 
158     //https://etherconverter.online to Ether
159     function setStarPrice(uint _star, uint _price) public onlyOwner {
160         STAR_PRICE[_star] = _price;
161       }
162 
163     //https://etherconverter.online to Ether
164     function setStarFee(uint _star, uint _price) public onlyOwner {
165         STAR_FEE[_star] = _price;
166       }
167 
168     function setCurrentUserID(uint _currentUserID) public onlyOwner {
169         currentUserID = _currentUserID;
170       }
171 
172     //Null address is 0x0000000000000000000000000000000000000000
173     function setUserData(uint _userID, address _wallet, uint _referrerID, uint _introducerID, address _referral1, address _referral2, address _referral3, uint star) public onlyOwner {
174 
175         require(_userID > 0, 'Invalid user ID');
176         require(_wallet != address(0), 'Invalid user wallet');
177         require(_referrerID > 0, 'Invalid referrer ID');
178         require(_introducerID > 0, 'Invalid introducer ID');
179 
180         if(_userID > currentUserID){
181             currentUserID++;
182         }
183 
184         if(users[_userID].isExist){
185             delete userList[users[_userID].wallet];
186             delete users[_userID];
187         }
188 
189         UserStruct memory userStruct;
190 
191         userStruct = UserStruct({
192             isExist : true,
193             wallet : _wallet,
194             referrerID : _referrerID,
195             introducerID : _introducerID,
196             referral : new address[](0)
197         });
198     
199         users[_userID] = userStruct;
200         userList[_wallet] = _userID;
201 
202         for(uint a = 1; a <= uint(16); a++){
203             if(a <= star){
204                 users[_userID].starActive[a] = true;
205             } else {
206                 users[_userID].starActive[a] = false;
207             }
208         }
209 
210         if(_referral1 != address(0)){
211             users[_userID].referral.push(_referral1);
212         }
213            
214         if(_referral2 != address(0)){
215             users[_userID].referral.push(_referral2);
216         }
217 
218         if(_referral3 != address(0)){
219             users[_userID].referral.push(_referral3);
220         }
221 
222     }
223 
224     function () external payable {
225 
226         require(!paused, 'Temporarily not accepting new users and Star upgrades');
227 
228         uint star;
229 
230         if(msg.value == STAR_PRICE[1]){
231             star = 1;
232         }else if(msg.value == STAR_PRICE[2]){
233             star = 2;
234         }else if(msg.value == STAR_PRICE[3]){
235             star = 3;
236         }else if(msg.value == STAR_PRICE[4]){
237             star = 4;
238         }else if(msg.value == STAR_PRICE[5]){
239             star = 5;
240         }else if(msg.value == STAR_PRICE[6]){
241             star = 6;
242         }else if(msg.value == STAR_PRICE[7]){
243             star = 7;
244         }else if(msg.value == STAR_PRICE[8]){
245             star = 8;
246         }else if(msg.value == STAR_PRICE[9]){
247             star = 9;
248         }else if(msg.value == STAR_PRICE[10]){
249             star = 10;
250         }else if(msg.value == STAR_PRICE[11]){
251             star = 11;
252         }else if(msg.value == STAR_PRICE[12]){
253             star = 12;
254         }else if(msg.value == STAR_PRICE[13]){
255             star = 13;
256         }else if(msg.value == STAR_PRICE[14]){
257             star = 14;
258         }else if(msg.value == STAR_PRICE[15]){
259             star = 15;
260         }else if(msg.value == STAR_PRICE[16]){
261             star = 16;
262         }else {
263             revert('You have sent incorrect payment amount');
264         }
265 
266         if(star == 1){
267 
268             uint referrerID = 0;
269             address referrer = bytesToAddress(msg.data);
270 
271             if (userList[referrer] > 0 && userList[referrer] <= currentUserID){
272                 referrerID = userList[referrer];
273             } else {
274                 revert('Incorrect referrer');
275             }
276 
277             if(users[userList[msg.sender]].isExist){
278                 changeSponsor(referrerID);
279             } else {
280                 registerUser(referrerID);
281             }
282         } else if(users[userList[msg.sender]].isExist){
283             upgradeUser(star);
284         } else {
285             revert("Please buy first star");
286         }
287     }
288 
289     function changeSponsor(uint _referrerID) internal {
290 
291         require(allowSponsorChange, 'You are already signed up. Sponsor change not allowed');
292         require(users[userList[msg.sender]].isExist, 'You are not signed up');
293         require(userList[msg.sender] != _referrerID, 'You cannot sponsor yourself');
294         require(users[userList[msg.sender]].referrerID != _referrerID && users[userList[msg.sender]].introducerID != _referrerID, 'You are already under this sponsor');
295         require(_referrerID > 0 && _referrerID <= currentUserID, 'Incorrect referrer ID');
296         require(msg.value==STAR_PRICE[1], 'You have sent incorrect payment amount');
297         require(users[userList[msg.sender]].starActive[2] == false, 'Sponsor change is allowed only on Star 1');
298 
299         uint _introducerID = _referrerID;
300         uint oldReferrer = users[userList[msg.sender]].referrerID;
301 
302         if(users[_referrerID].referral.length >= REFERRER_1_STAR_LIMIT)
303         {
304             _referrerID = userList[findFreeReferrer(_referrerID)];
305         }
306 
307         users[userList[msg.sender]].referrerID = _referrerID;
308         users[userList[msg.sender]].introducerID = _introducerID;
309 
310         users[_referrerID].referral.push(msg.sender);
311 
312         uint arrayLength = SafeMath.sub(uint(users[oldReferrer].referral.length),uint(1));
313 
314         address[] memory referrals = new address[](arrayLength);
315 
316         for(uint a = 0; a <= arrayLength; a++){
317             if(users[oldReferrer].referral[a] != msg.sender){
318                 referrals[a] = users[oldReferrer].referral[a];
319             }
320         }
321 
322         for(uint b = 0; b <= arrayLength; b++){
323             users[oldReferrer].referral.pop();
324         }
325 
326         uint arrayLengthSecond = SafeMath.sub(uint(referrals.length),uint(1));
327 
328         for(uint c = 0; c <= arrayLengthSecond; c++){
329             if(referrals[c] != address(0)){
330                 users[oldReferrer].referral.push(referrals[c]);
331             }
332         }
333 
334         upgradePayment(userList[msg.sender], 1);
335 
336         emit SponsorChange(userList[msg.sender], _referrerID, _introducerID, now);
337 
338     }
339 
340     function registerUser(uint _referrerID) internal {
341 
342         require(!users[userList[msg.sender]].isExist, 'You are already signed up');
343         require(_referrerID > 0 && _referrerID <= currentUserID, 'Incorrect referrer ID');
344         require(msg.value==STAR_PRICE[1], 'You have sent incorrect payment amount');
345 
346         uint _introducerID = _referrerID;
347 
348         if(users[_referrerID].referral.length >= REFERRER_1_STAR_LIMIT)
349         {
350             _referrerID = userList[findFreeReferrer(_referrerID)];
351         }
352 
353         UserStruct memory userStruct;
354         currentUserID++;
355 
356         userStruct = UserStruct({
357             isExist : true,
358             wallet : msg.sender,
359             referrerID : _referrerID,
360             introducerID : _introducerID,
361             referral : new address[](0)
362         });
363 
364         users[currentUserID] = userStruct;
365         userList[msg.sender] = currentUserID;
366 
367         users[currentUserID].starActive[1] = true;
368         users[currentUserID].starActive[2] = false;
369         users[currentUserID].starActive[3] = false;
370         users[currentUserID].starActive[4] = false;
371         users[currentUserID].starActive[5] = false;
372         users[currentUserID].starActive[6] = false;
373         users[currentUserID].starActive[7] = false;
374         users[currentUserID].starActive[8] = false;
375         users[currentUserID].starActive[9] = false;
376         users[currentUserID].starActive[10] = false;
377         users[currentUserID].starActive[11] = false;
378         users[currentUserID].starActive[12] = false;
379         users[currentUserID].starActive[13] = false;
380         users[currentUserID].starActive[14] = false;
381         users[currentUserID].starActive[15] = false;
382         users[currentUserID].starActive[16] = false;
383 
384         users[_referrerID].referral.push(msg.sender);
385 
386         upgradePayment(currentUserID, 1);
387 
388         emit Register(currentUserID, _referrerID, _introducerID, now);
389     }
390 
391     function upgradeUser(uint _star) internal {
392 
393         require(users[userList[msg.sender]].isExist, 'You are not signed up yet');
394         require( _star >= 2 && _star <= 16, 'Incorrect star');
395         require(msg.value==STAR_PRICE[_star], 'You have sent incorrect payment amount');
396         require(users[userList[msg.sender]].starActive[_star] == false, 'You have already activated this star');
397 
398         uint previousStar = SafeMath.sub(_star,uint(1));
399         require(users[userList[msg.sender]].starActive[previousStar] == true, 'Buy the previous star first');
400         
401         users[userList[msg.sender]].starActive[_star] = true;
402 
403         upgradePayment(userList[msg.sender], _star);
404         
405         emit Upgrade(userList[msg.sender], _star, STAR_PRICE[_star], now);
406     }
407 
408     function upgradePayment(uint _user, uint _star) internal {
409 
410         address referrer;
411         address introducer;
412 
413         uint referrerFinal;
414         uint referrer1;
415         uint referrer2;
416         uint referrer3;
417         uint money;
418 
419         if(_star == 1 || _star == 5 || _star == 9 || _star == 13){
420             referrerFinal = users[_user].referrerID;
421         } else if(_star == 2 || _star == 6 || _star == 10 || _star == 14){
422             referrer1 = users[_user].referrerID;
423             referrerFinal = users[referrer1].referrerID;
424         } else if(_star == 3 || _star == 7 || _star == 11 || _star == 15){
425             referrer1 = users[_user].referrerID;
426             referrer2 = users[referrer1].referrerID;
427             referrerFinal = users[referrer2].referrerID;
428         } else if(_star == 4 || _star == 8 || _star == 12 || _star == 16){
429             referrer1 = users[_user].referrerID;
430             referrer2 = users[referrer1].referrerID;
431             referrer3 = users[referrer2].referrerID;
432             referrerFinal = users[referrer3].referrerID;
433         }
434 
435         if(!users[referrerFinal].isExist || users[referrerFinal].starActive[_star] == false){
436             referrer = mainAddress;
437         } else {
438             referrer = users[referrerFinal].wallet;
439         }
440 
441         money = STAR_PRICE[_star];
442                 
443         if(STAR_FEE[_star] > 0){
444             bool result;
445             result = address(uint160(mainAddress)).send(STAR_FEE[_star]);
446             money = SafeMath.sub(money,STAR_FEE[_star]);
447             totalFees = SafeMath.add(totalFees,money);
448         }
449 
450         total = SafeMath.add(total,money);
451 
452         if(_star>=3){
453 
454             if(!users[users[_user].introducerID].isExist){
455                 introducer = mainAddress;
456             } else {
457                 introducer = users[users[_user].introducerID].wallet;
458             }
459 
460             money = SafeMath.div(money,2);
461 
462             bool result_one;
463             result_one = address(uint160(referrer)).send(money);
464 
465             bool result_two;
466             result_two = address(uint160(introducer)).send(money);
467             
468         } else {
469             bool result_three;
470             result_three = address(uint160(referrer)).send(money);
471         }
472 
473         if(users[referrerFinal].starActive[_star] == false ){
474             emit LostMoney(referrerFinal, userList[msg.sender], _star, money, now);
475         }
476 
477         emit Payment(userList[msg.sender], userList[referrer], userList[introducer], _star, money, STAR_FEE[_star], now);
478 
479     }
480 
481     function findFreeReferrer(uint _user) public view returns(address) {
482 
483         require(users[_user].isExist, 'User does not exist');
484 
485         if(users[_user].referral.length < REFERRER_1_STAR_LIMIT){
486             return users[_user].wallet;
487         }
488 
489         address[] memory referrals = new address[](363);
490         referrals[0] = users[_user].referral[0]; 
491         referrals[1] = users[_user].referral[1];
492         referrals[2] = users[_user].referral[2];
493 
494         address freeReferrer;
495         bool noFreeReferrer = true;
496 
497         for(uint i = 0; i < 363; i++){
498             if(users[userList[referrals[i]]].referral.length == REFERRER_1_STAR_LIMIT){
499                 if(i < 120){
500                     referrals[(i+1)*3] = users[userList[referrals[i]]].referral[0];
501                     referrals[(i+1)*3+1] = users[userList[referrals[i]]].referral[1];
502                     referrals[(i+1)*3+2] = users[userList[referrals[i]]].referral[2];
503                 }
504             } else {
505                 noFreeReferrer = false;
506                 freeReferrer = referrals[i];
507                 break;
508             }
509         }
510         require(!noFreeReferrer, 'Free referrer not found');
511         return freeReferrer;
512 
513     }
514 
515     function viewUserReferrals(uint _user) public view returns(address[] memory) {
516         return users[_user].referral;
517     }
518 
519     function viewUserStarActive(uint _user, uint _star) public view returns(bool) {
520         return users[_user].starActive[_star];
521     }
522 
523     function bytesToAddress(bytes memory bys) private pure returns (address  addr) {
524         assembly {
525             addr := mload(add(bys, 20))
526         }
527     }
528 }