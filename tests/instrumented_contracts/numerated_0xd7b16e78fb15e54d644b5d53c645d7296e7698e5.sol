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
50 /**
51  * @title SafeMath
52  * @dev Unsigned math operations with safety checks that revert on error.
53  */
54 library SafeMath {
55     /**
56      * @dev Multiplies two unsigned integers, reverts on overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b);
68 
69         return c;
70     }
71 
72     /**
73      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
74      */
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Solidity only automatically asserts when dividing by 0
77         require(b > 0);
78         uint256 c = a / b;
79         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81         return c;
82     }
83 
84     /**
85      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86      */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Adds two unsigned integers, reverts on overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a);
100 
101         return c;
102     }
103 
104     /**
105      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
106      * reverts when dividing by zero.
107      */
108     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109         require(b != 0);
110         return a % b;
111     }
112 }
113 
114 interface ICitizen {
115 
116     function addF1DepositedToInviter(address _invitee, uint _amount) external;
117 
118     function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
119 
120     function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
121 
122     function getF1Deposited(address _investor) external view returns (uint);
123 
124     function getId(address _investor) external view returns (uint);
125 
126     function getInvestorCount() external view returns (uint);
127 
128     function getInviter(address _investor) external view returns (address);
129 
130     function getDirectlyInvitee(address _investor) external view returns (address[]);
131 
132     function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
133 
134     function getNetworkDeposited(address _investor) external view returns (uint);
135 
136     function getRank(address _investor) external view returns (uint);
137 
138     function getRankBonus(uint _index) external view returns (uint);
139 
140     function getUserAddresses(uint _index) external view returns (address);
141 
142     function getSubscribers(address _investor) external view returns (uint);
143 
144     function increaseInviterF1HaveJoinedPackage(address _invitee) external;
145 
146     function isCitizen(address _user) view external returns (bool);
147 
148     function register(address _user, string _userName, address _inviter) external returns (uint);
149 
150     function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
151 }
152 
153 interface IReserveFund {
154 
155     function getLockedStatus(address _investor) view external returns (uint8);
156 
157     function getTransferDifficulty() view external returns (uint);
158 }
159 
160 interface IWalletStore {
161 
162     function makeDailyProfit(address _user, uint dailyProfit) external;
163 
164     function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) external;
165 
166     function increaseETHWithdrew(uint _amount) external;
167 
168     function mineToken(address _from, uint _amount) external;
169 
170     function getProfitPaid() view external returns (uint);
171 
172     function setTotalDeposited(address _investor, uint _totalDeposited) external;
173 
174     function getTotalDeposited(address _investor) view external returns (uint);
175 
176     function pushDeposited(address _investor, uint _deposited) external;
177 
178     function getDeposited(address _investor) view external returns (uint[]);
179 
180     function setProfitableBalance(address _investor, uint _profitableBalance) external;
181 
182     function getProfitableBalance(address _investor) view external returns (uint);
183 
184     function setProfitSourceBalance(address _investor, uint _profitSourceBalance) external;
185 
186     function getProfitSourceBalance(address _investor) view external returns (uint);
187 
188     function setProfitBalance(address _investor, uint _profitBalance) external;
189 
190     function getProfitBalance(address _investor) view external returns (uint);
191 
192     function setTotalProfited(address _investor, uint _totalProfited) external;
193 
194     function getTotalProfited(address _investor) view external returns (uint);
195 
196     function setAmountToMineToken(address _investor, uint _amountToMineToken) external;
197 
198     function getAmountToMineToken(address _investor) view external returns (uint);
199 
200     function getEthWithdrewOfInvestor(address _investor) view external returns (uint);
201 
202     function getEthWithdrew() view external returns (uint);
203 
204     function getUserWallet(address _investor) view external returns (uint, uint[], uint, uint, uint, uint, uint, uint);
205 
206     function getInvestorLastDeposited(address _investor) view external returns (uint);
207 
208     function getF11RewardCondition() view external returns (uint);
209 }
210 
211 contract Wallet is Auth {
212     using SafeMath for uint;
213 
214     IReserveFund private reserveFundContract;
215     ICitizen private citizen;
216     IWalletStore private walletStore;
217 
218     modifier onlyReserveFundContract() {
219         require(msg.sender == address(reserveFundContract), "onlyReserveFundContract");
220         _;
221     }
222 
223     modifier onlyCitizenContract() {
224         require(msg.sender == address(citizen), "onlyCitizenContract");
225         _;
226     }
227 
228     event ProfitBalanceTransferred(address from, address to, uint amount);
229     event RankBonusSent(address investor, uint rank, uint amount);
230     // source: 0-eth 1-token 2-usdt
231     event ProfitSourceBalanceChanged(address investor, int amount, address from, uint8 source);
232     event ProfitableBalanceChanged(address investor, int amount, address from, uint8 source);
233     // source: 0-profit paid 1-active user
234     event ProfitBalanceChanged(address from, address to, int amount, uint8 source);
235 
236     constructor (address _mainAdmin) Auth(_mainAdmin, msg.sender) public {}
237 
238 
239     // ONLY-CONTRACT-ADMIN FUNCTIONS
240 
241     function setReserveFundContract(address _reserveFundContract) onlyContractAdmin public {
242         reserveFundContract = IReserveFund(_reserveFundContract);
243     }
244 
245     function setC(address _citizenContract) onlyContractAdmin public {
246         citizen = ICitizen(_citizenContract);
247     }
248 
249     function setWS(address _walletStore) onlyContractAdmin public {
250         walletStore = IWalletStore(_walletStore);
251     }
252 
253     function updateContractAdmin(address _newAddress) onlyContractAdmin public {
254         transferOwnership(_newAddress);
255     }
256 
257     function makeDailyProfit(address[] _users) onlyContractAdmin public {
258         require(_users.length > 0, "Invalid input");
259         uint investorCount = citizen.getInvestorCount();
260         uint dailyPercent;
261         uint dailyProfit;
262         uint8 lockProfit = 1;
263         uint id;
264         address userAddress;
265         for (uint i = 0; i < _users.length; i++) {
266             id = citizen.getId(_users[i]);
267             require(investorCount > id, "Invalid userId");
268             userAddress = _users[i];
269             if (reserveFundContract.getLockedStatus(userAddress) != lockProfit) {
270                 uint totalDeposited = walletStore.getTotalDeposited(userAddress);
271                 uint profitableBalance = walletStore.getProfitableBalance(userAddress);
272                 uint totalProfited = walletStore.getTotalProfited(userAddress);
273 
274                 dailyPercent = (totalProfited == 0 || totalProfited < totalDeposited) ? 5 : (totalProfited < 4 * totalDeposited) ? 4 : 3;
275                 dailyProfit = profitableBalance.mul(dailyPercent).div(1000);
276 
277                 walletStore.makeDailyProfit(userAddress, dailyProfit);
278                 emit ProfitBalanceChanged(address(0x0), userAddress, int(dailyProfit), 0);
279             }
280         }
281     }
282 
283 
284     // ONLY-MAIN-ADMIN-FUNCTIONS
285     function getProfitPaid() onlyMainAdmin public view returns (uint) {
286         return walletStore.getProfitPaid();
287     }
288 
289     // ONLY-SFU-CONTRACT FUNCTIONS
290     // _source: 0-eth 1-token 2-usdt
291     function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount)
292     onlyReserveFundContract
293     public {
294         require(_to != address(0x0), "User address can not be empty");
295         require(_deposited > 0, "Package value must be > 0");
296 
297         uint totalDeposited = walletStore.getTotalDeposited(_to);
298         uint[] memory deposited = walletStore.getDeposited(_to);
299         uint profitableBalance = walletStore.getProfitableBalance(_to);
300         uint profitSourceBalance = walletStore.getProfitSourceBalance(_to);
301         uint profitBalance = getProfitBalance(_to);
302 
303 
304         bool firstDeposit = deposited.length == 0;
305         walletStore.pushDeposited(_to, _deposited);
306         uint profitableIncreaseAmount = _deposited * (firstDeposit ? 2 : 1);
307         uint profitSourceIncreaseAmount = _deposited * 10;
308         walletStore.setTotalDeposited(_to, totalDeposited.add(_deposited));
309         walletStore.setProfitableBalance(_to, profitableBalance.add(profitableIncreaseAmount));
310         walletStore.setProfitSourceBalance(_to, profitSourceBalance.add(profitSourceIncreaseAmount));
311         if (_source == 2) {
312             if (_to == tx.origin) {
313                 // self deposit
314                 walletStore.setProfitBalance(_to, profitBalance.sub(_deposited));
315             } else {
316                 // deposit to another
317                 uint senderProfitBalance = getProfitBalance(tx.origin);
318                 walletStore.setProfitBalance(tx.origin, senderProfitBalance.sub(_deposited));
319             }
320             emit ProfitBalanceChanged(tx.origin, _to, int(_deposited) * - 1, 1);
321         }
322         citizen.addF1DepositedToInviter(_to, _deposited);
323         addRewardToInviter(_to, _deposited, _source, _sourceAmount);
324 
325         if (firstDeposit) {
326             citizen.increaseInviterF1HaveJoinedPackage(_to);
327         }
328 
329         if (profitableIncreaseAmount > 0) {
330             emit ProfitableBalanceChanged(_to, int(profitableIncreaseAmount), _to, _source);
331             emit ProfitSourceBalanceChanged(_to, int(profitSourceIncreaseAmount), _to, _source);
332         }
333     }
334 
335     // ONLY-CITIZEN-CONTRACT FUNCTIONS
336 
337     function bonusNewRank(address _investor, uint _currentRank, uint _newRank)
338     onlyCitizenContract
339     public {
340         require(_newRank > _currentRank, "Invalid ranks");
341         uint profitBalance = getProfitBalance(_investor);
342 
343         for (uint8 i = uint8(_currentRank) + 1; i <= uint8(_newRank); i++) {
344             uint rankBonusAmount = citizen.getRankBonus(i);
345             walletStore.setProfitBalance(_investor, profitBalance.add(rankBonusAmount));
346             if (rankBonusAmount > 0) {
347                 emit RankBonusSent(_investor, i, rankBonusAmount);
348             }
349         }
350     }
351 
352     // PUBLIC FUNCTIONS
353 
354     function getUserWallet(address _investor)
355     public
356     view
357     returns (uint, uint[], uint, uint, uint, uint, uint, uint)
358     {
359         if (msg.sender != address(reserveFundContract) && msg.sender != contractAdmin && msg.sender != mainAdmin) {
360             require(_investor != mainAdmin, "You can not see admin account");
361         }
362 
363         return walletStore.getUserWallet(_investor);
364     }
365 
366     function getInvestorLastDeposited(address _investor)
367     public
368     view
369     returns (uint) {
370         return walletStore.getInvestorLastDeposited(_investor);
371     }
372 
373     function transferProfitWallet(uint _amount, address _to)
374     public {
375         require(_amount >= reserveFundContract.getTransferDifficulty(), "Amount must be >= minimumTransferProfitBalance");
376         uint profitBalanceOfSender = getProfitBalance(msg.sender);
377 
378         require(citizen.isCitizen(msg.sender), "Please register first");
379         require(citizen.isCitizen(_to), "You can only transfer to an exists member");
380         require(profitBalanceOfSender >= _amount, "You have not enough balance");
381         bool inTheSameTree = citizen.checkInvestorsInTheSameReferralTree(msg.sender, _to);
382         require(inTheSameTree, "This user isn't in your referral tree");
383 
384         uint profitBalanceOfReceiver = getProfitBalance(_to);
385         walletStore.setProfitBalance(msg.sender, profitBalanceOfSender.sub(_amount));
386         walletStore.setProfitBalance(_to, profitBalanceOfReceiver.add(_amount));
387         emit ProfitBalanceTransferred(msg.sender, _to, _amount);
388     }
389 
390     function getProfitBalance(address _investor)
391     public
392     view
393     returns (uint) {
394         return walletStore.getProfitBalance(_investor);
395     }
396 
397     // PRIVATE FUNCTIONS
398 
399     function addRewardToInviter(address _invitee, uint _amount, uint8 _source, uint _sourceAmount)
400     private {
401         address inviter;
402         uint16 referralLevel = 1;
403         do {
404             inviter = citizen.getInviter(_invitee);
405             if (inviter != address(0x0)) {
406                 citizen.addNetworkDepositedToInviter(inviter, _amount, _source, _sourceAmount);
407                 checkAddReward(_invitee, inviter, referralLevel, _source, _amount);
408                 _invitee = inviter;
409                 referralLevel += 1;
410             }
411         }
412         while (inviter != address(0x0));
413     }
414 
415     function checkAddReward(address _invitee, address _inviter, uint16 _referralLevel, uint8 _source, uint _amount)
416     private {
417         if (_referralLevel == 1) {
418             moveBalanceForInviting(_invitee, _inviter, _referralLevel, _source, _amount);
419         } else {
420             uint[] memory deposited = walletStore.getDeposited(_inviter);
421             uint directlyInviteeCount = citizen.getDirectlyInviteeHaveJoinedPackage(_inviter).length;
422 
423             bool condition1 = deposited.length > 0;
424             bool condition2 = directlyInviteeCount >= _referralLevel;
425 
426             if (_referralLevel > 1 && _referralLevel < 11) {
427                 if (condition1 && condition2) {
428                     moveBalanceForInviting(_invitee, _inviter, _referralLevel, _source, _amount);
429                 }
430             } else {
431                 uint f11RewardCondition = walletStore.getF11RewardCondition();
432                 uint totalDeposited = walletStore.getTotalDeposited(_inviter);
433                 uint rank = citizen.getRank(_inviter);
434 
435                 bool condition3 = totalDeposited > f11RewardCondition;
436                 bool condition4 = rank >= 1;
437 
438                 if (condition1 && condition2 && condition3 && condition4) {
439                     moveBalanceForInviting(_invitee, _inviter, _referralLevel, _source, _amount);
440                 }
441             }
442         }
443     }
444 
445     function moveBalanceForInviting(address _invitee, address _inviter, uint16 _referralLevel, uint8 _source, uint _amount)
446     private
447     {
448         uint willMoveAmount = 0;
449         uint profitableBalance = walletStore.getProfitableBalance(_inviter);
450         uint profitSourceBalance = walletStore.getProfitSourceBalance(_inviter);
451         uint profitBalance = getProfitBalance(_inviter);
452 
453         if (_referralLevel == 1) {
454             willMoveAmount = (_amount * 50) / 100;
455             uint reward = (_amount * 3) / 100;
456             walletStore.setProfitBalance(_inviter, profitBalance.add(reward));
457             emit ProfitBalanceChanged(_invitee, _inviter, int(reward), 1);
458         }
459         else if (_referralLevel == 2) {
460             willMoveAmount = (_amount * 20) / 100;
461         } else if (_referralLevel == 3) {
462             willMoveAmount = (_amount * 15) / 100;
463         } else if (_referralLevel == 4 || _referralLevel == 5) {
464             willMoveAmount = (_amount * 10) / 100;
465         } else if (_referralLevel >= 6 && _referralLevel <= 10) {
466             willMoveAmount = (_amount * 5) / 100;
467         } else {
468             willMoveAmount = (_amount * 5) / 100;
469         }
470         if (willMoveAmount == 0) {
471             return;
472         }
473         if (profitSourceBalance > willMoveAmount) {
474             walletStore.setProfitableBalance(_inviter, profitableBalance.add(willMoveAmount));
475             walletStore.setProfitSourceBalance(_inviter, profitSourceBalance.sub(willMoveAmount));
476             notifyMoveSuccess(_invitee, _inviter, _source, willMoveAmount);
477         } else if (willMoveAmount > 0 && profitSourceBalance > 0 && profitSourceBalance <= willMoveAmount) {
478             walletStore.setProfitableBalance(_inviter, profitableBalance.add(profitSourceBalance));
479             walletStore.setProfitSourceBalance(_inviter, 0);
480             notifyMoveSuccess(_invitee, _inviter, _source, profitSourceBalance);
481         }
482     }
483 
484 
485     function notifyMoveSuccess(address _invitee, address _inviter, uint8 _source, uint move)
486     private
487     {
488         emit ProfitableBalanceChanged(_inviter, int(move), _invitee, _source);
489         emit ProfitSourceBalanceChanged(_inviter, int(move) * - 1, _invitee, _source);
490     }
491 
492 }