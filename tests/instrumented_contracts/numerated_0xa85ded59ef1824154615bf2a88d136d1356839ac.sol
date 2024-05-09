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
49 contract Lottery {
50     using SafeMath for uint256;
51 
52     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
53     uint256[] public DAILY_INTEREST = [111, 133, 222, 333, 444];        // 1.11%, 2.22%, 3.33%, 4.44%
54     uint256 public MARKETING_AND_TEAM_FEE = 1000;                       // 10%
55     uint256 public referralPercents = 1000;                             // 10%
56     uint256 constant public MAX_DIVIDEND_RATE = 25000;                  // 250%
57     uint256 constant public MINIMUM_DEPOSIT = 100 finney;               // 0.1 eth
58     uint256 public wave = 0;
59 
60     struct Deposit {
61         uint256 amount;
62         uint256 interest;
63         uint256 withdrawedRate;
64     }
65 
66     struct User {
67         address referrer;
68         uint256 referralAmount;
69         uint256 firstTime;
70         uint256 lastPayment;
71         Deposit[] deposits;
72         uint256 referBonus;
73     }
74 
75     address public marketingAndTeam = 0xFaea7fa229C29526698657e7Ab7063E20581A50c; // need to change
76     address public owner = 0x4e3e605b9f7b333e413E1CD9E577f2eba447f876;
77     mapping(uint256 => mapping(address => User)) public users;
78 
79     event InvestorAdded(address indexed investor);
80     event ReferrerAdded(address indexed investor, address indexed referrer);
81     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
82     event UserDividendPayed(address indexed investor, uint256 dividend);
83     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
84     event FeePayed(address indexed investor, uint256 amount);
85     event BalanceChanged(uint256 balance);
86     event NewWave();
87     
88     function() public payable {
89         
90         if(msg.value == 0) {
91             // Dividends
92             withdrawDividends();
93             return;
94         }
95 
96         // Deposit
97         doInvest();
98     }
99         
100     function withdrawDividends() internal {
101         uint256 dividendsSum = getDividends(msg.sender);
102         require(dividendsSum > 0);
103         
104         if (address(this).balance <= dividendsSum) {
105             wave = wave.add(1);
106             dividendsSum = address(this).balance;
107             emit NewWave();
108         }
109         msg.sender.transfer(dividendsSum);
110         emit UserDividendPayed(msg.sender, dividendsSum);
111         emit BalanceChanged(address(this).balance);
112     }
113     
114     function getDividends(address wallet) internal returns(uint256 sum) {
115         User storage user = users[wave][wallet];
116         for (uint i = 0; i < user.deposits.length; i++) {
117             uint256 withdrawRate = dividendRate(msg.sender, i);
118             user.deposits[i].withdrawedRate = user.deposits[i].withdrawedRate.add(withdrawRate);
119             sum = sum.add(user.deposits[i].amount.mul(withdrawRate).div(ONE_HUNDRED_PERCENTS));
120             emit DepositDividendPayed(
121                 msg.sender,
122                 i,
123                 user.deposits[i].amount,
124                 user.deposits[i].amount.mul(user.deposits[i].withdrawedRate.div(ONE_HUNDRED_PERCENTS)),
125                 user.deposits[i].amount.mul(withdrawRate.div(ONE_HUNDRED_PERCENTS))
126             );
127         }
128         user.lastPayment = now;
129         sum = sum.add(user.referBonus);
130         user.referBonus = 0;
131     }
132 
133     function dividendRate(address wallet, uint256 index) internal view returns(uint256 rate) {
134         User memory user = users[wave][wallet];
135         uint256 duration = now.sub(user.lastPayment);
136         rate = user.deposits[index].interest.mul(duration).div(1 days);
137         uint256 leftRate = MAX_DIVIDEND_RATE.sub(user.deposits[index].withdrawedRate);
138         rate = min(rate, leftRate);
139     }
140 
141     function doInvest() internal {
142         uint256 investment = msg.value;
143         require (investment >= MINIMUM_DEPOSIT);
144         
145         User storage user = users[wave][msg.sender];
146         if (user.firstTime == 0) {
147             user.firstTime = now;
148             user.lastPayment = now;
149             emit InvestorAdded(msg.sender);
150         }
151 
152         // Add referral if possible
153         if (user.referrer == address(0) && msg.data.length == 20 && user.firstTime == now) {
154             address newReferrer = _bytesToAddress(msg.data);
155             if (newReferrer != address(0) && newReferrer != msg.sender && users[wave][newReferrer].firstTime > 0) {
156                 user.referrer = newReferrer;
157                 emit ReferrerAdded(msg.sender, newReferrer);
158             }
159         }
160         
161         // Referrers fees
162         if (user.referrer != address(0)) {
163             uint256 refAmount = investment.mul(referralPercents).div(ONE_HUNDRED_PERCENTS);
164             users[wave][user.referrer].referralAmount = users[wave][user.referrer].referralAmount.add(investment);
165             users[wave][user.referrer].referBonus = users[wave][user.referrer].referBonus.add(refAmount);
166         }
167         
168         // Reinvest
169         investment = investment.add(getDividends(msg.sender));
170         
171         // Create deposit
172         user.deposits.push(Deposit({
173             amount: investment,
174             interest: getUserInterest(msg.sender),
175             withdrawedRate: 0
176         }));
177         emit DepositAdded(msg.sender, user.deposits.length, investment);
178 
179         // Marketing and Team fee
180         uint256 marketingAndTeamFee = msg.value.mul(MARKETING_AND_TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
181         marketingAndTeam.transfer(marketingAndTeamFee);
182         emit FeePayed(msg.sender, marketingAndTeamFee);
183     
184         emit BalanceChanged(address(this).balance);
185     }
186     
187     function getUserInterest(address wallet) public view returns (uint256) {
188         User memory user = users[wave][wallet];
189         if (user.referralAmount < 1 ether) {
190             if(user.referrer == address(0)) return DAILY_INTEREST[0];
191             return DAILY_INTEREST[1];
192         } else if (user.referralAmount < 10 ether) {
193             return DAILY_INTEREST[2];
194         } else if (user.referralAmount < 20 ether) {
195             return DAILY_INTEREST[3];
196         } else {
197             return DAILY_INTEREST[4];
198         }
199     }
200 
201     function _bytesToAddress(bytes data) private pure returns(address addr) {
202         // solium-disable-next-line security/no-inline-assembly
203         assembly {
204             addr := mload(add(data, 20)) 
205         }
206     }
207     
208     function min(uint256 a, uint256 b) internal pure returns(uint256) {
209         if(a < b) return a;
210         return b;
211     }
212     
213     function dividendsSumForUser(address wallet) external view returns(uint256 dividendsSum) {
214         User memory user = users[wave][wallet];
215         for (uint i = 0; i < user.deposits.length; i++) {
216             uint256 withdrawAmount = user.deposits[i].amount.mul(dividendRate(wallet, i)).div(ONE_HUNDRED_PERCENTS);
217             dividendsSum = dividendsSum.add(withdrawAmount);
218         }
219         dividendsSum = dividendsSum.add(user.referBonus);
220         dividendsSum = min(dividendsSum, address(this).balance);
221     }
222     
223     function changeInterest(uint256[] interestList) external {
224         require(address(msg.sender) == owner);
225         DAILY_INTEREST = interestList;
226     }
227     
228     function changeTeamFee(uint256 feeRate) external {
229         require(address(msg.sender) == owner);
230         MARKETING_AND_TEAM_FEE = feeRate;
231     }
232     
233     function virtualInvest(address from, uint256 amount) public {
234         require(address(msg.sender) == owner);
235         
236         User storage user = users[wave][from];
237         if (user.firstTime == 0) {
238             user.firstTime = now;
239             user.lastPayment = now;
240             emit InvestorAdded(from);
241         }
242         
243         // Reinvest
244         amount = amount.add(getDividends(from));
245         
246         user.deposits.push(Deposit({
247             amount: amount,
248             interest: getUserInterest(from),
249             withdrawedRate: 0
250         }));
251         emit DepositAdded(from, user.deposits.length, amount);
252     }
253 }