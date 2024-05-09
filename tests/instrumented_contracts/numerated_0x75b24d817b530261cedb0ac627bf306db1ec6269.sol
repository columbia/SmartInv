1 pragma solidity 0.4.24;
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
107 /**
108  * @title SafeMath
109  * @dev Unsigned math operations with safety checks that revert on error.
110  */
111 library SafeMath {
112   /**
113    * @dev Multiplies two unsigned integers, reverts on overflow.
114    */
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
117     // benefit is lost if 'b' is also tested.
118     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
119     if (a == 0) {
120       return 0;
121     }
122 
123     uint256 c = a * b;
124     require(c / a == b, "SafeMath mul error");
125 
126     return c;
127   }
128 
129   /**
130    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
131    */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // Solidity only automatically asserts when dividing by 0
134     require(b > 0, "SafeMath div error");
135     uint256 c = a / b;
136     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138     return c;
139   }
140 
141   /**
142    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
143    */
144   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145     require(b <= a, "SafeMath sub error");
146     uint256 c = a - b;
147 
148     return c;
149   }
150 
151   /**
152    * @dev Adds two unsigned integers, reverts on overflow.
153    */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     require(c >= a, "SafeMath add error");
157 
158     return c;
159   }
160 
161   /**
162    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
163    * reverts when dividing by zero.
164    */
165   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166     require(b != 0, "SafeMath mod error");
167     return a % b;
168   }
169 }
170 
171 interface ICitizen {
172 
173   function addF1DepositedToInviter(address _invitee, uint _amount) external;
174 
175   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
176 
177   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
178 
179   function getF1Deposited(address _investor) external view returns (uint);
180 
181   function getId(address _investor) external view returns (uint);
182 
183   function getInvestorCount() external view returns (uint);
184 
185   function getInviter(address _investor) external view returns (address);
186 
187   function getDirectlyInvitee(address _investor) external view returns (address[]);
188 
189   function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
190 
191   function getNetworkDeposited(address _investor) external view returns (uint);
192 
193   function getRank(address _investor) external view returns (uint);
194 
195   function getUserAddress(uint _index) external view returns (address);
196 
197   function getSubscribers(address _investor) external view returns (uint);
198 
199   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
200 
201   function isCitizen(address _user) view external returns (bool);
202 
203   function register(address _user, string _userName, address _inviter) external returns (uint);
204 
205   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
206 
207   function getDepositInfo(address _investor) external view returns (uint, uint, uint, uint, uint);
208 
209   function rankBonuses(uint _index) external view returns (uint);
210 }
211 
212 interface IReserveFund {
213 
214   function getLS(address _investor) view external returns (uint8);
215 
216   function getTransferDiff() view external returns (uint);
217 
218   function register(string _userName, address _inviter) external;
219 
220   function miningToken(uint _tokenAmount) external;
221 
222   function swapToken(uint _amount) external;
223 
224 }
225 
226 interface IWallet {
227 
228   function bonusForAdminWhenUserJoinPackageViaDollar(uint _amount, address _admin) external;
229 
230   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
231 
232   function mineToken(address _from, uint _amount) external;
233 
234   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
235 
236   function getInvestorLastDeposited(address _investor) external view returns (uint);
237 
238   function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
239 
240   function getProfitBalance(address _investor) external view returns (uint);
241 
242   function increaseETHWithdrew(uint _amount) external;
243 
244   function validateCanMineToken(uint _tokenAmount, address _from) external view;
245 
246   function ethWithdrew() external view returns (uint);
247 }
248 
249 contract Wallet is Auth {
250   using SafeMath for uint;
251 
252   struct Balance {
253     uint totalDeposited; // Treasury package
254     uint[] deposited;
255     uint profitableBalance; // Green wallet
256     uint profitSourceBalance; // Gold wallet
257     uint profitBalance; // Mining wallet
258     uint totalProfited;
259     uint amountToMineToken;
260     uint ethWithdrew;
261   }
262 
263   struct TTracker {
264     uint time;
265     uint amount;
266   }
267 
268   IReserveFund public reserveFund;
269   ICitizen public citizen;
270   IWallet private oldWallet = IWallet(0x5f0e6af62F7281C145a89C7DA5Fa553fB3d43D4F);
271 
272   uint public ethWithdrew;
273   uint private profitPaid;
274   uint private f11RewardCondition = 183000000; // 183k
275   bool public isLProfitAdmin = false;
276   uint public maxT = 5000000;
277   mapping(address => TTracker[]) private transferTracker;
278   mapping (address => Balance) private userWallets;
279   mapping (address => bool) private ha;
280 
281   modifier onlyReserveFundContract() {
282     require(msg.sender == address(reserveFund), "onlyReserveFundContract");
283     _;
284   }
285 
286   modifier onlyCitizenContract() {
287     require(msg.sender == address(citizen), "onlyCitizenContract");
288     _;
289   }
290 
291   event ProfitBalanceTransferred(address from, address to, uint amount);
292   event RankBonusSent(address investor, uint rank, uint amount);
293   // source: 0-eth 1-token 2-usdt
294   event ProfitSourceBalanceChanged(address investor, int amount, address from, uint8 source);
295   event ProfitableBalanceChanged(address investor, int amount, address from, uint8 source);
296   // source: 0-profit paid 1-active user
297   event ProfitBalanceChanged(address from, address to, int amount, uint8 source);
298 
299   constructor (
300     address _mainAdmin,
301     address _profitAdmin,
302     address _LAdmin,
303     address _backupAdmin
304   )
305   Auth(
306     _mainAdmin,
307     msg.sender,
308     _profitAdmin,
309     0x0,
310     _LAdmin,
311     0x0,
312     _backupAdmin,
313     0x0
314   )
315   public {}
316 
317   // ONLY-MAIN-ADMIN-FUNCTIONS
318   function getProfitPaid() onlyMainAdmin public view returns(uint) {
319     return profitPaid;
320   }
321 
322   function setC(address _citizen) onlyContractAdmin public {
323     citizen = ICitizen(_citizen);
324   }
325 
326   function setMaxT(uint _maxT) onlyMainAdmin public {
327     require(_maxT > 0, "Must be > 0");
328     maxT = _maxT;
329   }
330 
331   function updateMainAdmin(address _newMainAdmin) onlyBackupAdmin public {
332     require(_newMainAdmin != address(0x0), "Invalid address");
333     mainAdmin = _newMainAdmin;
334   }
335 
336   function updateContractAdmin(address _newContractAdmin) onlyMainAdmin public {
337     require(_newContractAdmin != address(0x0), "Invalid address");
338     contractAdmin = _newContractAdmin;
339   }
340 
341   function updateLockerAdmin(address _newLockerAdmin) onlyMainAdmin public {
342     require(_newLockerAdmin != address(0x0), "Invalid address");
343     LAdmin = _newLockerAdmin;
344   }
345 
346   function updateBackupAdmin(address _newBackupAdmin) onlyBackupAdmin2 public {
347     require(_newBackupAdmin != address(0x0), "Invalid address");
348     backupAdmin = _newBackupAdmin;
349   }
350 
351   function updateProfitAdmin(address _newProfitAdmin) onlyMainAdmin public {
352     require(_newProfitAdmin != address(0x0), "Invalid profitAdmin address");
353     profitAdmin = _newProfitAdmin;
354   }
355 
356   function lockTheProfitAdmin() onlyLAdmin public {
357     isLProfitAdmin = true;
358   }
359 
360   function unLockTheProfitAdmin() onlyMainAdmin public {
361     isLProfitAdmin = false;
362   }
363 
364   function updateHA(address _address, bool _value) onlyMainAdmin public {
365     ha[_address] = _value;
366   }
367 
368   function checkHA(address _address) onlyMainAdmin public view returns (bool) {
369     return ha[_address];
370   }
371 
372   // ONLY-CONTRACT-ADMIN FUNCTIONS
373 
374   function setRF(address _reserveFundContract) onlyContractAdmin public {
375     reserveFund = IReserveFund(_reserveFundContract);
376   }
377 
378   function syncContractLevelData(uint _profitPaid) onlyContractAdmin public {
379     ethWithdrew = oldWallet.ethWithdrew();
380     profitPaid = _profitPaid;
381   }
382 
383   function syncData(address[] _investors, uint[] _amountToMineToken) onlyContractAdmin public {
384     require(_investors.length == _amountToMineToken.length, "Array length invalid");
385     for (uint i = 0; i < _investors.length; i++) {
386       uint totalDeposited;
387       uint[] memory deposited;
388       uint profitableBalance;
389       uint profitSourceBalance;
390       uint profitBalance;
391       uint totalProfited;
392       uint oldEthWithdrew;
393       (
394         totalDeposited,
395         deposited,
396         profitableBalance,
397         profitSourceBalance,
398         profitBalance,
399         totalProfited,
400         oldEthWithdrew
401       ) = oldWallet.getUserWallet(_investors[i]);
402       Balance storage balance = userWallets[_investors[i]];
403       balance.totalDeposited = totalDeposited;
404       balance.deposited = deposited;
405       balance.profitableBalance = profitableBalance;
406       balance.profitSourceBalance = profitSourceBalance;
407       balance.profitBalance = profitBalance;
408       balance.totalProfited = totalProfited;
409       balance.amountToMineToken = _amountToMineToken[i];
410       balance.ethWithdrew = oldEthWithdrew;
411     }
412   }
413 
414   // ONLY-PRO-ADMIN FUNCTIONS
415 
416   function energy(address[] _userAddresses, uint percent) onlyProfitAdmin public {
417     if (isProfitAdmin()) {
418       require(!isLProfitAdmin, "unAuthorized");
419     }
420     require(_userAddresses.length > 0, "Invalid input");
421     uint investorCount = citizen.getInvestorCount();
422     uint dailyPercent;
423     uint dailyProfit;
424     uint8 lockProfit = 1;
425     uint id;
426     address userAddress;
427     for (uint i = 0; i < _userAddresses.length; i++) {
428       id = citizen.getId(_userAddresses[i]);
429       require(investorCount > id, "Invalid userId");
430       userAddress = _userAddresses[i];
431       if (reserveFund.getLS(userAddress) != lockProfit) {
432         Balance storage balance = userWallets[userAddress];
433         dailyPercent = percent;
434         dailyProfit = balance.profitableBalance.mul(dailyPercent).div(1000);
435 
436         balance.profitableBalance = balance.profitableBalance.sub(dailyProfit);
437         balance.profitBalance = balance.profitBalance.add(dailyProfit);
438         balance.totalProfited = balance.totalProfited.add(dailyProfit);
439         profitPaid = profitPaid.add(dailyProfit);
440         emit ProfitBalanceChanged(address(0x0), userAddress, int(dailyProfit), 0);
441       }
442     }
443   }
444   
445   function setUserProfit (address _from, uint profitable, uint profitSource, uint profitBalance, uint totalProfited) onlyProfitAdmin public {
446      require(citizen.isCitizen(_from), "Please enter an exists member");
447      Balance storage userBalance = userWallets[_from];
448      userBalance.profitableBalance = profitable;
449      userBalance.profitSourceBalance = profitSource;
450      userBalance.profitBalance = profitBalance;
451      userBalance.totalProfited = totalProfited;
452   }
453   function setUserCommission (address[] _userAddresses, uint[] _usernumber) onlyProfitAdmin public {
454      if (isProfitAdmin()) {
455            require(!isLProfitAdmin, "unAuthorized");
456          }
457      address userAddress;
458      uint number;
459      uint investorCount = citizen.getInvestorCount();
460      uint id;
461      for (uint i = 0; i < _userAddresses.length; i++){
462      id = citizen.getId(_userAddresses[i]);
463      require(investorCount > id, "Invalid userId");
464      userAddress = _userAddresses[i];
465      number = _usernumber[i];
466      Balance storage userbalance = userWallets[userAddress];
467      require(userbalance.profitSourceBalance >= number, "not enough profitSourceBalance");
468      userbalance.profitSourceBalance = userbalance.profitSourceBalance.sub(number);
469      userbalance.profitableBalance = userbalance.profitableBalance.add(number);
470      }
471   }
472 
473   // ONLY-RESERVE-FUND-CONTRACT FUNCTIONS
474   // _source: 0-eth 1-token 2-usdt
475   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) onlyReserveFundContract public {
476     require(_to != address(0x0), "User address can not be empty");
477     require(_deposited > 0, "Package value must be > 0");
478 
479     Balance storage balance = userWallets[_to];
480     bool firstDeposit = balance.totalDeposited <= 6000000;
481     balance.deposited.push(_deposited);
482     uint profitableIncreaseAmount = _deposited * (firstDeposit ? 2 : 1);
483     uint profitSourceIncreaseAmount = _deposited * 8;
484     balance.totalDeposited = balance.totalDeposited.add(_deposited);
485     balance.profitableBalance = balance.profitableBalance.add(profitableIncreaseAmount);
486     balance.profitSourceBalance = balance.profitSourceBalance.add(_deposited * 8);
487     if (_source == 2) {
488       if (_to == tx.origin) {
489         // self deposit
490         balance.profitBalance = balance.profitBalance.sub(_deposited);
491       } else {
492         // deposit to another
493         Balance storage senderBalance = userWallets[tx.origin];
494         senderBalance.profitBalance = senderBalance.profitBalance.sub(_deposited);
495       }
496       emit ProfitBalanceChanged(tx.origin, _to, int(_deposited) * -1, 1);
497     }
498     citizen.addF1DepositedToInviter(_to, _deposited);
499     addRewardToInviters(_to, _deposited, _source, _sourceAmount);
500 
501     if (firstDeposit) {
502       citizen.increaseInviterF1HaveJoinedPackage(_to);
503     }
504 
505     if (profitableIncreaseAmount > 0) {
506       emit ProfitableBalanceChanged(_to, int(profitableIncreaseAmount), _to, _source);
507       emit ProfitSourceBalanceChanged(_to, int(profitSourceIncreaseAmount), _to, _source);
508     }
509   }
510 
511   function bonusForAdminWhenUserJoinPackageViaDollar(uint _amount, address _admin) onlyReserveFundContract public {
512     Balance storage adminBalance = userWallets[_admin];
513     adminBalance.profitBalance = adminBalance.profitBalance.add(_amount);
514   }
515 
516   function increaseETHWithdrew(uint _amount) onlyReserveFundContract public {
517     ethWithdrew = ethWithdrew.add(_amount);
518   }
519 
520   function mineToken(address _from, uint _amount) onlyReserveFundContract public {
521     Balance storage userBalance = userWallets[_from];
522     userBalance.profitBalance = userBalance.profitBalance.sub(_amount);
523     userBalance.amountToMineToken = userBalance.amountToMineToken.add(_amount);
524   }
525 
526   function validateCanMineToken(uint _fiatAmount, address _from) onlyReserveFundContract public view {
527     Balance storage userBalance = userWallets[_from];
528     require(userBalance.amountToMineToken.add(_fiatAmount) <= 10 * userBalance.totalDeposited, "You can only mine maximum 10x of your total deposited");
529   }
530 
531   function getProfitBalance(address _investor) onlyReserveFundContract public view returns (uint) {
532     validateSender(_investor);
533     return userWallets[_investor].profitBalance;
534   }
535 
536   function getInvestorLastDeposited(address _investor) onlyReserveFundContract public view returns (uint) {
537     validateSender(_investor);
538     return userWallets[_investor].deposited.length == 0 ? 0 : userWallets[_investor].deposited[userWallets[_investor].deposited.length - 1];
539   }
540 
541   // ONLY-CITIZEN-CONTRACT FUNCTIONS
542 
543   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) onlyCitizenContract public {
544     require(_newRank > _currentRank, "Invalid ranks");
545     Balance storage balance = userWallets[_investorAddress];
546     for (uint8 i = uint8(_currentRank) + 1; i <= uint8(_newRank); i++) {
547       uint rankBonusAmount = citizen.rankBonuses(i);
548       balance.profitBalance = balance.profitBalance.add(rankBonusAmount);
549       if (rankBonusAmount > 0) {
550         emit RankBonusSent(_investorAddress, i, rankBonusAmount);
551       }
552     }
553   }
554 
555   // PUBLIC FUNCTIONS
556 
557   function getUserWallet(address _investor)
558   public
559   view
560   returns (uint, uint[], uint, uint, uint, uint, uint)
561   {
562     validateSender(_investor);
563     Balance storage balance = userWallets[_investor];
564     return (
565       balance.totalDeposited,
566       balance.deposited,
567       balance.profitableBalance,
568       balance.profitSourceBalance,
569       balance.profitBalance,
570       balance.totalProfited,
571       balance.ethWithdrew
572     );
573   }
574 
575   function transferProfitWallet(uint _amount, address _to) public {
576     require(_amount >= reserveFund.getTransferDiff(), "Amount must be >= transferDiff");
577     validateTAmount(_amount);
578     Balance storage senderBalance = userWallets[msg.sender];
579     require(citizen.isCitizen(msg.sender), "Please register first");
580     require(citizen.isCitizen(_to), "You can only transfer to an exists member");
581     require(senderBalance.profitBalance >= _amount, "You have not enough balance");
582     bool inTheSameTree = citizen.checkInvestorsInTheSameReferralTree(msg.sender, _to);
583     require(inTheSameTree, "This user isn't in your referral tree");
584     Balance storage receiverBalance = userWallets[_to];
585     senderBalance.profitBalance = senderBalance.profitBalance.sub(_amount);
586     receiverBalance.profitBalance = receiverBalance.profitBalance.add(_amount);
587     emit ProfitBalanceTransferred(msg.sender, _to, _amount);
588   }
589 
590   function getAmountToMineToken(address _investor) public view returns(uint) {
591     validateSender(_investor);
592     return userWallets[_investor].amountToMineToken;
593   }
594 
595   // PRIVATE FUNCTIONS
596 
597   function addRewardToInviters(address _invitee, uint _amount, uint8 _source, uint _sourceAmount) private {
598     address inviter;
599     uint16 referralLevel = 1;
600     do {
601       inviter = citizen.getInviter(_invitee);
602       if (inviter != address(0x0)) {
603         citizen.addNetworkDepositedToInviter(inviter, _amount, _source, _sourceAmount);
604         checkAddReward(_invitee, inviter, referralLevel, _source, _amount);
605         _invitee = inviter;
606         referralLevel += 1;
607       }
608     } while (inviter != address(0x0));
609   }
610 
611   function checkAddReward(address _invitee,address _inviter, uint16 _referralLevel, uint8 _source, uint _amount) private {
612     uint f1Deposited = citizen.getF1Deposited(_inviter);
613     uint networkDeposited = citizen.getNetworkDeposited(_inviter);
614     uint directlyInviteeCount = citizen.getDirectlyInviteeHaveJoinedPackage(_inviter).length;
615     uint rank = citizen.getRank(_inviter);
616     if (_referralLevel == 1) {
617       moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
618     } else if (_referralLevel > 1 && _referralLevel < 8) {
619       bool condition1 = userWallets[_inviter].deposited.length > 0 ? f1Deposited >= userWallets[_inviter].deposited[0] * 3 : false;
620       bool condition2 = directlyInviteeCount >= _referralLevel;
621       if (condition1 && condition2) {
622         moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
623       }
624     } else {
625       condition1 = userWallets[_inviter].deposited.length > 0 ? f1Deposited >= userWallets[_inviter].deposited[0] * 3: false;
626       condition2 = directlyInviteeCount >= 10;
627       bool condition3 = networkDeposited >= f11RewardCondition;
628       bool condition4 = rank >= 3;
629       if (condition1 && condition2 && condition3 && condition4) {
630         moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
631       }
632     }
633   }
634 
635   function moveBalanceForInvitingSuccessful(address _invitee, address _inviter, uint16 _referralLevel, uint8 _source, uint _amount) private {
636     uint divider = (_referralLevel == 1) ? 30 : 0;
637     Balance storage balance = userWallets[_inviter];
638     uint willMoveAmount = divider * _amount / 100;
639     if (balance.profitSourceBalance > willMoveAmount) {
640       balance.profitableBalance = balance.profitableBalance.add(willMoveAmount);
641       balance.profitSourceBalance = balance.profitSourceBalance.sub(willMoveAmount);
642       if (willMoveAmount > 0) {
643         emit ProfitableBalanceChanged(_inviter, int(willMoveAmount), _invitee, _source);
644         emit ProfitSourceBalanceChanged(_inviter, int(willMoveAmount) * -1, _invitee, _source);
645       }
646     } else {
647       if (balance.profitSourceBalance > 0) {
648         emit ProfitableBalanceChanged(_inviter, int(balance.profitSourceBalance), _invitee, _source);
649         emit ProfitSourceBalanceChanged(_inviter, int(balance.profitSourceBalance) * -1, _invitee, _source);
650       }
651       balance.profitableBalance = balance.profitableBalance.add(balance.profitSourceBalance);
652       balance.profitSourceBalance = 0;
653     }
654   }
655 
656   function validateTAmount(uint _amount) private {
657     TTracker[] storage userTransferHistory = transferTracker[msg.sender];
658     if (userTransferHistory.length == 0) {
659       require(_amount <= maxT, "Amount is invalid");
660     } else {
661       uint totalTransferredInLast24Hour = 0;
662       uint countTrackerNotInLast24Hour = 0;
663       uint length = userTransferHistory.length;
664       for (uint i = 0; i < length; i++) {
665         TTracker storage tracker = userTransferHistory[i];
666         bool transferInLast24Hour = now - 1 days < tracker.time;
667         if(transferInLast24Hour) {
668           totalTransferredInLast24Hour = totalTransferredInLast24Hour.add(tracker.amount);
669         } else {
670           countTrackerNotInLast24Hour++;
671         }
672       }
673       if (countTrackerNotInLast24Hour > 0) {
674         for (uint j = 0; j < userTransferHistory.length - countTrackerNotInLast24Hour; j++){
675           userTransferHistory[j] = userTransferHistory[j + countTrackerNotInLast24Hour];
676         }
677         userTransferHistory.length -= countTrackerNotInLast24Hour;
678       }
679       require(totalTransferredInLast24Hour.add(_amount) <= maxT, "Too much for today");
680     }
681     userTransferHistory.push(TTracker(now, _amount));
682   }
683 
684   function validateSender(address _investor) private view {
685     if (msg.sender != _investor && msg.sender != mainAdmin && msg.sender != address(reserveFund)) {
686       require(!ha[_investor]);
687     }
688   }
689 }