1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-31
3 */
4 
5 pragma solidity 0.5.11;
6 
7 
8 library SafeMath {
9     /**
10      * @dev Returns the addition of two unsigned integers, reverting on
11      * overflow.
12      *
13      * Counterpart to Solidity's `+` operator.
14      *
15      * Requirements:
16      * - Addition cannot overflow.
17      */
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Returns the subtraction of two unsigned integers, reverting on
27      * overflow (when the result is negative).
28      *
29      * Counterpart to Solidity's `-` operator.
30      *
31      * Requirements:
32      * - Subtraction cannot overflow.
33      */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      * - Subtraction cannot overflow.
46      *
47      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
48      * @dev Get it via `npm install @openzeppelin/contracts@next`.
49      */
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the multiplication of two unsigned integers, reverting on
59      * overflow.
60      *
61      * Counterpart to Solidity's `*` operator.
62      *
63      * Requirements:
64      * - Multiplication cannot overflow.
65      */
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
68         // benefit is lost if 'b' is also tested.
69         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
70         if (a == 0) {
71             return 0;
72         }
73 
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76 
77         return c;
78     }
79 
80     /**
81      * @dev Returns the integer division of two unsigned integers. Reverts on
82      * division by zero. The result is rounded towards zero.
83      *
84      * Counterpart to Solidity's `/` operator. Note: this function uses a
85      * `revert` opcode (which leaves remaining gas untouched) while Solidity
86      * uses an invalid opcode to revert (consuming all remaining gas).
87      *
88      * Requirements:
89      * - The divisor cannot be zero.
90      */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      * - The divisor cannot be zero.
105      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
106      * @dev Get it via `npm install @openzeppelin/contracts@next`.
107      */
108     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 }
117 
118 contract EEZA {
119     
120     using SafeMath for *;
121     
122     address public ownerWallet;
123     address public wallet1; //3%
124     address public wallet2; //15%
125 
126 
127     
128    struct UserStruct {
129         bool isExist;
130         uint id;
131         uint referrerID;
132         address[] referral;
133         uint directSponsor;
134         uint referralCounter;
135         mapping(uint => uint) levelExpired;
136     }
137 
138     uint REFERRER_1_LEVEL_LIMIT = 2;
139     uint PERIOD_LENGTH = 360 days;
140     uint private adminFees = 10;
141     uint private directSponsorFees =0;
142     uint private earnings = 90;
143 
144     mapping(uint => uint) public LEVEL_PRICE;
145 
146     mapping (address => UserStruct) public users;
147     mapping (uint => address) public userList;
148     uint public currUserID = 0;
149 
150     event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
151     event buyLevelEvent(address indexed _user, uint _level, uint _time);
152     event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
153     event getSponsorBonusEvent(address indexed _sponsor, address indexed _user, uint _level, uint _time);
154     event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint number);
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     constructor(address _owner, address _wallet1, address _wallet2) public {
158         ownerWallet = msg.sender;
159         wallet1 = _wallet1;
160         wallet2 = _wallet2;
161 
162         LEVEL_PRICE[1] = 0.03 ether;
163         LEVEL_PRICE[2] = 0.05 ether;
164         LEVEL_PRICE[3] = 0.1 ether;
165         LEVEL_PRICE[4] = 0.5 ether;
166         LEVEL_PRICE[5] = 1.5 ether;
167         LEVEL_PRICE[6] = 3 ether;
168         LEVEL_PRICE[7] = 8 ether;
169         LEVEL_PRICE[8] = 10 ether;
170         LEVEL_PRICE[9] = 15 ether;
171         LEVEL_PRICE[10] = 25 ether;
172         LEVEL_PRICE[11] = 30 ether;
173         LEVEL_PRICE[12] = 40 ether;
174 
175         UserStruct memory userStruct;
176         currUserID++;
177 
178         userStruct = UserStruct({
179             isExist: true,
180             id: currUserID,
181             referrerID: 0,
182             referral: new address[](0),
183             directSponsor: 0,
184             referralCounter: 0
185         });
186         users[_owner] = userStruct;
187         userList[currUserID] = _owner;
188 
189         for(uint i = 1; i <= 12; i++) {
190             users[_owner].levelExpired[i] = 55555555555;
191         }
192     }
193 
194     function () external payable {
195         uint level;
196 
197         if(msg.value == LEVEL_PRICE[1]) level = 1;
198         else if(msg.value == LEVEL_PRICE[2]) level = 2;
199         else if(msg.value == LEVEL_PRICE[3]) level = 3;
200         else if(msg.value == LEVEL_PRICE[4]) level = 4;
201         else if(msg.value == LEVEL_PRICE[5]) level = 5;
202         else if(msg.value == LEVEL_PRICE[6]) level = 6;
203         else if(msg.value == LEVEL_PRICE[7]) level = 7;
204         else if(msg.value == LEVEL_PRICE[8]) level = 8;
205         else if(msg.value == LEVEL_PRICE[9]) level = 9;
206         else if(msg.value == LEVEL_PRICE[10]) level = 10;
207         else if(msg.value == LEVEL_PRICE[11]) level = 11;
208         else if(msg.value == LEVEL_PRICE[12]) level = 12;
209         
210         else revert('Incorrect Value send');
211 
212         if(users[msg.sender].isExist) buyLevel(level);
213         else if(level == 1) {
214             uint refId = 0;
215             address referrer = bytesToAddress(msg.data);
216 
217             if(users[referrer].isExist) refId = users[referrer].id;
218             else revert('Incorrect referrer');
219 
220             regUser(refId);
221         }
222         else revert('Please buy first level for 0.03 ETH');
223     }
224 
225     function regUser(uint _referrerID) public payable {
226        
227         require(!users[msg.sender].isExist, 'User exist');
228         require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
229         require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
230 
231         uint tempReferrerID = _referrerID;
232 
233         if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) 
234             _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
235 
236         UserStruct memory userStruct;
237         currUserID++;
238 
239         userStruct = UserStruct({
240             isExist: true,
241             id: currUserID,
242             referrerID: _referrerID,
243             referral: new address[](0),
244             directSponsor: tempReferrerID,
245             referralCounter: 0
246         });
247 
248         users[msg.sender] = userStruct;
249         userList[currUserID] = msg.sender;
250 
251         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
252 
253         users[userList[_referrerID]].referral.push(msg.sender);
254 
255         payForLevel(1, msg.sender,userList[_referrerID]);
256         
257         //increase the referral counter;
258         users[userList[tempReferrerID]].referralCounter++;
259 
260         emit regLevelEvent(msg.sender, userList[tempReferrerID], now);
261     }
262     
263     function regAdmins(address [] memory _adminAddress) public  {
264         
265         require(msg.sender == ownerWallet,"You are not authorized");
266         require(currUserID <= 8, "No more admins can be registered");
267         
268         UserStruct memory userStruct;
269         
270         for(uint i = 0; i < _adminAddress.length; i++){
271             
272             currUserID++;
273 
274             uint _referrerID = 1;
275             uint tempReferrerID = _referrerID;
276     
277             if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) 
278                 _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
279     
280             userStruct = UserStruct({
281                 isExist: true,
282                 id: currUserID,
283                 referrerID: _referrerID,
284                 referral: new address[](0),
285                 directSponsor: tempReferrerID,
286                 referralCounter: 0
287             });
288     
289             users[_adminAddress[i]] = userStruct;
290             userList[currUserID] = _adminAddress[i];
291             
292             for(uint j = 1; j <= 12; j++) {
293                 users[_adminAddress[i]].levelExpired[j] = 55555555555;
294             }
295     
296             users[userList[_referrerID]].referral.push(_adminAddress[i]);
297     
298             //increase the referral counter;
299             users[userList[tempReferrerID]].referralCounter++;
300     
301             emit regLevelEvent(msg.sender, userList[tempReferrerID], now);
302         }
303     }
304     
305     
306 
307     function buyLevel(uint _level) public payable {
308         require(users[msg.sender].isExist, 'User not exist'); 
309         require(_level > 0 && _level <= 12, 'Incorrect level');
310 
311         if(_level == 1) {
312             require(msg.value == LEVEL_PRICE[1], 'Incorrect Value');
313             users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
314         }
315         else {
316             require(msg.value == LEVEL_PRICE[_level], 'Incorrect Value');
317 
318             for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
319 
320             if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
321             else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
322         }
323 
324         payForLevel(_level, msg.sender, userList[users[msg.sender].directSponsor]);
325 
326         emit buyLevelEvent(msg.sender, _level, now);
327     }
328     
329    
330     function payForLevel(uint _level, address _user, address _sponsor) internal {
331         address actualReferer;
332         address referer1;
333         address referer2;
334         
335 
336         if(_level == 1)
337         {
338             referer1 = userList[users[_user].directSponsor];
339             actualReferer = userList[users[_user].referrerID];
340         }
341         else if(_level == 7)
342         {
343             actualReferer = userList[users[_user].referrerID];
344         }
345         else if(_level == 2 || _level == 8) {
346             referer1 = userList[users[_user].referrerID];
347             actualReferer = userList[users[referer1].referrerID];
348         }
349         else if(_level == 3 || _level == 9) {
350             referer1 = userList[users[_user].referrerID];
351             referer2 = userList[users[referer1].referrerID];
352             actualReferer = userList[users[referer2].referrerID];
353         }
354         else if(_level == 4 || _level == 10) {
355             referer1 = userList[users[_user].referrerID];
356             referer2 = userList[users[referer1].referrerID];
357             referer1 = userList[users[referer2].referrerID];
358             actualReferer = userList[users[referer1].referrerID];
359         }
360         else if(_level == 5 || _level == 11) {
361             referer1 = userList[users[_user].referrerID];
362             referer2 = userList[users[referer1].referrerID];
363             referer1 = userList[users[referer2].referrerID];
364             referer2 = userList[users[referer1].referrerID];
365             actualReferer = userList[users[referer2].referrerID];
366         }
367         else if(_level == 6 || _level == 12) {
368             referer1 = userList[users[_user].referrerID];
369             referer2 = userList[users[referer1].referrerID];
370             referer1 = userList[users[referer2].referrerID];
371             referer2 = userList[users[referer1].referrerID];
372             referer1 = userList[users[referer2].referrerID];
373             actualReferer = userList[users[referer1].referrerID];
374         }
375 
376         if(!users[actualReferer].isExist) actualReferer = userList[1];
377 
378         bool sent = false;
379         
380         if(_level == 1) {
381             
382                 sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level]/2);
383                 sent = address(uint160(referer1)).send(LEVEL_PRICE[_level]/2);
384                 if (sent) {
385                     emit getSponsorBonusEvent(referer1, msg.sender, _level, now);
386                     emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now);
387                 }
388             
389             else {
390                 address(uint160(wallet2)).transfer(LEVEL_PRICE[_level]);
391                 emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now,1);
392             }
393         }
394         else {
395             if(users[actualReferer].levelExpired[_level] >= now) {
396                 sent = address(uint160(actualReferer)).send(LEVEL_PRICE[_level].mul(earnings).div(100));
397                         emit getMoneyForLevelEvent(actualReferer, msg.sender, _level, now);
398                 if (sent) {
399                     
400                     address(uint160(wallet1)).transfer(LEVEL_PRICE[_level].mul(adminFees).div(100)); 
401                 }
402             }
403             
404             if(!sent) {
405                 emit lostMoneyForLevelEvent(actualReferer, msg.sender, _level, now, 2);
406     
407                 payForLevel(_level, actualReferer, _sponsor);
408             }
409         }
410     }
411 
412     function findFreeReferrer(address _user) public view returns(address) {
413         if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;
414 
415         address[] memory referrals = new address[](1022);
416         referrals[0] = users[_user].referral[0];
417         referrals[1] = users[_user].referral[1];
418 
419         address freeReferrer;
420         bool noFreeReferrer = true;
421 
422         for(uint i = 0; i < 1022; i++) {
423             if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
424                 if(i < 62) {
425                     referrals[(i+1)*2] = users[referrals[i]].referral[0];
426                     referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
427                 }
428             }
429             else {
430                 noFreeReferrer = false;
431                 freeReferrer = referrals[i];
432                 break;
433             }
434         }
435 
436         require(!noFreeReferrer, 'No Free Referrer');
437 
438         return freeReferrer;
439     }
440 
441     function viewUserReferral(address _user) public view returns(address[] memory) {
442         return users[_user].referral;
443     }
444 
445     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
446         return users[_user].levelExpired[_level];
447     }
448 
449     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
450         assembly {
451             addr := mload(add(bys, 20))
452         }
453     }
454     
455      /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) external {
460         
461         require(msg.sender == ownerWallet,"You are not authorized");
462         _transferOwnership(newOwner);
463     }
464 
465      /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      */
468     function _transferOwnership(address newOwner) internal {
469         require(newOwner != address(0), "New owner cannot be the zero address");
470         emit OwnershipTransferred(ownerWallet, newOwner);
471         ownerWallet = newOwner;
472     }
473 }