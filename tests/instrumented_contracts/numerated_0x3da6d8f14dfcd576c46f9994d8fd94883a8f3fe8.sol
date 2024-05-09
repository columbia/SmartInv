1 pragma solidity ^0.4.24;
2 
3 /**
4  *  https://Smart-Pyramid.io
5  *
6  * Smart-Pyramid Contract
7  *  - GAIN 1.23% PER 24 HOURS (every 5900 blocks)
8  *  - Minimal contribution 0.01 eth
9  *  - Currency and payment - ETH
10  *  - Contribution allocation schemes:
11  *    -- 84% payments
12  *    -- 16% Marketing + Operating Expenses
13  *
14  *
15  * You get MORE PROFIT if you withdraw later !
16  * Increase of the total rate of return by 0.01% every day before the payment.
17  * The increase in profitability affects all previous days!
18  *  After the dividend is paid, the rate of return is returned to 1.23 % per day
19  *
20  *           For example: if the Deposit is 10 ETH
21  * 
22  *                days      |   %    |   profit
23  *          --------------------------------------
24  *            1 (>24 hours) | 1.24 % | 0.124 ETH
25  *              10          | 1.33 % | 1.330 ETH
26  *              30          | 1.53 % | 4.590 ETH
27  *              50          | 1.73 % | 8.650 ETH
28  *              100         | 2.23 % | 22.30 ETH
29  *
30  *
31  * How to use:
32  *  1. Send any amount of ether to make an investment
33  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
34  *  OR
35  *  2b. Send more ether to reinvest AND get your profit at the same time
36  *
37  * RECOMMENDED GAS LIMIT: 200000
38  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
39  *
40  *
41  * Investors Contest rules
42  *
43  * Investor contest lasts a whole week
44  * The results of the competition are confirmed every MON not earlier than 13:00 MSK (10:00 UTC)
45  * According to the results, will be determined 3 winners, who during the week invested the maximum amounts
46  * in one payment.
47  * If two investors invest the same amount - the highest place in the competition is occupied by the one whose operation
48  *  was before
49  *
50  * Prizes:
51  * 1st place: 2 ETH
52  * 2nd place: 1 ETH
53  * 3rd place: 0.5 ETH
54  *
55  * On the offensive (10:00 UTC) on Monday, it is necessary to initiate the summing up of the competition.
56  * Until the results are announced - the competition is still on.
57  * To sum up the results, you need to call the PayDay function
58  *
59  *
60  * Contract reviewed and approved by experts!
61  *
62  */
63 
64 
65 library SafeMath {
66 
67     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
68         if (_a == 0) {
69             return 0;
70         }
71 
72         uint256 c = _a * _b;
73         require(c / _a == _b);
74 
75         return c;
76     }
77 
78     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
79         require(_b > 0);
80         uint256 c = _a / _b;
81 
82         return c;
83     }
84 
85     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
86         require(_b <= _a);
87         uint256 c = _a - _b;
88 
89         return c;
90     }
91 
92     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
93         uint256 c = _a + _b;
94         require(c >= _a);
95 
96         return c;
97     }
98 
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0);
101         return a % b;
102     }
103 }
104 
105 contract InvestorsStorage {
106     address private owner;
107 
108     mapping (address => Investor) private investors;
109 
110     struct Investor {
111         uint deposit;
112         uint checkpoint;
113         address referrer;
114     }
115 
116     constructor() public {
117         owner = msg.sender;
118     }
119 
120     modifier onlyOwner() {
121         require(msg.sender == owner);
122         _;
123     }
124 
125     function updateInfo(address _address, uint _value) external onlyOwner {
126         investors[_address].deposit += _value;
127         investors[_address].checkpoint = block.timestamp;
128     }
129 
130     function updateCheckpoint(address _address) external onlyOwner {
131         investors[_address].checkpoint = block.timestamp;
132     }
133 
134     function addReferrer(address _referral, address _referrer) external onlyOwner {
135         investors[_referral].referrer = _referrer;
136     }
137 
138     function getInterest(address _address) external view returns(uint) {
139         if (investors[_address].deposit > 0) {
140             return(123 + ((block.timestamp - investors[_address].checkpoint) / 1 days));
141         }
142     }
143 
144     function d(address _address) external view returns(uint) {
145         return investors[_address].deposit;
146     }
147 
148     function c(address _address) external view returns(uint) {
149         return investors[_address].checkpoint;
150     }
151 
152     function r(address _address) external view returns(address) {
153         return investors[_address].referrer;
154     }
155 }
156 
157 contract SmartPyramid {
158     using SafeMath for uint;
159 
160     address admin;
161     uint waveStartUp;
162     uint nextPayDay;
163 
164     mapping (uint => Leader) top;
165 
166     event LogInvestment(address indexed _addr, uint _value);
167     event LogIncome(address indexed _addr, uint _value, string indexed _type);
168     event LogReferralInvestment(address indexed _referrer, address indexed _referral, uint _value);
169     event LogGift(address _firstAddr, uint _firstDep, address _secondAddr, uint _secondDep, address _thirdAddr, uint _thirdDep);
170     event LogNewWave(uint _waveStartUp);
171 
172     InvestorsStorage private x;
173 
174     modifier notOnPause() {
175         require(waveStartUp <= block.timestamp);
176         _;
177     }
178 
179     struct Leader {
180         address addr;
181         uint deposit;
182     }
183 
184     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
185         assembly {
186             parsedReferrer := mload(add(_source,0x14))
187         }
188         return parsedReferrer;
189     }
190 
191     function addReferrer(uint _value) internal {
192         address _referrer = bytesToAddress(bytes(msg.data));
193         if (_referrer != msg.sender) {
194             x.addReferrer(msg.sender, _referrer);
195             x.r(msg.sender).transfer(_value / 20);
196             emit LogReferralInvestment(_referrer, msg.sender, _value);
197             emit LogIncome(_referrer, _value / 20, "referral");
198         }
199     }
200 
201     constructor(address _admin) public {
202         admin = _admin;
203         x = new InvestorsStorage();
204     }
205 
206     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
207         deposit = x.d(_address);
208         if (block.timestamp >= x.c(_address) + 10 minutes) {
209             amountToWithdraw = (x.d(_address).mul(x.getInterest(_address)).div(10000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);
210         } else {
211             amountToWithdraw = 0;
212         }
213     }
214 
215     function getTop() external view returns(address, uint, address, uint, address, uint) {
216         return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
217     }
218 
219     function() external payable {
220         if (msg.value == 0) {
221             withdraw();
222         } else {
223             invest();
224         }
225     }
226 
227     function invest() notOnPause public payable {
228 
229         admin.transfer(msg.value * 4 / 25);
230 
231         if (x.d(msg.sender) > 0) {
232             withdraw();
233         }
234 
235         x.updateInfo(msg.sender, msg.value);
236 
237         if (msg.value > top[3].deposit) {
238             toTheTop();
239         }
240 
241         if (x.r(msg.sender) != 0x0) {
242             x.r(msg.sender).transfer(msg.value / 20);
243             emit LogReferralInvestment(x.r(msg.sender), msg.sender, msg.value);
244             emit LogIncome(x.r(msg.sender), msg.value / 20, "referral");
245         } else if (msg.data.length == 20) {
246             addReferrer(msg.value);
247         }
248 
249         emit LogInvestment(msg.sender, msg.value);
250     }
251 
252 
253     function withdraw() notOnPause public {
254 
255         if (block.timestamp >= x.c(msg.sender) + 10 minutes) {
256             uint _payout = (x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);
257             x.updateCheckpoint(msg.sender);
258         }
259 
260         if (_payout > 0) {
261 
262             if (_payout > address(this).balance) {
263                 nextWave();
264                 return;
265             }
266 
267             msg.sender.transfer(_payout);
268             emit LogIncome(msg.sender, _payout, "withdrawn");
269         }
270     }
271 
272     function toTheTop() internal {
273         if (msg.value <= top[2].deposit) {
274             top[3] = Leader(msg.sender, msg.value);
275         } else {
276             if (msg.value <= top[1].deposit) {
277                 top[3] = top[2];
278                 top[2] = Leader(msg.sender, msg.value);
279             } else {
280                 top[3] = top[2];
281                 top[2] = top[1];
282                 top[1] = Leader(msg.sender, msg.value);
283             }
284         }
285     }
286 
287     function payDay() external {
288         require(block.timestamp >= nextPayDay);
289         nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);
290 
291         emit LogGift(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
292 
293         for (uint i = 0; i <= 2; i++) {
294             if (top[i+1].addr != 0x0) {
295                 top[i+1].addr.transfer(2 ether / 2 ** i);
296                 top[i+1] = Leader(0x0, 0);
297             }
298         }
299     }
300 
301     function nextWave() private {
302         for (uint i = 0; i <= 2; i++) {
303             top[i+1] = Leader(0x0, 0);
304         }
305         x = new InvestorsStorage();
306         waveStartUp = block.timestamp + 7 days;
307         emit LogNewWave(waveStartUp);
308     }
309 }