1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 
68 
69 
70 contract MyEthLab {
71     using SafeMath for uint256;
72 
73     uint256 constant public PERCENT_PER_DAY = 5;                        // 0.05%
74     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;               // 100%
75     uint256 constant public MARKETING_FEE = 700;                        // 7%
76     uint256 constant public TEAM_FEE = 300;                             // 3%
77     uint256 constant public REFERRAL_PERCENTS = 300;                    // 3%
78     uint256 constant public MAX_RATE = 330;                             // 3.3%
79     uint256 constant public MAX_DAILY_LIMIT = 150 ether;                // 150 ETH
80     uint256 constant public MAX_DEPOSIT = 25 ether;                     // 25 ETH
81     uint256 constant public MIN_DEPOSIT = 50 finney;                    // 0.05 ETH
82     uint256 constant public MAX_USER_DEPOSITS_COUNT = 50;
83 
84     struct Deposit {
85         uint256 time;
86         uint256 amount;
87         uint256 rate;
88     }
89 
90     struct User {
91         address referrer;
92         uint256 firstTime;
93         uint256 lastPayment;
94         uint256 totalAmount;
95         uint256 lastInvestment;
96         uint256 depositAdditionalRate;
97         Deposit[] deposits;
98     }
99 
100     address public marketing = 0x270ff8c154d4d738B78bEd52a6885b493A2EDdA3;
101     address public team = 0x69B18e895F2D9438d2128DB8151EB6e9bB02136d;
102 
103     uint256 public totalDeposits;
104     uint256 public dailyTime;
105     uint256 public dailyLimit;
106     bool public running = true;
107     mapping(address => User) public users;
108 
109     event InvestorAdded(address indexed investor);
110     event ReferrerAdded(address indexed investor, address indexed referrer);
111     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
112     event UserDividendPayed(address indexed investor, uint256 dividend);
113     event ReferrerPayed(address indexed investor, address indexed referrer, uint256 amount, uint256 refAmount);
114     event FeePayed(address indexed investor, uint256 amount);
115     event TotalDepositsChanged(uint256 totalDeposits);
116     event BalanceChanged(uint256 balance);
117     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 rate, uint256 dividend);
118     
119     constructor() public {
120         dailyTime = now.add(1 days);
121     }
122     
123     function() public payable {
124         require(running, "MyEthLab is not running");
125         User storage user = users[msg.sender];
126 
127         if (now > dailyTime) {
128             dailyTime = now.add(1 days);
129             dailyLimit = 0;
130         }
131 
132         // Dividends
133         uint256[] memory dividends = dividendsForUser(msg.sender);
134         uint256 dividendsSum = _dividendsSum(dividends);
135         if (dividendsSum > 0) {
136 
137             // One payment per hour and first payment will be after 24 hours
138             if ((now.sub(user.lastPayment)) > 1 hours && (now.sub(user.firstTime)) > 1 days) {
139                 if (dividendsSum >= address(this).balance) {
140                 	dividendsSum = address(this).balance;
141                 	running = false;
142             	}
143                 msg.sender.transfer(dividendsSum);
144                 user.lastPayment = now;
145                 emit UserDividendPayed(msg.sender, dividendsSum);
146                 for (uint i = 0; i < dividends.length; i++) {
147                     emit DepositDividendPayed(
148                         msg.sender,
149                         i,
150                         user.deposits[i].amount,
151                         user.deposits[i].rate,
152                         dividends[i]
153                     );
154                 }
155             }
156         }
157 
158         // Deposit
159         if (msg.value > 0) {
160             require(msg.value >= MIN_DEPOSIT, "You dont have enough ethers");
161 
162             uint256 userTotalDeposit = user.totalAmount.add(msg.value);
163             require(userTotalDeposit <= MAX_DEPOSIT, "You have enough invesments");
164 
165             if (user.firstTime != 0 && (now.sub(user.lastInvestment)) > 1 days) {
166                 user.depositAdditionalRate = user.depositAdditionalRate.add(5);
167             }
168 
169             if (user.firstTime == 0) {
170                 user.firstTime = now;
171                 emit InvestorAdded(msg.sender);
172             }
173 
174             user.lastInvestment = now;
175             user.totalAmount = userTotalDeposit;
176 
177             uint currentRate = getRate(userTotalDeposit).add(user.depositAdditionalRate).add(balanceAdditionalRate());
178             if (currentRate > MAX_RATE) {
179                 currentRate = MAX_RATE;
180             }
181 
182             // Create deposit
183             user.deposits.push(Deposit({
184                 time: now,
185                 amount: msg.value,
186                 rate: currentRate
187             }));
188 
189             require(user.deposits.length <= MAX_USER_DEPOSITS_COUNT, "Too many deposits per user");
190             emit DepositAdded(msg.sender, user.deposits.length, msg.value);
191 
192             // Check daily limit and Add daily amount of etheres
193             dailyLimit = dailyLimit.add(msg.value);
194             require(dailyLimit < MAX_DAILY_LIMIT, "Please wait one more day too invest");
195 
196             // Add to total deposits
197             totalDeposits = totalDeposits.add(msg.value);
198             emit TotalDepositsChanged(totalDeposits);
199 
200             // Add referral if possible
201             if (user.referrer == address(0) && msg.data.length == 20) {
202                 address referrer = _bytesToAddress(msg.data);
203                 if (referrer != address(0) && referrer != msg.sender && now >= users[referrer].firstTime) {
204                     user.referrer = referrer;
205                     emit ReferrerAdded(msg.sender, referrer);
206                 }
207             }
208 
209             // Referrers fees
210             if (users[msg.sender].referrer != address(0)) {
211                 address referrerAddress = users[msg.sender].referrer;
212                 uint256 refAmount = msg.value.mul(REFERRAL_PERCENTS).div(ONE_HUNDRED_PERCENTS);
213                 referrerAddress.send(refAmount); // solium-disable-line security/no-send
214                 emit ReferrerPayed(msg.sender, referrerAddress, msg.value, refAmount);
215             }
216 
217             // Marketing and team fees
218             uint256 marketingFee = msg.value.mul(MARKETING_FEE).div(ONE_HUNDRED_PERCENTS);
219             uint256 teamFee = msg.value.mul(TEAM_FEE).div(ONE_HUNDRED_PERCENTS);
220             marketing.send(marketingFee); // solium-disable-line security/no-send
221             team.send(teamFee); // solium-disable-line security/no-send
222             emit FeePayed(msg.sender, marketingFee.add(teamFee));            
223         }
224 
225         emit BalanceChanged(address(this).balance);
226     }
227 
228     function depositsCountForUser(address wallet) public view returns(uint256) {
229         return users[wallet].deposits.length;
230     }
231 
232     function depositForUser(address wallet, uint256 index) public view returns(uint256 time, uint256 amount, uint256 rate) {
233         time = users[wallet].deposits[index].time;
234         amount = users[wallet].deposits[index].amount;
235         rate = users[wallet].deposits[index].rate;
236     }
237 
238     function dividendsSumForUser(address wallet) public view returns(uint256 dividendsSum) {
239         return _dividendsSum(dividendsForUser(wallet));
240     }
241 
242     function dividendsForUser(address wallet) public view returns(uint256[] dividends) {
243         User storage user = users[wallet];
244         dividends = new uint256[](user.deposits.length);
245 
246         for (uint i = 0; i < user.deposits.length; i++) {
247             uint256 duration = now.sub(user.lastPayment);
248             dividends[i] = dividendsForAmountAndTime(user.deposits[i].rate, user.deposits[i].amount, duration);
249         }
250     }
251 
252     function dividendsForAmountAndTime(uint256 rate, uint256 amount, uint256 duration) public pure returns(uint256) {
253         return amount
254             .mul(rate).div(ONE_HUNDRED_PERCENTS)
255             .mul(duration).div(1 days);
256     }
257 
258     function _bytesToAddress(bytes data) private pure returns(address addr) {
259         // solium-disable-next-line security/no-inline-assembly
260         assembly {
261             addr := mload(add(data, 20)) 
262         }
263     }
264 
265     function _dividendsSum(uint256[] dividends) private pure returns(uint256 dividendsSum) {
266         for (uint i = 0; i < dividends.length; i++) {
267             dividendsSum = dividendsSum.add(dividends[i]);
268         }
269     }
270     
271     function getRate(uint256 userTotalDeposit) private pure returns(uint256) {
272         if (userTotalDeposit < 5 ether) {
273             return 180;
274         } else if (userTotalDeposit < 10 ether) {
275             return 200;
276         } else {
277             return 220;
278         }
279     }
280     
281     function balanceAdditionalRate() public view returns(uint256) {
282         if (address(this).balance < 600 ether) {
283             return 0;
284         } else if (address(this).balance < 1200 ether) {
285             return 10;
286         } else if (address(this).balance < 1800 ether) {
287             return 20;
288         } else if (address(this).balance < 2400 ether) {
289             return 30;
290         } else if (address(this).balance < 3000 ether) {
291             return 40;
292         } else {
293             return 50;
294         }
295     }
296 }