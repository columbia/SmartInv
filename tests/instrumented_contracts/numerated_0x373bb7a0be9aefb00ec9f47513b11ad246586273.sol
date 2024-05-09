1 pragma solidity ^0.4.24;
2 
3 /*
4  * ETH SMART GAME DISTRIBUTION PROJECT
5  * Web:                     https://efirica.io
6  * Telegram_channel:        https://t.me/efirica_io
7  * EN Telegram_chat:        https://t.me/efirica_chat
8  * RU Telegram_chat:        https://t.me/efirica_chat_ru
9  * Telegram Support:        @efirica
10  * 
11  * - GAIN 0.5-5% per 24 HOURS lifetime income without invitations
12  * - Life-long payments
13  * - New technologies on blockchain
14  * - Unique code (without admin, automatic % health for lifelong game, not fork !!! )
15  * - Minimal contribution 0.01 eth
16  * - Currency and payment - ETH
17  * - Contribution allocation schemes:
18  *    -- 99% payments (In some cases, the included 10% marketing to players when specifying a referral link)
19  *    -- 1% technical support
20  * 
21  * --- About the Project
22  * EFIRICA - smart game contract, new technologies on blockchain ETH, have opened code allowing
23  *           to work autonomously without admin for as long as possible with honest smart code.
24  */
25 
26 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
38     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
39     // benefit is lost if 'b' is also tested.
40     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41     if (_a == 0) {
42       return 0;
43     }
44 
45     c = _a * _b;
46     assert(c / _a == _b);
47     return c;
48   }
49 
50   /**
51   * @dev Integer division of two numbers, truncating the quotient.
52   */
53   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
54     // assert(_b > 0); // Solidity automatically throws when dividing by 0
55     // uint256 c = _a / _b;
56     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
57     return _a / _b;
58   }
59 
60   /**
61   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
62   */
63   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     assert(_b <= _a);
65     return _a - _b;
66   }
67 
68   /**
69   * @dev Adds two numbers, throws on overflow.
70   */
71   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
72     c = _a + _b;
73     assert(c >= _a);
74     return c;
75   }
76 }
77 
78 // File: contracts/Efirica.sol
79 
80 contract Efirica {
81     using SafeMath for uint256;
82 
83     uint256 constant public ONE_HUNDRED_PERCENTS = 10000;
84     uint256 constant public LOWEST_DIVIDEND_PERCENTS = 50;            // 0.50%
85     uint256 constant public HIGHEST_DIVIDEND_PERCENTS = 500;          // 5.00%
86     uint256 constant public REFERRAL_ACTIVATION_TIME = 1 days;
87     uint256[] /*constant*/ public referralPercents = [500, 300, 200]; // 5%, 3%, 2%
88 
89     bool public running = true;
90     address public admin = msg.sender;
91     uint256 public totalDeposits = 0;
92     mapping(address => uint256) public deposits;
93     mapping(address => uint256) public withdrawals;
94     mapping(address => uint256) public joinedAt;
95     mapping(address => uint256) public updatedAt;
96     mapping(address => address) public referrers;
97     mapping(address => uint256) public refCount;
98     mapping(address => uint256) public refEarned;
99 
100     event InvestorAdded(address indexed investor);
101     event ReferrerAdded(address indexed investor, address indexed referrer);
102     event DepositAdded(address indexed investor, uint256 deposit, uint256 amount);
103     event DividendPayed(address indexed investor, uint256 dividend);
104     event ReferrerPayed(address indexed investor, uint256 indexed level, address referrer, uint256 amount);
105     event AdminFeePayed(address indexed investor, uint256 amount);
106     event TotalDepositsChanged(uint256 totalDeposits);
107     event BalanceChanged(uint256 balance);
108     
109     function() public payable {
110         require(running, "Project is not running");
111 
112         // Dividends
113         uint256 dividends = dividendsForUser(msg.sender);
114         if (dividends > 0) {
115             if (dividends > address(this).balance) {
116                 dividends = address(this).balance;
117                 running = false;
118             }
119             msg.sender.transfer(dividends);
120             withdrawals[msg.sender] = withdrawals[msg.sender].add(dividends);
121             updatedAt[msg.sender] = now;
122             emit DividendPayed(msg.sender, dividends);
123         }
124 
125         // Deposit
126         if (msg.value > 0) {
127             if (deposits[msg.sender] == 0) {
128                 joinedAt[msg.sender] = now;
129                 emit InvestorAdded(msg.sender);
130             }
131             updatedAt[msg.sender] = now;
132             deposits[msg.sender] = deposits[msg.sender].add(msg.value);
133             emit DepositAdded(msg.sender, deposits[msg.sender], msg.value);
134 
135             totalDeposits = totalDeposits.add(msg.value);
136             emit TotalDepositsChanged(totalDeposits);
137 
138             // Add referral if possible
139             if (referrers[msg.sender] == address(0) && msg.data.length == 20) {
140                 address referrer = bytesToAddress(msg.data);
141                 if (referrer != address(0) && deposits[referrer] > 0 && now >= joinedAt[referrer].add(REFERRAL_ACTIVATION_TIME)) {
142                     referrers[msg.sender] = referrer;
143                     refCount[referrer] += 1;
144                     emit ReferrerAdded(msg.sender, referrer);
145                 }
146             }
147 
148             // Referrers fees
149             referrer = referrers[msg.sender];
150             for (uint i = 0; referrer != address(0) && i < referralPercents.length; i++) {
151                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);
152                 referrer.send(refAmount); // solium-disable-line security/no-send
153                 refEarned[referrer] = refEarned[referrer].add(refAmount);
154                 emit ReferrerPayed(msg.sender, i, referrer, refAmount);
155                 referrer = referrers[referrer];
156             }
157 
158             // Admin fee 1%
159             uint256 adminFee = msg.value.div(100);
160             admin.send(adminFee); // solium-disable-line security/no-send
161             emit AdminFeePayed(msg.sender, adminFee);
162         }
163 
164         emit BalanceChanged(address(this).balance);
165     }
166 
167     function dividendsForUser(address user) public view returns(uint256) {
168         return dividendsForPercents(user, percentsForUser(user));
169     }
170 
171     function dividendsForPercents(address user, uint256 percents) public view returns(uint256) {
172         return deposits[user]
173             .mul(percents).div(ONE_HUNDRED_PERCENTS)
174             .mul(now.sub(updatedAt[user])).div(1 days); // solium-disable-line security/no-block-members
175     }
176 
177     function percentsForUser(address user) public view returns(uint256) {
178         uint256 percents = generalPercents();
179 
180         // Referrals should have increased percents (+10%)
181         if (referrers[user] != address(0)) {
182             percents = percents.mul(110).div(100);
183         }
184 
185         return percents;
186     }
187 
188     function generalPercents() public view returns(uint256) {
189         uint256 health = healthPercents();
190         if (health >= ONE_HUNDRED_PERCENTS.mul(80).div(100)) { // health >= 80%
191             return HIGHEST_DIVIDEND_PERCENTS;
192         }
193 
194         // From 5% to 0.5% with 0.1% step (45 steps) while health drops from 100% to 0% 
195         uint256 percents = LOWEST_DIVIDEND_PERCENTS.add(
196             HIGHEST_DIVIDEND_PERCENTS.sub(LOWEST_DIVIDEND_PERCENTS)
197                 .mul(healthPercents().mul(45).div(ONE_HUNDRED_PERCENTS.mul(80).div(100))).div(45)
198         );
199 
200         return percents;
201     }
202 
203     function healthPercents() public view returns(uint256) {
204         if (totalDeposits == 0) {
205             return ONE_HUNDRED_PERCENTS;
206         }
207 
208         return address(this).balance
209             .mul(ONE_HUNDRED_PERCENTS).div(totalDeposits);
210     }
211 
212     function bytesToAddress(bytes data) internal pure returns(address addr) {
213         // solium-disable-next-line security/no-inline-assembly
214         assembly {
215             addr := mload(add(data, 0x14)) 
216         }
217     }
218 }