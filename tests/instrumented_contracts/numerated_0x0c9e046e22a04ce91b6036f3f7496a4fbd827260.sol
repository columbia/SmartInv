1 /**
2 * Absolutus smart contract by BioHazzardt
3 */
4 pragma solidity ^0.5.7;
5 
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the multiplication of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `*` operator.
26      *
27      * Requirements:
28      * - Multiplication cannot overflow.
29      */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a * b;
32         require(a == 0 || c / a == b, 'Invalid values');
33         return c;
34     }
35 
36     /**
37      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
38      * division by zero. The result is rounded towards zero.
39      *
40      * Counterpart to Solidity's `/` operator. Note: this function uses a
41      * `revert` opcode (which leaves remaining gas untouched) while Solidity
42      * uses an invalid opcode to revert (consuming all remaining gas).
43      *
44      * Requirements:
45      * - The divisor cannot be zero.
46      *
47      * _Available since v2.4.0._
48      */
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a / b;
51         return c;
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a, 'Substraction result smaller than zero');
65         return a - b;
66     }
67 
68     /**
69      * @dev Returns the addition of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `+` operator.
73      *
74      * Requirements:
75      * - Addition cannot overflow.
76     */
77     function add(uint256 a, uint256 b) internal pure returns (uint256) {
78         uint256 c = a + b;
79         require(c >= a, 'Invalid values');
80         return c;
81     }
82 }
83 
84 
85 /**
86  * @dev Contract module which provides a basic access control mechanism, where
87  * there is an account (an owner) that can be granted exclusive access to
88  * specific functions.
89  *
90  * This module is used through inheritance. It will make available the modifier
91  * `onlyOwner`, which can be applied to your functions to restrict their use to
92  * the owner.
93  */
94 contract Ownable {
95     address public owner;
96     address public manager;
97     address public ownerWallet;
98     address public adminWallet;
99     uint adminPersent;
100 
101     constructor() public {
102         owner = msg.sender;
103         manager = msg.sender;
104         adminWallet = 0xcFebf7C3Ec7B407DFf17aa20a2631c95c8ff508c;
105         ownerWallet = 0xcFebf7C3Ec7B407DFf17aa20a2631c95c8ff508c;
106         adminPersent = 10;
107     }
108 
109     modifier onlyOwner() {
110         require(msg.sender == owner, "only for owner");
111         _;
112     }
113 
114     modifier onlyOwnerOrManager() {
115         require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
116         _;
117     }
118 
119     function transferOwnership(address newOwner) public onlyOwner {
120         owner = newOwner;
121     }
122 
123     function setManager(address _manager) public onlyOwnerOrManager {
124         manager = _manager;
125     }
126 
127     function setAdminWallet(address _admin) public onlyOwner {
128         adminWallet = _admin;
129     }
130 }
131 
132 
133 contract WalletOnly {
134     function isContract(address account) internal view returns (bool) {
135         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
136         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
137         // for accounts without code, i.e. `keccak256('')`
138         bytes32 codehash;
139         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
140         // solhint-disable-next-line no-inline-assembly
141         assembly { codehash := extcodehash(account) }
142         return (codehash != accountHash && codehash != 0x0);
143     }
144 }
145 
146 
147 contract Absolutus is Ownable, WalletOnly {
148     // Events
149     event RegLevelEvent(address indexed _user, address indexed _referrer, uint _id, uint _time);
150     event BuyLevelEvent(address indexed _user, uint _level, uint _time);
151     event ProlongateLevelEvent(address indexed _user, uint _level, uint _time);
152     event GetMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _price, bool _prevLost);
153     event LostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint _price, bool _prevLost);
154 
155     // New events
156     event PaymentForHolder(address indexed _addr, uint _index, uint _value);
157     event PaymentForHolderLost(address indexed _addr, uint _index, uint _value);
158 
159     // Common values
160     mapping (uint => uint) public LEVEL_PRICE;
161     address canSetLevelPrice;
162     uint REFERRER_1_LEVEL_LIMIT = 3;
163     uint PERIOD_LENGTH = 365 days; // uncomment before production
164     uint MAX_AUTOPAY_COUNT = 5;     // Automatic level buying limit per one transaction (to prevent gas limit reaching)
165 
166     struct UserStruct {
167         bool isExist;
168         uint id;
169         uint referrerID;
170         uint fund;          // Fund for the automatic level pushcase
171         uint currentLvl;    // Current user's level
172         address[] referral;
173         mapping (uint => uint) levelExpired;
174         mapping (uint => uint) paymentsCount;
175     }
176 
177     mapping (address => UserStruct) public users;
178     mapping (uint => address) public userList;
179     mapping (address => uint) public allowUsers;
180 
181     uint public currUserID = 0;
182     bool nostarted = false;
183 
184     AbsDAO _dao; // DAO contract
185     bool daoSet = false; // if true payment processed for DAO holders
186 
187     using SafeMath for uint; // <== do not forget about this
188 
189     constructor() public {
190         // Prices in ETH: production
191         LEVEL_PRICE[1] = 0.5 ether;
192         LEVEL_PRICE[2] = 1.0 ether;
193         LEVEL_PRICE[3] = 2.0 ether;
194         LEVEL_PRICE[4] = 4.0 ether;
195         LEVEL_PRICE[5] = 16.0 ether;
196         LEVEL_PRICE[6] = 32.0 ether;
197         LEVEL_PRICE[7] = 64.0 ether;
198         LEVEL_PRICE[8] = 128.0 ether;
199 
200         UserStruct memory userStruct;
201         currUserID++;
202 
203         canSetLevelPrice = owner;
204 
205         // Create root user
206         userStruct = UserStruct({
207             isExist : true,
208             id : currUserID,
209             referrerID : 0,
210             fund: 0,
211             currentLvl: 1,
212             referral : new address[](0)
213         });
214 
215         users[ownerWallet] = userStruct;
216         userList[currUserID] = ownerWallet;
217 
218         users[ownerWallet].levelExpired[1] = 77777777777;
219         users[ownerWallet].levelExpired[2] = 77777777777;
220         users[ownerWallet].levelExpired[3] = 77777777777;
221         users[ownerWallet].levelExpired[4] = 77777777777;
222         users[ownerWallet].levelExpired[5] = 77777777777;
223         users[ownerWallet].levelExpired[6] = 77777777777;
224         users[ownerWallet].levelExpired[7] = 77777777777;
225         users[ownerWallet].levelExpired[8] = 77777777777;
226 
227         // Set inviting registration only
228         nostarted = true;
229     }
230 
231     function () external payable {
232         require(!isContract(msg.sender), 'This contract cannot support payments from other contracts');
233 
234         uint level;
235 
236         // Check for payment with level price
237         if (msg.value == LEVEL_PRICE[1]) {
238             level = 1;
239         } else if (msg.value == LEVEL_PRICE[2]) {
240             level = 2;
241         } else if (msg.value == LEVEL_PRICE[3]) {
242             level = 3;
243         } else if (msg.value == LEVEL_PRICE[4]) {
244             level = 4;
245         } else if (msg.value == LEVEL_PRICE[5]) {
246             level = 5;
247         } else if (msg.value == LEVEL_PRICE[6]) {
248             level = 6;
249         } else if (msg.value == LEVEL_PRICE[7]) {
250             level = 7;
251         } else if (msg.value == LEVEL_PRICE[8]) {
252             level = 8;
253         } else {
254             // Pay to user's fund
255             if (!users[msg.sender].isExist || users[msg.sender].currentLvl >= 8)
256                 revert('Incorrect Value send');
257 
258             users[msg.sender].fund += msg.value;
259             updateCurrentLevel(msg.sender);
260             // if the referer is have funds for autobuy next level
261             if (LEVEL_PRICE[users[msg.sender].currentLvl+1] <= users[msg.sender].fund) {
262                 buyLevelByFund(msg.sender, 0);
263             }
264             return;
265         }
266 
267         // Buy level or register user
268         if (users[msg.sender].isExist) {
269             buyLevel(level);
270         } else if (level == 1) {
271             uint refId = 0;
272             address referrer = bytesToAddress(msg.data);
273 
274             if (users[referrer].isExist) {
275                 refId = users[referrer].id;
276             } else {
277                 revert('Incorrect referrer');
278                 // refId = 1;
279             }
280 
281             regUser(refId);
282         } else {
283             revert("Please buy first level for 0.1 ETH");
284         }
285     }
286 
287     // allow user in invite mode
288     function allowUser(address _user) public onlyOwner {
289         require(nostarted, 'You cant allow user in battle mode');
290         allowUsers[_user] = 1;
291     }
292 
293     // disable inviting
294     function battleMode() public onlyOwner {
295         require(nostarted, 'Battle mode activated');
296         nostarted = false;
297     }
298 
299     // this function sets the DAO contract address
300     function setDAOAddress(address payable _dao_addr) public onlyOwner {
301         require(!daoSet, 'DAO address already set');
302         _dao = AbsDAO(_dao_addr);
303         daoSet = true;
304     }
305 
306     // process payment to administrator wallet
307     // or DAO holders
308     function payToAdmin(uint _amount) internal {
309         if (daoSet) {
310             // Pay for DAO
311             uint holderCount = _dao.getHolderCount();       // get the DAO holders count
312             for (uint i = 1; i <= holderCount; i++) {
313                 uint val = _dao.getHolderPieAt(i);          // get pie of holder with index == i
314                 address payable holder = _dao.getHolder(i); // get the holder address
315 
316                 if (val > 0) {                              // check of the holder pie value
317                     uint payValue = _amount.div(100).mul(val); // calculate amount for pay to the holder
318                     holder.transfer(payValue);
319                     emit PaymentForHolder(holder, i, payValue); // payment ok
320                 } else {
321                     emit PaymentForHolderLost(holder, i, val); // holder's pie value is zero
322                 }
323             }
324         } else {
325             // pay to admin wallet
326             address(uint160(adminWallet)).transfer(_amount);
327         }
328     }
329 
330     // user registration
331     function regUser(uint referrerID) public payable {
332         require(!isContract(msg.sender), 'This contract cannot support payments from other contracts');
333 
334         if (nostarted) {
335             require(allowUsers[msg.sender] > 0, 'You cannot use this contract on start');
336         }
337 
338         require(!users[msg.sender].isExist, 'User exist');
339         require(referrerID > 0 && referrerID <= currUserID, 'Incorrect referrer Id');
340         require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
341 
342         // NOTE: use one more variable to prevent 'Security/No-assign-param' error (for vscode-solidity extension).
343         // Need to check the gas consumtion with it
344         uint _referrerID = referrerID;
345 
346         if (users[userList[referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) {
347             _referrerID = users[findFreeReferrer(userList[referrerID])].id;
348         }
349 
350 
351         UserStruct memory userStruct;
352         currUserID++;
353 
354         // add user to list
355         userStruct = UserStruct({
356             isExist : true,
357             id : currUserID,
358             referrerID : _referrerID,
359             fund: 0,
360             currentLvl: 1,
361             referral : new address[](0)
362         });
363 
364         users[msg.sender] = userStruct;
365         userList[currUserID] = msg.sender;
366 
367         users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
368         users[msg.sender].levelExpired[2] = 0;
369         users[msg.sender].levelExpired[3] = 0;
370         users[msg.sender].levelExpired[4] = 0;
371         users[msg.sender].levelExpired[5] = 0;
372         users[msg.sender].levelExpired[6] = 0;
373         users[msg.sender].levelExpired[7] = 0;
374         users[msg.sender].levelExpired[8] = 0;
375 
376         users[userList[_referrerID]].referral.push(msg.sender);
377 
378         // pay for referer
379         payForLevel(
380             1,
381             msg.sender,
382             msg.sender,
383             0,
384             false
385         );
386 
387         emit RegLevelEvent(
388             msg.sender,
389             userList[_referrerID],
390             currUserID,
391             now
392         );
393     }
394 
395     // buy level function
396     function buyLevel(uint _level) public payable {
397         require(!isContract(msg.sender), 'This contract cannot support payments from other contracts');
398 
399         require(users[msg.sender].isExist, 'User not exist');
400         require(_level>0 && _level<=8, 'Incorrect level');
401         require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');
402 
403         if (_level > 1) { // Replace for condition (_level == 1) on top (done)
404             for (uint i = _level-1; i>0; i--) {
405                 require(users[msg.sender].levelExpired[i] >= now, 'Buy the previous level');
406             }
407         }
408 
409         // if(users[msg.sender].levelExpired[_level] == 0){ <-- BUG
410         // if the level expired in the future, need add PERIOD_LENGTH to the level expiration time,
411         // or set the level expiration time to 'now + PERIOD_LENGTH' in other cases.
412         if (users[msg.sender].levelExpired[_level] > now) {
413             users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
414         } else {
415             users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
416         }
417 
418         // Set user's current level
419         if (users[msg.sender].currentLvl < _level)
420             users[msg.sender].currentLvl = _level;
421 
422         // provide payment for the user's referer
423         payForLevel(
424             _level,
425             msg.sender,
426             msg.sender,
427             0,
428             false
429         );
430 
431         emit BuyLevelEvent(msg.sender, _level, now);
432     }
433 
434     function setLevelPrice(uint _level, uint _price) public {
435         require(_level >= 0 && _level <= 8, 'Invalid level');
436         require(msg.sender == canSetLevelPrice, 'Invalid caller');
437         require(_price > 0, 'Price cannot be zero or negative');
438 
439         LEVEL_PRICE[_level] = _price * 1.0 finney;
440     }
441 
442     function setCanUpdateLevelPrice(address addr) public onlyOwner {
443         canSetLevelPrice = addr;
444     }
445 
446     // for interactive correction of the limitations
447     function setMaxAutopayForLevelCount(uint _count) public onlyOwnerOrManager {
448         MAX_AUTOPAY_COUNT = _count;
449     }
450 
451     // buyLevelByFund provides automatic payment for next level for user
452     function buyLevelByFund(address referer, uint _counter) internal {
453         require(users[referer].isExist, 'User not exists');
454 
455         uint _level = users[referer].currentLvl + 1; // calculate a next level
456         require(users[referer].fund >= LEVEL_PRICE[_level], 'Not have funds to autobuy level');
457 
458         uint remaining = users[referer].fund - LEVEL_PRICE[_level]; // Amount for pay to the referer
459 
460         // extend the level's expiration time
461         if (users[referer].levelExpired[_level] >= now) {
462             users[referer].levelExpired[_level] += PERIOD_LENGTH;
463         } else {
464             users[referer].levelExpired[_level] = now + PERIOD_LENGTH;
465         }
466 
467         users[referer].currentLvl = _level; // set current level for referer
468         users[referer].fund = 0;            // clear the referer's fund
469 
470         // process payment for next referer with increment autopay counter
471         payForLevel(
472             _level,
473             referer,
474             referer,
475             _counter+1,
476             false
477         );
478         address(uint160(referer)).transfer(remaining); // send the remaining amount to referer
479 
480         emit BuyLevelEvent(referer, _level, now); // emit the buy level event for referer
481     }
482 
483     // updateCurrentLevel calculate 'currentLvl' value for given user
484     function updateCurrentLevel(address _user) internal {
485         users[_user].currentLvl = actualLevel(_user);
486     }
487 
488     // helper function
489     function actualLevel(address _user) public view returns(uint) {
490         require(users[_user].isExist, 'User not found');
491 
492         for (uint i = 1; i <= 8; i++) {
493             if (users[_user].levelExpired[i] <= now) {
494                 return i-1;
495             }
496         }
497 
498         return 8;
499     }
500 
501     // payForLevel provides payment processing for user's referer and automatic buying referer's next
502     // level.
503     function payForLevel(uint _level, address _user, address _sender, uint _autoPayCtr, bool prevLost) internal {
504         address referer;
505         address referer1;
506         address referer2;
507         address referer3;
508 
509         if (_level == 1 || _level == 5) {
510             referer = userList[users[_user].referrerID];
511         } else if (_level == 2 || _level == 6) {
512             referer1 = userList[users[_user].referrerID];
513             referer = userList[users[referer1].referrerID];
514         } else if (_level == 3 || _level == 7) {
515             referer1 = userList[users[_user].referrerID];
516             referer2 = userList[users[referer1].referrerID];
517             referer = userList[users[referer2].referrerID];
518         } else if (_level == 4 || _level == 8) {
519             referer1 = userList[users[_user].referrerID];
520             referer2 = userList[users[referer1].referrerID];
521             referer3 = userList[users[referer2].referrerID];
522             referer = userList[users[referer3].referrerID];
523         }
524 
525         if (!users[referer].isExist) {
526             referer = userList[1];
527         }
528 
529         uint amountToUser;
530         uint amountToAdmin;
531 
532         amountToAdmin = LEVEL_PRICE[_level] / 100 * adminPersent;
533         amountToUser = LEVEL_PRICE[_level] - amountToAdmin;
534 
535         if (users[referer].id <= 4) {
536             payToAdmin(LEVEL_PRICE[_level]);
537 
538             emit GetMoneyForLevelEvent(
539                 referer,
540                 _sender,
541                 _level,
542                 now,
543                 amountToUser,
544                 prevLost
545             );
546 
547             return;
548         }
549 
550         if (users[referer].levelExpired[_level] >= now) {
551             payToAdmin(amountToAdmin);
552 
553             // update current referer's level
554             updateCurrentLevel(referer);
555 
556 
557             // check for the user has right level and automatic payment counter
558             // smaller than the 'MAX_AUTOPAY_COUNT' value
559             if (_level == users[referer].currentLvl && _autoPayCtr < MAX_AUTOPAY_COUNT && users[referer].currentLvl < 8) {
560                 users[referer].fund += amountToUser;
561 
562                 emit GetMoneyForLevelEvent(
563                     referer,
564                     _sender,
565                     _level,
566                     now,
567                     amountToUser,
568                     prevLost
569                 );
570 
571                 // if the referer is have funds for autobuy next level
572                 if (LEVEL_PRICE[users[referer].currentLvl+1] <= users[referer].fund) {
573                     buyLevelByFund(referer, _autoPayCtr);
574                 }
575             } else {
576                 // send the ethers to referer
577                 address(uint160(referer)).transfer(amountToUser);
578 
579                 emit GetMoneyForLevelEvent(
580                     referer,
581                     _sender,
582                     _level,
583                     now,
584                     amountToUser,
585                     prevLost
586                 );
587             }
588         } else {
589             // pay for the referer's referer
590             emit LostMoneyForLevelEvent(
591                 referer,
592                 _sender,
593                 _level,
594                 now,
595                 amountToUser,
596                 prevLost
597             );
598 
599             payForLevel(
600                 _level,
601                 referer,
602                 _sender,
603                 _autoPayCtr,
604                 true
605             );
606         }
607     }
608 
609     function findFreeReferrer(address _user) public view returns(address) {
610         if (users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) {
611             return _user;
612         }
613 
614         address[] memory referrals = new address[](363);
615         referrals[0] = users[_user].referral[0];
616         referrals[1] = users[_user].referral[1];
617         referrals[2] = users[_user].referral[2];
618 
619         address freeReferrer;
620         bool noFreeReferrer = true;
621 
622         for (uint i = 0; i<363; i++) {
623             if (users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
624                 if (i<120) {
625                     referrals[(i+1)*3] = users[referrals[i]].referral[0];
626                     referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
627                     referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
628                 }
629             } else {
630                 noFreeReferrer = false;
631                 freeReferrer = referrals[i];
632                 break;
633             }
634         }
635         require(!noFreeReferrer, 'No Free Referrer');
636         return freeReferrer;
637     }
638 
639     function viewUserReferral(address _user) public view returns(address[] memory) {
640         return users[_user].referral;
641     }
642 
643     function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
644         return users[_user].levelExpired[_level];
645     }
646 
647     function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
648         assembly {
649             addr := mload(add(bys, 20))
650         }
651     }
652 }
653 
654 
655 contract AbsDAO is Ownable, WalletOnly {
656     // events
657     event TransferPie(address indexed _from, address indexed _to, uint _value);
658     event NewHolder(address indexed _addr, uint _index);
659     event HolderChanged(address indexed _from, address indexed _to, uint _index);
660     event PaymentReceived(address indexed _from, uint _value);
661     event PaymentForHolder(address indexed _addr, uint _index, uint _value);
662     event PaymentForHolderLost(address indexed _addr, uint _index, uint _value);
663 
664     struct Holder {
665         bool isExist;
666         uint id;
667         uint value;
668         address payable addr;
669     }
670 
671     mapping(address => Holder) public holders;
672     mapping(uint=>address payable) holderAddrs;
673 
674     uint holderCount;
675     uint _initialPie = 100;
676 
677     using SafeMath for uint;
678 
679     constructor() public {
680         // creating root hoder
681         holderCount = 1;
682         holders[msg.sender] = Holder({
683             isExist: true,
684             id: 1,
685             value: _initialPie,
686             addr: msg.sender
687         });
688 
689         holderAddrs[1] = msg.sender;
690     }
691 
692     function () external payable {
693         require(!isContract(msg.sender), 'This contract cannot support payments from other contracts');
694 
695         emit PaymentReceived(msg.sender, msg.value);
696 
697         for (uint i = 1; i <= holderCount; i++) {
698             if (holders[holderAddrs[i]].value > 0) {
699                 uint payValue = msg.value.div(100).mul(holders[holderAddrs[i]].value);
700                 holderAddrs[i].transfer(payValue);
701                 emit PaymentForHolder(holderAddrs[i], i, payValue);
702             } else {
703                 emit PaymentForHolderLost(holderAddrs[i], i, holders[holderAddrs[i]].value);
704             }
705         }
706     }
707 
708     function getHolderPieAt(uint i) public view returns(uint) {
709         return holders[holderAddrs[i]].value;
710     }
711 
712     function getHolder(uint i) public view returns(address payable) {
713         return holderAddrs[i];
714     }
715 
716     function getHolderCount() public view returns(uint) {
717         return holderCount;
718     }
719 
720     function transferPie(uint _amount, address payable _to) public {
721         require(holders[msg.sender].isExist, 'Holder not found');
722         require(_amount > 0 && _amount <= holders[msg.sender].value, 'Invalid amount');
723 
724         if (_amount == holders[msg.sender].value) {
725             uint id = holders[msg.sender].id;
726             delete holders[msg.sender];
727 
728             holders[_to] = Holder({
729                 isExist: true,
730                 id: id,
731                 value: _amount,
732                 addr: _to
733             });
734 
735             holderAddrs[id] = _to;
736 
737             emit HolderChanged(msg.sender, _to, id);
738         } else {
739             if (holders[_to].isExist) {
740                 holders[msg.sender].value -= _amount;
741                 holders[_to].value += _amount;
742             } else if (holderCount < 20) {
743                 holderCount += 1;
744                 holders[msg.sender].value -= _amount;
745                 holders[_to] = Holder({
746                     isExist: true,
747                     id: holderCount,
748                     value: _amount,
749                     addr: _to
750                 });
751 
752                 holderAddrs[holderCount] = _to;
753 
754                 emit NewHolder(_to, holderCount);
755             } else {
756                 revert('Holder limit excised');
757             }
758         }
759 
760         emit TransferPie(msg.sender, _to, _amount);
761     }
762 }