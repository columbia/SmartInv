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
90     uint256 public currentPercents = 500; // 5%
91     mapping(address => uint256) public deposits;
92     mapping(address => uint256) public joinedAt;
93     mapping(address => uint256) public updatedAt;
94     mapping(address => address) public referrers;
95 
96     event InvestorAdded(address investor);
97     event ReferrerAdded(address investor, address referrer);
98     event DepositAdded(address investor, uint256 deposit, uint256 amount);
99     event DividendPayed(address investor, uint256 dividend);
100     event ReferrerPayed(address investor, address referrer, uint256 amount);
101     event AdminFeePayed(address investor, uint256 amount);
102     event TotalDepositsChanged(uint256 totalDeposits);
103     event BalanceChanged(uint256 balance);
104     
105     function() public payable {
106         // Dividends
107         uint256 dividends = dividendsForUser(msg.sender);
108         if (dividends > 0) {
109             if (dividends > address(this).balance) {
110                 dividends = address(this).balance;
111             }
112             msg.sender.transfer(dividends);
113             updatedAt[msg.sender] = now; // solium-disable-line security/no-block-members
114             currentPercents = generalPercents();
115             emit DividendPayed(msg.sender, dividends);
116         }
117 
118         // Deposit
119         if (msg.value > 0) {
120             if (deposits[msg.sender] == 0) {
121                 joinedAt[msg.sender] = now; // solium-disable-line security/no-block-members
122                 emit InvestorAdded(msg.sender);
123             }
124             updatedAt[msg.sender] = now; // solium-disable-line security/no-block-members
125             deposits[msg.sender] = deposits[msg.sender].add(msg.value);
126             emit DepositAdded(msg.sender, deposits[msg.sender], msg.value);
127 
128             totalDeposits = totalDeposits.add(msg.value);
129             emit TotalDepositsChanged(totalDeposits);
130 
131             // Add referral if possible
132             if (referrers[msg.sender] == address(0) && msg.data.length == 20) {
133                 address referrer = bytesToAddress(msg.data);
134                 if (referrer != address(0) && deposits[referrer] > 0 && now >= joinedAt[referrer].add(1 days)) { // solium-disable-line security/no-block-members
135                     referrers[msg.sender] = referrer;
136                     emit ReferrerAdded(msg.sender, referrer);
137                 }
138             }
139 
140             // Referrers fees
141             referrer = referrers[msg.sender];
142             for (uint i = 0; referrer != address(0) && i < referralPercents.length; i++) {
143                 uint256 refAmount = msg.value.mul(referralPercents[i]).div(ONE_HUNDRED_PERCENTS);
144                 referrer.send(refAmount); // solium-disable-line security/no-send
145                 emit ReferrerPayed(msg.sender, referrer, refAmount);
146                 referrer = referrers[referrer];
147             }
148 
149             // Admin fee 1%
150             uint256 adminFee = msg.value.div(100);
151             admin.send(adminFee); // solium-disable-line security/no-send
152             emit AdminFeePayed(msg.sender, adminFee);
153         }
154 
155         emit BalanceChanged(address(this).balance);
156     }
157 
158     function dividendsForUser(address user) public view returns(uint256) {
159         return dividendsForPercents(user, percentsForUser(user));
160     }
161 
162     function dividendsForPercents(address user, uint256 percents) public view returns(uint256) {
163         return deposits[user]
164             .mul(percents).div(ONE_HUNDRED_PERCENTS)
165             .mul(now.sub(updatedAt[user])).div(1 days); // solium-disable-line security/no-block-members
166     }
167 
168     function percentsForUser(address user) public view returns(uint256) {
169         uint256 percents = generalPercents();
170 
171         // Referrals should have increased percents (+10%)
172         if (referrers[user] != address(0)) {
173             percents = percents.mul(110).div(100);
174         }
175 
176         return percents;
177     }
178 
179     function generalPercents() public view returns(uint256) {
180         // From 5% to 0.5% with 0.1% step (45 steps) while health drops from 100% to 0% 
181         uint256 percents = LOWEST_DIVIDEND_PERCENTS.add(
182             HIGHEST_DIVIDEND_PERCENTS.sub(LOWEST_DIVIDEND_PERCENTS)
183                 .mul(healthPercents().mul(45).div(ONE_HUNDRED_PERCENTS)).div(45)
184         );
185 
186         // Percents should never increase
187         if (percents > currentPercents) {
188             percents = currentPercents;
189         }
190 
191         return percents;
192     }
193 
194     function healthPercents() public view returns(uint256) {
195         if (totalDeposits == 0) {
196             return ONE_HUNDRED_PERCENTS;
197         }
198 
199         return address(this).balance
200             .mul(ONE_HUNDRED_PERCENTS).div(totalDeposits);
201     }
202 
203     function bytesToAddress(bytes data) internal pure returns(address addr) {
204         // solium-disable-next-line security/no-inline-assembly
205         assembly {
206             addr := mload(add(data, 0x14)) 
207         }
208     }
209 }