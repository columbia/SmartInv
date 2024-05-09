1 /*
2  * EtherLab is an investment fund.
3  * Telegram: https://t.me/EtherLabBot.
4  * The profit is 1.5% for 24 hours.
5  * The deposit is included in the payments, 100 days after the deposit is over and eliminated.
6  * Minimum deposit is 0.01 ETH.
7  * Each deposit is a new deposit contributed to the community.
8  * No more than 50 deposits from one ETH wallet are allowed.
9  * Referral system:
10  *   Line 1 - 3%
11  *   Line 2 - 1.5%
12  *   Line 3 - 0.5%
13  * If you indicate your referral, you get 2% refback.
14  */
15 
16 pragma solidity ^0.4.24;
17 
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
24     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25     // benefit is lost if 'b' is also tested.
26     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27     if (_a == 0) {
28       return 0;
29     }
30 
31     c = _a * _b;
32     assert(c / _a == _b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     // assert(_b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = _a / _b;
42     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
43     return _a / _b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     assert(_b <= _a);
51     return _a - _b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
58     c = _a + _b;
59     assert(c >= _a);
60     return c;
61   }
62 }
63 
64 contract EtherLab {
65     using SafeMath for uint256;
66     
67     uint256 constant public TOTAL = 10000;                              // 100%
68     uint256 constant public DIVIDENTS = 150;                            // 1.5%
69     uint256 constant public MARKETING = 2000;                           // 20%
70     uint256 constant public COMISSION = 500;                            // 5%
71     uint256 constant public DEPOSIT_TIME = 100 days;                    // 150%
72     uint256 constant public REFBACK = 200;                              // 2%
73     uint256[] /*constant*/ public referralPercents = [300, 150, 50];   // 3%, 1.5%, 0.5%
74     uint256 constant public ACTIVATE = 0;
75     uint256 constant public MAX_DEPOSITS = 50;
76 
77     struct Deposit {
78         uint256 time;
79         uint256 amount;
80     }
81 
82     struct User {
83         address referrer;
84         uint256 firstTime;
85         uint256 lastPayment;
86         Deposit[] deposits;
87     }
88     
89     address public marketing = 0xa559c2a74407CA8B283A928E8cb561A3f977AFD7;
90     address public team = 0xc0138acF1b97224E08Fd5E71f46FBEa71d481805;
91     uint256 public totalDeposits;
92     bool public running = true;
93     mapping(address => User) public users;
94     
95     event InvestorAdded(address indexed investor);
96     event ReferrerAdded(address indexed investor, address indexed referrer);
97     event DepositAdded(address indexed investor, uint256 indexed depositsCount, uint256 amount);
98     event UserDividendPayed(address indexed investor, uint256 dividend);
99     event DepositDividendPayed(address indexed investor, uint256 indexed index, uint256 deposit, uint256 totalPayed, uint256 dividend);
100     event ReferrerPayed(address indexed investor, address indexed referrer, uint256 amount, uint256 refAmount, uint256 indexed level);
101     event FeePayed(address indexed investor, uint256 amount);
102     event TotalDepositsChanged(uint256 totalDeposits);
103     event BalanceChanged(uint256 balance);
104     
105     function() public payable {
106         require(running, "EtherLab is not running");
107         User storage user = users[msg.sender];
108 
109         // Dividends
110         uint256[] memory dividends = dividendsForUser(msg.sender);
111         uint256 dividendsSum = _dividendsSum(dividends);
112         if (dividendsSum > 0) {
113             if (dividendsSum >= address(this).balance) {
114                 dividendsSum = address(this).balance;
115                 running = false;
116             }
117 
118             msg.sender.transfer(dividendsSum);
119             user.lastPayment = now;
120             emit UserDividendPayed(msg.sender, dividendsSum);
121             for (uint i = 0; i < dividends.length; i++) {
122                 emit DepositDividendPayed(
123                     msg.sender,
124                     i,
125                     user.deposits[i].amount,
126                     dividendsForAmountAndTime(user.deposits[i].amount, now.sub(user.deposits[i].time)),
127                     dividends[i]
128                 );
129             }
130 
131             // Cleanup deposits array a bit
132             for (i = 0; i < user.deposits.length; i++) {
133                 if (now >= user.deposits[i].time.add(DEPOSIT_TIME)) {
134                     user.deposits[i] = user.deposits[user.deposits.length - 1];
135                     user.deposits.length -= 1;
136                     i -= 1;
137                 }
138             }
139         }
140 
141         // Deposit
142         if (msg.value > 0) {
143             if (user.firstTime == 0) {
144                 user.firstTime = now;
145                 user.lastPayment = now;
146                 emit InvestorAdded(msg.sender);
147             }
148 
149             // Create deposit
150             user.deposits.push(Deposit({
151                 time: now,
152                 amount: msg.value
153             }));
154             require(user.deposits.length <= MAX_DEPOSITS, "Too many deposits per user");
155             emit DepositAdded(msg.sender, user.deposits.length, msg.value);
156 
157             // Add to total deposits
158             totalDeposits = totalDeposits.add(msg.value);
159             emit TotalDepositsChanged(totalDeposits);
160 
161             // Add referral if possible
162             if (user.referrer == address(0) && msg.data.length == 20) {
163                 address referrer = _bytesToAddress(msg.data);
164                 if (referrer != address(0) && referrer != msg.sender && users[referrer].firstTime > 0 && now >= users[referrer].firstTime.add(ACTIVATE))
165                 {
166                     user.referrer = referrer;
167                     msg.sender.transfer(msg.value.mul(REFBACK).div(TOTAL));
168                     emit ReferrerAdded(msg.sender, referrer);
169                 }
170             }
171 
172             // Referrers fees
173             referrer = users[msg.sender].referrer;
174             for (i = 0; referrer != address(0) && i < referralPercents.length; i++) {
175                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(TOTAL);
176                 referrer.send(refAmount); // solium-disable-line security/no-send
177                 emit ReferrerPayed(msg.sender, referrer, msg.value, refAmount, i);
178                 referrer = users[referrer].referrer;
179             }
180 
181             // Marketing and team fees
182             uint256 marketingFee = msg.value.mul(MARKETING).div(TOTAL);
183             uint256 teamFee = msg.value.mul(COMISSION).div(TOTAL);
184             marketing.send(marketingFee); // solium-disable-line security/no-send
185             team.send(teamFee); // solium-disable-line security/no-send
186             emit FeePayed(msg.sender, marketingFee.add(teamFee));
187         }
188 
189     }
190 
191     function depositsCountForUser(address wallet) public view returns(uint256) {
192         return users[wallet].deposits.length;
193     }
194 
195     function depositForUser(address wallet, uint256 index) public view returns(uint256 time, uint256 amount) {
196         time = users[wallet].deposits[index].time;
197         amount = users[wallet].deposits[index].amount;
198     }
199 
200     function dividendsSumForUser(address wallet) public view returns(uint256 dividendsSum) {
201         return _dividendsSum(dividendsForUser(wallet));
202     }
203 
204     function dividendsForUser(address wallet) public view returns(uint256[] dividends) {
205         User storage user = users[wallet];
206         dividends = new uint256[](user.deposits.length);
207 
208         for (uint i = 0; i < user.deposits.length; i++) {
209             uint256 howOld = now.sub(user.deposits[i].time);
210             uint256 duration = now.sub(user.lastPayment);
211             if (howOld > DEPOSIT_TIME) {
212                 uint256 overtime = howOld.sub(DEPOSIT_TIME);
213                 duration = duration.sub(overtime);
214             }
215 
216             dividends[i] = dividendsForAmountAndTime(user.deposits[i].amount, duration);
217         }
218     }
219 
220     function dividendsForAmountAndTime(uint256 amount, uint256 duration) public pure returns(uint256) {
221         return amount
222             .mul(DIVIDENTS).div(TOTAL)
223             .mul(duration).div(1 days);
224     }
225 
226     function _bytesToAddress(bytes data) private pure returns(address addr) {
227         // solium-disable-next-line security/no-inline-assembly
228         assembly {
229             addr := mload(add(data, 20)) 
230         }
231     }
232 
233     function _dividendsSum(uint256[] dividends) private pure returns(uint256 dividendsSum) {
234         for (uint i = 0; i < dividends.length; i++) {
235             dividendsSum = dividendsSum.add(dividends[i]);
236         }
237     }
238 }