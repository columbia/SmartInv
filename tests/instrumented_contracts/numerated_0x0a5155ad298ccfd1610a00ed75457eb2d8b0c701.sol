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
39  *   of the smart contract - 0x0A5155AD298CcfD1610A00eD75457eb2d8B0C701
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
128         uint256 firstTime;
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
150     function() public payable {
151         require(running, "Oasis is not running");
152         User storage user = users[msg.sender];
153 
154         // Dividends
155         uint256[] memory dividends = dividendsForUser(msg.sender);
156         uint256 dividendsSum = _dividendsSum(dividends);
157         if (dividendsSum > 0) {
158             if (dividendsSum >= address(this).balance) {
159                 dividendsSum = address(this).balance;
160                 running = false;
161             }
162 
163             msg.sender.transfer(dividendsSum);
164             user.lastPayment = now;
165             emit UserDividendPayed(msg.sender, dividendsSum);
166             for (uint i = 0; i < dividends.length; i++) {
167                 emit DepositDividendPayed(
168                     msg.sender,
169                     i,
170                     user.deposits[i].amount,
171                     dividendsForAmountAndTime(user.deposits[i].amount, now.sub(user.deposits[i].time)),
172                     dividends[i]
173                 );
174             }
175 
176             // Cleanup deposits array a bit
177             for (i = 0; i < user.deposits.length; i++) {
178                 if (now >= user.deposits[i].time.add(MAX_DEPOSIT_TIME)) {
179                     user.deposits[i] = user.deposits[user.deposits.length - 1];
180                     user.deposits.length -= 1;
181                     i -= 1;
182                 }
183             }
184         }
185 
186         // Deposit
187         if (msg.value > 0) {
188             if (user.firstTime == 0) {
189                 user.firstTime = now;
190                 user.lastPayment = now;
191                 emit InvestorAdded(msg.sender);
192             }
193 
194             // Create deposit
195             user.deposits.push(Deposit({
196                 time: now,
197                 amount: msg.value
198             }));
199             require(user.deposits.length <= MAX_USER_DEPOSITS_COUNT, "Too many deposits per user");
200             emit DepositAdded(msg.sender, user.deposits.length, msg.value);
201 
202             // Add to total deposits
203             totalDeposits = totalDeposits.add(msg.value);
204             emit TotalDepositsChanged(totalDeposits);
205 
206             // Add referral if possible
207             if (user.referrer == address(0) && msg.data.length == 20) {
208                 address referrer = _bytesToAddress(msg.data);
209                 if (referrer != address(0) && referrer != msg.sender && users[referrer].firstTime > 0 && now >= users[referrer].firstTime.add(REFERRER_ACTIVATION_PERIOD))
210                 {
211                     user.referrer = referrer;
212                     msg.sender.transfer(msg.value.mul(REFBACK_PERCENT).div(ONE_HUNDRED_PERCENTS));
213                     emit ReferrerAdded(msg.sender, referrer);
214                 }
215             }
216 
217             // Referrers fees
218             referrer = users[msg.sender].referrer;
219             for (i = 0; referrer != address(0) && i < referralPercents.length; i++) {
220                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);
221                 referrer.send(refAmount); // solium-disable-line security/no-send
222                 emit ReferrerPayed(msg.sender, referrer, msg.value, refAmount, i);
223                 referrer = users[referrer].referrer;
224             }
225 
226             // Marketing and team fees
227             uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(ONE_HUNDRED_PERCENTS);
228             uint256 teamFee = msg.value.mul(TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
229             uint256 charityFee = msg.value.mul(CHARITY_FEE).div(ONE_HUNDRED_PERCENTS);
230             marketing.send(marketingFee); // solium-disable-line security/no-send
231             team.send(teamFee); // solium-disable-line security/no-send
232             charity.send(charityFee); // solium-disable-line security/no-send
233             emit FeePayed(msg.sender, marketingFee.add(teamFee));
234         }
235 
236         // Create referrer for free
237         if (user.deposits.length == 0 && msg.value == 0) {
238             user.firstTime = now;
239         }
240         emit BalanceChanged(address(this).balance);
241     }
242 
243     function depositsCountForUser(address wallet) public view returns(uint256) {
244         return users[wallet].deposits.length;
245     }
246 
247     function depositForUser(address wallet, uint256 index) public view returns(uint256 time, uint256 amount) {
248         time = users[wallet].deposits[index].time;
249         amount = users[wallet].deposits[index].amount;
250     }
251 
252     function dividendsSumForUser(address wallet) public view returns(uint256 dividendsSum) {
253         return _dividendsSum(dividendsForUser(wallet));
254     }
255 
256     function dividendsForUser(address wallet) public view returns(uint256[] dividends) {
257         User storage user = users[wallet];
258         dividends = new uint256[](user.deposits.length);
259 
260         for (uint i = 0; i < user.deposits.length; i++) {
261             uint256 howOld = now.sub(user.deposits[i].time);
262             uint256 duration = now.sub(user.lastPayment);
263             if (howOld > MAX_DEPOSIT_TIME) {
264                 uint256 overtime = howOld.sub(MAX_DEPOSIT_TIME);
265                 duration = duration.sub(overtime);
266             }
267 
268             dividends[i] = dividendsForAmountAndTime(user.deposits[i].amount, duration);
269         }
270     }
271 
272     function dividendsForAmountAndTime(uint256 amount, uint256 duration) public pure returns(uint256) {
273         return amount
274             .mul(DAILY_INTEREST).div(ONE_HUNDRED_PERCENTS)
275             .mul(duration).div(1 days);
276     }
277 
278     function _bytesToAddress(bytes data) private pure returns(address addr) {
279         // solium-disable-next-line security/no-inline-assembly
280         assembly {
281             addr := mload(add(data, 20)) 
282         }
283     }
284 
285     function _dividendsSum(uint256[] dividends) private pure returns(uint256 dividendsSum) {
286         for (uint i = 0; i < dividends.length; i++) {
287             dividendsSum = dividendsSum.add(dividends[i]);
288         }
289     }
290 }