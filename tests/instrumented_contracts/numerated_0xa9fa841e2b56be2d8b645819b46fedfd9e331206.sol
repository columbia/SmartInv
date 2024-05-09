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
15  * The later widthdrow - the MORE PROFIT !
16  * Increase of the total rate of return by 0.01% every day before the payment.
17  * The increase in profitability affects all previous days!
18  *  After the dividend is paid, the rate of return is returned to 1.23 % per day
19  *
20  *           For example: if the Deposit is 10 ETH
21  *                days      |   %    |   profit
22  *          --------------------------------------
23  *            1 (>24 hours) | 1.24 % | 0.124 ETH
24  *              10          | 1.33 % | 1.330 ETH
25  *              30          | 1.53 % | 4.590 ETH
26  *              50          | 1.73 % | 8.650 ETH
27  *              100         | 2.23 % | 22.30 ETH
28  *
29  *
30  * How to use:
31  *  1. Send any amount of ether to make an investment
32  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
33  *  OR
34  *  2b. Send more ether to reinvest AND get your profit at the same time
35  *
36  * RECOMMENDED GAS LIMIT: 200000
37  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
38  *
39  *
40  * Investors Contest rules
41  *
42  * Investor contest lasts a whole week
43  * The results of the competition are confirmed every MON not earlier than 13:00 MSK (10:00 UTC)
44  * According to the results, will be determined 3 winners, who during the week invested the maximum amounts
45  * in one payment.
46  * If two investors invest the same amount - the highest place in the competition is occupied by the one whose operation
47  *  was before
48  *
49  * Prizes:
50  * 1st place: 2 ETH
51  * 2nd place: 1 ETH
52  * 3rd place: 0.5 ETH
53  *
54  * On the offensive (10:00 UTC) on Monday, it is necessary to initiate the summing up of the competition.
55  * Until the results are announced - the competition is still on.
56  * To sum up the results, you need to call the PayDay function
57  *
58  *
59  * Contract reviewed and approved by experts!
60  *
61  */
62 
63 
64 library SafeMath {
65 
66     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
67         if (_a == 0) {
68             return 0;
69         }
70 
71         uint256 c = _a * _b;
72         require(c / _a == _b);
73 
74         return c;
75     }
76 
77     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
78         require(_b > 0);
79         uint256 c = _a / _b;
80 
81         return c;
82     }
83 
84     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
85         require(_b <= _a);
86         uint256 c = _a - _b;
87 
88         return c;
89     }
90 
91     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
92         uint256 c = _a + _b;
93         require(c >= _a);
94 
95         return c;
96     }
97 
98     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99         require(b != 0);
100         return a % b;
101     }
102 }
103 
104 contract InvestorsStorage {
105     address private owner;
106 
107     mapping (address => Investor) private investors;
108 
109     struct Investor {
110         uint deposit;
111         uint checkpoint;
112         address referrer;
113     }
114 
115     constructor() public {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner() {
120         require(msg.sender == owner);
121         _;
122     }
123 
124     function updateInfo(address _address, uint _value) external onlyOwner {
125         investors[_address].deposit += _value;
126         investors[_address].checkpoint = block.timestamp;
127     }
128 
129     function updateCheckpoint(address _address) external onlyOwner {
130         investors[_address].checkpoint = block.timestamp;
131     }
132 
133     function addReferrer(address _referral, address _referrer) external onlyOwner {
134         investors[_referral].referrer = _referrer;
135     }
136 
137     function getInterest(address _address) external view returns(uint) {
138         if (investors[_address].deposit > 0) {
139             return(123 + ((block.timestamp - investors[_address].checkpoint) / 1 days));
140         }
141     }
142 
143     function d(address _address) external view returns(uint) {
144         return investors[_address].deposit;
145     }
146 
147     function c(address _address) external view returns(uint) {
148         return investors[_address].checkpoint;
149     }
150 
151     function r(address _address) external view returns(address) {
152         return investors[_address].referrer;
153     }
154 }
155 
156 contract SmartPyramid {
157     using SafeMath for uint;
158 
159     address admin;
160     uint waveStartUp;
161     uint nextPayDay;
162 
163     mapping (uint => Leader) top;
164 
165     event LogInvestment(address _addr, uint _value);
166     event LogIncome(address _addr, uint _value, string _type);
167     event LogReferralInvestment(address _referrer, address _referral, uint _value);
168     event LogGift(address _firstAddr, uint _firstDep, address _secondAddr, uint _secondDep, address _thirdAddr, uint _thirdDep);
169     event LogNewWave(uint _waveStartUp);
170 
171     InvestorsStorage private x;
172 
173     modifier notOnPause() {
174         require(waveStartUp <= block.timestamp);
175         _;
176     }
177 
178     struct Leader {
179         address addr;
180         uint deposit;
181     }
182 
183     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
184         assembly {
185             parsedReferrer := mload(add(_source,0x14))
186         }
187         return parsedReferrer;
188     }
189 
190     function addReferrer(uint _value) internal {
191         address _referrer = bytesToAddress(bytes(msg.data));
192         if (_referrer != msg.sender) {
193             x.addReferrer(msg.sender, _referrer);
194             x.r(msg.sender).transfer(_value / 20);
195             emit LogReferralInvestment(_referrer, msg.sender, _value);
196             emit LogIncome(_referrer, _value / 20, "referral");
197         }
198     }
199 
200     constructor(address _admin) public {
201         admin = _admin;
202         x = new InvestorsStorage();
203     }
204 
205     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
206         deposit = x.d(_address);
207         if (block.timestamp >= x.c(_address) + 10 minutes) {
208             amountToWithdraw = (x.d(_address).mul(x.getInterest(_address)).div(10000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);
209         } else {
210             amountToWithdraw = 0;
211         }
212     }
213 
214     function getTop() external view returns(address, uint, address, uint, address, uint) {
215         return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
216     }
217 
218     function() external payable {
219         if (msg.value == 0) {
220             withdraw();
221         } else {
222             invest();
223         }
224     }
225 
226     function invest() notOnPause public payable {
227 
228         admin.transfer(msg.value * 4 / 25);
229 
230         if (x.d(msg.sender) > 0) {
231             withdraw();
232         }
233 
234         x.updateInfo(msg.sender, msg.value);
235 
236         if (msg.value > top[3].deposit) {
237             toTheTop();
238         }
239 
240         if (x.r(msg.sender) != 0x0) {
241             x.r(msg.sender).transfer(msg.value / 20);
242             emit LogReferralInvestment(x.r(msg.sender), msg.sender, msg.value);
243             emit LogIncome(x.r(msg.sender), msg.value / 20, "referral");
244         } else if (msg.data.length == 20) {
245             addReferrer(msg.value);
246         }
247 
248         emit LogInvestment(msg.sender, msg.value);
249     }
250 
251 
252     function withdraw() notOnPause public {
253 
254         if (block.timestamp >= x.c(msg.sender) + 10 minutes) {
255             uint _payout = (x.d(msg.sender).mul(x.getInterest(msg.sender)).div(10000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);
256             x.updateCheckpoint(msg.sender);
257         }
258 
259         if (_payout > 0) {
260 
261             if (_payout > address(this).balance) {
262                 nextWave();
263                 return;
264             }
265 
266             msg.sender.transfer(_payout);
267             emit LogIncome(msg.sender, _payout, "withdrawn");
268         }
269     }
270 
271     function toTheTop() internal {
272         if (msg.value <= top[2].deposit) {
273             top[3] = Leader(msg.sender, msg.value);
274         } else {
275             if (msg.value <= top[1].deposit) {
276                 top[3] = top[2];
277                 top[2] = Leader(msg.sender, msg.value);
278             } else {
279                 top[3] = top[2];
280                 top[2] = top[1];
281                 top[1] = Leader(msg.sender, msg.value);
282             }
283         }
284     }
285 
286     function payDay() external {
287         require(block.timestamp >= nextPayDay);
288         nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);
289 
290         emit LogGift(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
291 
292         for (uint i = 0; i <= 2; i++) {
293             if (top[i+1].addr != 0x0) {
294                 top[i+1].addr.transfer(2 ether / 2 ** i);
295                 top[i+1] = Leader(0x0, 0);
296             }
297         }
298     }
299 
300     function nextWave() private {
301         for (uint i = 0; i <= 2; i++) {
302             top[i+1] = Leader(0x0, 0);
303         }
304         x = new InvestorsStorage();
305         waveStartUp = block.timestamp + 7 days;
306         emit LogNewWave(waveStartUp);
307     }
308 }