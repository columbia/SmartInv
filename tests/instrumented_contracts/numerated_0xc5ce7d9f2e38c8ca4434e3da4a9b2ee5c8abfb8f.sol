1 pragma solidity ^0.5.8;
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
49 contract ETH_8 {
50     using SafeMath for uint256;
51 
52     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
53     uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%
54     uint256[] public REFERRAL_AMOUNT_CLASS = [1 ether, 10 ether, 20 ether ];               // 1ether, 10ether, 20ether
55     uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%
56     uint256 public referralPercents = 1000;                             // 10%
57     uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%
58     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
59     uint256 public wave = 0;
60     uint256 public totalInvest = 0;
61     uint256 public totalDividend = 0;
62     uint256 public waiting = 0;
63     uint256 public dailyLimit = 10 ether;
64     uint256 public dailyTotalInvest = 0;
65 
66     struct Deposit {
67         uint256 amount;
68         uint256 withdrawedRate;
69         uint256 lastPayment;
70     }
71 
72     struct User {
73         address payable referrer;
74         uint256 referralAmount;
75         bool isInvestor;
76         Deposit[] deposits;
77         uint256 interest;
78         uint256 dividend;
79     }
80 
81     address payable public owner;
82     address payable public teamWallet = 0x947fEa6f44e8b514DfE2f1Bb8bc2a86FD493874f;
83     mapping(uint256 => mapping(address => User)) public users;
84 
85     event InvestorAdded(address indexed investor);
86     event ReferrerAdded(address indexed investor, address indexed referrer);
87     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
88     event UserDividendPayed(address indexed investor, uint256 dividend);
89     event FeePayed(address indexed investor, uint256 amount);
90     event BalanceChanged(uint256 balance);
91     event NewWave();
92     
93     constructor() public {
94         owner = msg.sender;
95     }
96     
97     function() external payable {
98         if(msg.value == 0) {
99             // Dividends
100             withdrawDividends(msg.sender);
101             return;
102         }
103         
104         address payable newReferrer = _bytesToAddress(msg.data);
105         // Deposit
106         doInvest(msg.sender, msg.value, newReferrer);
107     }
108     
109     function _bytesToAddress(bytes memory data) private pure returns(address payable addr) {
110         // solium-disable-next-line security/no-inline-assembly
111         assembly {
112             addr := mload(add(data, 20)) 
113         }
114     }
115 
116     function withdrawDividends(address payable from) internal {
117         uint256 dividendsSum = getDividends(from);
118         require(dividendsSum > 0);
119         
120         totalDividend = totalDividend.add(dividendsSum);
121         if (address(this).balance <= dividendsSum) {
122             wave = wave.add(1);
123             totalInvest = 0;
124             totalDividend = 0;
125             dividendsSum = address(this).balance;
126             emit NewWave();
127         }
128         from.transfer(dividendsSum);
129         emit UserDividendPayed(from, dividendsSum);
130         emit BalanceChanged(address(this).balance);
131     }
132     
133     function getDividends(address wallet) internal returns(uint256 sum) {
134         User storage user = users[wave][wallet];
135         sum = user.dividend;
136         user.dividend = 0;
137         for (uint i = 0; i < user.deposits.length; i++) {
138             uint256 withdrawRate = dividendRate(wallet, i);
139             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
140             user.deposits[i].lastPayment = max(now, user.deposits[i].lastPayment);
141             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
142         }
143     }
144 
145     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
146         User memory user = users[wave][wallet];
147         uint256 duration = now.sub(min(user.deposits[index].lastPayment, now));
148         rate = user.interest.mul(duration).div(1 days);
149         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
150         rate = min(rate, leftRate);
151     }
152 
153     function doInvest(address from, uint256 investment, address payable newReferrer) internal {
154         require (investment >= MINIMUM_DEPOSIT);
155         
156         User storage user = users[wave][from];
157         if (!user.isInvestor) {
158             // Add referral if possible
159             if (user.referrer == address(0)
160                 && newReferrer != address(0)
161                 && newReferrer != from
162                 && users[wave][newReferrer].isInvestor
163             ) {
164                 user.referrer = newReferrer;
165                 emit ReferrerAdded(from, newReferrer);
166             }
167             
168             user.isInvestor = true;
169             user.interest = getUserInterest(from);
170             emit InvestorAdded(from);
171         }
172         
173         // Referrers fees
174         if (user.referrer != address(0)) {
175             addReferralAmount(investment, user);
176         }
177         
178         // Reinvest
179         investment = investment.add(getDividends(from));
180         
181         totalInvest = totalInvest.add(investment);
182         
183         // Create deposit
184         createDeposit(from, investment);
185 
186         // Marketing and Team fee
187         uint256 marketingAndTeamFee = investment.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
188         teamWallet.transfer(marketingAndTeamFee);
189         emit FeePayed(from, marketingAndTeamFee);
190     
191         emit BalanceChanged(address(this).balance);
192     }
193     
194     function createDeposit(address from, uint256 investment) internal {
195         User storage user = users[wave][from];
196         
197         if(now > waiting.add(1 days)){
198             waiting = now;
199             dailyTotalInvest = 0;
200         }
201         while(investment > 0){
202             uint256 investable = min(investment, dailyLimit.sub(dailyTotalInvest));
203             user.deposits.push(Deposit({
204                 amount: investable,
205                 withdrawedRate: 0,
206                 lastPayment: max(now, waiting)
207             }));
208             emit DepositAdded(from, user.deposits.length, investable);
209             investment = investment.sub(investable);
210             dailyTotalInvest = dailyTotalInvest.add(investable);
211             if(dailyTotalInvest == dailyLimit){
212                 waiting = waiting.add(1 days);
213                 dailyTotalInvest = 0;
214             }
215         }
216     }
217     
218     function addReferralAmount(uint256 investment, User memory investor) internal {
219         uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
220         investor.referrer.transfer(refAmount);
221         
222         User storage referrer = users[wave][investor.referrer];
223         referrer.referralAmount = referrer.referralAmount.add(investment);
224         uint256 newInterest = getUserInterest(investor.referrer);
225         if(newInterest != referrer.interest){ 
226             referrer.dividend = getDividends(investor.referrer);
227             referrer.interest = newInterest;
228         }
229     }
230     
231     function getUserInterest(address wallet) public view returns (uint256) {
232         User memory user = users[wave][wallet];
233         if (user.referralAmount < REFERRAL_AMOUNT_CLASS[0]) {
234             if(user.referrer == address(0)) return DAILY_INTEREST[0];
235             return DAILY_INTEREST[1];
236         } else if (user.referralAmount < REFERRAL_AMOUNT_CLASS[1]) {
237             return DAILY_INTEREST[2];
238         } else if (user.referralAmount < REFERRAL_AMOUNT_CLASS[2]) {
239             return DAILY_INTEREST[3];
240         } else {
241             return DAILY_INTEREST[4];
242         }
243     }
244     
245     function max(uint256 a, uint256 b) internal pure returns(uint256){
246         if( a > b) return a;
247         return b;
248     }
249     
250     function min(uint256 a, uint256 b) internal pure returns(uint256) {
251         if(a < b) return a;
252         return b;
253     }
254     
255     function depositForUser(address wallet) external view returns(uint256 sum) {
256         User memory user = users[wave][wallet];
257         for (uint i = 0; i < user.deposits.length; i++) {
258             if(user.deposits[i].lastPayment <= now) sum = sum.add(user.deposits[i].amount);
259         }
260     }
261     
262     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
263         User memory user = users[wave][wallet];
264         dividendsSum = user.dividend;
265         for (uint i = 0; i < user.deposits.length; i++) {
266             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
267             dividendsSum = dividendsSum.add(withdrawAmount);
268         }
269         dividendsSum = min(dividendsSum, address(this).balance);
270     }
271 
272     function changeTeamFee(uint256 feeRate) external {
273         require(address(msg.sender) == owner);
274         MARKETING_AND_TEAM_FEE = feeRate;
275     }
276     
277     function changeDailyLimit(uint256 newLimit) external {
278         require(address(msg.sender) == owner);
279         dailyLimit = newLimit;
280     }
281     
282     function changeReferrerFee(uint256 feeRate) external {
283         require(address(msg.sender) == owner);
284         referralPercents = feeRate;
285     }
286     
287     function virtualInvest(address from, uint256 amount) public {
288         require(address(msg.sender) == owner);
289         
290         User storage user = users[wave][from];
291         if (!user.isInvestor) {
292             user.isInvestor = true;
293             user.interest = getUserInterest(from);
294             emit InvestorAdded(from);
295         }
296         
297         // Reinvest
298         amount = amount.add(getDividends(from));
299         
300         user.deposits.push(Deposit({
301             amount: amount,
302             withdrawedRate: 0,
303             lastPayment: now
304         }));
305         emit DepositAdded(from, user.deposits.length, amount);
306     }
307 }