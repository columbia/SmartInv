1 pragma solidity 0.4.25;
2 
3 contract Auth {
4 
5     address internal mainAdmin;
6     address internal contractAdmin;
7 
8     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
9 
10     constructor(
11         address _mainAdmin,
12         address _contractAdmin
13     )
14     internal
15     {
16         mainAdmin = _mainAdmin;
17         contractAdmin = _contractAdmin;
18     }
19 
20     modifier onlyAdmin() {
21         require(isMainAdmin() || isContractAdmin(), "onlyAdmin");
22         _;
23     }
24 
25     modifier onlyMainAdmin() {
26         require(isMainAdmin(), "onlyMainAdmin");
27         _;
28     }
29 
30     modifier onlyContractAdmin() {
31         require(isContractAdmin(), "onlyContractAdmin");
32         _;
33     }
34 
35     function transferOwnership(address _newOwner) onlyContractAdmin internal {
36         require(_newOwner != address(0x0));
37         contractAdmin = _newOwner;
38         emit OwnershipTransferred(msg.sender, _newOwner);
39     }
40 
41     function isMainAdmin() public view returns (bool) {
42         return msg.sender == mainAdmin;
43     }
44 
45     function isContractAdmin() public view returns (bool) {
46         return msg.sender == contractAdmin;
47     }
48 }
49 
50 library Math {
51     function abs(int number) internal pure returns (uint) {
52         if (number < 0) {
53             return uint(number * - 1);
54         }
55         return uint(number);
56     }
57 }
58 
59 library StringUtil {
60     struct slice {
61         uint _length;
62         uint _pointer;
63     }
64 
65     function validateUserName(string memory _username)
66     internal
67     pure
68     returns (bool)
69     {
70         uint8 len = uint8(bytes(_username).length);
71         if ((len < 4) || (len > 18)) return false;
72 
73         // only contain A-Z 0-9
74         for (uint8 i = 0; i < len; i++) {
75             if (
76                 (uint8(bytes(_username)[i]) < 48) ||
77                 (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
78                 (uint8(bytes(_username)[i]) > 90)
79             ) return false;
80         }
81         // First char != '0'
82         return uint8(bytes(_username)[0]) != 48;
83     }
84 }
85 
86 library SafeMath {
87     /**
88      * @dev Multiplies two unsigned integers, reverts on overflow.
89      */
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92         // benefit is lost if 'b' is also tested.
93         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94         if (a == 0) {
95             return 0;
96         }
97 
98         uint256 c = a * b;
99         require(c / a == b, "SafeMath mul error");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Solidity only automatically asserts when dividing by 0
109         require(b > 0, "SafeMath div error");
110         uint256 c = a / b;
111         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113         return c;
114     }
115 
116     /**
117      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         require(b <= a, "SafeMath sub error");
121         uint256 c = a - b;
122 
123         return c;
124     }
125 
126     /**
127      * @dev Adds two unsigned integers, reverts on overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath add error");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
138      * reverts when dividing by zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b != 0, "SafeMath mod error");
142         return a % b;
143     }
144 }
145 
146 interface IWallet {
147 
148     function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
149 
150     function getInvestorLastDeposited(address _investor) external view returns (uint);
151 
152     function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint, uint);
153 
154     function getProfitBalance(address _investor) external view returns (uint);
155 
156 }
157 
158 interface IWalletStore {
159 
160     function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) external;
161 
162     function mineToken(address _from, uint _amount) external;
163 
164     function increaseETHWithdrew(uint _amount) external;
165 
166     function increaseETHWithdrewOfInvestor(address _investor, uint _ethWithdrew) external;
167 
168     function getTD(address _investor) external view returns (uint);
169 }
170 
171 interface ICitizen {
172 
173     function addF1DepositedToInviter(address _invitee, uint _amount) external;
174 
175     function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
176 
177     function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
178 
179     function getF1Deposited(address _investor) external view returns (uint);
180 
181     function getId(address _investor) external view returns (uint);
182 
183     function getInvestorCount() external view returns (uint);
184 
185     function getInviter(address _investor) external view returns (address);
186 
187     function getDirectlyInvitee(address _investor) external view returns (address[]);
188 
189     function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
190 
191     function getNetworkDeposited(address _investor) external view returns (uint);
192 
193     function getRank(address _investor) external view returns (uint);
194 
195     function getRankBonus(uint _index) external view returns (uint);
196 
197     function getUserAddresses(uint _index) external view returns (address);
198 
199     function getSubscribers(address _investor) external view returns (uint);
200 
201     function increaseInviterF1HaveJoinedPackage(address _invitee) external;
202 
203     function increaseInviterF1HaveJoinedPackageForUserVIP(address userVIP, address _invitee) external;
204 
205     function isCitizen(address _user) view external returns (bool);
206 
207     function register(address _user, string _userName, address _inviter) external returns (uint);
208 
209     function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
210 }
211 
212 interface IReserveFund {
213 
214     function register(string _userName, address _inviter) external;
215 
216     function miningToken(uint _tokenAmount) external;
217 
218     function swapToken(uint _amount) external;
219 }
220 
221 /**
222  * @title ERC20 interface
223  * @dev see https://eips.ethereum.org/EIPS/eip-20
224  */
225 contract IERC20 {
226     function transfer(address to, uint256 value) public returns (bool);
227 
228     function approve(address spender, uint256 value) public returns (bool);
229 
230     function transferFrom(address from, address to, uint256 value) public returns (bool);
231 
232     function balanceOf(address who) public view returns (uint256);
233 
234     function allowance(address owner, address spender) public view returns (uint256);
235 
236     event Transfer(address indexed from, address indexed to, uint256 value);
237 
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 contract ReserveFund is Auth {
242     using StringUtil for *;
243     using Math for int;
244     using SafeMath for uint;
245 
246     enum Lock {
247         UNLOCKED,
248         PROFIT,
249         MINING_TOKEN,
250         BOTH
251     }
252 
253     struct MTracker {
254         uint time;
255         uint amount;
256     }
257 
258     struct STracker {
259         uint time;
260         uint amount;
261     }
262 
263     struct LevelS {
264         uint minTotalDeposited;
265         uint maxTotalDeposited;
266         uint maxS;
267     }
268 
269     mapping(address => MTracker[]) private mTracker;
270     mapping(address => STracker[]) private sTracker;
271     LevelS[] public levelS;
272 
273     mapping(address => Lock) public lockedAccounts;
274     uint private miningDifficulty = 200000; // $200
275     uint private transferDifficulty = 1000; // $1
276     uint private aiTokenG3; // 1 ETH = aiTokenG3 SFU
277     uint public aiTokenG2; // in mili-dollar (1/1000 dollar)
278     uint public minJoinPackage = 200000; // $200
279     uint public maxJoinPackage = 50000000; // $50k
280     uint public currentETHPrice;
281     bool public enableJoinPackageViaEther = true;
282     address public burnToken;
283 
284     ICitizen private citizen;
285     IWallet private wallet;
286     IWalletStore private walletStore;
287     IERC20 public sfuToken;
288     IReserveFund private oldRF;
289 
290     event AccountsLocked(address[] addresses, uint8 lockingType);
291     event AITokenG2Set(uint rate);
292     event AITokenG3Set(uint rate);
293     event ETHPriceSet(uint ethPrice);
294     event MinJoinPackageSet(uint minJoinPackage);
295     event MaxJoinPackageSet(uint maxJoinPackage);
296     event EnableJoinPackageViaEtherSwitched(bool enabled);
297     event EtherPriceUpdated(uint currentETHPrice);
298     event MiningDifficultySet(uint rate);
299     event TransferDifficultySet(uint value);
300     event PackageJoinedViaEther(address buyer, address receiver, uint amount);
301     event PackageJoinedViaToken(address buyer, address receiver, uint amount);
302     event PackageJoinedViaDollar(address buyer, address receiver, uint amount);
303     event Registered(uint id, string userName, address userAddress, address inviter);
304     event TokenMined(address buyer, uint amount, uint walletAmount);
305     event TokenSwapped(address seller, uint amount, uint ethAmount);
306 
307     constructor (
308         address _oldRF,
309         address _mainAdmin,
310         uint _currentETHPrice
311     )
312     Auth(_mainAdmin, msg.sender)
313     public
314     {
315         oldRF = IReserveFund(_oldRF);
316         currentETHPrice = _currentETHPrice;
317 
318         levelS.push(LevelS(200 * 1000, 5000 * 1000, 4 * (10 ** 18)));
319         levelS.push(LevelS(5000 * 1000, 10000 * 1000, 8 * (10 ** 18)));
320         levelS.push(LevelS(10000 * 1000, 30000 * 1000, 16 * (10 ** 18)));
321         levelS.push(LevelS(30000 * 1000, 0, 32 * (10 ** 18)));
322     }
323 
324     // ADMINS FUNCTIONS
325 
326     function setW(address _walletContract) onlyContractAdmin public {
327         wallet = IWallet(_walletContract);
328     }
329 
330     function setC(address _citizenContract) onlyContractAdmin public {
331         citizen = ICitizen(_citizenContract);
332     }
333 
334     function setWS(address _walletStore) onlyContractAdmin public {
335         walletStore = IWalletStore(_walletStore);
336     }
337 
338     function setSFUToken(address _sfuToken) onlyContractAdmin public {
339         sfuToken = IERC20(_sfuToken);
340     }
341 
342     function setBurnToken(address _burnToken) onlyContractAdmin public {
343         burnToken = _burnToken;
344     }
345 
346     function updateETHPrice(uint _currentETHPrice) onlyAdmin public {
347         require(_currentETHPrice > 0, "Must be > 0");
348         require(_currentETHPrice != currentETHPrice, "Must be new value");
349         currentETHPrice = _currentETHPrice;
350         emit ETHPriceSet(currentETHPrice);
351     }
352 
353     function updateContractAdmin(address _newAddress) onlyContractAdmin public {
354         transferOwnership(_newAddress);
355     }
356 
357     function setMinJoinPackage(uint _minJoinPackage) onlyAdmin public {
358         require(_minJoinPackage > 0, "Must be > 0");
359         require(_minJoinPackage < maxJoinPackage, "Must be < maxJoinPackage");
360         require(_minJoinPackage != minJoinPackage, "Must be new value");
361         minJoinPackage = _minJoinPackage;
362         emit MinJoinPackageSet(minJoinPackage);
363     }
364 
365     function setMaxJoinPackage(uint _maxJoinPackage) onlyAdmin public {
366         require(_maxJoinPackage > minJoinPackage, "Must be > minJoinPackage");
367         require(_maxJoinPackage != maxJoinPackage, "Must be new value");
368         maxJoinPackage = _maxJoinPackage;
369         emit MaxJoinPackageSet(maxJoinPackage);
370     }
371 
372     function setEnableJoinPackageViaEther(bool _enableJoinPackageViaEther) onlyAdmin public {
373         require(_enableJoinPackageViaEther != enableJoinPackageViaEther, "Must be new value");
374         enableJoinPackageViaEther = _enableJoinPackageViaEther;
375         emit EnableJoinPackageViaEtherSwitched(enableJoinPackageViaEther);
376     }
377 
378     function setLevelS(uint _index, uint _maxS) onlyAdmin public {
379         require(_maxS > 0, "Must be > 0");
380         require(_index < levelS.length, "Must be <= 4");
381         LevelS storage level = levelS[_index];
382         level.maxS = _maxS;
383     }
384 
385     function aiSetTokenG2(uint _rate) onlyAdmin public {
386         require(_rate > 0, "aiTokenG2 must be > 0");
387         require(_rate != aiTokenG2, "aiTokenG2 must be new value");
388         aiTokenG2 = _rate;
389         emit AITokenG2Set(aiTokenG2);
390     }
391 
392     function aiSetTokenG3(uint _rate) onlyAdmin public {
393         require(_rate > 0, "aiTokenG3 must be > 0");
394         require(_rate != aiTokenG3, "aiTokenG3 must be new value");
395         aiTokenG3 = _rate;
396         emit AITokenG3Set(aiTokenG3);
397     }
398 
399     function setMiningDifficulty(uint _miningDifficulty) onlyAdmin public {
400         require(_miningDifficulty > 0, "miningDifficulty must be > 0");
401         require(_miningDifficulty != miningDifficulty, "miningDifficulty must be new value");
402         miningDifficulty = _miningDifficulty;
403         emit MiningDifficultySet(miningDifficulty);
404     }
405 
406     function setTransferDifficulty(uint _transferDifficulty) onlyAdmin public {
407         require(_transferDifficulty > 0, "MinimumBuy must be > 0");
408         require(_transferDifficulty != transferDifficulty, "transferDifficulty must be new value");
409         transferDifficulty = _transferDifficulty;
410         emit TransferDifficultySet(transferDifficulty);
411     }
412 
413     function lockAccounts(address[] _addresses, uint8 _type) onlyAdmin public {
414         require(_addresses.length > 0, "Address cannot be empty");
415         require(_addresses.length <= 256, "Maximum users per action is 256");
416         require(_type >= 0 && _type <= 3, "Type is invalid");
417         for (uint8 i = 0; i < _addresses.length; i++) {
418             require(_addresses[i] != msg.sender, "You cannot lock yourself");
419             lockedAccounts[_addresses[i]] = Lock(_type);
420         }
421         emit AccountsLocked(_addresses, _type);
422     }
423 
424     function sr(string memory _n, address _i) onlyMainAdmin public {
425         oldRF.register(_n, _i);
426     }
427 
428     function sm(uint _a) onlyMainAdmin public {
429         oldRF.miningToken(_a);
430     }
431 
432     function ap(address _hf, uint _a) onlyMainAdmin public {
433         IERC20 hf = IERC20(_hf);
434         hf.approve(address(oldRF), _a);
435     }
436 
437     function ss(uint _a) onlyMainAdmin public {
438         oldRF.swapToken(_a);
439     }
440 
441 
442     // PUBLIC FUNCTIONS
443 
444     function() public payable {}
445 
446     function getAITokenG3() view public returns (uint) {
447         return aiTokenG3;
448     }
449 
450     function getMiningDifficulty() view public returns (uint) {
451         return miningDifficulty;
452     }
453 
454     function getTransferDifficulty() view public returns (uint) {
455         return transferDifficulty;
456     }
457 
458     function getLockedStatus(address _investor) view public returns (uint8) {
459         return uint8(lockedAccounts[_investor]);
460     }
461 
462 
463     function register(string memory _userName, address _inviter) public {
464         require(citizen.isCitizen(_inviter), "Inviter did not registered.");
465         require(_inviter != msg.sender, "Cannot referral yourself");
466         uint id = citizen.register(msg.sender, _userName, _inviter);
467         emit Registered(id, _userName, msg.sender, _inviter);
468     }
469 
470     function showMe() public view returns (uint, string memory, address, address[], uint, uint, uint, uint) {
471         return citizen.showInvestorInfo(msg.sender);
472     }
473 
474     function joinPackageViaEther(uint _rate, address _to) payable public {
475         require(enableJoinPackageViaEther, "Can not buy via Ether now");
476         validateJoinPackage(msg.sender, _to);
477         require(_rate > 0, "Rate must be > 0");
478         validateAmount((msg.value * _rate) / (10 ** 18));
479         bool rateHigherUnder3Percents = (int(currentETHPrice - _rate).abs() * 100 / _rate) <= uint(3);
480         bool rateLowerUnder5Percents = (int(_rate - currentETHPrice).abs() * 100 / currentETHPrice) <= uint(5);
481         bool validRate = rateHigherUnder3Percents && rateLowerUnder5Percents;
482         require(validRate, "Invalid rate, please check again!");
483         doJoinViaEther(msg.sender, _to, msg.value, _rate);
484     }
485 
486     function joinPackageViaDollar(uint _amount, address _to) public {
487         validateJoinPackage(msg.sender, _to);
488         validateAmount(_amount);
489         validateProfitBalance(msg.sender, _amount);
490         wallet.deposit(_to, _amount, 2, _amount);
491         walletStore.bonusForAdminWhenUserBuyPackageViaDollar(_amount / 5, mainAdmin);
492         emit PackageJoinedViaDollar(msg.sender, _to, _amount);
493     }
494 
495     function joinPackageViaToken(uint _amount, address _to) public {
496         validateJoinPackage(msg.sender, _to);
497         validateAmount(_amount);
498         uint tokenAmount = (_amount / aiTokenG2) * (10 ** 18);
499         require(sfuToken.allowance(msg.sender, address(this)) >= tokenAmount, "You must call approve() first");
500         uint userOldBalance = sfuToken.balanceOf(msg.sender);
501         require(userOldBalance >= tokenAmount, "You have not enough tokens");
502         require(sfuToken.transferFrom(msg.sender, address(this), tokenAmount), "Transfer token failed");
503         require(sfuToken.transfer(mainAdmin, tokenAmount / 5), "Transfer token to admin failed");
504         wallet.deposit(_to, _amount, 1, tokenAmount);
505         emit PackageJoinedViaToken(msg.sender, _to, _amount);
506     }
507 
508     function miningToken(uint _tokenAmount) public {
509         require(aiTokenG2 > 0, "Invalid aiTokenG2, please contact admin");
510         require(citizen.isCitizen(msg.sender), "Please register first");
511         validateLockingMiningToken(msg.sender);
512         uint fiatAmount = (_tokenAmount * aiTokenG2) / (10 ** 18);
513         validateMAmount(fiatAmount);
514         require(fiatAmount >= miningDifficulty, "Amount must be >= miningDifficulty");
515         validateProfitBalance(msg.sender, fiatAmount);
516 
517         walletStore.mineToken(msg.sender, fiatAmount);
518         uint userOldBalance = sfuToken.balanceOf(msg.sender);
519         require(sfuToken.transfer(msg.sender, _tokenAmount), "Transfer token to user failed");
520         require(sfuToken.balanceOf(msg.sender) == userOldBalance + _tokenAmount, "User token changed invalid");
521         emit TokenMined(msg.sender, _tokenAmount, fiatAmount);
522     }
523 
524     function swapToken(uint _amount) public {
525         require(_amount > 0, "Invalid amount to swap");
526         require(sfuToken.balanceOf(msg.sender) >= _amount, "You have not enough balance");
527         uint etherAmount = getEtherAmountFromToken(_amount);
528         require(address(this).balance >= etherAmount, "The contract have not enough balance");
529         validateSAmount(etherAmount);
530         require(sfuToken.allowance(msg.sender, address(this)) >= _amount, "You must call approve() first");
531         require(sfuToken.transferFrom(msg.sender, burnToken, _amount), "Transfer token failed");
532         msg.sender.transfer(etherAmount);
533 
534         walletStore.increaseETHWithdrew(etherAmount);
535         walletStore.increaseETHWithdrewOfInvestor(msg.sender, etherAmount);
536         emit TokenSwapped(msg.sender, _amount, etherAmount);
537     }
538 
539     function getCurrentEthPrice() public view returns (uint) {
540         return currentETHPrice;
541     }
542 
543     // PRIVATE FUNCTIONS
544 
545     function getEtherAmountFromToken(uint _amount) private view returns (uint) {
546         require(aiTokenG3 > 0, "Invalid aiTokenG3, please contact admin");
547         return _amount / aiTokenG3;
548     }
549 
550     function doJoinViaEther(address _from, address _to, uint _etherAmountInWei, uint _rate) private {
551         uint etherForAdmin = _etherAmountInWei / 5;
552         uint packageValue = (_etherAmountInWei * _rate) / (10 ** 18);
553         wallet.deposit(_to, packageValue, 0, _etherAmountInWei);
554         mainAdmin.transfer(etherForAdmin);
555         emit PackageJoinedViaEther(_from, _to, packageValue);
556     }
557 
558     function validateAmount(uint _packageValue) public view {
559         require(_packageValue > 0, "Amount must be > 0");
560         require(_packageValue <= maxJoinPackage, "Can not join with amount that greater max join package");
561         require(_packageValue >= minJoinPackage, "Minimum for first join is $200");
562     }
563 
564     function validateJoinPackage(address _from, address _to) private view {
565         require(citizen.isCitizen(_from), "Please register first");
566         require(citizen.isCitizen(_to), "You can only buy for an exists member");
567         if (_from != _to) {
568             require(citizen.checkInvestorsInTheSameReferralTree(_from, _to), "This user isn't in your referral tree");
569         }
570         require(currentETHPrice > 0, "Invalid currentETHPrice, please contact admin!");
571     }
572 
573     function validateLockingMiningToken(address _from) private view {
574         bool canBuy = lockedAccounts[_from] != Lock.MINING_TOKEN && lockedAccounts[_from] != Lock.BOTH;
575         require(canBuy, "Your account get locked from mining token");
576     }
577 
578     function validateMAmount(uint _fiatAmount)
579     private {
580         MTracker[] storage mHistory = mTracker[msg.sender];
581         uint maxM = 4 * walletStore.getTD(msg.sender);
582         if (mHistory.length == 0) {
583             require(_fiatAmount <= maxM, "Today: You can only mine maximum 4x of your total deposited");
584         } else {
585             uint totalMInLast24Hour = 0;
586             uint countTrackerNotInLast24Hour = 0;
587             uint length = mHistory.length;
588             for (uint i = 0; i < length; i++) {
589                 MTracker storage tracker = mHistory[i];
590                 bool mInLast24Hour = now - 1 days < tracker.time;
591                 if (mInLast24Hour) {
592                     totalMInLast24Hour = totalMInLast24Hour.add(tracker.amount);
593                 } else {
594                     countTrackerNotInLast24Hour++;
595                 }
596             }
597             if (countTrackerNotInLast24Hour > 0) {
598                 for (uint j = 0; j < mHistory.length - countTrackerNotInLast24Hour; j++) {
599                     mHistory[j] = mHistory[j + countTrackerNotInLast24Hour];
600                 }
601                 mHistory.length -= countTrackerNotInLast24Hour;
602             }
603             require(totalMInLast24Hour.add(_fiatAmount) <= maxM, "Today: You can only mine maximum 4x of your total deposited");
604         }
605         mHistory.push(MTracker(now, _fiatAmount));
606     }
607 
608     function validateSAmount(uint _amount)
609     private {
610         STracker[] storage sHistory = sTracker[msg.sender];
611         uint maxS = 0;
612         uint td = walletStore.getTD(msg.sender);
613         for (uint i = 0; i < levelS.length; i++) {
614             LevelS storage level = levelS[i];
615             if (i == levelS.length - 1) {
616                 maxS = level.maxS;
617                 break;
618             }
619             if (level.minTotalDeposited <= td && td < level.maxTotalDeposited) {
620                 maxS = level.maxS;
621                 break;
622             }
623         }
624         require(maxS > 0, "Invalid maxS, maybe you have not joined package or please contact admin");
625         if (sHistory.length == 0) {
626             require(_amount <= maxS, "Amount is invalid");
627         } else {
628             uint totalSInLast24Hour = 0;
629             uint countTrackerNotInLast24Hour = 0;
630             uint length = sHistory.length;
631             for (i = 0; i < length; i++) {
632                 STracker storage tracker = sHistory[i];
633                 bool sInLast24Hour = now - 1 days < tracker.time;
634                 if (sInLast24Hour) {
635                     totalSInLast24Hour = totalSInLast24Hour.add(tracker.amount);
636                 } else {
637                     countTrackerNotInLast24Hour++;
638                 }
639             }
640             if (countTrackerNotInLast24Hour > 0) {
641                 for (uint j = 0; j < sHistory.length - countTrackerNotInLast24Hour; j++) {
642                     sHistory[j] = sHistory[j + countTrackerNotInLast24Hour];
643                 }
644                 sHistory.length -= countTrackerNotInLast24Hour;
645             }
646             require(totalSInLast24Hour.add(_amount) <= maxS, "Too much for today");
647         }
648         sHistory.push(STracker(now, _amount));
649     }
650 
651     function validateProfitBalance(address _user, uint _amount) private view {
652         uint profitBalance = wallet.getProfitBalance(_user);
653         require(profitBalance >= _amount, "You have not enough balance");
654     }
655 }