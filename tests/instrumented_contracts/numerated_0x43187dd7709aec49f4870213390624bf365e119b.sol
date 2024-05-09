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
50 /**
51  * @title SafeMath
52  * @dev Unsigned math operations with safety checks that revert on error.
53  */
54 library SafeMath {
55   /**
56    * @dev Multiplies two unsigned integers, reverts on overflow.
57    */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60     // benefit is lost if 'b' is also tested.
61     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62     if (a == 0) {
63       return 0;
64     }
65 
66     uint256 c = a * b;
67     require(c / a == b);
68 
69     return c;
70   }
71 
72   /**
73    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
74    */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // Solidity only automatically asserts when dividing by 0
77     require(b > 0);
78     uint256 c = a / b;
79     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
80 
81     return c;
82   }
83 
84   /**
85    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
86    */
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     require(b <= a);
89     uint256 c = a - b;
90 
91     return c;
92   }
93 
94   /**
95    * @dev Adds two unsigned integers, reverts on overflow.
96    */
97   function add(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a + b;
99     require(c >= a);
100 
101     return c;
102   }
103 
104   /**
105    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
106    * reverts when dividing by zero.
107    */
108   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109     require(b != 0);
110     return a % b;
111   }
112 }
113 
114 interface ICitizen {
115 
116   function addF1DepositedToInviter(address _invitee, uint _amount) external;
117 
118   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount) external;
119 
120   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
121 
122   function getF1Deposited(address _investor) external view returns (uint);
123 
124   function getId(address _investor) external view returns (uint);
125 
126   function getInvestorCount() external view returns (uint);
127 
128   function getInviter(address _investor) external view returns (address);
129 
130   function getDirectlyInvitee(address _investor) external view returns (address[]);
131 
132   function getDirectlyInviteeHaveJoinedPackage(address _investor) external view returns (address[]);
133 
134   function getNetworkDeposited(address _investor) external view returns (uint);
135 
136   function getRank(address _investor) external view returns (uint);
137 
138   function getRankBonus(uint _index) external view returns (uint);
139 
140   function getUserAddresses(uint _index) external view returns (address);
141 
142   function getSubscribers(address _investor) external view returns (uint);
143 
144   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
145 
146   function isCitizen(address _user) view external returns (bool);
147 
148   function register(address _user, string _userName, address _inviter) external returns (uint);
149 
150   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[], uint, uint, uint, uint);
151 }
152 
153 interface IReserveFund {
154 
155   function getLockedStatus(address _investor) view external returns (uint8);
156 
157   function getTransferDifficulty() view external returns (uint);
158 }
159 
160 contract Wallet is Auth {
161   using SafeMath for uint;
162 
163   struct Balance {
164     // NOTE: balance is counted in mili-dollar (1/1000 dollar)
165     uint totalDeposited; // Treasury package
166     uint[] deposited;
167     uint profitableBalance; // Green wallet
168     uint profitSourceBalance; // Gold wallet
169     uint profitBalance; // Mining wallet
170     uint totalProfited;
171     uint amountToMineToken;
172     uint ethWithdrew;
173   }
174 
175   IReserveFund private reserveFundContract;
176   ICitizen private citizen;
177 
178   uint public ethWithdrew;
179   uint private profitPaid;
180   uint private f11RewardCondition = 200000000; // 200k
181 
182   mapping (address => Balance) private userWallets;
183 
184   modifier onlyReserveFundContract() {
185     require(msg.sender == address(reserveFundContract), "onlyReserveFundContract");
186     _;
187   }
188 
189   modifier onlyCitizenContract() {
190     require(msg.sender == address(citizen), "onlyCitizenContract");
191     _;
192   }
193 
194   event ProfitBalanceTransferred(address from, address to, uint amount);
195   event RankBonusSent(address investor, uint rank, uint amount);
196   // source: 0-eth 1-token 2-usdt
197   event ProfitSourceBalanceChanged(address investor, int amount, address from, uint8 source);
198   event ProfitableBalanceChanged(address investor, int amount, address from, uint8 source);
199   // source: 0-profit paid 1-active user
200   event ProfitBalanceChanged(address from, address to, int amount, uint8 source);
201 
202   constructor (address _mainAdmin, address _citizen)
203   Auth(_mainAdmin, msg.sender)
204   public
205   {
206     citizen = ICitizen(_citizen);
207   }
208 
209   // ONLY-MAIN-ADMIN-FUNCTIONS
210   function getProfitPaid() onlyMainAdmin public view returns(uint) {
211     return profitPaid;
212   }
213 
214   // ONLY-CONTRACT-ADMIN FUNCTIONS
215 
216   function setDABankContract(address _reserveFundContract) onlyContractAdmin public {
217     reserveFundContract = IReserveFund(_reserveFundContract);
218   }
219 
220   function makeDailyProfit(address[] _userAddresses) onlyContractAdmin public {
221     require(_userAddresses.length > 0, "Invalid input");
222     uint investorCount = citizen.getInvestorCount();
223     uint dailyPercent;
224     uint dailyProfit;
225     uint8 lockProfit = 1;
226     uint id;
227     address userAddress;
228     for (uint i = 0; i < _userAddresses.length; i++) {
229       id = citizen.getId(_userAddresses[i]);
230       require(investorCount > id, "Invalid userId");
231       userAddress = _userAddresses[i];
232       if (reserveFundContract.getLockedStatus(userAddress) != lockProfit) {
233         Balance storage balance = userWallets[userAddress];
234         dailyPercent = (balance.totalProfited == 0 || balance.totalProfited < balance.totalDeposited) ? 5 : (balance.totalProfited < 4 * balance.totalDeposited) ? 4 : 3;
235         dailyProfit = balance.profitableBalance.mul(dailyPercent).div(1000);
236 
237         balance.profitableBalance = balance.profitableBalance.sub(dailyProfit);
238         balance.profitBalance = balance.profitBalance.add(dailyProfit);
239         balance.totalProfited = balance.totalProfited.add(dailyProfit);
240         profitPaid = profitPaid.add(dailyProfit);
241         emit ProfitBalanceChanged(address(0x0), userAddress, int(dailyProfit), 0);
242       }
243     }
244   }
245 
246   // ONLY-DABANK-CONTRACT FUNCTIONS
247   // _source: 0-eth 1-token 2-usdt
248   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) onlyReserveFundContract public {
249     require(_to != address(0x0), "User address can not be empty");
250     require(_deposited > 0, "Package value must be > 0");
251 
252     Balance storage balance = userWallets[_to];
253     bool firstDeposit = balance.deposited.length == 0;
254     balance.deposited.push(_deposited);
255     uint profitableIncreaseAmount = _deposited * (firstDeposit ? 2 : 1);
256     uint profitSourceIncreaseAmount = _deposited * 8;
257     balance.totalDeposited = balance.totalDeposited.add(_deposited);
258     balance.profitableBalance = balance.profitableBalance.add(profitableIncreaseAmount);
259     balance.profitSourceBalance = balance.profitSourceBalance.add(_deposited * 8);
260     if (_source == 2) {
261       if (_to == tx.origin) {
262         // self deposit
263         balance.profitBalance = balance.profitBalance.sub(_deposited);
264       } else {
265         // deposit to another
266         Balance storage senderBalance = userWallets[tx.origin];
267         senderBalance.profitBalance = senderBalance.profitBalance.sub(_deposited);
268       }
269       emit ProfitBalanceChanged(tx.origin, _to, int(_deposited) * -1, 1);
270     }
271     citizen.addF1DepositedToInviter(_to, _deposited);
272     addRewardToInviters(_to, _deposited, _source, _sourceAmount);
273 
274     if (firstDeposit) {
275       citizen.increaseInviterF1HaveJoinedPackage(_to);
276     }
277 
278     if (profitableIncreaseAmount > 0) {
279       emit ProfitableBalanceChanged(_to, int(profitableIncreaseAmount), _to, _source);
280       emit ProfitSourceBalanceChanged(_to, int(profitSourceIncreaseAmount), _to, _source);
281     }
282   }
283 
284   function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) onlyReserveFundContract public {
285     Balance storage adminBalance = userWallets[_admin];
286     adminBalance.profitBalance = adminBalance.profitBalance.add(_amount);
287   }
288 
289   function increaseETHWithdrew(uint _amount) onlyReserveFundContract public {
290     ethWithdrew = ethWithdrew.add(_amount);
291   }
292 
293   function mineToken(address _from, uint _amount) onlyReserveFundContract public {
294     Balance storage userBalance = userWallets[_from];
295     userBalance.profitBalance = userBalance.profitBalance.sub(_amount);
296     userBalance.amountToMineToken = userBalance.amountToMineToken.add(_amount);
297   }
298 
299   function validateCanMineToken(uint _tokenAmount, address _from) onlyReserveFundContract public view {
300     Balance storage userBalance = userWallets[_from];
301     require(userBalance.amountToMineToken.add(_tokenAmount) <= 4 * userBalance.totalDeposited, "You can only mine maximum 4x of your total deposited");
302   }
303 
304   // ONLY-CITIZEN-CONTRACT FUNCTIONS
305 
306   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) onlyCitizenContract public {
307     require(_newRank > _currentRank, "Invalid ranks");
308     Balance storage balance = userWallets[_investorAddress];
309     for (uint8 i = uint8(_currentRank) + 1; i <= uint8(_newRank); i++) {
310       uint rankBonusAmount = citizen.getRankBonus(i);
311       balance.profitBalance = balance.profitBalance.add(rankBonusAmount);
312       if (rankBonusAmount > 0) {
313         emit RankBonusSent(_investorAddress, i, rankBonusAmount);
314       }
315     }
316   }
317 
318   // PUBLIC FUNCTIONS
319 
320   function getUserWallet(address _investor)
321   public
322   view
323   returns (uint, uint[], uint, uint, uint, uint, uint)
324   {
325     if (msg.sender != address(reserveFundContract) && msg.sender != contractAdmin && msg.sender != mainAdmin) {
326       require(_investor != mainAdmin, "You can not see admin account");
327     }
328     Balance storage balance = userWallets[_investor];
329     return (
330       balance.totalDeposited,
331       balance.deposited,
332       balance.profitableBalance,
333       balance.profitSourceBalance,
334       balance.profitBalance,
335       balance.totalProfited,
336       balance.ethWithdrew
337     );
338   }
339 
340   function getInvestorLastDeposited(address _investor) public view returns (uint) {
341     return userWallets[_investor].deposited.length == 0 ? 0 : userWallets[_investor].deposited[userWallets[_investor].deposited.length - 1];
342   }
343 
344   function transferProfitWallet(uint _amount, address _to) public {
345     require(_amount >= reserveFundContract.getTransferDifficulty(), "Amount must be >= minimumTransferProfitBalance");
346     Balance storage senderBalance = userWallets[msg.sender];
347     require(citizen.isCitizen(msg.sender), "Please register first");
348     require(citizen.isCitizen(_to), "You can only transfer to an exists member");
349     require(senderBalance.profitBalance >= _amount, "You have not enough balance");
350     bool inTheSameTree = citizen.checkInvestorsInTheSameReferralTree(msg.sender, _to);
351     require(inTheSameTree, "This user isn't in your referral tree");
352     Balance storage receiverBalance = userWallets[_to];
353     senderBalance.profitBalance = senderBalance.profitBalance.sub(_amount);
354     receiverBalance.profitBalance = receiverBalance.profitBalance.add(_amount);
355     emit ProfitBalanceTransferred(msg.sender, _to, _amount);
356   }
357 
358   function getProfitBalance(address _investor) public view returns (uint) {
359     return userWallets[_investor].profitBalance;
360   }
361 
362   // PRIVATE FUNCTIONS
363 
364   function addRewardToInviters(address _invitee, uint _amount, uint8 _source, uint _sourceAmount) private {
365     address inviter;
366     uint16 referralLevel = 1;
367     do {
368       inviter = citizen.getInviter(_invitee);
369       if (inviter != address(0x0)) {
370         citizen.addNetworkDepositedToInviter(inviter, _amount, _source, _sourceAmount);
371         checkAddReward(_invitee, inviter, referralLevel, _source, _amount);
372         _invitee = inviter;
373         referralLevel += 1;
374       }
375     } while (inviter != address(0x0));
376   }
377 
378   function checkAddReward(address _invitee,address _inviter, uint16 _referralLevel, uint8 _source, uint _amount) private {
379     uint f1Deposited = citizen.getF1Deposited(_inviter);
380     uint networkDeposited = citizen.getNetworkDeposited(_inviter);
381     uint directlyInviteeCount = citizen.getDirectlyInviteeHaveJoinedPackage(_inviter).length;
382     uint rank = citizen.getRank(_inviter);
383     if (_referralLevel == 1) {
384       moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
385     } else if (_referralLevel > 1 && _referralLevel < 11) {
386       bool condition1 = userWallets[_inviter].deposited.length > 0 ? f1Deposited >= userWallets[_inviter].deposited[0] * 3 : false;
387       bool condition2 = directlyInviteeCount >= _referralLevel;
388       if (condition1 && condition2) {
389         moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
390       }
391     } else {
392       condition1 = userWallets[_inviter].deposited.length > 0 ? f1Deposited >= userWallets[_inviter].deposited[0] * 3: false;
393       condition2 = directlyInviteeCount >= 10;
394       bool condition3 = networkDeposited >= f11RewardCondition;
395       bool condition4 = rank >= 3;
396       if (condition1 && condition2 && condition3 && condition4) {
397         moveBalanceForInvitingSuccessful(_invitee, _inviter, _referralLevel, _source, _amount);
398       }
399     }
400   }
401 
402   function moveBalanceForInvitingSuccessful(address _invitee, address _inviter, uint16 _referralLevel, uint8 _source, uint _amount) private {
403     uint divider = (_referralLevel == 1) ? 2 : (_referralLevel > 1 && _referralLevel < 11) ? 10 : 20;
404     Balance storage balance = userWallets[_inviter];
405     uint willMoveAmount = _amount / divider;
406     if (balance.profitSourceBalance > willMoveAmount) {
407       balance.profitableBalance = balance.profitableBalance.add(willMoveAmount);
408       balance.profitSourceBalance = balance.profitSourceBalance.sub(willMoveAmount);
409       if (willMoveAmount > 0) {
410         emit ProfitableBalanceChanged(_inviter, int(willMoveAmount), _invitee, _source);
411         emit ProfitSourceBalanceChanged(_inviter, int(willMoveAmount) * -1, _invitee, _source);
412       }
413     } else {
414       if (balance.profitSourceBalance > 0) {
415         emit ProfitableBalanceChanged(_inviter, int(balance.profitSourceBalance), _invitee, _source);
416         emit ProfitSourceBalanceChanged(_inviter, int(balance.profitSourceBalance) * -1, _invitee, _source);
417       }
418       balance.profitableBalance = balance.profitableBalance.add(balance.profitSourceBalance);
419       balance.profitSourceBalance = 0;
420     }
421   }
422 }