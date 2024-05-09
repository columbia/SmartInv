1 pragma solidity ^0.4.24;
2 
3 /*
4  * OASIS is an international community of financially independent people,
5  * united by the principles of trust and mutual assistance.
6  * 
7  * This community was implemented based on the Ethereum smart contract.
8  * The technology is completely transparent and has no analogues in the world.
9  * Ethereum blockchain stores all the information concerning the distribution 
10  * of community finances.
11  * 
12  * Smart contract stores the funds of community members, managing payments
13  * according to the algorithm. This function allows the community to develop
14  * on the principles of trust and mutual assistance.
15  * 
16  * The community has activated smart contract’s “REFUSE FROM OWNERSHIP” function,
17  * thus, no one can change this smart contract, including the community creators.
18  * 
19  * The community distributes funds in accordance with the following scheme:
20  *   80% for community members;
21  *   15% for advertising budget;
22  *   4% for technical support;
23  *   1% to contribute to SENS Research Foundation.
24  * 
25  * The profit is 3% for 24 hours (interest is accrued continuously).
26  * The deposit is included in the payments, 50 days after the deposit is over and eliminated.
27  * Minimum deposit is 0.01 ETH.
28  * Each deposit is a new deposit contributed to the community.
29  * No more than 50 deposits from one ETH wallet are allowed.
30  * 
31  * Referral system:
32  *   Line 1 - 3%
33  *   Line 2 - 2%
34  *   Line 3 - 1%
35  * If you indicate your referral, you get 50% refback from Line 1.
36  * 
37  * How to make a deposit:
38  *   Send cryptocurrency from ETH wallet (at least 0.01 ETH) to the address
39  *   of the smart contract - 0x4390a19282c661c9eb8ffb47faca7ad4b47d21fc
40  * 
41  * Recommended limits are 200000 ETH, check the current ETH rate at
42  * the following link: https://ethgasstation.info/
43  * 
44  * How to get paid:
45  *   Request your profit by sending 0 ETH to the address of the smart contract.
46  * 
47  * It is not allowed to make transfers from cryptocurrency exchanges.
48  * Only personal ETH wallet with private keys is allowed.
49  * 
50  * The source code of this smart contract was created by CryptoManiacs.
51  */
52 
53 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60 
61   /**
62   * @dev Multiplies two numbers, throws on overflow.
63   */
64   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
65     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
66     // benefit is lost if 'b' is also tested.
67     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
68     if (_a == 0) {
69       return 0;
70     }
71 
72     c = _a * _b;
73     assert(c / _a == _b);
74     return c;
75   }
76 
77   /**
78   * @dev Integer division of two numbers, truncating the quotient.
79   */
80   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
81     // assert(_b > 0); // Solidity automatically throws when dividing by 0
82     // uint256 c = _a / _b;
83     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
84     return _a / _b;
85   }
86 
87   /**
88   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
89   */
90   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
91     assert(_b <= _a);
92     return _a - _b;
93   }
94 
95   /**
96   * @dev Adds two numbers, throws on overflow.
97   */
98   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
99     c = _a + _b;
100     assert(c >= _a);
101     return c;
102   }
103 }
104 
105 // File: contracts/Oasis.sol
106 
107 contract Oasis {
108     using SafeMath for uint256;
109 
110     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
111     uint256 constant public DAILY_INTEREST = 300;                       // 3%
112     uint256 constant public MARKETING_FEE = 1500;                       // 15%
113     uint256 constant public TEAM_FEE = 400;                             // 4%
114     uint256 constant public CHARITY_FEE = 100;                          // 1%
115     uint256 constant public MAX_DEPOSIT_TIME = 50 days;                 // 150%
116     uint256 constant public REFERRER_ACTIVATION_PERIOD = 0;
117     uint256 constant public MAX_USER_DEPOSITS_COUNT = 50;
118     uint256 constant public REFBACK_PERCENT = 150;                      // 1.5%
119     uint256[] /*constant*/ public referralPercents = [150, 200, 100];   // 1.5%, 2%, 1%
120 
121     struct Deposit {
122         uint256 time;
123         uint256 amount;
124     }
125 
126     struct User {
127         address referrer;
128         uint256 refStartTime;
129         uint256 lastPayment;
130         Deposit[] deposits;
131     }
132 
133     address public marketing = 0xDB6827de6b9Fc722Dc4EFa7e35f3b78c54932494;
134     address public team = 0x31CdA77ab136c8b971511473c3D04BBF7EAe8C0f;
135     address public charity = 0x36c92a9Da5256EaA5Ccc355415271b7d2682f32E;
136     uint256 public totalDeposits;
137     bool public running = true;
138     mapping(address => User) public users;
139 
140     event InvestorAdded(address indexed investor);
141     event ReferrerAdded(address indexed investor, address indexed referrer);
142     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
143     event UserDividendPayed(address indexed investor, uint256 dividend);
144     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
145     event ReferrerPayed(address indexed investor, address indexed referrer, uint256 amount, uint256 refAmount, uint256 indexed level);
146     event FeePayed(address indexed investor, uint256 amount);
147     event TotalDepositsChanged(uint256 totalDeposits);
148     event BalanceChanged(uint256 balance);
149 
150     Oasis public prevContract = Oasis(0x0A5155AD298CcfD1610A00eD75457eb2d8B0C701);
151     mapping(address => bool) public wasImported;
152 
153     function migrateDeposits() public {
154         require(totalDeposits == 0, "Should be called on start");
155         totalDeposits = prevContract.totalDeposits();
156     }
157 
158     function migrate(address[] investors) public {
159         for (uint i = 0; i < investors.length; i++) {
160             if (wasImported[investors[i]]) {
161                 continue;
162             }
163 
164             wasImported[investors[i]] = true;
165             User storage user = users[investors[i]];
166             (user.referrer, user.refStartTime, user.lastPayment) = prevContract.users(investors[i]);
167             
168             uint depositsCount = prevContract.depositsCountForUser(investors[i]);
169             for (uint j = 0; j < depositsCount; j++) {
170                 (uint256 time, uint256 amount) = prevContract.depositForUser(investors[i], j);
171                 user.deposits.push(Deposit({
172                     time: time,
173                     amount: amount
174                 }));
175             }
176 
177             if (user.lastPayment == 0 && depositsCount > 0) {
178                 user.lastPayment = user.deposits[0].time;
179             }
180         }
181     }
182     
183     function() public payable {
184         require(running, "Oasis is not running");
185         User storage user = users[msg.sender];
186 
187         // Dividends
188         uint256[] memory dividends = dividendsForUser(msg.sender);
189         uint256 dividendsSum = _dividendsSum(dividends);
190         if (dividendsSum > 0) {
191             if (dividendsSum >= address(this).balance) {
192                 dividendsSum = address(this).balance;
193                 running = false;
194             }
195 
196             msg.sender.transfer(dividendsSum);
197             user.lastPayment = now;
198             emit UserDividendPayed(msg.sender, dividendsSum);
199             for (uint i = 0; i < dividends.length; i++) {
200                 emit DepositDividendPayed(
201                     msg.sender,
202                     i,
203                     user.deposits[i].amount,
204                     dividendsForAmountAndTime(user.deposits[i].amount, now.sub(user.deposits[i].time)),
205                     dividends[i]
206                 );
207             }
208 
209             // Cleanup deposits array a bit
210             for (i = 0; i < user.deposits.length; i++) {
211                 if (now >= user.deposits[i].time.add(MAX_DEPOSIT_TIME)) {
212                     user.deposits[i] = user.deposits[user.deposits.length - 1];
213                     user.deposits.length -= 1;
214                     i -= 1;
215                 }
216             }
217         }
218 
219         // Deposit
220         if (msg.value > 0) {
221             if (user.lastPayment == 0) {
222                 user.lastPayment = now;
223                 user.refStartTime = now;
224                 emit InvestorAdded(msg.sender);
225             }
226 
227             // Create deposit
228             user.deposits.push(Deposit({
229                 time: now,
230                 amount: msg.value
231             }));
232             require(user.deposits.length <= MAX_USER_DEPOSITS_COUNT, "Too many deposits per user");
233             emit DepositAdded(msg.sender, user.deposits.length, msg.value);
234 
235             // Add to total deposits
236             totalDeposits = totalDeposits.add(msg.value);
237             emit TotalDepositsChanged(totalDeposits);
238 
239             // Add referral if possible
240             if (user.referrer == address(0) && msg.data.length == 20) {
241                 address referrer = _bytesToAddress(msg.data);
242                 if (referrer != address(0) && referrer != msg.sender && users[referrer].refStartTime > 0 && now >= users[referrer].refStartTime.add(REFERRER_ACTIVATION_PERIOD))
243                 {
244                     user.referrer = referrer;
245                     msg.sender.transfer(msg.value.mul(REFBACK_PERCENT).div(ONE_HUNDRED_PERCENTS));
246                     emit ReferrerAdded(msg.sender, referrer);
247                 }
248             }
249 
250             // Referrers fees
251             referrer = users[msg.sender].referrer;
252             for (i = 0; referrer != address(0) && i < referralPercents.length; i++) {
253                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);
254                 referrer.send(refAmount); // solium-disable-line security/no-send
255                 emit ReferrerPayed(msg.sender, referrer, msg.value, refAmount, i);
256                 referrer = users[referrer].referrer;
257             }
258 
259             // Marketing and team fees
260             uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(ONE_HUNDRED_PERCENTS);
261             uint256 teamFee = msg.value.mul(TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
262             uint256 charityFee = msg.value.mul(CHARITY_FEE).div(ONE_HUNDRED_PERCENTS);
263             marketing.send(marketingFee); // solium-disable-line security/no-send
264             team.send(teamFee); // solium-disable-line security/no-send
265             charity.send(charityFee); // solium-disable-line security/no-send
266             emit FeePayed(msg.sender, marketingFee.add(teamFee));
267         }
268 
269         // Create referrer for free
270         if (user.deposits.length == 0 && msg.value == 0) {
271             user.refStartTime = now;
272         }
273         emit BalanceChanged(address(this).balance);
274     }
275 
276     function depositsCountForUser(address wallet) public view returns(uint256) {
277         return users[wallet].deposits.length;
278     }
279 
280     function depositForUser(address wallet, uint256 index) public view returns(uint256 time, uint256 amount) {
281         time = users[wallet].deposits[index].time;
282         amount = users[wallet].deposits[index].amount;
283     }
284 
285     function dividendsSumForUser(address wallet) public view returns(uint256 dividendsSum) {
286         return _dividendsSum(dividendsForUser(wallet));
287     }
288 
289     function dividendsForUser(address wallet) public view returns(uint256[] dividends) {
290         User storage user = users[wallet];
291         dividends = new uint256[](user.deposits.length);
292 
293         for (uint i = 0; i < user.deposits.length; i++) {
294             uint256 howOld = now.sub(user.deposits[i].time);
295             uint256 duration = now.sub(user.lastPayment);
296             if (howOld > MAX_DEPOSIT_TIME) {
297                 uint256 overtime = howOld.sub(MAX_DEPOSIT_TIME);
298                 duration = duration.sub(overtime);
299             }
300 
301             dividends[i] = dividendsForAmountAndTime(user.deposits[i].amount, duration);
302         }
303     }
304 
305     function dividendsForAmountAndTime(uint256 amount, uint256 duration) public pure returns(uint256) {
306         return amount
307             .mul(DAILY_INTEREST).div(ONE_HUNDRED_PERCENTS)
308             .mul(duration).div(1 days);
309     }
310 
311     function _bytesToAddress(bytes data) private pure returns(address addr) {
312         // solium-disable-next-line security/no-inline-assembly
313         assembly {
314             addr := mload(add(data, 20)) 
315         }
316     }
317 
318     function _dividendsSum(uint256[] dividends) private pure returns(uint256 dividendsSum) {
319         for (uint i = 0; i < dividends.length; i++) {
320             dividendsSum = dividendsSum.add(dividends[i]);
321         }
322     }
323 }