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
52     ETH_8 public eth_8;
53     
54     constructor() public {
55         eth_8 = ETH_8(msg.sender);
56     }
57     
58     function() public payable {
59         
60         if(msg.value == 0) {
61             // Dividends
62             eth_8.withdrawDividends(msg.sender);
63             return;
64         }
65         
66         address newReferrer = _bytesToAddress(msg.data);
67         // Deposit
68         contribution = contribution.add(msg.value);
69         address(eth_8).transfer(msg.value);
70         eth_8.doInvest(msg.sender, msg.value, newReferrer);
71     }
72     
73     function _bytesToAddress(bytes data) private pure returns(address addr) {
74         // solium-disable-next-line security/no-inline-assembly
75         assembly {
76             addr := mload(add(data, 20)) 
77         }
78     }
79 }
80 
81 contract ETH_8 {
82     using SafeMath for uint256;
83 
84     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
85     uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%
86     uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%
87     uint256 public referralPercents = 1000;                             // 10%
88     uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%
89     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
90     uint256 public wave = 0;
91     uint256 public totalInvest = 0;
92     uint256 public totalDividend = 0;
93     mapping(address => bool) public isProxy;
94 
95     struct Deposit {
96         uint256 amount;
97         uint256 interest;
98         uint256 withdrawedRate;
99     }
100 
101     struct User {
102         address referrer;
103         uint256 referralAmount;
104         uint256 firstTime;
105         uint256 lastPayment;
106         Deposit[] deposits;
107     }
108 
109     address public marketingAndTechnicalSupport = 0xC93C7F3Ac689B822C3e9d09b9cA8934e54cf1D70;
110     address public owner = 0xbBdE48b0c31dA0DD601DA38F31dcf92b04f42588;
111     mapping(uint256 => mapping(address => User)) public users;
112 
113     event InvestorAdded(address indexed investor);
114     event ReferrerAdded(address indexed investor, address indexed referrer);
115     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
116     event UserDividendPayed(address indexed investor, uint256 dividend);
117     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
118     event FeePayed(address indexed investor, uint256 amount);
119     event BalanceChanged(uint256 balance);
120     event NewWave();
121     
122     function() public payable {
123         require(isProxy[msg.sender]);
124     }
125 
126     function withdrawDividends(address from) public {
127         require(isProxy[msg.sender]);
128         uint256 dividendsSum = getDividends(from);
129         require(dividendsSum > 0);
130         
131         if (address(this).balance <= dividendsSum) {
132             wave = wave.add(1);
133             totalInvest = 0;
134             dividendsSum = address(this).balance;
135             emit NewWave();
136         }
137         from.transfer(dividendsSum);
138         emit UserDividendPayed(from, dividendsSum);
139         emit BalanceChanged(address(this).balance);
140     }
141     
142     function getDividends(address wallet) internal returns(uint256 sum) {
143         User storage user = users[wave][wallet];
144         for (uint i = 0; i < user.deposits.length; i++) {
145             uint256 withdrawRate = dividendRate(wallet, i);
146             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
147             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
148             emit DepositDividendPayed(
149                 wallet,
150                 i,
151                 user.deposits[i].amount,
152                 user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),
153                 user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))
154             );
155         }
156         user.lastPayment = now;
157         totalDividend = totalDividend.add(sum);
158     }
159 
160     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
161         User memory user = users[wave][wallet];
162         uint256 duration = now.sub(user.lastPayment);
163         rate = user.deposits[index].interest.mul(duration).div(1 days);
164         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
165         rate = min(rate, leftRate);
166     }
167 
168     function doInvest(address from, uint256 investment, address newReferrer) public {
169         require(isProxy[msg.sender]);
170         require (investment >= MINIMUM_DEPOSIT);
171         
172         User storage user = users[wave][from];
173         if (user.firstTime == 0) {
174             user.firstTime = now;
175             user.lastPayment = now;
176             emit InvestorAdded(from);
177         }
178 
179         // Add referral if possible
180         if (user.referrer == address(0)
181             && user.firstTime == now
182             && newReferrer != address(0)
183             && newReferrer != from
184             && users[wave][newReferrer].firstTime > 0
185         ) {
186             user.referrer = newReferrer;
187             emit ReferrerAdded(from, newReferrer);
188         }
189         
190         // Referrers fees
191         if (user.referrer != address(0)) {
192             uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
193             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
194             user.referrer.transfer(refAmount);
195         }
196         
197         // Reinvest
198         investment = investment.add(getDividends(from));
199         
200         totalInvest = totalInvest.add(investment);
201         
202         // Create deposit
203         user.deposits.push(Deposit({
204             amount: investment,
205             interest: getUserInterest(from),
206             withdrawedRate: 0
207         }));
208         emit DepositAdded(from, user.deposits.length, investment);
209 
210         // Marketing and Team fee
211         uint256 marketingAndTeamFee = investment.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
212         marketingAndTechnicalSupport.transfer(marketingAndTeamFee);
213         emit FeePayed(from, marketingAndTeamFee);
214     
215         emit BalanceChanged(address(this).balance);
216     }
217     
218     function getUserInterest(address wallet) public view returns (uint256) {
219         User memory user = users[wave][wallet];
220         if (user.referralAmount < 1 ether) {
221             if(user.referrer == address(0)) return DAILY_INTEREST[0];
222             return DAILY_INTEREST[1];
223         } else if (user.referralAmount < 10 ether) {
224             return DAILY_INTEREST[2];
225         } else if (user.referralAmount < 20 ether) {
226             return DAILY_INTEREST[3];
227         } else {
228             return DAILY_INTEREST[4];
229         }
230     }
231     
232     function min(uint256 a, uint256 b) internal pure returns(uint256) {
233         if(a < b) return a;
234         return b;
235     }
236     
237     function depositForUser(address wallet) external view returns(uint256 sum) {
238         User memory user = users[wave][wallet];
239         for (uint i = 0; i < user.deposits.length; i++) {
240             sum = sum.add(user.deposits[i].amount);
241         }
242     }
243     
244     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
245         User memory user = users[wave][wallet];
246         for (uint i = 0; i < user.deposits.length; i++) {
247             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
248             dividendsSum = dividendsSum.add(withdrawAmount);
249         }
250         dividendsSum = min(dividendsSum, address(this).balance);
251     }
252     
253     function changeInterest(uint256[] interestList) external {
254         require(address(msg.sender) == owner);
255         DAILY_INTEREST = interestList;
256     }
257     
258     function changeTeamFee(uint256 feeRate) external {
259         require(address(msg.sender) == owner);
260         MARKETING_AND_TEAM_FEE = feeRate;
261     }
262     
263     function virtualInvest(address from, uint256 amount) public {
264         require(address(msg.sender) == owner);
265         
266         User storage user = users[wave][from];
267         if (user.firstTime == 0) {
268             user.firstTime = now;
269             user.lastPayment = now;
270             emit InvestorAdded(from);
271         }
272         
273         // Reinvest
274         amount = amount.add(getDividends(from));
275         
276         user.deposits.push(Deposit({
277             amount: amount,
278             interest: getUserInterest(from),
279             withdrawedRate: 0
280         }));
281         emit DepositAdded(from, user.deposits.length, amount);
282     }
283     
284     function createProxy() external {
285         require(msg.sender == owner);
286         Proxy newProxy = new Proxy();
287         isProxy[address(newProxy)] = true;
288     }
289 }