1 pragma solidity ^0.4.24;
2 
3 /*
4 *__/\\\\____________/\\\\________________/\\\\____________/\\\\________/\\\\\\_____/\\\\\\___________________________________________________
5 * _\/\\\\\\________/\\\\\\_______________\/\\\\\\________/\\\\\\_______\////\\\____\////\\\___________________________________________________
6 *  _\/\\\//\\\____/\\\//\\\____/\\\__/\\\_\/\\\//\\\____/\\\//\\\__/\\\____\/\\\_______\/\\\_____/\\\__________________________________________
7 *   _\/\\\\///\\\/\\\/_\/\\\___\//\\\/\\\__\/\\\\///\\\/\\\/_\/\\\_\///_____\/\\\_______\/\\\____\///______/\\\\\_____/\\/\\\\\\____/\\\\\\\\\\_
8 *    _\/\\\__\///\\\/___\/\\\____\//\\\\\___\/\\\__\///\\\/___\/\\\__/\\\____\/\\\_______\/\\\_____/\\\___/\\\///\\\__\/\\\////\\\__\/\\\//////__
9 *     _\/\\\____\///_____\/\\\_____\//\\\____\/\\\____\///_____\/\\\_\/\\\____\/\\\_______\/\\\____\/\\\__/\\\__\//\\\_\/\\\__\//\\\_\/\\\\\\\\\\_
10 *      _\/\\\_____________\/\\\__/\\_/\\\_____\/\\\_____________\/\\\_\/\\\____\/\\\_______\/\\\____\/\\\_\//\\\__/\\\__\/\\\___\/\\\_\////////\\\_
11 *       _\/\\\_____________\/\\\_\//\\\\/______\/\\\_____________\/\\\_\/\\\__/\\\\\\\\\__/\\\\\\\\\_\/\\\__\///\\\\\/___\/\\\___\/\\\__/\\\\\\\\\\_
12 *        _\///______________\///___\////________\///______________\///__\///__\/////////__\/////////__\///_____\/////_____\///____\///__\//////////__
13 */
14 
15 contract Ownable {
16     address public owner;
17     address public developers = 0x0c05aE835f26a8d4a89Ae80c7A0e5495e5361ca1;
18     address public marketers = 0xE222Dd2DD012FCAC0256B1f3830cc033418B6889;
19     uint256 public constant developersPercent = 1;
20     uint256 public constant marketersPercent = 14;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23     event DevelopersChanged(address indexed previousDevelopers, address indexed newDevelopers);
24     event MarketersChanged(address indexed previousMarketers, address indexed newMarketers);
25 
26     function Ownable() public {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     modifier onlyThisOwner(address _owner) {
36         require(owner == _owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46     function setDevelopers(address newDevelopers) public onlyOwner {
47         require(newDevelopers != address(0));
48         emit DevelopersChanged(developers, newDevelopers);
49         developers = newDevelopers;
50     }
51 
52     function setMarketers(address newMarketers) public onlyOwner {
53         require(newMarketers != address(0));
54         emit MarketersChanged(marketers, newMarketers);
55         marketers = newMarketers;
56     }
57 
58 }
59 
60 library SafeMath {
61     function mul(uint256 _a, uint256 _b) internal pure returns(uint256) {
62         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
63         // benefit is lost if 'b' is also tested.
64         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
65         if (_a == 0) {
66             return 0;
67         }
68 
69         uint256 c = _a * _b;
70         require(c / _a == _b);
71 
72         return c;
73     }
74 
75     function div(uint256 _a, uint256 _b) internal pure returns(uint256) {
76         require(_b > 0); // Solidity only automatically asserts when dividing by 0
77         uint256 c = _a / _b;
78         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
79 
80         return c;
81     }
82 
83     function sub(uint256 _a, uint256 _b) internal pure returns(uint256) {
84         require(_b <= _a);
85         uint256 c = _a - _b;
86 
87         return c;
88     }
89 
90     function add(uint256 _a, uint256 _b) internal pure returns(uint256) {
91         uint256 c = _a + _b;
92         require(c >= _a);
93 
94         return c;
95     }
96 
97     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
98         require(b != 0);
99         return a % b;
100     }
101 }
102 
103 library Math {
104     function max(uint a, uint b) returns (uint) {
105         if (a > b) return a;
106         else return b;
107     }
108     function min(uint a, uint b) returns (uint) {
109         if (a < b) return a;
110         else return b;
111     }
112 }
113 
114 contract LeaderSystem {
115     using SafeMath for uint256;
116 
117     event NewLeader(uint256 _indexTable, address _addr, uint256 _index, uint256 _sum);
118     event LeadersClear(uint256 _indexTable);
119 
120     uint8 public constant leadersCount = 7;
121     mapping (uint8 => uint256) public leaderBonuses;
122 
123     struct LeadersTable {
124         uint256 timestampEnd;              // timestamp of closing table
125         uint256 duration;                   // duration compute
126         uint256 minSum;                     // min sum of leaders
127         address[] leaders;                  // leaders array
128         mapping (address => uint256) users; // sum all users
129     }
130 
131     LeadersTable[] public leaders;
132 
133     function setupLeaderSystemModule() internal {
134         leaderBonuses[0] = 10;  // 10%
135         leaderBonuses[1] = 7;   // 7%
136         leaderBonuses[2] = 5;   // 5%
137         leaderBonuses[3] = 3;   // 3%
138         leaderBonuses[4] = 1;   // 1%
139         leaderBonuses[5] = 0;   // 0%
140         leaderBonuses[6] = 0;   // 0%
141 
142         leaders.push(LeadersTable(now + 86400, 86400, 0, new address[](0)));
143         leaders.push(LeadersTable(now + 604800, 604800, 0, new address[](0)));
144         leaders.push(LeadersTable(now + 77760000, 77760000, 0, new address[](0)));
145         leaders.push(LeadersTable(now + 31536000, 31536000, 0, new address[](0)));
146     }
147 
148     function _clearLeadersTable(uint256 _indexTable) internal {
149         LeadersTable storage _leader = leaders[_indexTable];
150         leaders[_indexTable] = LeadersTable(_leader.timestampEnd + _leader.duration, _leader.duration, 0, new address[](0));
151 
152         emit LeadersClear(_indexTable);
153     }
154 
155     function quickSort(LeadersTable storage leader, int left, int right) internal {
156         int i = left;
157         int j = right;
158         if (i == j) return;
159         uint pivot = leader.users[leader.leaders[uint(left + (right - left) / 2)]];
160         while (i <= j) {
161             while (leader.users[leader.leaders[uint(i)]] > pivot) i++;
162             while (pivot > leader.users[leader.leaders[uint(j)]]) j--;
163             if (i <= j) {
164                 (leader.leaders[uint(i)], leader.leaders[uint(j)]) = (leader.leaders[uint(j)], leader.leaders[uint(i)]);
165                 i++;
166                 j--;
167             }
168         }
169         if (left < j)
170             quickSort(leader, left, j);
171         if (i < right)
172             quickSort(leader, i, right);
173     }
174 
175     function _updateLeadersTable(uint256 i, address _addr, uint256 _value) internal {
176         if (now > leaders[i].timestampEnd) _clearLeadersTable(i);
177 
178         LeadersTable storage leader = leaders[i];
179         bool isExist = leader.users[_addr] >= leader.minSum;
180 
181         uint256 oldSum = leader.users[_addr];
182         uint256 newSum = oldSum.add(_value);
183         leader.users[_addr] = newSum;
184 
185         if (newSum < leader.minSum && leader.leaders.length == leadersCount) return;
186 
187         if (!isExist || leader.leaders.length == 0) leader.leaders.push(_addr);
188 
189         if (leader.leaders.length > 1) quickSort(leader, 0, int256(leader.leaders.length - 1));
190         if (leader.leaders.length > leadersCount) {
191             delete leader.leaders[leadersCount - 1];
192         }
193 
194         leader.minSum = leader.users[leader.leaders[leader.leaders.length - 1]];
195     }
196 
197     function _updateLeaders(address _addr, uint256 _value) internal {
198         for (uint i = 0; i < leaders.length; i++) {
199             _updateLeadersTable(i, _addr, _value);
200         }
201     }
202 
203     function getLeadersTableInfo(uint256 _indexTable) public view returns(uint256, uint256, uint256) {
204         return (leaders[_indexTable].timestampEnd, leaders[_indexTable].duration, leaders[_indexTable].minSum);
205     }
206 
207     function getLeaders(uint256 _indexTable) public view returns(address[], uint256[]) {
208         LeadersTable storage leader = leaders[_indexTable];
209         uint256[] memory balances = new uint256[](leader.leaders.length);
210 
211         for (uint i = 0; i < leader.leaders.length; i++) {
212             balances[i] = leader.users[leader.leaders[i]];
213         }
214 
215         return (leader.leaders, balances);
216     }
217 
218 }
219 
220 contract Factoring {
221 
222     enum FactoryType { Wood, Metal, Oil, PreciousMetal }
223 
224     mapping (uint8 => uint256) public resourcePrices;
225 
226     function setupFactoringModule() internal {
227         resourcePrices[uint8(FactoryType.Wood)]         = 0.02315 szabo;
228         resourcePrices[uint8(FactoryType.Metal)]        = 0.03646 szabo;
229         resourcePrices[uint8(FactoryType.Oil)]          = 0.04244 szabo;
230         resourcePrices[uint8(FactoryType.PreciousMetal)]= 0.06655 szabo;
231     }
232 
233     function getResourcePrice(uint8 _type) public view returns(uint256) {
234         return resourcePrices[_type];
235     }
236 
237 }
238 
239 contract Improvements is Factoring {
240 
241     mapping (uint8 => mapping (uint8 => Params)) public levelStack;
242     uint8 public constant levelsCount = 7;
243 
244     struct Params {
245         uint256 price;      // improvements cost
246         uint256 ppm;        // products per minute
247         uint256 ppmBonus;   // bonus per minute
248     }
249 
250     function setupImprovementsModule() internal {
251         // initial pricess
252         levelStack[uint8(FactoryType.Wood)][0]          = Params(0.01 ether, 200, 0);
253         levelStack[uint8(FactoryType.Metal)][0]         = Params(0.03 ether, 400, 0);
254         levelStack[uint8(FactoryType.Oil)][0]           = Params(0.05 ether, 600, 0);
255         levelStack[uint8(FactoryType.PreciousMetal)][0] = Params(0.10 ether, 800, 0);
256 
257         // level 1
258         levelStack[uint8(FactoryType.Wood)][1]          = Params(0.05 ether, 1200, 120);
259         levelStack[uint8(FactoryType.Metal)][1]         = Params(0.09 ether, 1600, 138);
260         levelStack[uint8(FactoryType.Oil)][1]           = Params(0.15 ether, 2400, 164);
261         levelStack[uint8(FactoryType.PreciousMetal)][1] = Params(0.50 ether, 4800, 418);
262 
263         // level 2
264         levelStack[uint8(FactoryType.Wood)][2]          = Params(0.12 ether, 3600, 540);
265         levelStack[uint8(FactoryType.Metal)][2]         = Params(0.27 ether, 5200, 866);
266         levelStack[uint8(FactoryType.Oil)][2]           = Params(0.35 ether, 6600, 1050);
267         levelStack[uint8(FactoryType.PreciousMetal)][2] = Params(1.00 ether, 12800, 1670);
268 
269         // level 3
270         levelStack[uint8(FactoryType.Wood)][3]          = Params(0.30 ether, 9600, 2400);
271         levelStack[uint8(FactoryType.Metal)][3]         = Params(0.75 ether, 15200, 3980);
272         levelStack[uint8(FactoryType.Oil)][3]           = Params(1.15 ether, 20400, 5099);
273         levelStack[uint8(FactoryType.PreciousMetal)][3] = Params(3.50 ether, 40800, 11531);
274 
275         // level 4
276         levelStack[uint8(FactoryType.Wood)][4]          = Params(0.90 ether, 27600, 9660);
277         levelStack[uint8(FactoryType.Metal)][4]         = Params(2.13 ether, 43600, 15568);
278         levelStack[uint8(FactoryType.Oil)][4]           = Params(3.00 ether, 56400, 17943);
279         levelStack[uint8(FactoryType.PreciousMetal)][4] = Params(7.00 ether, 96800, 31567);
280 
281         // level 5
282         levelStack[uint8(FactoryType.Wood)][5]          = Params(1.80 ether, 63600, 25440);
283         levelStack[uint8(FactoryType.Metal)][5]         = Params(5.31 ether, 114400, 49022);
284         levelStack[uint8(FactoryType.Oil)][5]           = Params(7.30 ether, 144000, 55629);
285         levelStack[uint8(FactoryType.PreciousMetal)][5] = Params(17.10 ether, 233600, 96492);
286 
287         // level 6
288         levelStack[uint8(FactoryType.Wood)][6]          = Params(5.40 ether, 171600, 85800);
289         levelStack[uint8(FactoryType.Metal)][6]         = Params(13.89 ether, 298400, 158120);
290         levelStack[uint8(FactoryType.Oil)][6]           = Params(24.45 ether, 437400, 218674);
291         levelStack[uint8(FactoryType.PreciousMetal)][6] = Params(55.50 ether, 677600, 353545);
292     }
293 
294     function getPrice(FactoryType _type, uint8 _level) public view returns(uint256) {
295         return levelStack[uint8(_type)][_level].price;
296     }
297 
298     function getProductsPerMinute(FactoryType _type, uint8 _level) public view returns(uint256) {
299         return levelStack[uint8(_type)][_level].ppm;
300     }
301 
302     function getBonusPerMinute(FactoryType _type, uint8 _level) public view returns(uint256) {
303         return levelStack[uint8(_type)][_level].ppmBonus;
304     }
305 }
306 
307 contract ReferralsSystem {
308 
309     struct ReferralGroup {
310         uint256 minSum;
311         uint256 maxSum;
312         uint16[] percents;
313     }
314 
315     uint256 public constant minSumReferral = 0.01 ether;
316     uint256 public constant referralLevelsGroups = 3;
317     uint256 public constant referralLevelsCount = 5;
318     ReferralGroup[] public referralGroups;
319 
320     function setupReferralsSystemModule() internal {
321         ReferralGroup memory refGroupFirsty = ReferralGroup(minSumReferral, 10 ether - 1 wei, new uint16[](referralLevelsCount));
322         refGroupFirsty.percents[0] = 300;   // 3%
323         refGroupFirsty.percents[1] = 75;    // 0.75%
324         refGroupFirsty.percents[2] = 60;    // 0.6%
325         refGroupFirsty.percents[3] = 40;    // 0.4%
326         refGroupFirsty.percents[4] = 25;    // 0.25%
327         referralGroups.push(refGroupFirsty);
328 
329         ReferralGroup memory refGroupLoyalty = ReferralGroup(10 ether, 50 ether - 1 wei, new uint16[](referralLevelsCount));
330         refGroupLoyalty.percents[0] = 500;  // 5%
331         refGroupLoyalty.percents[1] = 200;  // 2%
332         refGroupLoyalty.percents[2] = 150;  // 1.5%
333         refGroupLoyalty.percents[3] = 100;  // 1%
334         refGroupLoyalty.percents[4] = 50;   // 0.5%
335         referralGroups.push(refGroupLoyalty);
336 
337         ReferralGroup memory refGroupUltraPremium = ReferralGroup(50 ether, 2**256 - 1, new uint16[](referralLevelsCount));
338         refGroupUltraPremium.percents[0] = 700; // 7%
339         refGroupUltraPremium.percents[1] = 300; // 3%
340         refGroupUltraPremium.percents[2] = 250; // 2.5%
341         refGroupUltraPremium.percents[3] = 150; // 1.5%
342         refGroupUltraPremium.percents[4] = 100; // 1%
343         referralGroups.push(refGroupUltraPremium);
344     }
345 
346     function getReferralPercents(uint256 _sum) public view returns(uint16[]) {
347         for (uint i = 0; i < referralLevelsGroups; i++) {
348             ReferralGroup memory group = referralGroups[i];
349             if (_sum >= group.minSum && _sum <= group.maxSum) return group.percents;
350         }
351     }
352 
353     function getReferralPercentsByIndex(uint256 _index) public view returns(uint16[]) {
354         return referralGroups[_index].percents;
355     }
356 
357 }
358 
359 /// @title Smart-contract of MyMillions ecosystem
360 /// @author Shagaleev Alexey
361 contract MyMillions is Ownable, Improvements, ReferralsSystem, LeaderSystem {
362     using SafeMath for uint256;
363 
364     event CreateUser(uint256 _index, address _address, uint256 _balance);
365     event ReferralRegister(uint256 _refferalId, uint256 _userId);
366     event ReferrerDistribute(uint256 _userId, uint256 _referrerId, uint256 _sum);
367     event Deposit(uint256 _userId, uint256 _value);
368     event PaymentProceed(uint256 _userId, uint256 _factoryId, FactoryType _factoryType, uint256 _price);
369     event CollectResources(FactoryType _type, uint256 _resources);
370     event LevelUp(uint256 _factoryId, uint8 _newLevel, uint256 _userId, uint256 _price);
371     event Sell(uint256 _userId, uint8 _type, uint256 _sum);
372 
373     bool isSetted = false;
374     uint256 public minSumDeposit = 0.01 ether;
375 
376     struct User {
377         address addr;                                   // user address
378         uint256 balance;                                // balance of account
379         uint256 totalPay;                               // sum of all input pay
380         uint256 referrersReceived;                      // total deposit from referrals
381         uint256[] resources;                            // collected resources
382         uint256[] referrersByLevel;                     // referrers user ids
383         mapping (uint8 => uint256[]) referralsByLevel;  // all referrals user ids
384     }
385 
386     User[] public users;
387     mapping (address => uint256) public addressToUser;
388     uint256 public totalUsers = 0;
389     uint256 public totalDeposit = 0;
390 
391     struct Factory {
392         FactoryType ftype;      // factory type
393         uint8 level;            // factory level
394         uint256 collected_at;   // timestamp updated
395     }
396 
397     Factory[] public factories;
398     mapping (uint256 => uint256) public factoryToUser;
399     mapping (uint256 => uint256[]) public userToFactories;
400 
401     modifier onlyExistingUser() {
402         require(addressToUser[msg.sender] != 0);
403         _;
404     }
405     modifier onlyNotExistingUser() {
406         require(addressToUser[msg.sender] == 0);
407         _;
408     }
409 
410     constructor() public payable {
411         users.push(User(0x0, 0, 0, 0, new uint256[](4), new uint256[](referralLevelsCount)));  // for find by addressToUser map
412     }
413 
414     function setup() public onlyOwner {
415         require(isSetted == false);
416         isSetted = true;
417 
418         setupFactoringModule();
419         setupImprovementsModule();
420         setupReferralsSystemModule();
421         setupLeaderSystemModule();
422     }
423 
424     // @dev register for only new users with min pay
425     /// @return id of new user
426     function register() public payable onlyNotExistingUser returns(uint256) {
427         require(addressToUser[msg.sender] == 0);
428 
429         uint256 index = users.push(User(msg.sender, msg.value, 0, 0, new uint256[](4), new uint256[](referralLevelsCount))) - 1;
430         addressToUser[msg.sender] = index;
431         totalUsers++;
432 
433         emit CreateUser(index, msg.sender, msg.value);
434         return index;
435     }
436 
437 
438     /// @notice just registry by referral link
439     /// @param _refId the ID of the user who gets the affiliate fee
440     /// @return id of new user
441     function registerWithRefID(uint256 _refId) public payable onlyNotExistingUser returns(uint256) {
442         require(_refId < users.length);
443 
444         uint256 index = register();
445         _updateReferrals(index, _refId);
446 
447         emit ReferralRegister(_refId, index);
448         return index;
449     }
450 
451     /// @notice update referrersByLevel and referralsByLevel of new user
452     /// @param _newUserId the ID of the new user
453     /// @param _refUserId the ID of the user who gets the affiliate fee
454     function _updateReferrals(uint256 _newUserId, uint256 _refUserId) private {
455         if (_newUserId == _refUserId) return;
456         users[_newUserId].referrersByLevel[0] = _refUserId;
457 
458         for (uint i = 1; i < referralLevelsCount; i++) {
459             uint256 _refId = users[_refUserId].referrersByLevel[i - 1];
460             users[_newUserId].referrersByLevel[i] = _refId;
461             users[_refId].referralsByLevel[uint8(i)].push(_newUserId);
462         }
463 
464         users[_refUserId].referralsByLevel[0].push(_newUserId);
465     }
466 
467     /// @notice distribute value of tx to referrers of user
468     /// @param _userId the ID of the user who gets the affiliate fee
469     /// @param _sum value of ethereum for distribute to referrers of user
470     function _distributeReferrers(uint256 _userId, uint256 _sum) private {
471         uint256[] memory referrers = users[_userId].referrersByLevel;
472 
473         for (uint i = 0; i < referralLevelsCount; i++) {
474             uint256 referrerId = referrers[i];
475 
476             if (referrers[i] == 0) break;
477             if (users[referrerId].totalPay < minSumReferral) continue;
478 
479             uint16[] memory percents = getReferralPercents(users[referrerId].totalPay);
480             uint256 value = _sum * percents[i] / 10000;
481             users[referrerId].balance = users[referrerId].balance.add(value);
482             users[referrerId].referrersReceived = users[referrerId].referrersReceived.add(value);
483 
484             emit ReferrerDistribute(_userId, referrerId, value);
485         }
486     }
487 
488     /// @notice deposit ethereum for user
489     /// @return balance value of user
490     function deposit() public payable onlyExistingUser returns(uint256) {
491         require(msg.value > minSumDeposit, "Deposit does not enough");
492         uint256 userId = addressToUser[msg.sender];
493         users[userId].balance = users[userId].balance.add(msg.value);
494         totalDeposit += msg.value;
495 
496         // distribute
497         _distributeInvestment(msg.value);
498         _updateLeaders(msg.sender, msg.value);
499 
500         emit Deposit(userId, msg.value);
501         return users[userId].balance;
502     }
503 
504     /// @notice getter for balance of user
505     /// @return balance value of user
506     function balanceOf() public view returns (uint256) {
507         return users[addressToUser[msg.sender]].balance;
508     }
509 
510     /// @notice getter for resources of user
511     /// @return resources value of user
512     function resoucesOf() public view returns (uint256[]) {
513         return users[addressToUser[msg.sender]].resources;
514     }
515 
516     /// @notice getter for referrers of user
517     /// @return array of referrers id
518     function referrersOf() public view returns (uint256[]) {
519         return users[addressToUser[msg.sender]].referrersByLevel;
520     }
521 
522     /// @notice getter for referrals of user by level
523     /// @param _level level of referrals user needed
524     /// @return array of referrals id
525     function referralsOf(uint8 _level) public view returns (uint256[]) {
526         return users[addressToUser[msg.sender]].referralsByLevel[uint8(_level)];
527     }
528 
529     /// @notice getter for extended information of user
530     /// @param _userId id of user needed
531     /// @return address of user
532     /// @return balance of user
533     /// @return totalPay of user
534     /// @return array of resources user
535     /// @return array of referrers id user
536     function userInfo(uint256 _userId) public view returns(address, uint256, uint256, uint256, uint256[], uint256[]) {
537         User memory user = users[_userId];
538         return (user.addr, user.balance, user.totalPay, user.referrersReceived, user.resources, user.referrersByLevel);
539     }
540 
541     /// @notice mechanics of buying any factory
542     /// @param _type type of factory needed
543     /// @return id of new factory
544     function buyFactory(FactoryType _type) public payable onlyExistingUser returns (uint256) {
545         uint256 userId = addressToUser[msg.sender];
546 
547         // if user not registered
548         if (addressToUser[msg.sender] == 0)
549             userId = register();
550 
551         return _paymentProceed(userId, Factory(_type, 0, now));
552     }
553 
554     /// @notice get factories of user
555     /// @param _user_id id of user
556     /// @return array of id factory
557     function getFactories(uint256 _user_id) public view returns (uint256[]) {
558         return userToFactories[_user_id];
559     }
560 
561     /// @notice buy wood factory
562     /// @dev wrapper over buyFactory for FactoryType.Wood
563     /// @return id of new factory
564     function buyWoodFactory() public payable returns (uint256) {
565         return buyFactory(FactoryType.Wood);
566     }
567 
568     /// @notice buy wood factory
569     /// @dev wrapper over buyFactory for FactoryType.Metal
570     /// @return id of new factory
571     function buyMetalFactory() public payable returns (uint256) {
572         return buyFactory(FactoryType.Metal);
573     }
574 
575     /// @notice buy wood factory
576     /// @dev wrapper over buyFactory for FactoryType.Oil
577     /// @return id of new factory
578     function buyOilFactory() public payable returns (uint256) {
579         return buyFactory(FactoryType.Oil);
580     }
581 
582     /// @notice buy wood factory
583     /// @dev wrapper over buyFactory for FactoryType.PreciousMetal
584     /// @return id of new factory
585     function buyPreciousMetal() public payable returns (uint256) {
586         return buyFactory(FactoryType.PreciousMetal);
587     }
588 
589     /// @notice distribute investment when user buy anything
590     /// @param _value value of investment
591     function _distributeInvestment(uint256 _value) private {
592         developers.transfer(msg.value * developersPercent / 100);
593         marketers.transfer(msg.value * marketersPercent / 100);
594     }
595 
596     /// @notice function of proceed payment
597     /// @dev for only buy new factory
598     /// @return id of new factory
599     function _paymentProceed(uint256 _userId, Factory _factory) private returns(uint256) {
600         User storage user = users[_userId];
601 
602         require(_checkPayment(user, _factory.ftype, _factory.level));
603 
604         uint256 price = getPrice(_factory.ftype, 0);
605         user.balance = user.balance.add(msg.value);
606         user.balance = user.balance.sub(price);
607         user.totalPay = user.totalPay.add(price);
608         totalDeposit += msg.value;
609 
610         uint256 index = factories.push(_factory) - 1;
611         factoryToUser[index] = _userId;
612         userToFactories[_userId].push(index);
613 
614         // distribute
615         _distributeInvestment(msg.value);
616         _distributeReferrers(_userId, price);
617         _updateLeaders(msg.sender, msg.value);
618 
619         emit PaymentProceed(_userId, index, _factory.ftype, price);
620         return index;
621     }
622 
623     /// @notice check available investment
624     /// @return true if user does enough balance for investment
625     function _checkPayment(User _user, FactoryType _type, uint8 _level) private view returns(bool) {
626         uint256 totalBalance = _user.balance.add(msg.value);
627 
628         if (totalBalance < getPrice(_type, _level)) return false;
629 
630         return true;
631     }
632 
633     /// @notice level up for factory
634     /// @param _factoryId id of factory
635     function levelUp(uint256 _factoryId) public payable onlyExistingUser {
636         Factory storage factory = factories[_factoryId];
637         uint256 price = getPrice(factory.ftype, factory.level + 1);
638 
639         uint256 userId = addressToUser[msg.sender];
640         User storage user = users[userId];
641 
642         require(_checkPayment(user, factory.ftype, factory.level + 1));
643 
644         // payment
645         user.balance = user.balance.add(msg.value);
646         user.balance = user.balance.sub(price);
647         user.totalPay = user.totalPay.add(price);
648         totalDeposit += msg.value;
649 
650         _distributeInvestment(msg.value);
651         _distributeReferrers(userId, price);
652 
653         // collect
654         _collectResource(factory, user);
655         factory.level++;
656 
657         _updateLeaders(msg.sender, msg.value);
658 
659         emit LevelUp(_factoryId, factory.level, userId, price);
660     }
661 
662     /// @notice sell resources of user with type
663     /// @param _type type of resources
664     /// @return sum of sell
665     function sellResources(uint8 _type) public onlyExistingUser returns(uint256) {
666         uint256 userId = addressToUser[msg.sender];
667         uint256 sum = Math.min(users[userId].resources[_type] * getResourcePrice(_type), address(this).balance);
668         users[userId].resources[_type] = 0;
669 
670         msg.sender.transfer(sum);
671 
672         emit Sell(userId, _type, sum);
673         return sum;
674     }
675 
676     /// @notice function for compute worktime factory
677     /// @param _collected_at timestamp of start
678     /// @return duration minutes
679     function worktimeAtDate(uint256 _collected_at) public view returns(uint256) {
680         return (now - _collected_at) / 60;
681     }
682 
683     /// @notice function for compute duration work factory
684     /// @param _factoryId id of factory
685     /// @return timestamp of duration
686     function worktime(uint256 _factoryId) public view returns(uint256) {
687         return worktimeAtDate(factories[_factoryId].collected_at);
688     }
689 
690     /// @notice function for compute resource factory at time
691     /// @param _type type of factory
692     /// @param _level level of factory
693     /// @param _collected_at timestamp for collect
694     /// @return count of resources
695     function _resourcesAtTime(FactoryType _type, uint8 _level, uint256 _collected_at) public view returns(uint256) {
696         return worktimeAtDate(_collected_at) * (getProductsPerMinute(_type, _level) + getBonusPerMinute(_type, _level)) / 100;
697     }
698 
699     /// @notice function for compute resource factory at time
700     /// @dev wrapper over _resourcesAtTime
701     /// @param _factoryId id of factory
702     /// @return count of resources
703     function resourcesAtTime(uint256 _factoryId) public view returns(uint256) {
704         Factory storage factory = factories[_factoryId];
705         return _resourcesAtTime(factory.ftype, factory.level, factory.collected_at);
706     }
707 
708     /// @notice function for collect resource
709     /// @param _factory factory object
710     /// @param _user user object
711     /// @return count of resources
712     function _collectResource(Factory storage _factory, User storage _user) internal returns(uint256) {
713         uint256 resources = _resourcesAtTime(_factory.ftype, _factory.level, _factory.collected_at);
714         _user.resources[uint8(_factory.ftype)] = _user.resources[uint8(_factory.ftype)].add(resources);
715         _factory.collected_at = now;
716 
717         emit CollectResources(_factory.ftype, resources);
718         return resources;
719     }
720 
721     /// @notice function for collect all resources from all factories
722     /// @dev wrapper over _collectResource
723     function collectResources() public onlyExistingUser {
724         uint256 index = addressToUser[msg.sender];
725         User storage user = users[index];
726         uint256[] storage factoriesIds = userToFactories[addressToUser[msg.sender]];
727 
728         for (uint256 i = 0; i < factoriesIds.length; i++) {
729             _collectResource(factories[factoriesIds[i]], user);
730         }
731     }
732 
733 }