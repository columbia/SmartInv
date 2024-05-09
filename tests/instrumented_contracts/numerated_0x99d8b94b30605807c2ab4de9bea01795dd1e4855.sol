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
57     
58     function() public payable {
59         
60         if(msg.value == 0) {
61             // Dividends
62             lottery.withdrawDividends(msg.sender);
63             return;
64         }
65         
66         address newReferrer = _bytesToAddress(msg.data);
67         // Deposit
68         contribution = contribution.add(msg.value);
69         lottery.doInvest(msg.sender, msg.value, newReferrer);
70         address(lottery).transfer(msg.value);
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
81         require(msg.sender == lottery.owner());
82         contribution = 0;
83     }
84 }
85 
86 contract Lottery {
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
99     address public proxy;
100 
101     struct Deposit {
102         uint256 amount;
103         uint256 interest;
104         uint256 withdrawedRate;
105     }
106 
107     struct User {
108         address referrer;
109         uint256 referralAmount;
110         uint256 firstTime;
111         uint256 lastPayment;
112         Deposit[] deposits;
113         uint256 referBonus;
114     }
115 
116     address public marketingAndTechnicalSupport = 0xFaea7fa229C29526698657e7Ab7063E20581A50c; // need to change
117     address public owner = 0x4e3e605b9f7b333e413E1CD9E577f2eba447f876;
118     mapping(uint256 => mapping(address => User)) public users;
119 
120     event InvestorAdded(address indexed investor);
121     event ReferrerAdded(address indexed investor, address indexed referrer);
122     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
123     event UserDividendPayed(address indexed investor, uint256 dividend);
124     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
125     event FeePayed(address indexed investor, uint256 amount);
126     event BalanceChanged(uint256 balance);
127     event NewWave();
128     
129     function() public payable {
130         require(isProxy[msg.sender]);
131     }
132         
133     function withdrawDividends(address from) public {
134         require(isProxy[msg.sender]);
135         uint256 dividendsSum = getDividends(from);
136         require(dividendsSum > 0);
137         
138         if (address(this).balance <= dividendsSum) {
139             wave = wave.add(1);
140             totalInvest = 0;
141             dividendsSum = address(this).balance;
142             emit NewWave();
143         }
144         from.transfer(dividendsSum);
145         emit UserDividendPayed(from, dividendsSum);
146         emit BalanceChanged(address(this).balance);
147     }
148     
149     function getDividends(address wallet) internal returns(uint256 sum) {
150         User storage user = users[wave][wallet];
151         for (uint i = 0; i < user.deposits.length; i++) {
152             uint256 withdrawRate = dividendRate(wallet, i);
153             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
154             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
155             emit DepositDividendPayed(
156                 wallet,
157                 i,
158                 user.deposits[i].amount,
159                 user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),
160                 user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))
161             );
162         }
163         user.lastPayment = now;
164         sum = sum.add(user.referBonus);
165         user.referBonus = 0;
166         totalDividend = totalDividend.add(sum);
167     }
168 
169     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
170         User memory user = users[wave][wallet];
171         uint256 duration = now.sub(user.lastPayment);
172         rate = user.deposits[index].interest.mul(duration).div(1 days);
173         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
174         rate = min(rate, leftRate);
175     }
176 
177     function doInvest(address from, uint256 investment, address newReferrer) public payable {
178         require(isProxy[msg.sender]);
179         require (investment >= MINIMUM_DEPOSIT);
180         
181         User storage user = users[wave][from];
182         if (user.firstTime == 0) {
183             user.firstTime = now;
184             user.lastPayment = now;
185             emit InvestorAdded(from);
186         }
187 
188         // Add referral if possible
189         if (user.referrer == address(0) 
190             && msg.data.length == 20 
191             && user.firstTime == now
192             && newReferrer != address(0) 
193             && newReferrer != from
194             && users[wave][newReferrer].firstTime > 0
195         ) {
196             user.referrer = newReferrer;
197             emit ReferrerAdded(from, newReferrer);
198         }
199         
200         // Referrers fees
201         if (user.referrer != address(0)) {
202             uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
203             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
204             user.referrer.transfer(refAmount);
205         }
206         
207         // Reinvest
208         investment = investment.add(getDividends(from));
209         
210         totalInvest = totalInvest.add(investment);
211         
212         // Create deposit
213         user.deposits.push(Deposit({
214             amount: investment,
215             interest: getUserInterest(from),
216             withdrawedRate: 0
217         }));
218         emit DepositAdded(from, user.deposits.length, investment);
219 
220         // Marketing and Team fee
221         uint256 marketingAndTeamFee = msg.value.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
222         marketingAndTechnicalSupport.transfer(marketingAndTeamFee);
223         emit FeePayed(from, marketingAndTeamFee);
224     
225         emit BalanceChanged(address(this).balance);
226     }
227     
228     function getUserInterest(address wallet) public view returns (uint256) {
229         User memory user = users[wave][wallet];
230         if (user.referralAmount < 1 ether) {
231             if(user.referrer == address(0)) return DAILY_INTEREST[0];
232             return DAILY_INTEREST[1];
233         } else if (user.referralAmount < 10 ether) {
234             return DAILY_INTEREST[2];
235         } else if (user.referralAmount < 20 ether) {
236             return DAILY_INTEREST[3];
237         } else {
238             return DAILY_INTEREST[4];
239         }
240     }
241     
242     function min(uint256 a, uint256 b) internal pure returns(uint256) {
243         if(a < b) return a;
244         return b;
245     }
246     
247     function depositForUser(address wallet) external view returns(uint256 sum) {
248         User memory user = users[wave][wallet];
249         for (uint i = 0; i < user.deposits.length; i++) {
250             sum = sum.add(user.deposits[i].amount);
251         }
252     }
253     
254     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
255         User memory user = users[wave][wallet];
256         for (uint i = 0; i < user.deposits.length; i++) {
257             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
258             dividendsSum = dividendsSum.add(withdrawAmount);
259         }
260         dividendsSum = dividendsSum.add(user.referBonus);
261         dividendsSum = min(dividendsSum, address(this).balance);
262     }
263     
264     function changeInterest(uint256[] interestList) external {
265         require(address(msg.sender) == owner);
266         DAILY_INTEREST = interestList;
267     }
268     
269     function changeTeamFee(uint256 feeRate) external {
270         require(address(msg.sender) == owner);
271         MARKETING_AND_TEAM_FEE = feeRate;
272     }
273     
274     function virtualInvest(address from, uint256 amount) public {
275         require(address(msg.sender) == owner);
276         
277         User storage user = users[wave][from];
278         if (user.firstTime == 0) {
279             user.firstTime = now;
280             user.lastPayment = now;
281             emit InvestorAdded(from);
282         }
283         
284         // Reinvest
285         amount = amount.add(getDividends(from));
286         
287         user.deposits.push(Deposit({
288             amount: amount,
289             interest: getUserInterest(from),
290             withdrawedRate: 0
291         }));
292         emit DepositAdded(from, user.deposits.length, amount);
293     }
294     
295     function createProxy() external {
296         require(msg.sender == owner);
297         Proxy newProxy = new Proxy();
298         proxy = address(newProxy);
299         isProxy[address(newProxy)] = true;
300     }
301 }