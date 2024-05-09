1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-24
3 */
4 
5 pragma solidity 0.4.25;
6 
7 contract Auth {
8 
9     address internal mainAdmin;
10     address internal contractAdmin;
11 
12     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
13 
14     constructor(
15         address _mainAdmin,
16         address _contractAdmin
17     )
18     internal
19     {
20         mainAdmin = _mainAdmin;
21         contractAdmin = _contractAdmin;
22     }
23 
24     modifier onlyAdmin() {
25         require(isMainAdmin() || isContractAdmin(), "onlyAdmin");
26         _;
27     }
28 
29     modifier onlyMainAdmin() {
30         require(isMainAdmin(), "onlyMainAdmin");
31         _;
32     }
33 
34     modifier onlyContractAdmin() {
35         require(isContractAdmin(), "onlyContractAdmin");
36         _;
37     }
38 
39     function transferOwnership(address _newOwner) onlyContractAdmin internal {
40         require(_newOwner != address(0x0));
41         contractAdmin = _newOwner;
42         emit OwnershipTransferred(msg.sender, _newOwner);
43     }
44 
45     function isMainAdmin() public view returns (bool) {
46         return msg.sender == mainAdmin;
47     }
48 
49     function isContractAdmin() public view returns (bool) {
50         return msg.sender == contractAdmin;
51     }
52 }
53 
54 library Math {
55     function abs(int number) internal pure returns (uint) {
56         if (number < 0) {
57             return uint(number * - 1);
58         }
59         return uint(number);
60     }
61 }
62 
63 library StringUtil {
64     struct slice {
65         uint _length;
66         uint _pointer;
67     }
68 
69     function validateUserName(string memory _username)
70     internal
71     pure
72     returns (bool)
73     {
74         uint8 len = uint8(bytes(_username).length);
75         if ((len < 4) || (len > 18)) return false;
76 
77         // only contain A-Z 0-9
78         for (uint8 i = 0; i < len; i++) {
79             if (
80                 (uint8(bytes(_username)[i]) < 48) ||
81                 (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
82                 (uint8(bytes(_username)[i]) > 90)
83             ) return false;
84         }
85         // First char != '0'
86         return uint8(bytes(_username)[0]) != 48;
87     }
88 }
89 
90 interface IWallet {
91 
92     function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) external;
93 
94     function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
95 
96     function mineToken(address _from, uint _amount) external;
97 
98     function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
99 
100     function rewardForUserVip(address _to) external;
101 
102     function getInvestorLastDeposited(address _investor) external view returns (uint);
103 
104     function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
105 
106     function getProfitBalance(address _investor) external view returns (uint);
107 
108     function increaseETHWithdrew(uint _amount) external;
109 
110     function validateCanMineToken(uint _tokenAmount, address _from) external view;
111 }
112 
113 interface ICitizen {
114 
115     function addF1DepositedToInviter(address _invitee, uint _amount) external;
116 
117     function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
118 
119     function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
120 
121     function getF1Deposited(address _investor) external view returns (uint);
122 
123     function getId(address _investor) external view returns (uint);
124 
125     function getInvestorCount() external view returns (uint);
126 
127     function getInviter(address _investor) external view returns (address);
128 
129     function getDirectlyInvitee(address _investor) external view returns (address[]);
130 
131     function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
132 
133     function getNetworkDeposited(address _investor) external view returns (uint);
134 
135     function getRank(address _investor) external view returns (uint);
136 
137     function getRankBonus(uint _index) external view returns (uint);
138 
139     function getUserAddresses(uint _index) external view returns (address);
140 
141     function getSubscribers(address _investor) external view returns (uint);
142 
143     function increaseInviterF1HaveJoinedPackage(address _invitee) external;
144 
145     function increaseInviterF1HaveJoinedPackageForUserVIP(address userVIP, address _invitee) external;
146 
147     function isCitizen(address _user) view external returns (bool);
148 
149     function register(address _user, string _userName, address _inviter) external returns (uint);
150 
151     function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
152 }
153 
154 /**
155  * @title ERC20 interface
156  * @dev see https://eips.ethereum.org/EIPS/eip-20
157  */
158 contract IERC20 {
159     function transfer(address to, uint256 value) public returns (bool);
160 
161     function approve(address spender, uint256 value) public returns (bool);
162 
163     function transferFrom(address from, address to, uint256 value) public returns (bool);
164 
165     function balanceOf(address who) public view returns (uint256);
166 
167     function allowance(address owner, address spender) public view returns (uint256);
168 
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 contract ReserveFund is Auth {
175     using StringUtil for *;
176     using Math for int;
177 
178     enum Lock {
179         UNLOCKED,
180         PROFIT,
181         MINING_TOKEN,
182         BOTH
183     }
184 
185 
186 
187     mapping(address => Lock) public lockedAccounts;
188     uint private miningDifficulty = 200000; // $200
189     uint private transferDifficulty = 1000; // $1
190     uint private aiTokenG3; // 1 ETH = aiTokenG3 SFU
191     uint public aiTokenG2; // in mili-dollar (1/1000 dollar)
192     uint public minJoinPackage = 200000; // $200
193     uint public maxJoinPackage = 50000000; // $50k
194     uint public currentETHPrice;
195     bool public enableJoinPackageViaEther = true;
196     address[] private usersVIP;
197 
198     ICitizen private citizen;
199     IWallet private wallet;
200     IERC20 public sfuToken;
201 
202     event AccountsLocked(address[] addresses, uint8 lockingType);
203     event AITokenG2Set(uint rate);
204     event AITokenG3Set(uint rate);
205     event ETHPriceSet(uint ethPrice);
206     event MinJoinPackageSet(uint minJoinPackage);
207     event MaxJoinPackageSet(uint maxJoinPackage);
208     event EnableJoinPackageViaEtherSwitched(bool enabled);
209     event EtherPriceUpdated(uint currentETHPrice);
210     event MiningDifficultySet(uint rate);
211     event TransferDifficultySet(uint value);
212     event PackageJoinedViaEther(address buyer, address receiver, uint amount);
213     event PackageJoinedViaToken(address buyer, address receiver, uint amount);
214     event PackageJoinedViaDollar(address buyer, address receiver, uint amount);
215     event Registered(uint id, string userName, address userAddress, address inviter);
216     event TokenMined(address buyer, uint amount, uint walletAmount);
217     event TokenSwapped(address seller, uint amount, uint ethAmount);
218 
219     constructor (
220         address _citizen,
221         address _wallet,
222         address _mainAdmin,
223         uint _currentETHPrice
224     )
225     Auth(_mainAdmin, msg.sender)
226     public
227     {
228         citizen = ICitizen(_citizen);
229         wallet = IWallet(_wallet);
230         currentETHPrice = _currentETHPrice;
231     }
232 
233     // ADMINS FUNCTIONS
234 
235     function setSFUToken(address _sfuToken) onlyAdmin public {
236         sfuToken = IERC20(_sfuToken);
237     }
238 
239     function updateETHPrice(uint _currentETHPrice) onlyAdmin public {
240         require(_currentETHPrice > 0, "Must be > 0");
241         require(_currentETHPrice != currentETHPrice, "Must be new value");
242         currentETHPrice = _currentETHPrice;
243         emit ETHPriceSet(currentETHPrice);
244     }
245 
246     function updateContractAdmin(address _newAddress) onlyAdmin public {
247         transferOwnership(_newAddress);
248     }
249 
250     function setMinJoinPackage(uint _minJoinPackage) onlyAdmin public {
251         require(_minJoinPackage > 0, "Must be > 0");
252         require(_minJoinPackage < maxJoinPackage, "Must be < maxJoinPackage");
253         require(_minJoinPackage != minJoinPackage, "Must be new value");
254         minJoinPackage = _minJoinPackage;
255         emit MinJoinPackageSet(minJoinPackage);
256     }
257 
258     function setMaxJoinPackage(uint _maxJoinPackage) onlyAdmin public {
259         require(_maxJoinPackage > minJoinPackage, "Must be > minJoinPackage");
260         require(_maxJoinPackage != maxJoinPackage, "Must be new value");
261         maxJoinPackage = _maxJoinPackage;
262         emit MaxJoinPackageSet(maxJoinPackage);
263     }
264 
265     function setEnableJoinPackageViaEther(bool _enableJoinPackageViaEther) onlyAdmin public {
266         require(_enableJoinPackageViaEther != enableJoinPackageViaEther, "Must be new value");
267         enableJoinPackageViaEther = _enableJoinPackageViaEther;
268         emit EnableJoinPackageViaEtherSwitched(enableJoinPackageViaEther);
269     }
270 
271     function aiSetTokenG2(uint _rate) onlyAdmin public {
272         require(_rate > 0, "aiTokenG2 must be > 0");
273         require(_rate != aiTokenG2, "aiTokenG2 must be new value");
274         aiTokenG2 = _rate;
275         emit AITokenG2Set(aiTokenG2);
276     }
277 
278     function aiSetTokenG3(uint _rate) onlyAdmin public {
279         require(_rate > 0, "aiTokenG3 must be > 0");
280         require(_rate != aiTokenG3, "aiTokenG3 must be new value");
281         aiTokenG3 = _rate;
282         emit AITokenG3Set(aiTokenG3);
283     }
284 
285     function setMiningDifficulty(uint _miningDifficulty) onlyAdmin public {
286         require(_miningDifficulty > 0, "miningDifficulty must be > 0");
287         require(_miningDifficulty != miningDifficulty, "miningDifficulty must be new value");
288         miningDifficulty = _miningDifficulty;
289         emit MiningDifficultySet(miningDifficulty);
290     }
291 
292     function setTransferDifficulty(uint _transferDifficulty) onlyAdmin public {
293         require(_transferDifficulty > 0, "MinimumBuy must be > 0");
294         require(_transferDifficulty != transferDifficulty, "transferDifficulty must be new value");
295         transferDifficulty = _transferDifficulty;
296         emit TransferDifficultySet(transferDifficulty);
297     }
298 
299     function lockAccounts(address[] _addresses, uint8 _type) onlyAdmin public {
300         require(_addresses.length > 0, "Address cannot be empty");
301         require(_addresses.length <= 256, "Maximum users per action is 256");
302         require(_type >= 0 && _type <= 3, "Type is invalid");
303         for (uint8 i = 0; i < _addresses.length; i++) {
304             require(_addresses[i] != msg.sender, "You cannot lock yourself");
305             lockedAccounts[_addresses[i]] = Lock(_type);
306         }
307         emit AccountsLocked(_addresses, _type);
308     }
309 
310     function addUserVIP(address userVIP, string memory _userName) onlyAdmin public {
311         require(usersVIP.length <= 10, "Max user vip.");
312         address _inviter = msg.sender;
313         if (usersVIP.length > 1) {
314             _inviter = usersVIP[usersVIP.length - 1];
315         }
316         require(citizen.isCitizen(_inviter), "Inviter did not registered.");
317         require(userVIP != msg.sender, "Cannot referral yourself");
318         uint id = citizen.register(userVIP, _userName, _inviter);
319         emit Registered(id, _userName, userVIP, _inviter);
320         for (uint i = 0; i <= 10; i ++) {
321             address _invitee = address(0x0);
322             citizen.increaseInviterF1HaveJoinedPackageForUserVIP(userVIP, _invitee);
323         }
324         wallet.rewardForUserVip(userVIP);
325         usersVIP.push(userVIP);
326     }
327 
328 
329     // PUBLIC FUNCTIONS
330 
331     function() public payable {}
332 
333     function getAITokenG3() view public returns (uint) {
334         return aiTokenG3;
335     }
336 
337     function getMiningDifficulty() view public returns (uint) {
338         return miningDifficulty;
339     }
340 
341     function getTransferDifficulty() view public returns (uint) {
342         return transferDifficulty;
343     }
344 
345     function getLockedStatus(address _investor) view public returns (uint8) {
346         return uint8(lockedAccounts[_investor]);
347     }
348 
349     function getUsersVIP() view public returns (address[]) {
350         return usersVIP;
351     }
352 
353     function register(string memory _userName, address _inviter) public {
354         require(citizen.isCitizen(_inviter), "Inviter did not registered.");
355         require(_inviter != msg.sender, "Cannot referral yourself");
356         uint id = citizen.register(msg.sender, _userName, _inviter);
357         emit Registered(id, _userName, msg.sender, _inviter);
358     }
359 
360     function showMe() public view returns (uint, string memory, address, address[], uint, uint, uint, uint) {
361         return citizen.showInvestorInfo(msg.sender);
362     }
363 
364     function joinPackageViaEther(uint _rate, address _to) payable public {
365         require(enableJoinPackageViaEther, "Can not buy via Ether now");
366         validateJoinPackage(msg.sender, _to);
367         require(_rate > 0, "Rate must be > 0");
368         validateAmount(_to, (msg.value * _rate) / (10 ** 18));
369         bool rateHigherUnder3Percents = (int(currentETHPrice - _rate).abs() * 100 / _rate) <= uint(3);
370         bool rateLowerUnder5Percents = (int(_rate - currentETHPrice).abs() * 100 / currentETHPrice) <= uint(5);
371         bool validRate = rateHigherUnder3Percents && rateLowerUnder5Percents;
372         require(validRate, "Invalid rate, please check again!");
373         doJoinViaEther(msg.sender, _to, msg.value, _rate);
374     }
375 
376     function joinPackageViaDollar(uint _amount, address _to) public {
377         validateJoinPackage(msg.sender, _to);
378         validateAmount(_to, _amount);
379         validateProfitBalance(msg.sender, _amount);
380         wallet.deposit(_to, _amount, 2, _amount);
381         wallet.bonusForAdminWhenUserBuyPackageViaDollar(_amount / 20, mainAdmin);
382         emit PackageJoinedViaDollar(msg.sender, _to, _amount);
383     }
384 
385     function joinPackageViaToken(uint _amount, address _to) public {
386         validateJoinPackage(msg.sender, _to);
387         validateAmount(_to, _amount);
388         uint tokenAmount = (_amount / aiTokenG2) * (10 ** 18);
389         require(sfuToken.allowance(msg.sender, address(this)) >= tokenAmount, "You must call approve() first");
390         uint userOldBalance = sfuToken.balanceOf(msg.sender);
391         require(userOldBalance >= tokenAmount, "You have not enough tokens");
392         require(sfuToken.transferFrom(msg.sender, address(this), tokenAmount), "Transfer token failed");
393         require(sfuToken.transfer(mainAdmin, tokenAmount / 10), "Transfer token to admin failed");
394         wallet.deposit(_to, _amount, 1, tokenAmount);
395         emit PackageJoinedViaToken(msg.sender, _to, _amount);
396     }
397 
398     function miningToken(uint _tokenAmount) public {
399         require(aiTokenG2 > 0, "Invalid aiTokenG2, please contact admin");
400         require(citizen.isCitizen(msg.sender), "Please register first");
401         validateLockingMiningToken(msg.sender);
402         require(_tokenAmount > miningDifficulty, "Amount must be > miningDifficulty");
403         uint fiatAmount = (_tokenAmount * aiTokenG2) / (10 ** 18);
404         validateProfitBalance(msg.sender, fiatAmount);
405         wallet.validateCanMineToken(fiatAmount, msg.sender);
406 
407         wallet.mineToken(msg.sender, fiatAmount);
408         uint userOldBalance = sfuToken.balanceOf(msg.sender);
409         require(sfuToken.transfer(msg.sender, _tokenAmount), "Transfer token to user failed");
410         require(sfuToken.balanceOf(msg.sender) == userOldBalance + _tokenAmount, "User token changed invalid");
411         emit TokenMined(msg.sender, _tokenAmount, fiatAmount);
412     }
413 
414     function swapToken(uint _amount) public {
415         require(_amount > 0, "Invalid amount to swap");
416         require(sfuToken.balanceOf(msg.sender) >= _amount, "You have not enough balance");
417         uint etherAmount = getEtherAmountFromToken(_amount);
418         require(address(this).balance >= etherAmount, "The contract have not enough balance");
419         require(sfuToken.allowance(msg.sender, address(this)) >= _amount, "You must call approve() first");
420         require(sfuToken.transferFrom(msg.sender, address(this), _amount), "Transfer token failed");
421         msg.sender.transfer(etherAmount);
422         wallet.increaseETHWithdrew(etherAmount);
423         emit TokenSwapped(msg.sender, _amount, etherAmount);
424     }
425 
426     function getCurrentEthPrice() public view returns (uint) {
427         return currentETHPrice;
428     }
429 
430     // PRIVATE FUNCTIONS
431 
432     function getEtherAmountFromToken(uint _amount) private view returns (uint) {
433         require(aiTokenG3 > 0, "Invalid aiTokenG3, please contact admin");
434         return _amount / aiTokenG3;
435     }
436 
437     function doJoinViaEther(address _from, address _to, uint _etherAmountInWei, uint _rate) private {
438         uint etherForAdmin = _etherAmountInWei / 20;
439         uint packageValue = (_etherAmountInWei * _rate) / (10 ** 18);
440         wallet.deposit(_to, packageValue, 0, _etherAmountInWei);
441         mainAdmin.transfer(etherForAdmin);
442         emit PackageJoinedViaEther(_from, _to, packageValue);
443     }
444 
445     function validateAmount(address _user, uint _packageValue) public view {
446         require(_packageValue > 0, "Amount must be > 0");
447         require(_packageValue <= maxJoinPackage, "Can not join with amount that greater max join package");
448         uint lastBuy = wallet.getInvestorLastDeposited(_user);
449         if (lastBuy == 0) {
450             require(_packageValue >= minJoinPackage, "Minimum for first join is $200");
451         } else {
452             require(_packageValue >= lastBuy, "Can not join with amount that lower than your last join");
453         }
454     }
455 
456     function validateJoinPackage(address _from, address _to) private view {
457         require(citizen.isCitizen(_from), "Please register first");
458         require(citizen.isCitizen(_to), "You can only buy for an exists member");
459         if (_from != _to) {
460             require(citizen.checkInvestorsInTheSameReferralTree(_from, _to), "This user isn't in your referral tree");
461         }
462         require(currentETHPrice > 0, "Invalid currentETHPrice, please contact admin!");
463     }
464 
465     function validateLockingMiningToken(address _from) private view {
466         bool canBuy = lockedAccounts[_from] != Lock.MINING_TOKEN && lockedAccounts[_from] != Lock.BOTH;
467         require(canBuy, "Your account get locked from mining token");
468     }
469 
470     function validateProfitBalance(address _user, uint _amount) private view {
471         uint profitBalance = wallet.getProfitBalance(_user);
472         require(profitBalance >= _amount, "You have not enough balance");
473     }
474 }