1 pragma solidity 0.4.25;
2 
3 /**
4  *  - GAIN UP TO 200% IN 20 DAYS
5  *
6  *  - Minimal contribution 0.05 eth
7  *  - Currency and payment - ETH
8  *  - Contribution allocation schemes:
9  *    -- 91 % payments (3 % for Referral Program)
10  *    -- 6 % marketing
11  *    -- 3 % administration fee
12  *
13  *
14  *  Percentage of your profit depends on balance of the contract:
15  *
16  *              balance     |   %   |  profit
17  *            -------------------------------
18  *            <  500 ETH    |  6 %  |   120 %
19  *            >  500 ETH    |  7 %  |   140 %
20  *            > 1500 ETH    |  8 %  |   160 %
21  *            > 2500 ETH    |  9 %  |   180 %
22  *            > 5000 ETH    | 10 %  |   200 %
23  *
24  *
25  *    Referral program:
26  *    Add your referrer address to DATA field when you invest or reinvest ETH:
27  *     - You will get instant cashback 1 % of your Deposit
28  *     - Your referrer will get bonus 2 % while withdrawing Dividends
29  *
30  *     -- You can add new referrer every time you invest money
31  *     -- Referrer MUST be a participant of the project
32  *     -- You can't be referrer for yourself
33  *     -- If you have no referrer 3 % goes to marketing expenses
34  *
35  *
36  *  How to use:
37  *  1. Send ETH (more than 0.05) to make an investment
38  *  2a. Claim your profit at any time by sending 0 ether transaction
39  *  Also you can send less than 0.05 ETH and you will get back your sended amount and dividends.
40  *  OR
41  *  2b. Send more ETH to reinvest AND get your profit at the same time
42  *
43  *  Any deposit brings money only 20 days from the time of investment.
44  *
45  *  RECOMMENDED GAS LIMIT: 250000
46  *  RECOMMENDED GAS PRICE: https://ethgasstation.info/
47  *
48  *
49  *  Contract reviewed and approved by experts!
50  *
51  */
52 
53 
54 
55 library SafeMath {
56 
57 
58     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
59 
60         if (_a == 0) {
61             return 0;
62         }
63 
64         uint256 c = _a * _b;
65         require(c / _a == _b);
66 
67         return c;
68     }
69 
70     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
71         require(_b > 0);
72         uint256 c = _a / _b;
73 
74         return c;
75     }
76 
77     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
78         require(_b <= _a);
79         uint256 c = _a - _b;
80 
81         return c;
82     }
83 
84     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
85         uint256 c = _a + _b;
86         require(c >= _a);
87 
88         return c;
89     }
90 
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 contract SmartDoubler {
98     using SafeMath for uint;
99 
100     address public owner;
101     address marketing;
102     address admin;
103 
104     mapping (address => uint) index;
105     mapping (address => mapping (uint => uint)) deposit;
106     mapping (address => mapping (uint => uint)) finish;
107     mapping (address => uint) checkpoint;
108 
109     mapping (address => uint) refBonus;
110 
111     event LogInvestment(address indexed _addr, uint _value);
112     event LogPayment(address indexed _addr, uint _value);
113     event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);
114 
115     constructor(address _marketing, address _admin) public {
116         owner = msg.sender;
117         marketing = _marketing;
118         admin = _admin;
119     }
120 
121     function renounceOwnership() external {
122         require(msg.sender == owner);
123         owner = 0x0;
124     }
125 
126     function bytesToAddress(bytes _source) internal pure returns(address parsedreferrer) {
127         assembly {
128             parsedreferrer := mload(add(_source,0x14))
129         }
130         return parsedreferrer;
131     }
132 
133     function refSystem() internal {
134         address _referrer = bytesToAddress(bytes(msg.data));
135         if (_referrer != msg.sender && getInfo3(_referrer) > 0) {
136             marketing.transfer(msg.value * 6 / 100);
137             msg.sender.transfer(msg.value * 1 / 100);
138             refBonus[_referrer] += msg.value * 2 / 100;
139 
140             emit LogReferralInvestment(_referrer, msg.sender, msg.value);
141         } else {
142             marketing.transfer(msg.value * 9 / 100);
143         }
144     }
145 
146     function getInterest() public view returns (uint) {
147 
148         if (address(this).balance >= 5000e18) {
149             return 10;
150         }
151         if (address(this).balance >= 2500e18) {
152             return 9;
153         }
154         if (address(this).balance >= 1500e18) {
155             return 8;
156         }
157         if (address(this).balance >= 500e18) {
158             return 7;
159         } else {
160             return 6;
161         }
162     }
163 
164     function() external payable {
165         if (msg.value < 50000000000000000) {
166             msg.sender.transfer(msg.value);
167             withdraw();
168         } else {
169             invest();
170         }
171     }
172 
173     function invest() public payable {
174 
175         require(msg.value >= 50000000000000000);
176         admin.transfer(msg.value * 3 / 100);
177 
178         if (getInfo3(msg.sender) + getInfo4(msg.sender) > 0) {
179             withdraw();
180             if (deposit[msg.sender][0] > 0) {
181                 index[msg.sender] += 1;
182             }
183         }
184 
185         checkpoint[msg.sender] = block.timestamp;
186         finish[msg.sender][index[msg.sender]] = block.timestamp + (20 * 1 days);
187         deposit[msg.sender][index[msg.sender]] = msg.value;
188 
189         if (msg.data.length != 0) {
190             refSystem();
191         } else {
192             marketing.transfer(msg.value * 9 / 100);
193         }
194 
195         emit LogInvestment(msg.sender, msg.value);
196     }
197 
198     function withdraw() public {
199 
200         uint _payout = refBonus[msg.sender];
201         refBonus[msg.sender] = 0;
202 
203         for (uint i = 0; i <= index[msg.sender]; i++) {
204             if (checkpoint[msg.sender] < finish[msg.sender][i]) {
205                 if (block.timestamp > finish[msg.sender][i]) {
206                     _payout = _payout.add((deposit[msg.sender][i].mul(getInterest()).div(100)).mul(finish[msg.sender][i].sub(checkpoint[msg.sender])).div(1 days));
207                 } else {
208                     _payout = _payout.add((deposit[msg.sender][i].mul(getInterest()).div(100)).mul(block.timestamp.sub(checkpoint[msg.sender])).div(1 days));
209                 }
210             }
211         }
212 
213         if (_payout > 0) {
214             checkpoint[msg.sender] = block.timestamp;
215             msg.sender.transfer(_payout);
216 
217             emit LogPayment(msg.sender, _payout);
218         }
219     }
220 
221     function getInfo1(address _address) public view returns(uint Invested) {
222         uint _sum;
223         for (uint i = 0; i <= index[_address]; i++) {
224             if (block.timestamp < finish[_address][i]) {
225                 _sum += deposit[_address][i];
226             }
227         }
228         Invested = _sum;
229     }
230 
231     function getInfo2(address _address, uint _number) public view returns(uint Deposit_N) {
232         if (block.timestamp < finish[_address][_number - 1]) {
233             Deposit_N = deposit[_address][_number - 1];
234         } else {
235             Deposit_N = 0;
236         }
237     }
238 
239     function getInfo3(address _address) public view returns(uint Dividends) {
240         uint _payout;
241         for (uint i = 0; i <= index[_address]; i++) {
242             if (checkpoint[_address] < finish[_address][i]) {
243                 if (block.timestamp > finish[_address][i]) {
244                     _payout = _payout.add((deposit[_address][i].mul(getInterest()).div(100)).mul(finish[_address][i].sub(checkpoint[_address])).div(1 days));
245                 } else {
246                     _payout = _payout.add((deposit[_address][i].mul(getInterest()).div(100)).mul(block.timestamp.sub(checkpoint[_address])).div(1 days));
247                 }
248             }
249         }
250         Dividends = _payout;
251     }
252 
253     function getInfo4(address _address) public view returns(uint Bonuses) {
254         Bonuses = refBonus[_address];
255     }
256 }