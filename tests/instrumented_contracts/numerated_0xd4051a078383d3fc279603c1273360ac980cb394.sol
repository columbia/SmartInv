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
20     require(c / a == b);
21 
22     return c;
23   }
24 
25   /**
26    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27    */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // Solidity only automatically asserts when dividing by 0
30     require(b > 0);
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
41     require(b <= a);
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
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59    * reverts when dividing by zero.
60    */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 library UnitConverter {
68   using SafeMath for uint256;
69 
70   function stringToBytes24(string memory source)
71   internal
72   pure
73   returns (bytes24 result)
74   {
75     bytes memory tempEmptyStringTest = bytes(source);
76     if (tempEmptyStringTest.length == 0) {
77       return 0x0;
78     }
79 
80     assembly {
81       result := mload(add(source, 24))
82     }
83   }
84 }
85 
86 library StringUtil {
87   struct slice {
88     uint _length;
89     uint _pointer;
90   }
91 
92   function validateUserName(string memory _username)
93   internal
94   pure
95   returns (bool)
96   {
97     uint8 len = uint8(bytes(_username).length);
98     if ((len < 4) || (len > 18)) return false;
99 
100     // only contain A-Z 0-9
101     for (uint8 i = 0; i < len; i++) {
102       if (
103         (uint8(bytes(_username)[i]) < 48) ||
104         (uint8(bytes(_username)[i]) > 57 && uint8(bytes(_username)[i]) < 65) ||
105         (uint8(bytes(_username)[i]) > 90)
106       ) return false;
107     }
108     // First char != '0'
109     return uint8(bytes(_username)[0]) != 48;
110   }
111 }
112 
113 contract Auth {
114 
115   address internal mainAdmin;
116   address internal contractAdmin;
117 
118   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
119 
120   constructor(
121     address _mainAdmin,
122     address _contractAdmin
123   )
124   internal
125   {
126     mainAdmin = _mainAdmin;
127     contractAdmin = _contractAdmin;
128   }
129 
130   modifier onlyAdmin() {
131     require(isMainAdmin() || isContractAdmin(), "onlyAdmin");
132     _;
133   }
134 
135   modifier onlyMainAdmin() {
136     require(isMainAdmin(), "onlyMainAdmin");
137     _;
138   }
139 
140   modifier onlyContractAdmin() {
141     require(isContractAdmin(), "onlyContractAdmin");
142     _;
143   }
144 
145   function transferOwnership(address _newOwner) onlyContractAdmin internal {
146     require(_newOwner != address(0x0));
147     contractAdmin = _newOwner;
148     emit OwnershipTransferred(msg.sender, _newOwner);
149   }
150 
151   function isMainAdmin() public view returns (bool) {
152     return msg.sender == mainAdmin;
153   }
154 
155   function isContractAdmin() public view returns (bool) {
156     return msg.sender == contractAdmin;
157   }
158 }
159 
160 library ArrayUtil {
161 
162   function tooLargestValues(uint[] array) internal pure returns (uint max, uint subMax) {
163     require(array.length >= 2, "Invalid array length");
164     max = array[0];
165     for (uint i = 1; i < array.length; i++) {
166       if (array[i] > max) {
167         subMax = max;
168         max = array[i];
169       } else if (array[i] > subMax) {
170         subMax = array[i];
171       }
172     }
173   }
174 }
175 
176 interface IWallet {
177 
178   function bonusForAdminWhenUserBuyPackageViaDollar(uint _amount, address _admin) external;
179 
180   function bonusNewRank(address _investorAddress, uint _currentRank, uint _newRank) external;
181 
182   function mineToken(address _from, uint _amount) external;
183 
184   function deposit(address _to, uint _deposited, uint8 _source, uint _sourceAmount) external;
185 
186   function getInvestorLastDeposited(address _investor) external view returns (uint);
187 
188   function getUserWallet(address _investor) external view returns (uint, uint[], uint, uint, uint, uint, uint);
189 
190   function getProfitBalance(address _investor) external view returns (uint);
191 
192   function increaseETHWithdrew(uint _amount) external;
193 
194   function validateCanMineToken(uint _tokenAmount, address _from) external view;
195 }
196 
197 contract Citizen is Auth {
198   using ArrayUtil for uint256[];
199   using StringUtil for string;
200   using UnitConverter for string;
201   using SafeMath for uint;
202 
203   enum Rank {
204     UnRanked,
205     Star1,
206     Star2,
207     Star3,
208     Star4,
209     Star5,
210     Star6,
211     Star7,
212     Star8,
213     Star9,
214     Star10
215   }
216 
217   enum DepositType {
218     Ether,
219     Token,
220     Dollar
221   }
222 
223   uint[11] public rankCheckPoints = [
224     0,
225     1000000,
226     3000000,
227     10000000,
228     40000000,
229     100000000,
230     300000000,
231     1000000000,
232     2000000000,
233     5000000000,
234     10000000000
235   ];
236 
237   uint[11] public rankBonuses = [
238     0,
239     0,
240     0,
241     0,
242     1000000, // $1k
243     2000000,
244     6000000,
245     20000000,
246     50000000,
247     150000000,
248     500000000 // $500k
249   ];
250 
251   struct Investor {
252     uint id;
253     string userName;
254     address inviter;
255     address[] directlyInvitee;
256     address[] directlyInviteeHaveJoinedPackage;
257     uint f1Deposited;
258     uint networkDeposited;
259     uint networkDepositedViaETH;
260     uint networkDepositedViaToken;
261     uint networkDepositedViaDollar;
262     uint subscribers;
263     Rank rank;
264   }
265 
266   address private reserveFundContract;
267   IWallet private walletContract;
268 
269   mapping (address => Investor) private investors;
270   mapping (bytes24 => address) private userNameAddresses;
271   address[] private userAddresses;
272 
273   modifier onlyWalletContract() {
274     require(msg.sender == address(walletContract), "onlyWalletContract");
275     _;
276   }
277 
278   modifier onlyReserveFundContract() {
279     require(msg.sender == address(reserveFundContract), "onlyReserveFundContract");
280     _;
281   }
282 
283   event RankAchieved(address investor, uint currentRank, uint newRank);
284 
285   constructor(address _mainAdmin) Auth(_mainAdmin, msg.sender) public {
286     setupAdminAccount();
287   }
288 
289   // ONLY-CONTRACT-ADMIN FUNCTIONS
290 
291   function setWalletContract(address _walletContract) onlyContractAdmin public {
292     walletContract = IWallet(_walletContract);
293   }
294 
295   function setDABankContract(address _reserveFundContract) onlyContractAdmin public {
296     reserveFundContract = _reserveFundContract;
297   }
298 
299   // ONLY-DABANK-CONTRACT FUNCTIONS
300 
301   function register(address _user, string memory _userName, address _inviter)
302   onlyReserveFundContract
303   public
304   returns
305   (uint)
306   {
307     require(_userName.validateUserName(), "Invalid username");
308     Investor storage investor = investors[_user];
309     require(!isCitizen(_user), "Already an citizen");
310     bytes24 _userNameAsKey = _userName.stringToBytes24();
311     require(userNameAddresses[_userNameAsKey] == address(0x0), "Username already exist");
312     userNameAddresses[_userNameAsKey] = _user;
313 
314     investor.id = userAddresses.length;
315     investor.userName = _userName;
316     investor.inviter = _inviter;
317     investor.rank = Rank.UnRanked;
318     increaseInvitersSubscribers(_inviter);
319     increaseInviterF1(_inviter, _user);
320     userAddresses.push(_user);
321     return investor.id;
322   }
323 
324   function showInvestorInfo(address _investorAddress)
325   onlyReserveFundContract
326   public
327   view
328   returns (uint, string memory, address, address[], uint, uint, uint, Citizen.Rank)
329   {
330     Investor storage investor = investors[_investorAddress];
331     return (
332       investor.id,
333       investor.userName,
334       investor.inviter,
335       investor.directlyInvitee,
336       investor.f1Deposited,
337       investor.networkDeposited,
338       investor.subscribers,
339       investor.rank
340     );
341   }
342 
343   // ONLY-WALLET-CONTRACT FUNCTIONS
344 
345   function addF1DepositedToInviter(address _invitee, uint _amount)
346   onlyWalletContract
347   public
348   {
349     address inviter = investors[_invitee].inviter;
350     investors[inviter].f1Deposited = investors[inviter].f1Deposited.add(_amount);
351     assert(investors[inviter].f1Deposited > 0);
352   }
353 
354   // _source: 0-eth 1-token 2-usdt
355   function addNetworkDepositedToInviter(address _inviter, uint _amount, uint _source, uint _sourceAmount)
356   onlyWalletContract
357   public
358   {
359     require(_inviter != address(0x0), "Invalid inviter address");
360     require(_amount >= 0, "Invalid deposit amount");
361     require(_source >= 0 && _source <= 2, "Invalid deposit source");
362     require(_sourceAmount >= 0, "Invalid source amount");
363     investors[_inviter].networkDeposited = investors[_inviter].networkDeposited.add(_amount);
364     if (_source == 0) {
365       investors[_inviter].networkDepositedViaETH = investors[_inviter].networkDepositedViaETH.add(_sourceAmount);
366     } else if (_source == 1) {
367       investors[_inviter].networkDepositedViaToken = investors[_inviter].networkDepositedViaToken.add(_sourceAmount);
368     } else {
369       investors[_inviter].networkDepositedViaDollar = investors[_inviter].networkDepositedViaDollar.add(_sourceAmount);
370     }
371   }
372 
373   function increaseInviterF1HaveJoinedPackage(address _invitee)
374   public
375   onlyWalletContract
376   {
377     address _inviter = getInviter(_invitee);
378     investors[_inviter].directlyInviteeHaveJoinedPackage.push(_invitee);
379   }
380 
381   // PUBLIC FUNCTIONS
382 
383   function updateRanking() public {
384     Investor storage investor = investors[msg.sender];
385     Rank currentRank = investor.rank;
386     require(investor.directlyInviteeHaveJoinedPackage.length > 2, "Invalid condition to make ranking");
387     require(currentRank < Rank.Star10, "Congratulations! You have reached max rank");
388     uint investorRevenueToCheckRank = getInvestorRankingRevenue(msg.sender);
389     Rank newRank;
390     for(uint8 k = uint8(currentRank) + 1; k <= uint8(Rank.Star10); k++) {
391       if(investorRevenueToCheckRank >= rankCheckPoints[k]) {
392         newRank = getRankFromIndex(k);
393       }
394     }
395     if (newRank > currentRank) {
396       walletContract.bonusNewRank(msg.sender, uint(currentRank), uint(newRank));
397       investor.rank = newRank;
398       emit RankAchieved(msg.sender, uint(currentRank), uint(newRank));
399     }
400   }
401 
402   function getInvestorRankingRevenue(address _investor) public view returns (uint) {
403     Investor storage investor = investors[_investor];
404     if (investor.directlyInviteeHaveJoinedPackage.length <= 2) {
405       return 0;
406     }
407     uint[] memory f1NetworkDeposited = new uint[](investor.directlyInviteeHaveJoinedPackage.length);
408     uint sumF1NetworkDeposited = 0;
409     for (uint j = 0; j < investor.directlyInviteeHaveJoinedPackage.length; j++) {
410       f1NetworkDeposited[j] = investors[investor.directlyInviteeHaveJoinedPackage[j]].networkDeposited;
411       sumF1NetworkDeposited = sumF1NetworkDeposited.add(f1NetworkDeposited[j]);
412     }
413     uint max;
414     uint subMax;
415     (max, subMax) = f1NetworkDeposited.tooLargestValues();
416     return sumF1NetworkDeposited.sub(max).sub(subMax);
417   }
418 
419   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee)
420   public
421   view
422   returns (bool)
423   {
424     require(_inviter != _invitee, "They are the same");
425     bool inTheSameTreeDownLine = checkInTheSameReferralTree(_inviter, _invitee);
426     bool inTheSameTreeUpLine = checkInTheSameReferralTree(_invitee, _inviter);
427     return inTheSameTreeDownLine || inTheSameTreeUpLine;
428   }
429 
430   function getInviter(address _investor) public view returns (address) {
431     return investors[_investor].inviter;
432   }
433 
434   function getDirectlyInvitee(address _investor) public view returns (address[]) {
435     return investors[_investor].directlyInvitee;
436   }
437 
438   function getDirectlyInviteeHaveJoinedPackage(address _investor) public view returns (address[]) {
439     return investors[_investor].directlyInviteeHaveJoinedPackage;
440   }
441 
442   function getDepositInfo(address _investor) public view returns (uint, uint, uint, uint, uint) {
443     return (
444       investors[_investor].f1Deposited,
445       investors[_investor].networkDeposited,
446       investors[_investor].networkDepositedViaETH,
447       investors[_investor].networkDepositedViaToken,
448       investors[_investor].networkDepositedViaDollar
449     );
450   }
451 
452   function getF1Deposited(address _investor) public view returns (uint) {
453     return investors[_investor].f1Deposited;
454   }
455 
456   function getNetworkDeposited(address _investor) public view returns (uint) {
457     return investors[_investor].networkDeposited;
458   }
459 
460   function getId(address _investor) public view returns (uint) {
461     return investors[_investor].id;
462   }
463 
464   function getUserName(address _investor) public view returns (string) {
465     return investors[_investor].userName;
466   }
467 
468   function getRank(address _investor) public view returns (Rank) {
469     return investors[_investor].rank;
470   }
471 
472   function getUserAddresses(uint _index) public view returns (address) {
473     require(_index >= 0 && _index < userAddresses.length, "Index must be >= 0 or < getInvestorCount()");
474     return userAddresses[_index];
475   }
476 
477   function getSubscribers(address _investor) public view returns (uint) {
478     return investors[_investor].subscribers;
479   }
480 
481   function isCitizen(address _user) view public returns (bool) {
482     Investor storage investor = investors[_user];
483     return bytes(investor.userName).length > 0;
484   }
485 
486   function getInvestorCount() public view returns (uint) {
487     return userAddresses.length;
488   }
489 
490   function getRankBonus(uint _index) public view returns (uint) {
491     return rankBonuses[_index];
492   }
493 
494   // PRIVATE FUNCTIONS
495 
496   function setupAdminAccount() private {
497     string memory _mainAdminUserName = "ADMIN";
498     bytes24 _mainAdminUserNameAsKey = _mainAdminUserName.stringToBytes24();
499     userNameAddresses[_mainAdminUserNameAsKey] = mainAdmin;
500     Investor storage mainAdminInvestor = investors[mainAdmin];
501     mainAdminInvestor.id = userAddresses.length;
502     mainAdminInvestor.userName = _mainAdminUserName;
503     mainAdminInvestor.inviter = 0x0;
504     mainAdminInvestor.rank = Rank.UnRanked;
505     userAddresses.push(mainAdmin);
506   }
507 
508   function increaseInviterF1(address _inviter, address _invitee) private {
509     investors[_inviter].directlyInvitee.push(_invitee);
510   }
511 
512   function checkInTheSameReferralTree(address _from, address _to) private view returns (bool) {
513     do {
514       Investor storage investor = investors[_from];
515       if (investor.inviter == _to) {
516         return true;
517       }
518       _from = investor.inviter;
519     } while (investor.inviter != 0x0);
520     return false;
521   }
522 
523   function increaseInvitersSubscribers(address _inviter) private {
524     do {
525       investors[_inviter].subscribers += 1;
526       _inviter = investors[_inviter].inviter;
527     } while (_inviter != address(0x0));
528   }
529 
530   function getRankFromIndex(uint8 _index) private pure returns (Rank rank) {
531     require(_index >= 0 && _index <= 10, "Invalid index");
532     if (_index == 1) {
533       return Rank.Star1;
534     } else if (_index == 2) {
535       return Rank.Star2;
536     } else if (_index == 3) {
537       return Rank.Star3;
538     } else if (_index == 4) {
539       return Rank.Star4;
540     } else if (_index == 5) {
541       return Rank.Star5;
542     } else if (_index == 6) {
543       return Rank.Star6;
544     } else if (_index == 7) {
545       return Rank.Star7;
546     } else if (_index == 8) {
547       return Rank.Star8;
548     } else if (_index == 9) {
549       return Rank.Star9;
550     } else if (_index == 10) {
551       return Rank.Star10;
552     } else {
553       return Rank.UnRanked;
554     }
555   }
556 }