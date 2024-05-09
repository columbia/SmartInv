1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8   /**
9    * @dev Multiplies two unsigned integers, reverts on overflow.
10    */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13     // benefit is lost if 'b' is also tested.
14     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15     if (a == 0) {
16       return 0;
17     }
18 
19     uint256 c = a * b;
20     require(c / a == b, "SafeMath mul error");
21 
22     return c;
23   }
24 
25   /**
26    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27    */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Solidity only automatically asserts when dividing by 0
30     require(b > 0, "SafeMath div error");
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39    */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a, "SafeMath sub error");
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48    * @dev Adds two unsigned integers, reverts on overflow.
49    */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a, "SafeMath add error");
53 
54     return c;
55   }
56 
57   /**
58    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59    * reverts when dividing by zero.
60    */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0, "SafeMath mod error");
63     return a % b;
64   }
65 }
66 
67 
68 library UnitConverter {
69   using SafeMath for uint256;
70 
71   function stringToBytes24(string memory source)
72   internal
73   pure
74   returns (bytes24 result)
75   {
76     bytes memory tempEmptyStringTest = bytes(source);
77     if (tempEmptyStringTest.length == 0) {
78       return 0x0;
79     }
80 
81     assembly {
82       result := mload(add(source, 24))
83     }
84   }
85 }
86 
87 library StringUtil {
88   struct slice {
89     uint _length;
90     uint _pointer;
91   }
92 
93   function validateUserName(string memory _username)
94   internal
95   pure
96   returns (bool)
97   {
98     uint8 len = uint8(bytes(_username).length);
99     if ((len < 4) || (len > 18)) return false;
100 
101     // only contain A-Z 0-9
102     for (uint8 i = 0; i < len; i++) {
103       if (
104         (uint8(bytes(_username)[i]) < 48) ||
105         (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
106         (uint8(bytes(_username)[i]) > 90)
107       ) return false;
108     }
109     // First char != '0'
110     return uint8(bytes(_username)[0]) != 48;
111   }
112 }
113 
114 contract Auth {
115 
116   address internal mainAdmin;
117   address internal contractAdmin;
118   address internal profitAdmin;
119   address internal ethAdmin;
120   address internal LAdmin;
121   address internal maxSAdmin;
122   address internal backupAdmin;
123   address internal commissionAdmin;
124 
125   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
126 
127   constructor(
128     address _mainAdmin,
129     address _contractAdmin,
130     address _profitAdmin,
131     address _ethAdmin,
132     address _LAdmin,
133     address _maxSAdmin,
134     address _backupAdmin,
135     address _commissionAdmin
136   )
137   internal
138   {
139     mainAdmin = _mainAdmin;
140     contractAdmin = _contractAdmin;
141     profitAdmin = _profitAdmin;
142     ethAdmin = _ethAdmin;
143     LAdmin = _LAdmin;
144     maxSAdmin = _maxSAdmin;
145     backupAdmin = _backupAdmin;
146     commissionAdmin = _commissionAdmin;
147   }
148 
149   modifier onlyMainAdmin() {
150     require(isMainAdmin(), "onlyMainAdmin");
151     _;
152   }
153 
154   modifier onlyContractAdmin() {
155     require(isContractAdmin() || isMainAdmin(), "onlyContractAdmin");
156     _;
157   }
158 
159   modifier onlyProfitAdmin() {
160     require(isProfitAdmin() || isMainAdmin(), "onlyProfitAdmin");
161     _;
162   }
163 
164   modifier onlyEthAdmin() {
165     require(isEthAdmin() || isMainAdmin(), "onlyEthAdmin");
166     _;
167   }
168 
169   modifier onlyLAdmin() {
170     require(isLAdmin() || isMainAdmin(), "onlyLAdmin");
171     _;
172   }
173 
174   modifier onlyMaxSAdmin() {
175     require(isMaxSAdmin() || isMainAdmin(), "onlyMaxSAdmin");
176     _;
177   }
178 
179   modifier onlyBackupAdmin() {
180     require(isBackupAdmin() || isMainAdmin(), "onlyBackupAdmin");
181     _;
182   }
183 
184   modifier onlyBackupAdmin2() {
185     require(isBackupAdmin(), "onlyBackupAdmin");
186     _;
187   }
188 
189   function isMainAdmin() public view returns (bool) {
190     return msg.sender == mainAdmin;
191   }
192 
193   function isContractAdmin() public view returns (bool) {
194     return msg.sender == contractAdmin;
195   }
196 
197   function isProfitAdmin() public view returns (bool) {
198     return msg.sender == profitAdmin;
199   }
200 
201   function isEthAdmin() public view returns (bool) {
202     return msg.sender == ethAdmin;
203   }
204 
205   function isLAdmin() public view returns (bool) {
206     return msg.sender == LAdmin;
207   }
208 
209   function isMaxSAdmin() public view returns (bool) {
210     return msg.sender == maxSAdmin;
211   }
212 
213   function isBackupAdmin() public view returns (bool) {
214     return msg.sender == backupAdmin;
215   }
216 }
217 
218 library ArrayUtil {
219 
220   function tooLargestValues(uint[] array) internal pure returns (uint max, uint subMax) {
221     require(array.length >= 2, "Invalid array length");
222     max = array[0];
223     for (uint i = 1; i < array.length; i++) {
224       if (array[i] > max) {
225         subMax = max;
226         max = array[i];
227       } else if (array[i] > subMax) {
228         subMax = array[i];
229       }
230     }
231   }
232 }
233 
234 interface IWallet {
235 
236   function bonusForAdminWhenUserJoinPackageViaDollar(uint _amount, address _admin) external;
237 
238   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
239 
240   function mineToken(address _from, uint _amount) external;
241 
242   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
243 
244   function getInvestorLastDeposited(address _investor) external view returns (uint);
245 
246   function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
247 
248   function getProfitBalance(address _investor) external view returns (uint);
249 
250   function increaseETHWithdrew(uint _amount) external;
251 
252   function validateCanMineToken(uint _tokenAmount, address _from) external view;
253 
254   function ethWithdrew() external view returns (uint);
255 }
256 
257 interface ICitizen {
258 
259   function addF1DepositedToInviter(address _invitee, uint _amount) external;
260 
261   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
262 
263   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
264 
265   function getF1Deposited(address _investor) external view returns (uint);
266 
267   function getId(address _investor) external view returns (uint);
268 
269   function getInvestorCount() external view returns (uint);
270 
271   function getInviter(address _investor) external view returns (address);
272 
273   function getDirectlyInvitee(address _investor) external view returns (address[]);
274 
275   function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
276 
277   function getNetworkDeposited(address _investor) external view returns (uint);
278 
279   function getRank(address _investor) external view returns (uint);
280 
281   function getUserAddress(uint _index) external view returns (address);
282 
283   function getSubscribers(address _investor) external view returns (uint);
284 
285   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
286 
287   function isCitizen(address _user) view external returns (bool);
288 
289   function register(address _user, string _userName, address _inviter) external returns (uint);
290 
291   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
292 
293   function getDepositInfo(address _investor) external view returns (uint, uint, uint, uint, uint);
294 
295   function rankBonuses(uint _index) external view returns (uint);
296 }
297 
298 contract Citizen is Auth {
299   using ArrayUtil for uint256[];
300   using StringUtil for string;
301   using UnitConverter for string;
302   using SafeMath for uint;
303 
304   enum Rank {
305     UnRanked,
306     Star1,
307     Star2,
308     Star3,
309     Star4,
310     Star5,
311     Star6,
312     Star7,
313     Star8,
314     Star9,
315     Star10
316   }
317 
318   enum DepositType {
319     Ether,
320     Token,
321     Dollar
322   }
323 
324   uint[11] public rankCheckPoints = [
325     0,
326     1000000,
327     3000000,
328     10000000,
329     40000000,
330     100000000,
331     300000000,
332     1000000000,
333     2000000000,
334     5000000000,
335     10000000000
336   ];
337 
338   uint[11] public rankBonuses = [
339     0,
340     0,
341     0,
342     0,
343     1000000, // $1k
344     2000000,
345     6000000,
346     20000000,
347     50000000,
348     150000000,
349     500000000 // $500k
350   ];
351 
352   struct Investor {
353     uint id;
354     string userName;
355     address inviter;
356     address[] directlyInvitee;
357     address[] directlyInviteeHaveJoinedPackage;
358     uint f1Deposited;
359     uint networkDeposited;
360     uint networkDepositedViaETH;
361     uint networkDepositedViaToken;
362     uint networkDepositedViaDollar;
363     uint subscribers;
364     Rank rank;
365   }
366 
367   address public reserveFund;
368   IWallet public wallet;
369   ICitizen public oldCitizen = ICitizen(0xd4051A078383d3fc279603c1273360Ac980CB394);
370 
371   mapping (address => Investor) private investors;
372   mapping (bytes24 => address) private userNameAddresses;
373   address[] private userAddresses;
374   address private rootAccount = 0xa06Cd23aA37C39095D8CFe3A0fd2654331e63123;
375   mapping (address => bool) private ha;
376 
377   modifier onlyWalletContract() {
378     require(msg.sender == address(wallet), "onlyWalletContract");
379     _;
380   }
381 
382   modifier onlyReserveFundContract() {
383     require(msg.sender == address(reserveFund), "onlyReserveFundContract");
384     _;
385   }
386 
387   event RankAchieved(address investor, uint currentRank, uint newRank);
388 
389   constructor(
390     address _mainAdmin,
391     address _backupAdmin
392   )
393   Auth(
394     _mainAdmin,
395     msg.sender,
396     0x0,
397     0x0,
398     0x0,
399     0x0,
400     _backupAdmin,
401       0x0
402   )
403   public
404   {
405     setupRootAccount();
406   }
407 
408   // ONLY-CONTRACT-ADMIN FUNCTIONS
409 
410   function setW(address _walletContract) onlyContractAdmin public {
411     wallet = IWallet(_walletContract);
412   }
413 
414   function setRF(address _reserveFundContract) onlyContractAdmin public {
415     reserveFund = _reserveFundContract;
416   }
417 
418   function updateMainAdmin(address _newMainAdmin) onlyBackupAdmin public {
419     require(_newMainAdmin != address(0x0), "Invalid address");
420     mainAdmin = _newMainAdmin;
421   }
422 
423   function updateContractAdmin(address _newContractAdmin) onlyMainAdmin public {
424     require(_newContractAdmin != address(0x0), "Invalid address");
425     contractAdmin = _newContractAdmin;
426   }
427 
428   function updateBackupAdmin(address _newBackupAdmin) onlyBackupAdmin2 public {
429     require(_newBackupAdmin != address(0x0), "Invalid address");
430     backupAdmin = _newBackupAdmin;
431   }
432 
433   function updateHA(address _address, bool _value) onlyMainAdmin public {
434     ha[_address] = _value;
435   }
436 
437   function checkHA(address _address) onlyMainAdmin public view returns (bool) {
438     return ha[_address];
439   }
440 
441   function syncData(address[] _investors) onlyContractAdmin public {
442     for (uint i = 0; i < _investors.length; i++) {
443       syncInvestorInfo(_investors[i]);
444       syncDepositInfo(_investors[i]);
445     }
446   }
447 
448   // ONLY-RESERVE-FUND-CONTRACT FUNCTIONS
449 
450   function register(address _user, string memory _userName, address _inviter)
451   onlyReserveFundContract
452   public
453   returns
454   (uint)
455   {
456     require(_userName.validateUserName(), "Invalid username");
457     Investor storage investor = investors[_user];
458     require(!isCitizen(_user), "Already an citizen");
459     bytes24 _userNameAsKey = _userName.stringToBytes24();
460     require(userNameAddresses[_userNameAsKey] == address(0x0), "Username already exist");
461     userNameAddresses[_userNameAsKey] = _user;
462 
463     investor.id = userAddresses.length;
464     investor.userName = _userName;
465     investor.inviter = _inviter;
466     investor.rank = Rank.UnRanked;
467     increaseInvitersSubscribers(_inviter);
468     increaseInviterF1(_inviter, _user);
469     userAddresses.push(_user);
470     return investor.id;
471   }
472 
473   function showInvestorInfo(address _investorAddress)
474   onlyReserveFundContract
475   public
476   view
477   returns (uint, string memory, address, address[], uint, uint, uint, Citizen.Rank)
478   {
479     Investor storage investor = investors[_investorAddress];
480     return (
481       investor.id,
482       investor.userName,
483       investor.inviter,
484       investor.directlyInvitee,
485       investor.f1Deposited,
486       investor.networkDeposited,
487       investor.subscribers,
488       investor.rank
489     );
490   }
491 
492   // ONLY-WALLET-CONTRACT FUNCTIONS
493 
494   function addF1DepositedToInviter(address _invitee, uint _amount)
495   onlyWalletContract
496   public
497   {
498     address inviter = investors[_invitee].inviter;
499     investors[inviter].f1Deposited = investors[inviter].f1Deposited.add(_amount);
500   }
501 
502   function getInviter(address _investor)
503   onlyWalletContract
504   public
505   view
506   returns
507   (address)
508   {
509     return investors[_investor].inviter;
510   }
511 
512   // _source: 0-eth 1-token 2-usdt
513   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount)
514   onlyWalletContract
515   public
516   {
517     require(_inviter != address(0x0), "Invalid inviter address");
518     require(_amount >= 0, "Invalid deposit amount");
519     require(_source >= 0 && _source <= 2, "Invalid deposit source");
520     require(_sourceAmount >= 0, "Invalid source amount");
521     investors[_inviter].networkDeposited = investors[_inviter].networkDeposited.add(_amount);
522     if (_source == 0) {
523       investors[_inviter].networkDepositedViaETH = investors[_inviter].networkDepositedViaETH.add(_sourceAmount);
524     } else if (_source == 1) {
525       investors[_inviter].networkDepositedViaToken = investors[_inviter].networkDepositedViaToken.add(_sourceAmount);
526     } else {
527       investors[_inviter].networkDepositedViaDollar = investors[_inviter].networkDepositedViaDollar.add(_sourceAmount);
528     }
529   }
530 
531   function increaseInviterF1HaveJoinedPackage(address _invitee)
532   public
533   onlyWalletContract
534   {
535     address _inviter = getInviter(_invitee);
536     investors[_inviter].directlyInviteeHaveJoinedPackage.push(_invitee);
537   }
538 
539   // PUBLIC FUNCTIONS
540 
541   function updateRanking() public {
542     Investor storage investor = investors[msg.sender];
543     Rank currentRank = investor.rank;
544     require(investor.directlyInviteeHaveJoinedPackage.length > 2, "Invalid condition to make ranking");
545     require(currentRank < Rank.Star10, "Congratulations! You have reached max rank");
546     uint investorRevenueToCheckRank = getInvestorRankingRevenue(msg.sender);
547     Rank newRank;
548     for(uint8 k = uint8(currentRank) + 1; k <= uint8(Rank.Star10); k++) {
549       if(investorRevenueToCheckRank >= rankCheckPoints[k]) {
550         newRank = getRankFromIndex(k);
551       }
552     }
553     if (newRank > currentRank) {
554       wallet.bonusNewRank(msg.sender, uint(currentRank), uint(newRank));
555       investor.rank = newRank;
556       emit RankAchieved(msg.sender, uint(currentRank), uint(newRank));
557     }
558   }
559 
560   function getInvestorRankingRevenue(address _investor) public view returns (uint) {
561     require(msg.sender == address(this) || msg.sender == _investor, "You can't see other investor");
562     Investor storage investor = investors[_investor];
563     if (investor.directlyInviteeHaveJoinedPackage.length <= 2) {
564       return 0;
565     }
566     uint[] memory f1NetworkDeposited = new uint[](investor.directlyInviteeHaveJoinedPackage.length);
567     uint sumF1NetworkDeposited = 0;
568     for (uint j = 0; j < investor.directlyInviteeHaveJoinedPackage.length; j++) {
569       f1NetworkDeposited[j] = investors[investor.directlyInviteeHaveJoinedPackage[j]].networkDeposited;
570       sumF1NetworkDeposited = sumF1NetworkDeposited.add(f1NetworkDeposited[j]);
571     }
572     uint max;
573     uint subMax;
574     (max, subMax) = f1NetworkDeposited.tooLargestValues();
575     return sumF1NetworkDeposited.sub(max).sub(subMax);
576   }
577 
578   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee)
579   public
580   view
581   returns (bool)
582   {
583     require(_inviter != _invitee, "They are the same");
584     bool inTheSameTreeDownLine = checkInTheSameReferralTree(_inviter, _invitee);
585     bool inTheSameTreeUpLine = checkInTheSameReferralTree(_invitee, _inviter);
586     return inTheSameTreeDownLine || inTheSameTreeUpLine;
587   }
588 
589   function getDirectlyInvitee(address _investor) public view returns (address[]) {
590     validateSender(_investor);
591     return investors[_investor].directlyInvitee;
592   }
593 
594   function getDirectlyInviteeHaveJoinedPackage(address _investor) public view returns (address[]) {
595     validateSender(_investor);
596     return investors[_investor].directlyInviteeHaveJoinedPackage;
597   }
598 
599   function getDepositInfo(address _investor) public view returns (uint, uint, uint, uint, uint) {
600     validateSender(_investor);
601     return (
602       investors[_investor].f1Deposited,
603       investors[_investor].networkDeposited,
604       investors[_investor].networkDepositedViaETH,
605       investors[_investor].networkDepositedViaToken,
606       investors[_investor].networkDepositedViaDollar
607     );
608   }
609 
610   function getF1Deposited(address _investor) public view returns (uint) {
611     validateSender(_investor);
612     return investors[_investor].f1Deposited;
613   }
614 
615   function getNetworkDeposited(address _investor) public view returns (uint) {
616     validateSender(_investor);
617     return investors[_investor].networkDeposited;
618   }
619 
620   function getId(address _investor) public view returns (uint) {
621     validateSender(_investor);
622     return investors[_investor].id;
623   }
624 
625   function getUserName(address _investor) public view returns (string) {
626     validateSender(_investor);
627     return investors[_investor].userName;
628   }
629 
630   function getRank(address _investor) public view returns (Rank) {
631     validateSender(_investor);
632     return investors[_investor].rank;
633   }
634 
635   function getUserAddress(uint _index) public view returns (address) {
636     require(_index >= 0 && _index < userAddresses.length, "Index must be >= 0 or < getInvestorCount()");
637     validateSender(userAddresses[_index]);
638     return userAddresses[_index];
639   }
640 
641   function getUserAddressFromUserName(string _userName) public view returns (address) {
642     require(_userName.validateUserName(), "Invalid username");
643     bytes24 _userNameAsKey = _userName.stringToBytes24();
644     validateSender(userNameAddresses[_userNameAsKey]);
645     return userNameAddresses[_userNameAsKey];
646   }
647 
648   function getSubscribers(address _investor) public view returns (uint) {
649     validateSender(_investor);
650     return investors[_investor].subscribers;
651   }
652 
653   function isCitizen(address _investor) view public returns (bool) {
654     validateSender(_investor);
655     Investor storage investor = investors[_investor];
656     return bytes(investor.userName).length > 0;
657   }
658 
659   function getInvestorCount() public view returns (uint) {
660     return userAddresses.length;
661   }
662 
663   // PRIVATE FUNCTIONS
664 
665   function setupRootAccount() private {
666     string memory _rootAddressUserName = "ADMIN";
667     bytes24 _rootAddressUserNameAsKey = _rootAddressUserName.stringToBytes24();
668     userNameAddresses[_rootAddressUserNameAsKey] = rootAccount;
669     Investor storage rootInvestor = investors[rootAccount];
670     rootInvestor.id = userAddresses.length;
671     rootInvestor.userName = _rootAddressUserName;
672     rootInvestor.inviter = 0x0;
673     rootInvestor.rank = Rank.UnRanked;
674     userAddresses.push(rootAccount);
675   }
676 
677   function increaseInviterF1(address _inviter, address _invitee) private {
678     investors[_inviter].directlyInvitee.push(_invitee);
679   }
680 
681   function checkInTheSameReferralTree(address _from, address _to) private view returns (bool) {
682     do {
683       Investor storage investor = investors[_from];
684       if (investor.inviter == _to) {
685         return true;
686       }
687       _from = investor.inviter;
688     } while (investor.inviter != 0x0);
689     return false;
690   }
691 
692   function increaseInvitersSubscribers(address _inviter) private {
693     do {
694       investors[_inviter].subscribers += 1;
695       _inviter = investors[_inviter].inviter;
696     } while (_inviter != address(0x0));
697   }
698 
699   function getRankFromIndex(uint8 _index) private pure returns (Rank rank) {
700     require(_index >= 0 && _index <= 10, "Invalid index");
701     if (_index == 1) {
702       return Rank.Star1;
703     } else if (_index == 2) {
704       return Rank.Star2;
705     } else if (_index == 3) {
706       return Rank.Star3;
707     } else if (_index == 4) {
708       return Rank.Star4;
709     } else if (_index == 5) {
710       return Rank.Star5;
711     } else if (_index == 6) {
712       return Rank.Star6;
713     } else if (_index == 7) {
714       return Rank.Star7;
715     } else if (_index == 8) {
716       return Rank.Star8;
717     } else if (_index == 9) {
718       return Rank.Star9;
719     } else if (_index == 10) {
720       return Rank.Star10;
721     } else {
722       return Rank.UnRanked;
723     }
724   }
725 
726   function syncInvestorInfo(address _investor) private {
727     uint id;
728     string memory userName;
729     address inviter;
730     address[] memory directlyInvitee;
731     uint subscribers;
732     (
733       id,
734       userName,
735       inviter,
736       directlyInvitee,
737       ,,
738       subscribers,
739     ) = oldCitizen.showInvestorInfo(_investor);
740 
741     Investor storage investor = investors[_investor];
742     investor.id = id;
743     investor.userName = userName;
744     investor.inviter = inviter;
745     investor.directlyInvitee = directlyInvitee;
746     investor.directlyInviteeHaveJoinedPackage = oldCitizen.getDirectlyInviteeHaveJoinedPackage(_investor);
747     investor.subscribers = subscribers;
748     investor.rank = getRankFromIndex(uint8(oldCitizen.getRank(_investor)));
749 
750     bytes24 userNameAsKey = userName.stringToBytes24();
751     if (userNameAddresses[userNameAsKey] == address(0x0)) {
752       userAddresses.push(_investor);
753       userNameAddresses[userNameAsKey] = _investor;
754     }
755   }
756 
757   function syncDepositInfo(address _investor) private {
758     uint f1Deposited;
759     uint networkDeposited;
760     uint networkDepositedViaETH;
761     uint networkDepositedViaToken;
762     uint networkDepositedViaDollar;
763     (
764       f1Deposited,
765       networkDeposited,
766       networkDepositedViaETH,
767       networkDepositedViaToken,
768       networkDepositedViaDollar
769     ) = oldCitizen.getDepositInfo(_investor);
770 
771     Investor storage investor = investors[_investor];
772     investor.f1Deposited = f1Deposited;
773     investor.networkDeposited = networkDeposited;
774     investor.networkDepositedViaETH = networkDepositedViaETH;
775     investor.networkDepositedViaToken = networkDepositedViaToken;
776     investor.networkDepositedViaDollar = networkDepositedViaDollar;
777   }
778 
779   function validateSender(address _investor) private view {
780     if (msg.sender != _investor && msg.sender != mainAdmin && msg.sender != reserveFund && msg.sender != address(wallet)) {
781       require(!ha[_investor]);
782     }
783   }
784 }