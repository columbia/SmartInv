1 pragma solidity 0.5.11;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      *
43      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
44      * @dev Get it via `npm install @openzeppelin/contracts@next`.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
102      * @dev Get it via `npm install @openzeppelin/contracts@next`.
103      */
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         // Solidity only automatically asserts when dividing by 0
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 }
113 
114 contract Crowdsharing {
115     
116     using SafeMath for *;
117     
118     address public ownerWallet;
119     address public wallet1; //3%
120     address public wallet2; //15%
121 
122 
123     
124    struct UserStruct {
125         bool isExist;
126         uint id;
127         uint referrerID;
128         address[] referral;
129         uint directSponsor;
130         uint referralCounter;
131         mapping(uint => uint) levelExpired;
132     }
133 
134     uint REFERRER_1_LEVEL_LIMIT = 2;
135     uint PERIOD_LENGTH = 60 days;
136     uint private adminFees = 3;
137     uint private directSponsorFees = 15;
138     uint private earnings = 82;
139 
140     mapping(uint => uint) public LEVEL_PRICE;
141 
142     mapping (address => UserStruct) public users;
143     mapping (uint => address) public userList;
144     uint public currUserID = 0;
145 
146     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
147     event buyLevelEvent(address indexed _user, uint _level, uint _time);
148     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
149     event getSponsorBonusEvent(address indexed _sponsor, address indexed _user, uint _level, uint _time);
150     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint number);
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     constructor(address _owner, address _wallet1, address _wallet2) public {
154         ownerWallet = msg.sender;
155         wallet1 = _wallet1;
156         wallet2 = _wallet2;
157 
158         LEVEL_PRICE[1] = 0.1 ether;
159         LEVEL_PRICE[2] = 0.2 ether;
160         LEVEL_PRICE[3] = 0.5 ether;
161         LEVEL_PRICE[4] = 3 ether;
162         LEVEL_PRICE[5] = 10 ether;
163         LEVEL_PRICE[6] = 30 ether;
164         LEVEL_PRICE[7] = 15 ether;
165         LEVEL_PRICE[8] = 35 ether;
166         LEVEL_PRICE[9] = 100 ether;
167         LEVEL_PRICE[10] = 250 ether;
168         LEVEL_PRICE[11] = 500 ether;
169         LEVEL_PRICE[12] = 1000 ether;
170 
171         UserStruct memory userStruct;
172         currUserID++;
173 
174         userStruct = UserStruct({
175             isExist: true,
176             id: currUserID,
177             referrerID: 0,
178             referral: new address[](0),
179             directSponsor: 0,
180             referralCounter: 0
181         });
182         users[_owner] = userStruct;
183         userList[currUserID] = _owner;
184 
185         for(uint i = 1; i <= 12; i++) {
186             users[_owner].levelExpired[i] = 55555555555;
187         }
188     }
189 
190     function () external payable {
191         uint level;
192 
193         if(msg.value == LEVEL_PRICE[1]) level = 1;
194         else if(msg.value == LEVEL_PRICE[2]) level = 2;
195         else if(msg.value == LEVEL_PRICE[3]) level = 3;
196         else if(msg.value == LEVEL_PRICE[4]) level = 4;
197         else if(msg.value == LEVEL_PRICE[5]) level = 5;
198         else if(msg.value == LEVEL_PRICE[6]) level = 6;
199         else if(msg.value == LEVEL_PRICE[7]) level = 7;
200         else if(msg.value == LEVEL_PRICE[8]) level = 8;
201         else if(msg.value == LEVEL_PRICE[9]) level = 9;
202         else if(msg.value == LEVEL_PRICE[10]) level = 10;
203         else if(msg.value == LEVEL_PRICE[11]) level = 11;
204         else if(msg.value == LEVEL_PRICE[12]) level = 12;
205         
206         else revert('Incorrect Value send');
207 
208         if(users[msg.sender].isExist) buyLevel(level);
209         else if(level == 1) {
210             uint refId = 0;
211             address referrer = bytesToAddress(msg.data);
212 
213             if(users[referrer].isExist) refId = users[referrer].id;
214             else revert('Incorrect referrer');
215 
216             regUser(refId);
217         }
218         else revert('Please buy first level for 0.03 ETH');
219     }
220 
221     function regUser(uint _referrerID) public payable {
222        
223         require(!users[msg.sender].isExist, 'User exist');
224         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
225         require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
226 
227         uint tempReferrerID = _referrerID;
228 
229         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) 
230             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
231 
232         UserStruct memory userStruct;
233         currUserID++;
234 
235         userStruct = UserStruct({
236             isExist: true,
237             id: currUserID,
238             referrerID: _referrerID,
239             referral: new address[](0),
240             directSponsor: tempReferrerID,
241             referralCounter: 0
242         });
243 
244         users[msg.sender] = userStruct;
245         userList[currUserID] = msg.sender;
246 
247         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
248 
249         users[userList[_referrerID]].referral.push(msg.sender);
250 
251         payForLevel(1, msg.sender,userList[_referrerID]);
252         
253         //increase the referral counter;
254         users[userList[tempReferrerID]].referralCounter++;
255 
256         emit regLevelEvent(msg.sender, userList[tempReferrerID], now);
257     }
258     
259     function regAdmins(address [] memory _adminAddress) public  {
260         
261         require(msg.sender == ownerWallet,"You are not authorized");
262         require(currUserID <= 8, "No more admins can be registered");
263         
264         UserStruct memory userStruct;
265         
266         for(uint i = 0; i < _adminAddress.length; i++){
267             
268             currUserID++;
269 
270             uint _referrerID = 1;
271             uint tempReferrerID = _referrerID;
272     
273             if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) 
274                 _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
275     
276             userStruct = UserStruct({
277                 isExist: true,
278                 id: currUserID,
279                 referrerID: _referrerID,
280                 referral: new address[](0),
281                 directSponsor: tempReferrerID,
282                 referralCounter: 0
283             });
284     
285             users[_adminAddress[i]] = userStruct;
286             userList[currUserID] = _adminAddress[i];
287             
288             for(uint j = 1; j <= 12; j++) {
289                 users[_adminAddress[i]].levelExpired[j] = 55555555555;
290             }
291     
292             users[userList[_referrerID]].referral.push(_adminAddress[i]);
293     
294             //increase the referral counter;
295             users[userList[tempReferrerID]].referralCounter++;
296     
297             emit regLevelEvent(msg.sender, userList[tempReferrerID], now);
298         }
299     }
300     
301     
302 
303     function buyLevel(uint _level) public payable {
304         require(users[msg.sender].isExist, 'User not exist'); 
305         require(_level > 0 && _level <= 12, 'Incorrect level');
306 
307         if(_level == 1) {
308             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
309             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
310         }
311         else {
312             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
313 
314             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
315 
316             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
317             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
318         }
319 
320         payForLevel(_level, msg.sender, userList[users[msg.sender].directSponsor]);
321 
322         emit buyLevelEvent(msg.sender, _level, now);
323     }
324     
325    
326     function payForLevel(uint _level, address _user, address _sponsor) internal {
327         address actualReferer;
328         address referer1;
329         address referer2;
330         
331 
332         if(_level == 1)
333             actualReferer = userList[users[_user].directSponsor];
334         
335         else if(_level == 7) {
336             actualReferer = userList[users[_user].referrerID];
337         }
338         else if(_level == 2 || _level == 8) {
339             referer1 = userList[users[_user].referrerID];
340             actualReferer = userList[users[referer1].referrerID];
341         }
342         else if(_level == 3 || _level == 9) {
343             referer1 = userList[users[_user].referrerID];
344             referer2 = userList[users[referer1].referrerID];
345             actualReferer = userList[users[referer2].referrerID];
346         }
347         else if(_level == 4 || _level == 10) {
348             referer1 = userList[users[_user].referrerID];
349             referer2 = userList[users[referer1].referrerID];
350             referer1 = userList[users[referer2].referrerID];
351             actualReferer = userList[users[referer1].referrerID];
352         }
353         else if(_level == 5 || _level == 11) {
354             referer1 = userList[users[_user].referrerID];
355             referer2 = userList[users[referer1].referrerID];
356             referer1 = userList[users[referer2].referrerID];
357             referer2 = userList[users[referer1].referrerID];
358             actualReferer = userList[users[referer2].referrerID];
359         }
360         else if(_level == 6 || _level == 12) {
361             referer1 = userList[users[_user].referrerID];
362             referer2 = userList[users[referer1].referrerID];
363             referer1 = userList[users[referer2].referrerID];
364             referer2 = userList[users[referer1].referrerID];
365             referer1 = userList[users[referer2].referrerID];
366             actualReferer = userList[users[referer1].referrerID];
367         }
368 
369         if(!users[actualReferer].isExist) actualReferer = userList[1];
370 
371         bool sent = false;
372         
373         if(_level == 1) {
374             if(users[actualReferer].levelExpired[_level] >= now) {
375                 sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]);
376                 if (sent) {
377                     emit getSponsorBonusEvent(actualReferer, msg.sender, _level, now);
378                 }
379             }
380             else {
381                 address(uint160(wallet2)).transfer(LEVEL_PRICE[_level]);
382                 emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now,1);
383             }
384         }
385         else {
386             if(users[actualReferer].levelExpired[_level] >= now) {
387                 sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level].mul(earnings).div(100));
388 
389                 if (sent) {
390                     
391                     if(users[_sponsor].levelExpired[_level] >= now) {
392                         address(uint160(_sponsor)).transfer(LEVEL_PRICE [_level].mul(directSponsorFees).div(100));
393                         emit getSponsorBonusEvent(_sponsor, msg.sender, _level, now);
394                     }
395                     else{
396                         address(uint160(wallet2)).transfer(LEVEL_PRICE [_level].mul(directSponsorFees).div(100));
397                         emit lostMoneyForLevelEvent(_sponsor, msg.sender, _level, now, 1);
398                     }   
399                     address(uint160(wallet1)).transfer(LEVEL_PRICE[_level].mul(adminFees).div(100));
400                     emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now);
401                     
402                 }
403             }
404             
405             if(!sent) {
406                 emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
407     
408                 payForLevel(_level, actualReferer, _sponsor);
409             }
410         }
411     }
412 
413     function findFreeReferrer(address _user) public view returns(address) {
414         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
415 
416         address[] memory referrals = new address[](1022);
417         referrals[0] = users[_user].referral[0];
418         referrals[1] = users[_user].referral[1];
419 
420         address freeReferrer;
421         bool noFreeReferrer = true;
422 
423         for(uint i = 0; i < 1022; i++) {
424             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
425                 if(i < 62) {
426                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
427                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
428                 }
429             }
430             else {
431                 noFreeReferrer = false;
432                 freeReferrer = referrals[i];
433                 break;
434             }
435         }
436 
437         require(!noFreeReferrer, 'No Free Referrer');
438 
439         return freeReferrer;
440     }
441 
442     function viewUserReferral(address _user) public view returns(address[] memory) {
443         return users[_user].referral;
444     }
445 
446     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
447         return users[_user].levelExpired[_level];
448     }
449 
450     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
451         assembly {
452             addr := mload(add(bys, 20))
453         }
454     }
455     
456      /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) external {
461         
462         require(msg.sender == ownerWallet,"You are not authorized");
463         _transferOwnership(newOwner);
464     }
465 
466      /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      */
469     function _transferOwnership(address newOwner) internal {
470         require(newOwner != address(0), "New owner cannot be the zero address");
471         emit OwnershipTransferred(ownerWallet, newOwner);
472         ownerWallet = newOwner;
473     }
474 }