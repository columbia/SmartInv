1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 interface IWRD {
50     function balanceOf(address _who) external view returns (uint256);
51     function transfer(address _to, uint256 _value) external returns (bool);
52     function addSpecialsaleTokens(address sender, uint256 amount) external;
53 }
54 
55 /**
56  * @title Roles
57  * @dev Library for managing addresses assigned to a Role.
58  */
59 library Roles {
60     struct Role {
61         mapping (address => bool) bearer;
62     }
63 
64     /**
65      * @dev give an account access to this role
66      */
67     function add(Role storage role, address account) internal {
68         require(account != address(0));
69         require(!has(role, account));
70 
71         role.bearer[account] = true;
72     }
73 
74     /**
75      * @dev remove an account's access to this role
76      */
77     function remove(Role storage role, address account) internal {
78         require(account != address(0));
79         require(has(role, account));
80 
81         role.bearer[account] = false;
82     }
83 
84     /**
85      * @dev check if an account has this role
86      * @return bool
87      */
88     function has(Role storage role, address account) internal view returns (bool) {
89         require(account != address(0));
90         return role.bearer[account];
91     }
92 }
93 
94 /**
95  * @title WhitelistAdminRole
96  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
97  */
98 contract WhitelistAdminRole {
99     using Roles for Roles.Role;
100 
101     event WhitelistAdminAdded(address indexed account);
102     event WhitelistAdminRemoved(address indexed account);
103 
104     Roles.Role private _whitelistAdmins;
105 
106     constructor () internal {
107         _addWhitelistAdmin(msg.sender);
108     }
109 
110     modifier onlyWhitelistAdmin() {
111         require(isWhitelistAdmin(msg.sender));
112         _;
113     }
114 
115     function isWhitelistAdmin(address account) public view returns (bool) {
116         return _whitelistAdmins.has(account);
117     }
118 
119     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
120         _addWhitelistAdmin(account);
121     }
122 
123     function renounceWhitelistAdmin() public {
124         _removeWhitelistAdmin(msg.sender);
125     }
126 
127     function _addWhitelistAdmin(address account) internal {
128         _whitelistAdmins.add(account);
129         emit WhitelistAdminAdded(account);
130     }
131 
132     function _removeWhitelistAdmin(address account) internal {
133         _whitelistAdmins.remove(account);
134         emit WhitelistAdminRemoved(account);
135     }
136 }
137 
138 /**
139  * @title WhitelistedRole
140  * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
141  * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
142  * it), and not Whitelisteds themselves.
143  */
144 contract WhitelistedRole is WhitelistAdminRole {
145     using Roles for Roles.Role;
146 
147     event WhitelistedAdded(address indexed account);
148     event WhitelistedRemoved(address indexed account);
149 
150     Roles.Role private _whitelisteds;
151 
152     modifier onlyWhitelisted() {
153         require(isWhitelisted(msg.sender));
154         _;
155     }
156 
157     function isWhitelisted(address account) public view returns (bool) {
158         return _whitelisteds.has(account);
159     }
160 
161     function addWhitelisted(address account) public onlyWhitelistAdmin {
162         _addWhitelisted(account);
163     }
164 
165     function removeWhitelisted(address account) public onlyWhitelistAdmin {
166         _removeWhitelisted(account);
167     }
168 
169     function renounceWhitelisted() public {
170         _removeWhitelisted(msg.sender);
171     }
172 
173     function _addWhitelisted(address account) internal {
174         _whitelisteds.add(account);
175         emit WhitelistedAdded(account);
176     }
177 
178     function _removeWhitelisted(address account) internal {
179         _whitelisteds.remove(account);
180         emit WhitelistedRemoved(account);
181     }
182 }
183 
184 contract FCBS is WhitelistedRole {
185     using SafeMath for uint256;
186 
187     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
188     uint256 constant public MAX_DIVIDEND_RATE = 40000;                  // 400%
189     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
190     
191     uint256[] public INTEREST_BASE = [2 ether, 4 ether, 8 ether, 16 ether, 32 ether, 64 ether, 128 ether, 256 ether, 512 ether, 1024 ether, 2048 ether , 4096 ether];
192     uint256[] public BENEFIT_RATE = [40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140];
193     uint256 public MARKETING_AND_TEAM_FEE = 2800;                       // 10%+18%
194     uint256 public REFERRAL_PERCENT = 500;                              // 5%
195     uint256 public WRD_ETH_RATE = 10;                                   // 1.0*10^-3 WRD = 10 wei
196     uint256 public WITHDRAW_ETH_PERCENT = 8000;                         // wrd:eth = 20%:80%
197     
198     bool public isLimited = true;
199     uint256 public releaseTime = 0;                                     //unix time
200     uint256 public wave = 0;
201     uint256 public totalInvest = 0;
202     uint256 public totalDividend = 0;
203     mapping(address => bool) public privateSale;
204 
205     uint256 public waiting = 0;                                         //day after release
206     uint256 public dailyLimit = 100 ether;
207     uint256 dailyTotalInvest = 0;
208     
209     struct Deposit {
210         uint256 amount;
211         uint256 interest;
212         uint256 withdrawedRate;
213         uint256 lastPayment;
214     }
215 
216     struct User {
217         address payable referrer;
218         uint256 referralAmount;
219         bool isInvestor;
220         Deposit[] deposits;
221     }
222 
223     address payable public marketingAndTechnicalSupport;
224     IWRD public wrdToken;
225     mapping(uint256 => mapping(address => User)) public users;
226 
227     event InvestorAdded(address indexed investor);
228     event ReferrerAdded(address indexed investor, address indexed referrer);
229     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
230     event UserDividendPayed(address indexed investor, uint256 dividend);
231     event FeePayed(address indexed investor, uint256 amount);
232     event BalanceChanged(uint256 balance);
233     event NewWave();
234     
235     modifier onlyWhitelistAdminOrWhitelisted() {
236         require(isWhitelisted(msg.sender) || isWhitelistAdmin(msg.sender));
237         _;
238     }
239     
240     constructor () public {
241         marketingAndTechnicalSupport = msg.sender;
242     }
243 
244     function() external payable {
245         require(!isLimited || privateSale[msg.sender]);
246 
247         if(msg.value == 0) {
248             // Dividends
249             withdrawDividends(msg.sender);
250             return;
251         }
252 
253         address payable newReferrer = _bytesToAddress(msg.data);
254         // Deposit
255         doInvest(msg.sender, msg.value, newReferrer);
256     }
257 
258     function _bytesToAddress(bytes memory data) private pure returns(address payable addr) {
259         // solium-disable-next-line security/no-inline-assembly
260         assembly {
261             addr := mload(add(data, 20)) 
262         }
263     }
264 
265     function withdrawDividends(address payable from) internal {
266         uint256 dividendsSum = getDividends(from);
267         require(dividendsSum > 0);
268         
269         uint256 dividendsWei = dividendsSum.mul(WITHDRAW_ETH_PERCENT).div(ONE_HUNDRED_PERCENTS);
270         if (address(this).balance <= dividendsWei) {
271             wave = wave.add(1);
272             totalInvest = 0;
273             totalDividend = 0;
274             dividendsWei = address(this).balance;
275             emit NewWave();
276         }
277         uint256 dividendsWRD = min(
278             (dividendsSum.sub(dividendsWei)).div(WRD_ETH_RATE),
279             wrdToken.balanceOf(address(this)));
280         wrdToken.addSpecialsaleTokens(from, dividendsWRD);
281         
282         from.transfer(dividendsWei);
283         emit UserDividendPayed(from, dividendsWei);
284         emit BalanceChanged(address(this).balance);
285     }
286 
287     function getDividends(address wallet) internal returns(uint256 sum) {
288         User storage user = users[wave][wallet];
289 
290         for (uint i = 0; i < user.deposits.length; i++) {
291             uint256 withdrawRate = dividendRate(wallet, i);
292             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
293             user.deposits[i].lastPayment = max(now, user.deposits[i].lastPayment);
294             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
295         }
296         totalDividend = totalDividend.add(sum);
297     }
298 
299     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
300         User memory user = users[wave][wallet];
301         uint256 duration = now.sub(min(user.deposits[index].lastPayment, now));
302         rate = user.deposits[index].interest.mul(duration).div(1 days);
303         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
304         rate = min(rate, leftRate);
305     }
306 
307     function doInvest(address from, uint256 investment, address payable newReferrer) internal {
308         require (investment >= MINIMUM_DEPOSIT);
309         
310         User storage user = users[wave][from];
311         if (!user.isInvestor) {
312             // Add referral if possible
313             if (newReferrer != address(0)
314                 && users[wave][newReferrer].isInvestor
315             ) {
316                 user.referrer = newReferrer;
317                 emit ReferrerAdded(from, newReferrer);
318             }
319             user.isInvestor = true;
320             emit InvestorAdded(from);
321         }
322         
323         if(user.referrer != address(0)){
324             // Referrers fees
325             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
326             uint256 refBonus = investment.mul(REFERRAL_PERCENT).div(ONE_HUNDRED_PERCENTS);
327             user.referrer.transfer(refBonus);
328         }
329         
330         totalInvest = totalInvest.add(investment);
331         
332         createDeposit(from, investment);
333 
334         // Marketing and Team fee
335         uint256 marketingAndTeamFee = investment.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
336         marketingAndTechnicalSupport.transfer(marketingAndTeamFee);
337         emit FeePayed(from, marketingAndTeamFee);
338     
339         emit BalanceChanged(address(this).balance);
340     }
341     
342     function createDeposit(address from, uint256 investment) internal {
343         User storage user = users[wave][from];
344         if(isLimited){
345             user.deposits.push(Deposit({
346                 amount: investment,
347                 interest: getUserInterest(from),
348                 withdrawedRate: 0,
349                 lastPayment: now
350             }));
351             emit DepositAdded(from, user.deposits.length, investment);
352             return;
353         }
354         
355         if(now.sub(1 days) > releaseTime.add(waiting.mul(1 days)) ){
356             waiting = (now.sub(releaseTime)).div(1 days);
357             dailyTotalInvest = 0;
358         }
359         while(investment > 0){
360             uint256 investable = min(investment, dailyLimit.sub(dailyTotalInvest));
361             user.deposits.push(Deposit({
362                 amount: investable,
363                 interest: getUserInterest(from),
364                 withdrawedRate: 0,
365                 lastPayment: max(now, releaseTime.add(waiting.mul(1 days)))
366             }));
367             emit DepositAdded(from, user.deposits.length, investable);
368             investment = investment.sub(investable);
369             dailyTotalInvest = dailyTotalInvest.add(investable);
370             if(dailyTotalInvest == dailyLimit){
371                 waiting = waiting.add(1);
372                 dailyTotalInvest = 0;
373             }
374         }
375     }
376     
377     function getUserInterest(address wallet) public view returns (uint256 rate) {
378         uint i;
379         for (i = 0; i < INTEREST_BASE.length; i++) {
380             if(users[wave][wallet].referralAmount < INTEREST_BASE[i]){
381                 break;
382             }
383         }
384         rate = BENEFIT_RATE[i];
385     }
386     
387     function min(uint256 a, uint256 b) internal pure returns(uint256) {
388         if(a < b) return a;
389         return b;
390     }
391     
392     function max(uint256 a, uint256 b) internal pure returns(uint256) {
393         if(a > b) return a;
394         return b;
395     }
396     
397     function depositForUser(address wallet) external view returns(uint256 sum) {
398         User memory user = users[wave][wallet];
399         for (uint i = 0; i < user.deposits.length; i++) {
400             sum = sum.add(user.deposits[i].amount);
401         }
402     }
403 
404     function dividendForUserDeposit(address wallet, uint256 index) internal view returns(uint256 dividend) {
405         User memory user = users[wave][wallet];
406         dividend = user.deposits[index].amount.mul(dividendRate(wallet, index)).div(ONE_HUNDRED_PERCENTS);
407     }
408 
409     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsWei, uint256 dividendsWatoshi) {
410         User memory user = users[wave][wallet];
411         uint256 dividendsSum = 0;
412         for (uint i = 0; i < user.deposits.length; i++) {
413             dividendsSum = dividendsSum.add(dividendForUserDeposit(wallet, i));
414         }
415         dividendsWei = min(dividendsSum.mul(WITHDRAW_ETH_PERCENT).div(ONE_HUNDRED_PERCENTS), address(this).balance);
416         dividendsWatoshi = min((dividendsSum.sub(dividendsWei)).div(WRD_ETH_RATE), wrdToken.balanceOf(address(this)));
417     }
418 
419     function setWithdrawEthPercent(uint256 newPercent) external onlyWhitelistAdmin {
420     		WITHDRAW_ETH_PERCENT = newPercent;
421     }
422 
423     function setDailyLimit(uint256 newLimit) external onlyWhitelistAdmin {
424     		dailyLimit = newLimit;
425     }
426 
427     function setReferralBonus(uint256 newBonus) external onlyWhitelistAdmin {
428     		REFERRAL_PERCENT = newBonus;
429     }
430     
431     function setWRD(address token) external onlyWhitelistAdmin {
432         wrdToken = IWRD(token);
433     }
434     
435     function changeTeamFee(uint256 feeRate) external onlyWhitelistAdmin {
436         MARKETING_AND_TEAM_FEE = feeRate;
437     }
438     
439     function changeWRDRate(uint256 rate) external onlyWhitelistAdminOrWhitelisted {
440         WRD_ETH_RATE = rate;
441     }
442     
443     function withdrawWRD(uint256 amount) external onlyWhitelistAdmin {
444         wrdToken.transfer(msg.sender, min(amount, wrdToken.balanceOf(address(this))));
445     }
446     
447     function allowPrivate(address wallet) external onlyWhitelistAdminOrWhitelisted {
448         privateSale[wallet] = true;
449         User storage user = users[wave][wallet];
450         user.referralAmount = user.referralAmount.add(INTEREST_BASE[0]);
451     }
452     
453     function release() external onlyWhitelistAdmin {
454         isLimited = false;
455         releaseTime = now;
456     }
457     
458     function virtualInvest(address from, uint256 amount) public onlyWhitelistAdminOrWhitelisted {
459         User storage user = users[wave][from];
460         
461         user.deposits.push(Deposit({
462             amount: amount,
463             interest: getUserInterest(from),
464             withdrawedRate: 0,
465             lastPayment: now
466         }));
467         emit DepositAdded(from, user.deposits.length, amount);
468     }
469 }