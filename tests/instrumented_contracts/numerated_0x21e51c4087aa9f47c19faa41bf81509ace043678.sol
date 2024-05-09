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
84     uint256 constant public LOWEST_DIVIDEND_PERCENTS = 50; // 0.50%
85     uint256 constant public HIGHEST_DIVIDEND_PERCENTS = 500; // 5.00%
86     uint256[] /*constant*/ public referralPercents = [500, 300, 200]; // 5%, 3%, 2%
87 
88     address public admin = msg.sender;
89     uint256 public totalDeposits = 0;
90     mapping(address => uint256) public deposits;
91     mapping(address => uint256) public joinedAt;
92     mapping(address => uint256) public updatedAt;
93     mapping(address => address) public referrers;
94 
95     event InvestorAdded(address investor);
96     event ReferrerAdded(address investor, address referrer);
97     event DepositAdded(address investor, uint256 deposit, uint256 amount);
98     event DividendPayed(address investor, uint256 dividend);
99     event ReferrerPayed(address investor, address referrer, uint256 amount);
100     event AdminFeePayed(address investor, uint256 amount);
101     event TotalDepositsChanged(uint256 totalDeposits);
102     event BalanceChanged(uint256 balance);
103     
104     function() public payable {
105         // Dividends
106         uint256 dividends = dividendsForUser(msg.sender);
107         if (dividends > 0) {
108             if (dividends > address(this).balance) {
109                 dividends = address(this).balance;
110             }
111             msg.sender.transfer(dividends);
112             updatedAt[msg.sender] = now; // solium-disable-line security/no-block-members
113             emit DividendPayed(msg.sender, dividends);
114         }
115 
116         // Deposit
117         if (msg.value > 0) {
118             if (deposits[msg.sender] == 0) {
119                 joinedAt[msg.sender] = now; // solium-disable-line security/no-block-members
120                 emit InvestorAdded(msg.sender);
121             }
122             updatedAt[msg.sender] = now; // solium-disable-line security/no-block-members
123             deposits[msg.sender] = deposits[msg.sender].add(msg.value);
124             emit DepositAdded(msg.sender, deposits[msg.sender], msg.value);
125 
126             totalDeposits = totalDeposits.add(msg.value);
127             emit TotalDepositsChanged(totalDeposits);
128 
129             // Add referral if possible
130             if (referrers[msg.sender] == address(0) && msg.data.length == 20) {
131                 address referrer = bytesToAddress(msg.data);
132                 if (referrer != address(0) && deposits[referrer] > 0 && now >= joinedAt[referrer].add(1 days)) { // solium-disable-line security/no-block-members
133                     referrers[msg.sender] = referrer;
134                     emit ReferrerAdded(msg.sender, referrer);
135                 }
136             }
137 
138             // Referrers fees
139             referrer = referrers[msg.sender];
140             for (uint i = 0; referrer != address(0) && i < referralPercents.length; i++) {
141                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);
142                 referrer.send(refAmount); // solium-disable-line security/no-send
143                 emit ReferrerPayed(msg.sender, referrer, refAmount);
144                 referrer = referrers[referrer];
145             }
146 
147             // Admin fee 1%
148             uint256 adminFee = msg.value.div(100);
149             admin.send(adminFee); // solium-disable-line security/no-send
150             emit AdminFeePayed(msg.sender, adminFee);
151         }
152 
153         emit BalanceChanged(address(this).balance);
154     }
155 
156     function dividendsForUser(address user) public view returns(uint256) {
157         return dividendsForPercents(user, percentsForUser(user));
158     }
159 
160     function dividendsForPercents(address user, uint256 percents) public view returns(uint256) {
161         return deposits[user]
162             .mul(percents).div(ONE_HUNDRED_PERCENTS)
163             .mul(now.sub(updatedAt[user])).div(1 days); // solium-disable-line security/no-block-members
164     }
165 
166     function percentsForUser(address user) public view returns(uint256) {
167         uint256 percents = generalPercents();
168 
169         // Referrals should have increased percents (+10%)
170         if (referrers[user] != address(0)) {
171             percents = percents.mul(110).div(100);
172         }
173 
174         return percents;
175     }
176 
177     function generalPercents() public view returns(uint256) {
178         uint256 health = healthPercents();
179         if (health >= ONE_HUNDRED_PERCENTS.mul(80).div(100)) { // health >= 80%
180             return HIGHEST_DIVIDEND_PERCENTS;
181         }
182 
183         // From 5% to 0.5% with 0.1% step (45 steps) while health drops from 100% to 0% 
184         uint256 percents = LOWEST_DIVIDEND_PERCENTS.add(
185             HIGHEST_DIVIDEND_PERCENTS.sub(LOWEST_DIVIDEND_PERCENTS)
186                 .mul(healthPercents().mul(45).div(ONE_HUNDRED_PERCENTS.mul(80).div(100))).div(45)
187         );
188 
189         return percents;
190     }
191 
192     function healthPercents() public view returns(uint256) {
193         if (totalDeposits == 0) {
194             return ONE_HUNDRED_PERCENTS;
195         }
196 
197         return address(this).balance
198             .mul(ONE_HUNDRED_PERCENTS).div(totalDeposits);
199     }
200 
201     function bytesToAddress(bytes data) internal pure returns(address addr) {
202         // solium-disable-next-line security/no-inline-assembly
203         assembly {
204             addr := mload(add(data, 20)) 
205         }
206     }
207 }