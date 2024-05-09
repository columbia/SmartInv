1 pragma solidity 0.4.25;
2 
3 contract Auth {
4 
5   address internal mainAdmin;
6   address internal contractAdmin;
7   address internal profitAdmin;
8   address internal ethAdmin;
9   address internal LAdmin;
10   address internal maxSAdmin;
11   address internal backupAdmin;
12   address internal commissionAdmin;
13 
14   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
15 
16   constructor(
17     address _mainAdmin,
18     address _contractAdmin,
19     address _profitAdmin,
20     address _ethAdmin,
21     address _LAdmin,
22     address _maxSAdmin,
23     address _backupAdmin,
24     address _commissionAdmin
25   )
26   internal
27   {
28     mainAdmin = _mainAdmin;
29     contractAdmin = _contractAdmin;
30     profitAdmin = _profitAdmin;
31     ethAdmin = _ethAdmin;
32     LAdmin = _LAdmin;
33     maxSAdmin = _maxSAdmin;
34     backupAdmin = _backupAdmin;
35     commissionAdmin = _commissionAdmin;
36   }
37 
38   modifier onlyMainAdmin() {
39     require(isMainAdmin(), "onlyMainAdmin");
40     _;
41   }
42 
43   modifier onlyContractAdmin() {
44     require(isContractAdmin() || isMainAdmin(), "onlyContractAdmin");
45     _;
46   }
47 
48   modifier onlyProfitAdmin() {
49     require(isProfitAdmin() || isMainAdmin(), "onlyProfitAdmin");
50     _;
51   }
52 
53   modifier onlyEthAdmin() {
54     require(isEthAdmin() || isMainAdmin(), "onlyEthAdmin");
55     _;
56   }
57 
58   modifier onlyLAdmin() {
59     require(isLAdmin() || isMainAdmin(), "onlyLAdmin");
60     _;
61   }
62 
63   modifier onlyMaxSAdmin() {
64     require(isMaxSAdmin() || isMainAdmin(), "onlyMaxSAdmin");
65     _;
66   }
67 
68   modifier onlyBackupAdmin() {
69     require(isBackupAdmin() || isMainAdmin(), "onlyBackupAdmin");
70     _;
71   }
72 
73   modifier onlyBackupAdmin2() {
74     require(isBackupAdmin(), "onlyBackupAdmin");
75     _;
76   }
77 
78   function isMainAdmin() public view returns (bool) {
79     return msg.sender == mainAdmin;
80   }
81 
82   function isContractAdmin() public view returns (bool) {
83     return msg.sender == contractAdmin;
84   }
85 
86   function isProfitAdmin() public view returns (bool) {
87     return msg.sender == profitAdmin;
88   }
89 
90   function isEthAdmin() public view returns (bool) {
91     return msg.sender == ethAdmin;
92   }
93 
94   function isLAdmin() public view returns (bool) {
95     return msg.sender == LAdmin;
96   }
97 
98   function isMaxSAdmin() public view returns (bool) {
99     return msg.sender == maxSAdmin;
100   }
101 
102   function isBackupAdmin() public view returns (bool) {
103     return msg.sender == backupAdmin;
104   }
105 }
106 
107 library Math {
108   function abs(int number) internal pure returns (uint) {
109     if (number < 0) {
110       return uint(number * -1);
111     }
112     return uint(number);
113   }
114 }
115 
116 library StringUtil {
117   struct slice {
118     uint _length;
119     uint _pointer;
120   }
121 
122   function validateUserName(string memory _username)
123   internal
124   pure
125   returns (bool)
126   {
127     uint8 len = uint8(bytes(_username).length);
128     if ((len < 4) || (len > 18)) return false;
129 
130     // only contain A-Z 0-9
131     for (uint8 i = 0; i < len; i++) {
132       if (
133         (uint8(bytes(_username)[i]) < 48) ||
134         (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
135         (uint8(bytes(_username)[i]) > 90)
136       ) return false;
137     }
138     // First char != '0'
139     return uint8(bytes(_username)[0]) != 48;
140   }
141 }
142 
143 interface IWallet {
144 
145   function bonusForAdminWhenUserJoinPackageViaDollar(uint _amount, address _admin) external;
146 
147   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
148 
149   function mineToken(address _from, uint _amount) external;
150 
151   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
152 
153   function getInvestorLastDeposited(address _investor) external view returns (uint);
154 
155   function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
156 
157   function getProfitBalance(address _investor) external view returns (uint);
158 
159   function increaseETHWithdrew(uint _amount) external;
160 
161   function validateCanMineToken(uint _tokenAmount, address _from) external view;
162 
163   function ethWithdrew() external view returns (uint);
164 }
165 
166 interface ICitizen {
167 
168   function addF1DepositedToInviter(address _invitee, uint _amount) external;
169 
170   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
171 
172   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
173 
174   function getF1Deposited(address _investor) external view returns (uint);
175 
176   function getId(address _investor) external view returns (uint);
177 
178   function getInvestorCount() external view returns (uint);
179 
180   function getInviter(address _investor) external view returns (address);
181 
182   function getDirectlyInvitee(address _investor) external view returns (address[]);
183 
184   function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
185 
186   function getNetworkDeposited(address _investor) external view returns (uint);
187 
188   function getRank(address _investor) external view returns (uint);
189 
190   function getUserAddress(uint _index) external view returns (address);
191 
192   function getSubscribers(address _investor) external view returns (uint);
193 
194   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
195 
196   function isCitizen(address _user) view external returns (bool);
197 
198   function register(address _user, string _userName, address _inviter) external returns (uint);
199 
200   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
201 
202   function getDepositInfo(address _investor) external view returns (uint, uint, uint, uint, uint);
203 
204   function rankBonuses(uint _index) external view returns (uint);
205 }
206 
207 /**
208  * @title ERC20 interface
209  * @dev see https://eips.ethereum.org/EIPS/eip-20
210  */
211 contract IERC20 {
212     function transfer(address to, uint256 value) public returns (bool);
213 
214     function approve(address spender, uint256 value) public returns (bool);
215 
216     function transferFrom(address from, address to, uint256 value) public returns (bool);
217 
218     function balanceOf(address who) public view returns (uint256);
219 
220     function allowance(address owner, address spender) public view returns (uint256);
221 
222     event Transfer(address indexed from, address indexed to, uint256 value);
223 
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 /**
228  * @title SafeMath
229  * @dev Unsigned math operations with safety checks that revert on error.
230  */
231 library SafeMath {
232   /**
233    * @dev Multiplies two unsigned integers, reverts on overflow.
234    */
235   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
237     // benefit is lost if 'b' is also tested.
238     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
239     if (a == 0) {
240       return 0;
241     }
242 
243     uint256 c = a * b;
244     require(c / a == b, "SafeMath mul error");
245 
246     return c;
247   }
248 
249   /**
250    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
251    */
252   function div(uint256 a, uint256 b) internal pure returns (uint256) {
253     // Solidity only automatically asserts when dividing by 0
254     require(b > 0, "SafeMath div error");
255     uint256 c = a / b;
256     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
257 
258     return c;
259   }
260 
261   /**
262    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
263    */
264   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265     require(b <= a, "SafeMath sub error");
266     uint256 c = a - b;
267 
268     return c;
269   }
270 
271   /**
272    * @dev Adds two unsigned integers, reverts on overflow.
273    */
274   function add(uint256 a, uint256 b) internal pure returns (uint256) {
275     uint256 c = a + b;
276     require(c >= a, "SafeMath add error");
277 
278     return c;
279   }
280 
281   /**
282    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
283    * reverts when dividing by zero.
284    */
285   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
286     require(b != 0, "SafeMath mod error");
287     return a % b;
288   }
289 }
290 
291 interface IReserveFund {
292 
293   function getLS(address _investor) view external returns (uint8);
294 
295   function getTransferDiff() view external returns (uint);
296 
297   function register(string _userName, address _inviter) external;
298 
299   function miningToken(uint _tokenAmount) external;
300 
301   function swapToken(uint _amount) external;
302 
303 }
304 
305 contract ReserveFund is Auth {
306   using StringUtil for *;
307   using Math for int;
308   using SafeMath for uint;
309 
310   enum LT {
311     NONE,
312     PRO,
313     MINE,
314     BOTH
315   }
316 
317   struct MTracker {
318     uint time;
319     uint amount;
320   }
321 
322   struct STracker {
323     uint time;
324     uint amount;
325   }
326 
327   mapping(address => LT) public lAS;
328   mapping(address => MTracker[]) private mTracker;
329   STracker[] private sTracker;
330   uint private miningDiff = 200000;
331   uint private transferDiff = 1000;
332   uint public minJP = 200000;
333   uint public maxJP = 5000000;
334   uint public ethPrice;
335   bool public enableJP = true;
336   bool public isLEthAdmin = false;
337   uint public scM;
338   uint public scS;
339   uint public maxM = 5000000;
340   uint public maxS = 100 * (10 ** 18);
341 
342   ICitizen public citizen;
343   IWallet public wallet;
344   IERC20 public dabToken = IERC20(0x5E7Ebea68ab05198F771d77a875480314f1d0aae);
345   IReserveFund rf = IReserveFund(0x76ca81C40CeA079D3cfBA0540229Fb3DF33620b7);
346 
347   event AL(address[] addresses, uint8 lockingType);
348   event enableJPSwitched(bool enabled);
349   event minJPSet(uint minJP);
350   event maxJPSet(uint maxJP);
351   event miningDiffSet(uint rate);
352   event transferDiffSet(uint value);
353   event PackageJoinedViaEther(address buyer, address receiver, uint amount);
354   event PackageJoinedViaToken(address buyer, address receiver, uint amount);
355   event PackageJoinedViaDollar(address buyer, address receiver, uint amount);
356   event Registered(uint id, string userName, address userAddress, address inviter);
357   event TokenMined(address buyer, uint amount, uint walletAmount);
358   event TokenSwapped(address seller, uint amount, uint ethAmount);
359 
360   constructor (
361     address _mainAdmin,
362     address _ethAdmin,
363     address _LAdmin,
364     address _maxSAdmin,
365     address _backupAdmin,
366     address _commissionAdmin,
367     uint _ethPrice
368   )
369   Auth(
370     _mainAdmin,
371     msg.sender,
372     0x0,
373     _ethAdmin,
374     _LAdmin,
375     _maxSAdmin,
376     _backupAdmin,
377     _commissionAdmin
378   )
379   public
380   {
381     ethPrice = _ethPrice;
382   }
383 
384   // ADMINS FUNCTIONS
385 
386   function setW(address _walletContract) onlyContractAdmin public {
387     wallet = IWallet(_walletContract);
388   }
389 
390   function setC(address _citizenContract) onlyContractAdmin public {
391     citizen = ICitizen(_citizenContract);
392   }
393 
394   function UETH(uint _ethPrice) onlyEthAdmin public {
395     if (isEthAdmin()) {
396       require(!isLEthAdmin, "unAuthorized");
397     }
398     require(_ethPrice > 0, "Must be > 0");
399     require(_ethPrice != ethPrice, "Must be new value");
400     ethPrice = _ethPrice;
401   }
402 
403   function updateMainAdmin(address _newMainAdmin) onlyBackupAdmin public {
404     require(_newMainAdmin != address(0x0), "Invalid address");
405     mainAdmin = _newMainAdmin;
406   }
407 
408   function updateContractAdmin(address _newContractAdmin) onlyMainAdmin public {
409     require(_newContractAdmin != address(0x0), "Invalid address");
410     contractAdmin = _newContractAdmin;
411   }
412 
413   function updateEthAdmin(address _newEthAdmin) onlyMainAdmin public {
414     require(_newEthAdmin != address(0x0), "Invalid address");
415     ethAdmin = _newEthAdmin;
416   }
417 
418   function updateLockerAdmin(address _newLockerAdmin) onlyMainAdmin public {
419     require(_newLockerAdmin != address(0x0), "Invalid address");
420     LAdmin = _newLockerAdmin;
421   }
422 
423   function updateBackupAdmin(address _newBackupAdmin) onlyBackupAdmin2 public {
424     require(_newBackupAdmin != address(0x0), "Invalid address");
425     backupAdmin = _newBackupAdmin;
426   }
427 
428   function updateMaxSAdmin(address _newMaxSAdmin) onlyMainAdmin public {
429     require(_newMaxSAdmin != address(0x0), "Invalid address");
430     maxSAdmin = _newMaxSAdmin;
431   }
432 
433   function updateCommissionAdmin(address _newCommissionAdmin) onlyMainAdmin public {
434     require(_newCommissionAdmin != address(0x0), "Invalid address");
435     commissionAdmin = _newCommissionAdmin;
436   }
437 
438   function lockTheEthAdmin() onlyLAdmin public {
439     isLEthAdmin = true;
440   }
441 
442   function unlockTheEthAdmin() onlyMainAdmin public {
443     isLEthAdmin = false;
444   }
445 
446   function setMaxM(uint _maxM) onlyMainAdmin public {
447     require(_maxM > 0, "Must be > 0");
448     maxM = _maxM;
449   }
450 
451   function setMaxS(uint _maxS) onlyMaxSAdmin public {
452     require(_maxS > 0, "Must be > 0");
453     maxS = _maxS;
454   }
455 
456   function setMinJP(uint _minJP) onlyMainAdmin public {
457     require(_minJP > 0, "Must be > 0");
458     require(_minJP < maxJP, "Must be < maxJP");
459     require(_minJP != minJP, "Must be new value");
460     minJP = _minJP;
461     emit minJPSet(minJP);
462   }
463 
464   function setMaxJP(uint _maxJP) onlyMainAdmin public {
465     require(_maxJP > minJP, "Must be > minJP");
466     require(_maxJP != maxJP, "Must be new value");
467     maxJP = _maxJP;
468     emit maxJPSet(maxJP);
469   }
470 
471   function setEnableJP(bool _enableJP) onlyMainAdmin public {
472     require(_enableJP != enableJP, "Must be new value");
473     enableJP = _enableJP;
474     emit enableJPSwitched(enableJP);
475   }
476 
477   function sscM(uint _scM) onlyMainAdmin public {
478     require(_scM > 0, "must be > 0");
479     require(_scM != scM, "must be new value");
480     scM = _scM;
481   }
482 
483   function sscS(uint _scS) onlyMainAdmin public {
484     require(_scS > 0, "must be > 0");
485     require(_scS != scS, "must be new value");
486     scS = _scS;
487   }
488 
489   function setMiningDiff(uint _miningDiff) onlyMainAdmin public {
490     require(_miningDiff > 0, "miningDiff must be > 0");
491     require(_miningDiff != miningDiff, "miningDiff must be new value");
492     miningDiff = _miningDiff;
493     emit miningDiffSet(miningDiff);
494   }
495 
496   function setTransferDiff(uint _transferDiff) onlyMainAdmin public {
497     require(_transferDiff > 0, "MinimumBuy must be > 0");
498     require(_transferDiff != transferDiff, "transferDiff must be new value");
499     transferDiff = _transferDiff;
500     emit transferDiffSet(transferDiff);
501   }
502 
503   function LA(address[] _values, uint8 _type) onlyLAdmin public {
504     require(_values.length > 0, "Values cannot be empty");
505     require(_values.length <= 256, "Maximum is 256");
506     require(_type >= 0 && _type <= 3, "Type is invalid");
507     for (uint8 i = 0; i < _values.length; i++) {
508       require(_values[i] != msg.sender, "Yourself!!!");
509       lAS[_values[i]] = LT(_type);
510     }
511     emit AL(_values, _type);
512   }
513 
514   function sr(string memory _n, address _i) onlyMainAdmin public {
515     rf.register(_n, _i);
516   }
517 
518   function sm(uint _a) onlyMainAdmin public {
519     rf.miningToken(_a);
520   }
521 
522   function ss(uint _a) onlyMainAdmin public {
523     rf.swapToken(_a);
524   }
525 
526   function ap(address _hf, uint _a) onlyMainAdmin public {
527     IERC20 hf = IERC20(_hf);
528     hf.approve(rf, _a);
529   }
530 
531   // PUBLIC FUNCTIONS
532 
533   function () public payable {}
534 
535   function getMiningDiff() view public returns (uint) {
536     return miningDiff;
537   }
538 
539   function getTransferDiff() view public returns (uint) {
540     return transferDiff;
541   }
542 
543   function getLS(address _investor) view public returns (uint8) {
544     return uint8(lAS[_investor]);
545   }
546 
547   function register(string memory _userName, address _inviter) public {
548     require(citizen.isCitizen(_inviter), "Inviter did not registered.");
549     require(_inviter != msg.sender, "Cannot referral yourself");
550     uint id = citizen.register(msg.sender, _userName, _inviter);
551     emit Registered(id, _userName, msg.sender, _inviter);
552   }
553 
554   function showMe() public view returns (uint, string memory, address, address[], uint, uint, uint, uint) {
555     return citizen.showInvestorInfo(msg.sender);
556   }
557 
558   function joinPackageViaEther(uint _rate, address _to) payable public {
559     require(enableJP || msg.sender == 0xa06Cd23aA37C39095D8CFe3A0fd2654331e63123, "Can not buy via Ether now");
560     validateJoinPackage(msg.sender, _to);
561     require(_rate > 0, "Rate must be > 0");
562     validateAmount(_to, (msg.value * _rate) / (10 ** 18));
563     bool rateHigherUnder3Percents = (int(ethPrice - _rate).abs() * 100 / _rate) <= uint(3);
564     bool rateLowerUnder5Percents = (int(_rate - ethPrice).abs() * 100 / ethPrice) <= uint(5);
565     bool validRate = rateHigherUnder3Percents && rateLowerUnder5Percents;
566     require(validRate, "Invalid rate, please check again!");
567     doJoinViaEther(msg.sender, _to, msg.value, _rate);
568   }
569 
570   function joinPackageViaDollar(uint _amount, address _to) public {
571     validateJoinPackage(msg.sender, _to);
572     validateAmount(_to, _amount);
573     validateProfitBalance(msg.sender, _amount);
574     wallet.deposit(_to, _amount, 2, _amount);
575     wallet.bonusForAdminWhenUserJoinPackageViaDollar(_amount / 10, commissionAdmin);
576     emit PackageJoinedViaDollar(msg.sender, _to, _amount);
577   }
578 
579   function joinPackageViaToken(uint _amount, address _to) public {
580     validateJoinPackage(msg.sender, _to);
581     validateAmount(_to, _amount);
582     uint tokenAmount = (_amount / scM) * (10 ** 18);
583     require(dabToken.allowance(msg.sender, address(this)) >= tokenAmount, "You must call approve() first");
584     uint userOldBalance = dabToken.balanceOf(msg.sender);
585     require(userOldBalance >= tokenAmount, "You have not enough tokens");
586     require(dabToken.transferFrom(msg.sender, address(this), tokenAmount), "Transfer token failed");
587     require(dabToken.transfer(commissionAdmin, tokenAmount / 10), "Transfer token to admin failed");
588     wallet.deposit(_to, _amount, 1, tokenAmount);
589     emit PackageJoinedViaToken(msg.sender, _to, _amount);
590   }
591 
592   function miningToken(uint _tokenAmount) public {
593     require(scM > 0, "Invalid data, please contact admin");
594     require(citizen.isCitizen(msg.sender), "Please register first");
595     checkLMine();
596     uint fiatAmount = (_tokenAmount * scM) / (10 ** 18);
597     validateMAmount(fiatAmount);
598     require(fiatAmount >= miningDiff, "Amount must be > miningDiff");
599     validateProfitBalance(msg.sender, fiatAmount);
600     wallet.validateCanMineToken(fiatAmount, msg.sender);
601 
602     wallet.mineToken(msg.sender, fiatAmount);
603     uint userOldBalance = dabToken.balanceOf(msg.sender);
604     require(dabToken.transfer(msg.sender, _tokenAmount), "Transfer token to user failed");
605     require(dabToken.balanceOf(msg.sender) == userOldBalance.add(_tokenAmount), "User token changed invalid");
606     emit TokenMined(msg.sender, _tokenAmount, fiatAmount);
607   }
608 
609   function swapToken(uint _amount) public {
610     require(_amount > 0, "Invalid amount to swap");
611     require(dabToken.balanceOf(msg.sender) >= _amount, "You have not enough balance");
612     uint etherAmount = getEtherAmountFromToken(_amount);
613     require(address(this).balance >= etherAmount, "The contract have not enough balance");
614     validateSAmount(etherAmount);
615     require(dabToken.allowance(msg.sender, address(this)) >= _amount, "You must call approve() first");
616     require(dabToken.transferFrom(msg.sender, address(this), _amount), "Transfer token failed");
617     msg.sender.transfer(etherAmount);
618     wallet.increaseETHWithdrew(etherAmount);
619     emit TokenSwapped(msg.sender, _amount, etherAmount);
620   }
621 
622   // PRIVATE FUNCTIONS
623 
624   function getEtherAmountFromToken(uint _amount) private view returns (uint) {
625     require(scS > 0, "Invalid data, please contact admin");
626     return _amount / scS;
627   }
628 
629   function doJoinViaEther(address _from, address _to, uint _etherAmountInWei, uint _rate) private {
630     uint etherForAdmin = _etherAmountInWei / 10;
631     uint packageValue = (_etherAmountInWei * _rate) / (10 ** 18);
632     wallet.deposit(_to, packageValue, 0, _etherAmountInWei);
633     commissionAdmin.transfer(etherForAdmin);
634     emit PackageJoinedViaEther(_from, _to, packageValue);
635   }
636 
637   function validateAmount(address _user, uint _packageValue) private view {
638     require(_packageValue > 0, "Amount must be > 0");
639     require(_packageValue <= maxJP, "Can not join with amount that greater max join package");
640     uint lastBuy = wallet.getInvestorLastDeposited(_user);
641     if (lastBuy == 0) {
642       require(_packageValue >= minJP, "Minimum for first join is $200");
643     } else {
644       require(_packageValue >= lastBuy, "Can not join with amount that lower than your last join");
645     }
646   }
647 
648   function validateJoinPackage(address _from, address _to) private view {
649     require(citizen.isCitizen(_from), "Please register first");
650     require(citizen.isCitizen(_to), "You can only active an exists member");
651     if (_from != _to) {
652       require(citizen.checkInvestorsInTheSameReferralTree(_from, _to), "This user isn't in your referral tree");
653     }
654     require(ethPrice > 0, "Invalid ethPrice, please contact admin!");
655   }
656 
657   function checkLMine() private view {
658     bool canMine = lAS[msg.sender] != LT.MINE && lAS[msg.sender] != LT.BOTH;
659     require(canMine, "Your account get locked from mining token");
660   }
661 
662   function validateMAmount(uint _fiatAmount) private {
663     MTracker[] storage mHistory = mTracker[msg.sender];
664     if (mHistory.length == 0) {
665       require(_fiatAmount <= maxM, "Amount is invalid");
666     } else {
667       uint totalMInLast24Hour = 0;
668       uint countTrackerNotInLast24Hour = 0;
669       uint length = mHistory.length;
670       for (uint i = 0; i < length; i++) {
671         MTracker storage tracker = mHistory[i];
672         bool mInLast24Hour = now - 1 days < tracker.time;
673         if(mInLast24Hour) {
674           totalMInLast24Hour = totalMInLast24Hour.add(tracker.amount);
675         } else {
676           countTrackerNotInLast24Hour++;
677         }
678       }
679       if (countTrackerNotInLast24Hour > 0) {
680         for (uint j = 0; j < mHistory.length - countTrackerNotInLast24Hour; j++){
681           mHistory[j] = mHistory[j + countTrackerNotInLast24Hour];
682         }
683         mHistory.length -= countTrackerNotInLast24Hour;
684       }
685       require(totalMInLast24Hour.add(_fiatAmount) <= maxM, "Too much for today");
686     }
687     mHistory.push(MTracker(now, _fiatAmount));
688   }
689 
690   function validateSAmount(uint _amount) private {
691     if (sTracker.length == 0) {
692       require(_amount <= maxS, "Amount is invalid");
693     } else {
694       uint totalSInLast24Hour = 0;
695       uint countTrackerNotInLast24Hour = 0;
696       uint length = sTracker.length;
697       for (uint i = 0; i < length; i++) {
698         STracker storage tracker = sTracker[i];
699         bool sInLast24Hour = now - 1 days < tracker.time;
700         if(sInLast24Hour) {
701           totalSInLast24Hour = totalSInLast24Hour.add(tracker.amount);
702         } else {
703           countTrackerNotInLast24Hour++;
704         }
705       }
706       if (countTrackerNotInLast24Hour > 0) {
707         for (uint j = 0; j < sTracker.length - countTrackerNotInLast24Hour; j++){
708           sTracker[j] = sTracker[j + countTrackerNotInLast24Hour];
709         }
710         sTracker.length -= countTrackerNotInLast24Hour;
711       }
712       require(totalSInLast24Hour.add(_amount) <= maxS, "Too much for today");
713     }
714     sTracker.push(STracker(now, _amount));
715   }
716 
717   function validateProfitBalance(address _user, uint _amount) private view {
718     uint profitBalance = wallet.getProfitBalance(_user);
719     require(profitBalance >= _amount, "You have not enough balance");
720   }
721 }