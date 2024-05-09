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
52     ETH_8 eth_8;
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
69         eth_8.doInvest(msg.sender, msg.value, newReferrer);
70         address(eth_8).transfer(msg.value);
71     }
72     
73     function _bytesToAddress(bytes data) private pure returns(address addr) {
74         // solium-disable-next-line security/no-inline-assembly
75         assembly {
76             addr := mload(add(data, 20)) 
77         }
78     }
79     
80     function resetContribution() external {
81         require(msg.sender == eth_8.owner());
82         contribution = 0;
83     }
84 }
85 
86 contract ETH_8 {
87     using SafeMath for uint256;
88 
89     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
90     uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%
91     uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%
92     uint256 public referralPercents = 1000;                             // 10%
93     uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%
94     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
95     uint256 public wave = 0;
96     uint256 public totalInvest = 0;
97     uint256 public totalDividend = 0;
98     mapping(address => bool) public isProxy;
99 
100     struct Deposit {
101         uint256 amount;
102         uint256 interest;
103         uint256 withdrawedRate;
104     }
105 
106     struct User {
107         address referrer;
108         uint256 referralAmount;
109         uint256 firstTime;
110         uint256 lastPayment;
111         Deposit[] deposits;
112         uint256 referBonus;
113     }
114 
115     address public marketingAndTechnicalSupport = 0xC93C7F3Ac689B822C3e9d09b9cA8934e54cf1D70; // need to change
116     address public owner = 0xbBdE48b0c31dA0DD601DA38F31dcf92b04f42588;
117     mapping(uint256 => mapping(address => User)) public users;
118 
119     event InvestorAdded(address indexed investor);
120     event ReferrerAdded(address indexed investor, address indexed referrer);
121     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
122     event UserDividendPayed(address indexed investor, uint256 dividend);
123     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
124     event FeePayed(address indexed investor, uint256 amount);
125     event BalanceChanged(uint256 balance);
126     event NewWave();
127     
128     function() public payable {
129         require(isProxy[msg.sender]);
130     }
131 
132     function withdrawDividends(address from) public {
133         require(isProxy[msg.sender]);
134         uint256 dividendsSum = getDividends(from);
135         require(dividendsSum > 0);
136         
137         if (address(this).balance <= dividendsSum) {
138             wave = wave.add(1);
139             totalInvest = 0;
140             dividendsSum = address(this).balance;
141             emit NewWave();
142         }
143         from.transfer(dividendsSum);
144         emit UserDividendPayed(from, dividendsSum);
145         emit BalanceChanged(address(this).balance);
146     }
147     
148     function getDividends(address wallet) internal returns(uint256 sum) {
149         User storage user = users[wave][wallet];
150         for (uint i = 0; i < user.deposits.length; i++) {
151             uint256 withdrawRate = dividendRate(wallet, i);
152             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
153             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
154             emit DepositDividendPayed(
155                 wallet,
156                 i,
157                 user.deposits[i].amount,
158                 user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),
159                 user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))
160             );
161         }
162         user.lastPayment = now;
163         sum = sum.add(user.referBonus);
164         user.referBonus = 0;
165         totalDividend = totalDividend.add(sum);
166     }
167 
168     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
169         User memory user = users[wave][wallet];
170         uint256 duration = now.sub(user.lastPayment);
171         rate = user.deposits[index].interest.mul(duration).div(1 days);
172         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
173         rate = min(rate, leftRate);
174     }
175 
176     function doInvest(address from, uint256 investment, address newReferrer) public payable {
177         require(isProxy[msg.sender]);
178         require (investment >= MINIMUM_DEPOSIT);
179         
180         User storage user = users[wave][from];
181         if (user.firstTime == 0) {
182             user.firstTime = now;
183             user.lastPayment = now;
184             emit InvestorAdded(from);
185         }
186 
187         // Add referral if possible
188         if (user.referrer == address(0)
189             && user.firstTime == now
190             && newReferrer != address(0)
191             && newReferrer != from
192             && users[wave][newReferrer].firstTime > 0
193         ) {
194             user.referrer = newReferrer;
195             emit ReferrerAdded(from, newReferrer);
196         }
197         
198         // Referrers fees
199         if (user.referrer != address(0)) {
200             uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
201             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
202             user.referrer.transfer(refAmount);
203         }
204         
205         // Reinvest
206         investment = investment.add(getDividends(from));
207         
208         totalInvest = totalInvest.add(investment);
209         
210         // Create deposit
211         user.deposits.push(Deposit({
212             amount: investment,
213             interest: getUserInterest(from),
214             withdrawedRate: 0
215         }));
216         emit DepositAdded(from, user.deposits.length, investment);
217 
218         // Marketing and Team fee
219         uint256 marketingAndTeamFee = investment.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
220         marketingAndTechnicalSupport.transfer(marketingAndTeamFee);
221         emit FeePayed(from, marketingAndTeamFee);
222     
223         emit BalanceChanged(address(this).balance);
224     }
225     
226     function getUserInterest(address wallet) public view returns (uint256) {
227         User memory user = users[wave][wallet];
228         if (user.referralAmount < 1 ether) {
229             if(user.referrer == address(0)) return DAILY_INTEREST[0];
230             return DAILY_INTEREST[1];
231         } else if (user.referralAmount < 10 ether) {
232             return DAILY_INTEREST[2];
233         } else if (user.referralAmount < 20 ether) {
234             return DAILY_INTEREST[3];
235         } else {
236             return DAILY_INTEREST[4];
237         }
238     }
239     
240     function min(uint256 a, uint256 b) internal pure returns(uint256) {
241         if(a < b) return a;
242         return b;
243     }
244     
245     function depositForUser(address wallet) external view returns(uint256 sum) {
246         User memory user = users[wave][wallet];
247         for (uint i = 0; i < user.deposits.length; i++) {
248             sum = sum.add(user.deposits[i].amount);
249         }
250     }
251     
252     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
253         User memory user = users[wave][wallet];
254         for (uint i = 0; i < user.deposits.length; i++) {
255             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
256             dividendsSum = dividendsSum.add(withdrawAmount);
257         }
258         dividendsSum = dividendsSum.add(user.referBonus);
259         dividendsSum = min(dividendsSum, address(this).balance);
260     }
261     
262     function changeInterest(uint256[] interestList) external {
263         require(address(msg.sender) == owner);
264         DAILY_INTEREST = interestList;
265     }
266     
267     function changeTeamFee(uint256 feeRate) external {
268         require(address(msg.sender) == owner);
269         MARKETING_AND_TEAM_FEE = feeRate;
270     }
271     
272     function virtualInvest(address from, uint256 amount) public {
273         require(address(msg.sender) == owner);
274         
275         User storage user = users[wave][from];
276         if (user.firstTime == 0) {
277             user.firstTime = now;
278             user.lastPayment = now;
279             emit InvestorAdded(from);
280         }
281         
282         // Reinvest
283         amount = amount.add(getDividends(from));
284         
285         user.deposits.push(Deposit({
286             amount: amount,
287             interest: getUserInterest(from),
288             withdrawedRate: 0
289         }));
290         emit DepositAdded(from, user.deposits.length, amount);
291     }
292     
293     function createProxy() external {
294         require(msg.sender == owner);
295         Proxy newProxy = new Proxy();
296         isProxy[address(newProxy)] = true;
297     }
298 }