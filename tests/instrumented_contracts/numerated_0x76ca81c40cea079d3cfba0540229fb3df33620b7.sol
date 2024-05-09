1 pragma solidity 0.4.25;
2 
3 contract Auth {
4 
5   address internal mainAdmin;
6   address internal contractAdmin;
7 
8   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
9 
10   constructor(
11     address _mainAdmin,
12     address _contractAdmin
13   )
14   internal
15   {
16     mainAdmin = _mainAdmin;
17     contractAdmin = _contractAdmin;
18   }
19 
20   modifier onlyAdmin() {
21     require(isMainAdmin() || isContractAdmin(), "onlyAdmin");
22     _;
23   }
24 
25   modifier onlyMainAdmin() {
26     require(isMainAdmin(), "onlyMainAdmin");
27     _;
28   }
29 
30   modifier onlyContractAdmin() {
31     require(isContractAdmin(), "onlyContractAdmin");
32     _;
33   }
34 
35   function transferOwnership(address _newOwner) onlyContractAdmin internal {
36     require(_newOwner != address(0x0));
37     contractAdmin = _newOwner;
38     emit OwnershipTransferred(msg.sender, _newOwner);
39   }
40 
41   function isMainAdmin() public view returns (bool) {
42     return msg.sender == mainAdmin;
43   }
44 
45   function isContractAdmin() public view returns (bool) {
46     return msg.sender == contractAdmin;
47   }
48 }
49 
50 library Math {
51   function abs(int number) internal pure returns (uint) {
52     if (number < 0) {
53       return uint(number * -1);
54     }
55     return uint(number);
56   }
57 }
58 
59 library StringUtil {
60   struct slice {
61     uint _length;
62     uint _pointer;
63   }
64 
65   function validateUserName(string memory _username)
66   internal
67   pure
68   returns (bool)
69   {
70     uint8 len = uint8(bytes(_username).length);
71     if ((len < 4) || (len > 18)) return false;
72 
73     // only contain A-Z 0-9
74     for (uint8 i = 0; i < len; i++) {
75       if (
76         (uint8(bytes(_username)[i]) < 48) ||
77         (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
78         (uint8(bytes(_username)[i]) > 90)
79       ) return false;
80     }
81     // First char != '0'
82     return uint8(bytes(_username)[0]) != 48;
83   }
84 }
85 
86 interface IWallet {
87 
88   function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) external;
89 
90   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
91 
92   function mineToken(address _from, uint _amount) external;
93 
94   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
95 
96   function getInvestorLastDeposited(address _investor) external view returns (uint);
97 
98   function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
99 
100   function getProfitBalance(address _investor) external view returns (uint);
101 
102   function increaseETHWithdrew(uint _amount) external;
103 
104   function validateCanMineToken(uint _tokenAmount, address _from) external view;
105 }
106 
107 interface ICitizen {
108 
109   function addF1DepositedToInviter(address _invitee, uint _amount) external;
110 
111   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
112 
113   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
114 
115   function getF1Deposited(address _investor) external view returns (uint);
116 
117   function getId(address _investor) external view returns (uint);
118 
119   function getInvestorCount() external view returns (uint);
120 
121   function getInviter(address _investor) external view returns (address);
122 
123   function getDirectlyInvitee(address _investor) external view returns (address[]);
124 
125   function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
126 
127   function getNetworkDeposited(address _investor) external view returns (uint);
128 
129   function getRank(address _investor) external view returns (uint);
130 
131   function getRankBonus(uint _index) external view returns (uint);
132 
133   function getUserAddresses(uint _index) external view returns (address);
134 
135   function getSubscribers(address _investor) external view returns (uint);
136 
137   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
138 
139   function isCitizen(address _user) view external returns (bool);
140 
141   function register(address _user, string _userName, address _inviter) external returns (uint);
142 
143   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://eips.ethereum.org/EIPS/eip-20
149  */
150 contract IERC20 {
151     function transfer(address to, uint256 value) public returns (bool);
152 
153     function approve(address spender, uint256 value) public returns (bool);
154 
155     function transferFrom(address from, address to, uint256 value) public returns (bool);
156 
157     function balanceOf(address who) public view returns (uint256);
158 
159     function allowance(address owner, address spender) public view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 contract ReserveFund is Auth {
167   using StringUtil for *;
168   using Math for int;
169 
170   enum Lock {
171     UNLOCKED,
172     PROFIT,
173     MINING_TOKEN,
174     BOTH
175   }
176 
177   mapping(address => Lock) public lockedAccounts;
178   uint private miningDifficulty = 200000; // $200
179   uint private transferDifficulty = 1000; // $1
180   uint private aiTokenG3; // 1 ETH = aiTokenG3 DAB
181   uint public aiTokenG2; // in mili-dollar (1/1000 dollar)
182   uint public minJoinPackage = 200000; // $200
183   uint public maxJoinPackage = 5000000; // $5k
184   uint public currentETHPrice;
185   bool public enableJoinPackageViaEther = true;
186 
187   ICitizen private citizen;
188   IWallet private wallet;
189   IERC20 public dabToken;
190 
191   event AccountsLocked(address[] addresses, uint8 lockingType);
192   event AITokenG2Set(uint rate);
193   event AITokenG3Set(uint rate);
194   event ETHPriceSet(uint ethPrice);
195   event EnableJoinPackageViaEtherSwitched(bool enabled);
196   event EtherPriceUpdated(uint currentETHPrice);
197   event MinJoinPackageSet(uint minJoinPackage);
198   event MaxJoinPackageSet(uint maxJoinPackage);
199   event MiningDifficultySet(uint rate);
200   event TransferDifficultySet(uint value);
201   event PackageJoinedViaEther(address buyer, address receiver, uint amount);
202   event PackageJoinedViaToken(address buyer, address receiver, uint amount);
203   event PackageJoinedViaDollar(address buyer, address receiver, uint amount);
204   event Registered(uint id, string userName, address userAddress, address inviter);
205   event TokenMined(address buyer, uint amount, uint walletAmount);
206   event TokenSwapped(address seller, uint amount, uint ethAmount);
207 
208   constructor (
209     address _citizen,
210     address _wallet,
211     address _mainAdmin,
212     uint _currentETHPrice
213   )
214   Auth(_mainAdmin, msg.sender)
215   public
216   {
217     citizen = ICitizen(_citizen);
218     wallet = IWallet(_wallet);
219     currentETHPrice = _currentETHPrice;
220   }
221 
222   // ADMINS FUNCTIONS
223 
224   function setDABankingToken(address _dabToken) onlyAdmin public {
225     dabToken = IERC20(_dabToken);
226   }
227 
228   function updateETHPrice(uint _currentETHPrice) onlyAdmin public {
229     require(_currentETHPrice > 0, "Must be > 0");
230     require(_currentETHPrice != currentETHPrice, "Must be new value");
231     currentETHPrice = _currentETHPrice;
232     emit ETHPriceSet(currentETHPrice);
233   }
234 
235   function updateContractAdmin(address _newAddress) onlyAdmin public {
236     transferOwnership(_newAddress);
237   }
238 
239   function setMinJoinPackage(uint _minJoinPackage) onlyAdmin public {
240     require(_minJoinPackage > 0, "Must be > 0");
241     require(_minJoinPackage < maxJoinPackage, "Must be < maxJoinPackage");
242     require(_minJoinPackage != minJoinPackage, "Must be new value");
243     minJoinPackage = _minJoinPackage;
244     emit MinJoinPackageSet(minJoinPackage);
245   }
246 
247   function setMaxJoinPackage(uint _maxJoinPackage) onlyAdmin public {
248     require(_maxJoinPackage > minJoinPackage, "Must be > minJoinPackage");
249     require(_maxJoinPackage != maxJoinPackage, "Must be new value");
250     maxJoinPackage = _maxJoinPackage;
251     emit MaxJoinPackageSet(maxJoinPackage);
252   }
253 
254   function setEnableJoinPackageViaEther(bool _enableJoinPackageViaEther) onlyAdmin public {
255     require(_enableJoinPackageViaEther != enableJoinPackageViaEther, "Must be new value");
256     enableJoinPackageViaEther = _enableJoinPackageViaEther;
257     emit EnableJoinPackageViaEtherSwitched(enableJoinPackageViaEther);
258   }
259 
260   function aiSetTokenG2(uint _rate) onlyAdmin public {
261     require(_rate > 0, "aiTokenG2 must be > 0");
262     require(_rate != aiTokenG2, "aiTokenG2 must be new value");
263     aiTokenG2 = _rate;
264     emit AITokenG2Set(aiTokenG2);
265   }
266 
267   function aiSetTokenG3(uint _rate) onlyAdmin public {
268     require(_rate > 0, "aiTokenG3 must be > 0");
269     require(_rate != aiTokenG3, "aiTokenG3 must be new value");
270     aiTokenG3 = _rate;
271     emit AITokenG3Set(aiTokenG3);
272   }
273 
274   function setMiningDifficulty(uint _miningDifficulty) onlyAdmin public {
275     require(_miningDifficulty > 0, "miningDifficulty must be > 0");
276     require(_miningDifficulty != miningDifficulty, "miningDifficulty must be new value");
277     miningDifficulty = _miningDifficulty;
278     emit MiningDifficultySet(miningDifficulty);
279   }
280 
281   function setTransferDifficulty(uint _transferDifficulty) onlyAdmin public {
282     require(_transferDifficulty > 0, "MinimumBuy must be > 0");
283     require(_transferDifficulty != transferDifficulty, "transferDifficulty must be new value");
284     transferDifficulty = _transferDifficulty;
285     emit TransferDifficultySet(transferDifficulty);
286   }
287 
288   function lockAccounts(address[] _addresses, uint8 _type) onlyAdmin public {
289     require(_addresses.length > 0, "Address cannot be empty");
290     require(_addresses.length <= 256, "Maximum users per action is 256");
291     require(_type >= 0 && _type <= 3, "Type is invalid");
292     for (uint8 i = 0; i < _addresses.length; i++) {
293       require(_addresses[i] != msg.sender, "You cannot lock yourself");
294       lockedAccounts[_addresses[i]] = Lock(_type);
295     }
296     emit AccountsLocked(_addresses, _type);
297   }
298 
299   // PUBLIC FUNCTIONS
300 
301   function () public payable {}
302 
303   function getAITokenG3() view public returns (uint) {
304     return aiTokenG3;
305   }
306 
307   function getMiningDifficulty() view public returns (uint) {
308     return miningDifficulty;
309   }
310 
311   function getTransferDifficulty() view public returns (uint) {
312     return transferDifficulty;
313   }
314 
315   function getLockedStatus(address _investor) view public returns (uint8) {
316     return uint8(lockedAccounts[_investor]);
317   }
318 
319   function register(string memory _userName, address _inviter) public {
320     require(citizen.isCitizen(_inviter), "Inviter did not registered.");
321     require(_inviter != msg.sender, "Cannot referral yourself");
322     uint id = citizen.register(msg.sender, _userName, _inviter);
323     emit Registered(id, _userName, msg.sender, _inviter);
324   }
325 
326   function showMe() public view returns (uint, string memory, address, address[], uint, uint, uint, uint) {
327     return citizen.showInvestorInfo(msg.sender);
328   }
329 
330   function joinPackageViaEther(uint _rate, address _to) payable public {
331     require(enableJoinPackageViaEther, "Can not buy via Ether now");
332     validateJoinPackage(msg.sender, _to);
333     require(_rate > 0, "Rate must be > 0");
334     validateAmount(_to, (msg.value * _rate) / (10 ** 18));
335     bool rateHigherUnder3Percents = (int(currentETHPrice - _rate).abs() * 100 / _rate) <= uint(3);
336     bool rateLowerUnder5Percents = (int(_rate - currentETHPrice).abs() * 100 / currentETHPrice) <= uint(5);
337     bool validRate = rateHigherUnder3Percents && rateLowerUnder5Percents;
338     require(validRate, "Invalid rate, please check again!");
339     doJoinViaEther(msg.sender, _to, msg.value, _rate);
340   }
341 
342   function joinPackageViaDollar(uint _amount, address _to) public {
343     validateJoinPackage(msg.sender, _to);
344     validateAmount(_to, _amount);
345     validateProfitBalance(msg.sender, _amount);
346     wallet.deposit(_to, _amount, 2, _amount);
347     wallet.bonusForAdminWhenUserBuyPackageViaDollar(_amount / 10, mainAdmin);
348     emit PackageJoinedViaDollar(msg.sender, _to, _amount);
349   }
350 
351   function joinPackageViaToken(uint _amount, address _to) public {
352     validateJoinPackage(msg.sender, _to);
353     validateAmount(_to, _amount);
354     uint tokenAmount = (_amount / aiTokenG2) * (10 ** 18);
355     require(dabToken.allowance(msg.sender, address(this)) >= tokenAmount, "You must call approve() first");
356     uint userOldBalance = dabToken.balanceOf(msg.sender);
357     require(userOldBalance >= tokenAmount, "You have not enough tokens");
358     require(dabToken.transferFrom(msg.sender, address(this), tokenAmount), "Transfer token failed");
359     require(dabToken.transfer(mainAdmin, tokenAmount / 10), "Transfer token to admin failed");
360     wallet.deposit(_to, _amount, 1, tokenAmount);
361     emit PackageJoinedViaToken(msg.sender, _to, _amount);
362   }
363 
364   function miningToken(uint _tokenAmount) public {
365     require(aiTokenG2 > 0, "Invalid aiTokenG2, please contact admin");
366     require(citizen.isCitizen(msg.sender), "Please register first");
367     validateLockingMiningToken(msg.sender);
368     require(_tokenAmount > miningDifficulty, "Amount must be > miningDifficulty");
369     uint fiatAmount = (_tokenAmount * aiTokenG2) / (10 ** 18);
370     validateProfitBalance(msg.sender, fiatAmount);
371     wallet.validateCanMineToken(fiatAmount, msg.sender);
372 
373     wallet.mineToken(msg.sender, fiatAmount);
374     uint userOldBalance = dabToken.balanceOf(msg.sender);
375     require(dabToken.transfer(msg.sender, _tokenAmount), "Transfer token to user failed");
376     require(dabToken.balanceOf(msg.sender) == userOldBalance + _tokenAmount, "User token changed invalid");
377     emit TokenMined(msg.sender, _tokenAmount, fiatAmount);
378   }
379 
380   function swapToken(uint _amount) public {
381     require(_amount > 0, "Invalid amount to swap");
382     require(dabToken.balanceOf(msg.sender) >= _amount, "You have not enough balance");
383     uint etherAmount = getEtherAmountFromToken(_amount);
384     require(address(this).balance >= etherAmount, "The contract have not enough balance");
385     require(dabToken.allowance(msg.sender, address(this)) >= _amount, "You must call approve() first");
386     require(dabToken.transferFrom(msg.sender, address(this), _amount), "Transfer token failed");
387     msg.sender.transfer(etherAmount);
388     wallet.increaseETHWithdrew(etherAmount);
389     emit TokenSwapped(msg.sender, _amount, etherAmount);
390   }
391 
392   function getCurrentEthPrice() public view returns (uint) {
393     return currentETHPrice;
394   }
395 
396   // PRIVATE FUNCTIONS
397 
398   function getEtherAmountFromToken(uint _amount) private view returns (uint) {
399     require(aiTokenG3 > 0, "Invalid aiTokenG3, please contact admin");
400     return _amount / aiTokenG3;
401   }
402 
403   function doJoinViaEther(address _from, address _to, uint _etherAmountInWei, uint _rate) private {
404     uint etherForAdmin = _etherAmountInWei / 10;
405     uint packageValue = (_etherAmountInWei * _rate) / (10 ** 18);
406     wallet.deposit(_to, packageValue, 0, _etherAmountInWei);
407     mainAdmin.transfer(etherForAdmin);
408     emit PackageJoinedViaEther(_from, _to, packageValue);
409   }
410 
411   function validateAmount(address _user, uint _packageValue) private view {
412     require(_packageValue > 0, "Amount must be > 0");
413     require(_packageValue <= maxJoinPackage, "Can not join with amount that greater max join package");
414     uint lastBuy = wallet.getInvestorLastDeposited(_user);
415     if (lastBuy == 0) {
416       require(_packageValue >= minJoinPackage, "Minimum for first join is $200");
417     } else {
418       require(_packageValue >= lastBuy, "Can not join with amount that lower than your last join");
419     }
420   }
421 
422   function validateJoinPackage(address _from, address _to) private view {
423     require(citizen.isCitizen(_from), "Please register first");
424     require(citizen.isCitizen(_to), "You can only buy for an exists member");
425     if (_from != _to) {
426       require(citizen.checkInvestorsInTheSameReferralTree(_from, _to), "This user isn't in your referral tree");
427     }
428     require(currentETHPrice > 0, "Invalid currentETHPrice, please contact admin!");
429   }
430 
431   function validateLockingMiningToken(address _from) private view {
432     bool canBuy = lockedAccounts[_from] != Lock.MINING_TOKEN && lockedAccounts[_from] != Lock.BOTH;
433     require(canBuy, "Your account get locked from mining token");
434   }
435 
436   function validateProfitBalance(address _user, uint _amount) private view {
437     uint profitBalance = wallet.getProfitBalance(_user);
438     require(profitBalance >= _amount, "You have not enough balance");
439   }
440 }