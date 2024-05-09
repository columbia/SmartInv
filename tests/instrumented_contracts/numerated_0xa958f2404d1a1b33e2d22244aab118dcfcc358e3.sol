1 pragma solidity ^0.4.24;
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
49 contract Proxy {
50     using SafeMath for uint256;
51     uint256 public contribution = 0;
52     Lottery lottery;
53     
54     constructor() public {
55         lottery = Lottery(msg.sender);
56     }
57     function() public payable {
58         contribution = contribution.add(msg.value);
59         address(lottery).transfer(msg.value);
60     }
61     function resetContribution() external {
62         require(msg.sender == lottery.owner());
63         contribution = 0;
64     }
65 }
66 
67 contract Lottery {
68     using SafeMath for uint256;
69 
70     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
71     uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%
72     uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%
73     uint256 public referralPercents = 1000;                             // 10%
74     uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%
75     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
76     uint256 public wave = 0;
77     uint256 public totalInvest = 0;
78     uint256 public totalDividend = 0;
79     mapping(address => bool) public isProxy;
80 
81     struct Deposit {
82         uint256 amount;
83         uint256 interest;
84         uint256 withdrawedRate;
85     }
86 
87     struct User {
88         address referrer;
89         uint256 referralAmount;
90         uint256 firstTime;
91         uint256 lastPayment;
92         Deposit[] deposits;
93         uint256 referBonus;
94     }
95 
96     address public marketingAndTechnicalSupport = 0xFaea7fa229C29526698657e7Ab7063E20581A50c; // need to change
97     address public owner = 0x4e3e605b9f7b333e413E1CD9E577f2eba447f876;
98     mapping(uint256 => mapping(address => User)) public users;
99 
100     event InvestorAdded(address indexed investor);
101     event ReferrerAdded(address indexed investor, address indexed referrer);
102     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
103     event UserDividendPayed(address indexed investor, uint256 dividend);
104     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
105     event FeePayed(address indexed investor, uint256 amount);
106     event BalanceChanged(uint256 balance);
107     event NewWave();
108     
109     function() public payable {
110         require(isProxy[msg.sender]);
111         
112         if(msg.value == 0) {
113             // Dividends
114             withdrawDividends();
115             return;
116         }
117 
118         // Deposit
119         doInvest();
120     }
121         
122     function withdrawDividends() internal {
123         uint256 dividendsSum = getDividends(tx.origin);
124         require(dividendsSum > 0);
125         
126         if (address(this).balance <= dividendsSum) {
127             wave = wave.add(1);
128             totalInvest = 0;
129             dividendsSum = address(this).balance;
130             emit NewWave();
131         }
132         tx.origin.transfer(dividendsSum);
133         emit UserDividendPayed(tx.origin, dividendsSum);
134         emit BalanceChanged(address(this).balance);
135     }
136     
137     function getDividends(address wallet) internal returns(uint256 sum) {
138         User storage user = users[wave][wallet];
139         for (uint i = 0; i < user.deposits.length; i++) {
140             uint256 withdrawRate = dividendRate(tx.origin, i);
141             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
142             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
143             emit DepositDividendPayed(
144                 tx.origin,
145                 i,
146                 user.deposits[i].amount,
147                 user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),
148                 user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))
149             );
150         }
151         user.lastPayment = now;
152         sum = sum.add(user.referBonus);
153         user.referBonus = 0;
154         totalDividend = totalDividend.add(sum);
155     }
156 
157     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
158         User memory user = users[wave][wallet];
159         uint256 duration = now.sub(user.lastPayment);
160         rate = user.deposits[index].interest.mul(duration).div(1 days);
161         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
162         rate = min(rate, leftRate);
163     }
164 
165     function doInvest() internal {
166         uint256 investment = msg.value;
167         require (investment >= MINIMUM_DEPOSIT);
168         
169         User storage user = users[wave][tx.origin];
170         if (user.firstTime == 0) {
171             user.firstTime = now;
172             user.lastPayment = now;
173             emit InvestorAdded(tx.origin);
174         }
175 
176         // Add referral if possible
177         if (user.referrer == address(0) && msg.data.length == 20 && user.firstTime == now) {
178             address newReferrer = _bytesToAddress(msg.data);
179             if (newReferrer != address(0) && newReferrer != tx.origin && users[wave][newReferrer].firstTime > 0) {
180                 user.referrer = newReferrer;
181                 emit ReferrerAdded(tx.origin, newReferrer);
182             }
183         }
184         
185         // Referrers fees
186         if (user.referrer != address(0)) {
187             uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
188             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
189             user.referrer.transfer(refAmount);
190         }
191         
192         // Reinvest
193         investment = investment.add(getDividends(tx.origin));
194         
195         totalInvest = totalInvest.add(investment);
196         
197         // Create deposit
198         user.deposits.push(Deposit({
199             amount: investment,
200             interest: getUserInterest(tx.origin),
201             withdrawedRate: 0
202         }));
203         emit DepositAdded(tx.origin, user.deposits.length, investment);
204 
205         // Marketing and Team fee
206         uint256 marketingAndTeamFee = msg.value.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
207         marketingAndTechnicalSupport.transfer(marketingAndTeamFee);
208         emit FeePayed(tx.origin, marketingAndTeamFee);
209     
210         emit BalanceChanged(address(this).balance);
211     }
212     
213     function getUserInterest(address wallet) public view returns (uint256) {
214         User memory user = users[wave][wallet];
215         if (user.referralAmount < 1 ether) {
216             if(user.referrer == address(0)) return DAILY_INTEREST[0];
217             return DAILY_INTEREST[1];
218         } else if (user.referralAmount < 10 ether) {
219             return DAILY_INTEREST[2];
220         } else if (user.referralAmount < 20 ether) {
221             return DAILY_INTEREST[3];
222         } else {
223             return DAILY_INTEREST[4];
224         }
225     }
226 
227     function _bytesToAddress(bytes data) private pure returns(address addr) {
228         // solium-disable-next-line security/no-inline-assembly
229         assembly {
230             addr := mload(add(data, 20)) 
231         }
232     }
233     
234     function min(uint256 a, uint256 b) internal pure returns(uint256) {
235         if(a < b) return a;
236         return b;
237     }
238     
239     function depositForUser(address wallet) external view returns(uint256 sum) {
240         User memory user = users[wave][wallet];
241         for (uint i = 0; i < user.deposits.length; i++) {
242             sum = sum.add(user.deposits[i].amount);
243         }
244     }
245     
246     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
247         User memory user = users[wave][wallet];
248         for (uint i = 0; i < user.deposits.length; i++) {
249             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
250             dividendsSum = dividendsSum.add(withdrawAmount);
251         }
252         dividendsSum = dividendsSum.add(user.referBonus);
253         dividendsSum = min(dividendsSum, address(this).balance);
254     }
255     
256     function changeInterest(uint256[] interestList) external {
257         require(address(msg.sender) == owner);
258         DAILY_INTEREST = interestList;
259     }
260     
261     function changeTeamFee(uint256 feeRate) external {
262         require(address(msg.sender) == owner);
263         MARKETING_AND_TEAM_FEE = feeRate;
264     }
265     
266     function virtualInvest(address from, uint256 amount) public {
267         require(address(msg.sender) == owner);
268         
269         User storage user = users[wave][from];
270         if (user.firstTime == 0) {
271             user.firstTime = now;
272             user.lastPayment = now;
273             emit InvestorAdded(from);
274         }
275         
276         // Reinvest
277         amount = amount.add(getDividends(from));
278         
279         user.deposits.push(Deposit({
280             amount: amount,
281             interest: getUserInterest(from),
282             withdrawedRate: 0
283         }));
284         emit DepositAdded(from, user.deposits.length, amount);
285     }
286     
287     function createProxy() external {
288         require(msg.sender == owner);
289         Proxy newProxy = new Proxy();
290         isProxy[address(newProxy)] = true;
291     }
292 }