1 /**
2  *  https://Smart-234.io
3  *
4  * Smart-contract start at 11 Dec 2018 10:00 UTC
5  *
6  *
7  * Smart-234 Contract
8  *  - GAIN 2.34% PER 24 HOURS
9  *  -     +0.02% every day before the payment
10  *
11  *  - Minimal contribution 0.01 eth
12  *  - Currency and payment - ETH
13  *  - Contribution allocation schemes:
14  *    -- 96% payments
15  *    -- 4% Marketing
16  *
17  *
18  * You get MORE PROFIT if you withdraw later !
19  * Increase of the total rate of return by 0.02% every day before the payment.
20  * The increase in profitability affects all previous days!
21  *  After the dividend is paid, the rate of return is returned to 2.34 % per day
22  *
23  *           For example: if the Deposit is 10 ETH
24  *
25  *                days      |   %    |   profit
26  *          --------------------------------------
27  *            1 (>24 hours) | 2.36 % | 0.235 ETH
28  *              10          | 2.54 % | 2.54  ETH
29  *              30          | 2.94 % | 8.82  ETH
30  *              50          | 3.34 % | 16.7  ETH
31  *              100         | 4.34 % | 43.4  ETH
32  *
33  *
34  * How to use:
35  *  1. Send any amount of ether to make an investment
36  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
37  *  OR
38  *  2b. Send more ether to reinvest AND get your profit at the same time
39  *
40  * RECOMMENDED GAS LIMIT: 250000
41  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
42  *
43  * Contract reviewed and approved by experts!
44  *
45  */
46 
47 pragma solidity ^0.4.24;
48 
49 library SafeMath {
50 
51     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         if (_a == 0) {
53             return 0;
54         }
55 
56         uint256 c = _a * _b;
57         require(c / _a == _b);
58 
59         return c;
60     }
61 
62     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63         require(_b > 0);
64         uint256 c = _a / _b;
65 
66         return c;
67     }
68 
69     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
70         require(_b <= _a);
71         uint256 c = _a - _b;
72 
73         return c;
74     }
75 
76     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
77         uint256 c = _a + _b;
78         require(c >= _a);
79 
80         return c;
81     }
82 }
83 
84 contract InvestorsStorage {
85     using SafeMath for uint256;
86 
87     address private owner;
88     uint private _investorsCount;
89 
90     struct Deposit {
91         uint amount;
92         uint start;
93     }
94 
95     struct Investor {
96         Deposit[] deposits;
97         uint checkpoint;
98         address referrer;
99     }
100 
101     mapping (address => Investor) private investors;
102 
103     constructor() public {
104         owner = msg.sender;
105     }
106 
107     modifier onlyOwner() {
108         require(msg.sender == owner);
109         _;
110     }
111 
112     function addDeposit(address _address, uint _value) external onlyOwner {
113         investors[_address].deposits.push(Deposit(_value, block.timestamp));
114         if (investors[_address].checkpoint == 0) {
115             investors[_address].checkpoint = block.timestamp;
116             _investorsCount += 1;
117         }
118     }
119 
120     function updateCheckpoint(address _address) external onlyOwner {
121         investors[_address].checkpoint = block.timestamp;
122     }
123 
124     function addReferrer(address _referral, address _referrer) external onlyOwner {
125         investors[_referral].referrer = _referrer;
126     }
127 
128     function getInterest(address _address, uint _index, bool _exception) public view returns(uint) {
129         if (investors[_address].deposits[_index].amount > 0) {
130             if (_exception) {
131                 uint time = investors[_address].deposits[_index].start;
132             } else {
133                 time = investors[_address].checkpoint;
134             }
135             return(234 + ((block.timestamp - time) / 1 days) * 2);
136         }
137     }
138 
139     function isException(address _address, uint _index) public view returns(bool) {
140         if (investors[_address].deposits[_index].start > investors[_address].checkpoint) {
141             return true;
142         }
143     }
144 
145     function d(address _address, uint _index) public view returns(uint) {
146         return investors[_address].deposits[_index].amount;
147     }
148 
149     function c(address _address) public view returns(uint) {
150         return investors[_address].checkpoint;
151     }
152 
153     function r(address _address) external view returns(address) {
154         return investors[_address].referrer;
155     }
156 
157     function s(address _address, uint _index) public view returns(uint) {
158         return investors[_address].deposits[_index].start;
159     }
160 
161     function sumOfDeposits(address _address) external view returns(uint) {
162         uint sum;
163         for (uint i = 0; i < investors[_address].deposits.length; i++) {
164             sum += investors[_address].deposits[i].amount;
165         }
166         return sum;
167     }
168 
169     function amountOfDeposits(address _address) external view returns(uint) {
170         return investors[_address].deposits.length;
171     }
172 
173     function dividends(address _address) external view returns(uint) {
174         uint _payout;
175         uint percent = getInterest(_address, 0, false);
176 
177         for (uint i = 0; i < investors[_address].deposits.length; i++) {
178             if (!isException(_address, i)) {
179                 _payout += (d(_address, i).mul(percent).div(10000)).mul(block.timestamp.sub(c(_address))).div(1 days);
180             } else {
181                 _payout += (d(_address, i).mul(getInterest(_address, i, true)).div(10000)).mul(block.timestamp.sub(s(_address, i))).div(1 days);
182             }
183         }
184 
185         return _payout;
186     }
187 
188     function investorsCount() external view returns(uint) {
189         return _investorsCount;
190     }
191 }
192 
193 contract Smart234 {
194     using SafeMath for uint;
195 
196     address admin;
197     uint waveStartUp;
198 
199     uint invested;
200     uint payed;
201     uint startTime;
202 
203     event LogInvestment(address indexed _addr, uint _value, uint _bonus);
204     event LogIncome(address indexed _addr, uint _value);
205     event LogReferrerAdded(address indexed _investor, address indexed _referrer);
206     event LogRefBonus(address indexed _investor, address indexed _referrer, uint _amount, uint indexed _level);
207     event LogNewWave(uint _waveStartUp);
208 
209     InvestorsStorage private x;
210 
211     modifier notOnPause() {
212         require(waveStartUp <= block.timestamp);
213         _;
214     }
215 
216     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
217         assembly {
218             parsedReferrer := mload(add(_source,0x14))
219         }
220         return parsedReferrer;
221     }
222 
223     function addReferrer() internal returns(uint) {
224         address _referrer = bytesToAddress(bytes(msg.data));
225         if (_referrer != msg.sender) {
226             x.addReferrer(msg.sender, _referrer);
227             emit LogReferrerAdded(msg.sender, _referrer);
228             return(msg.value / 20);
229         }
230     }
231 
232     function refSystem() private {
233         address first = x.r(msg.sender);
234         if (x.amountOfDeposits(first) < 500) {
235             x.addDeposit(first, msg.value / 10);
236             emit LogRefBonus(msg.sender, first, msg.value / 10, 1);
237         }
238         address second = x.r(first);
239         if (second != 0x0) {
240             if (x.amountOfDeposits(second) < 500) {
241                 x.addDeposit(second, msg.value / 20);
242                 emit LogRefBonus(msg.sender, second, msg.value / 20, 2);
243             }
244             address third = x.r(second);
245             if (third != 0x0) {
246                 if (x.amountOfDeposits(third) < 500) {
247                     x.addDeposit(third, msg.value * 3 / 100);
248                     emit LogRefBonus(msg.sender, third, msg.value * 3 / 100, 3);
249                 }
250             }
251         }
252     }
253 
254     constructor(address _admin) public {
255         admin = _admin;
256         x = new InvestorsStorage();
257         startTime = now;
258         // waveStartUp = 1544522400;
259     }
260 
261     function() external payable {
262         if (msg.value == 0) {
263             withdraw();
264         } else {
265             invest();
266         }
267     }
268 
269     function invest() notOnPause public payable {
270         // require(msg.value >= 0.01 ether);
271         admin.transfer(msg.value / 25);
272 
273         if (x.r(msg.sender) != 0x0) {
274             refSystem();
275         } else if (msg.data.length == 20) {
276             uint bonus = addReferrer();
277             refSystem();
278         }
279 
280         x.addDeposit(msg.sender, msg.value + bonus);
281 
282         invested += msg.value;
283         emit LogInvestment(msg.sender, msg.value, bonus);
284     }
285 
286     function withdraw() public {
287 
288         uint _payout = x.dividends(msg.sender);
289 
290         if (_payout > 0) {
291 
292             if (_payout > address(this).balance) {
293                 nextWave();
294                 return;
295             }
296 
297             x.updateCheckpoint(msg.sender);
298             admin.transfer(_payout / 25);
299             msg.sender.transfer(_payout * 24 / 25);
300             emit LogIncome(msg.sender, _payout);
301             payed += _payout;
302         }
303     }
304 
305     function getDeposits(address _address) external view returns(uint) {
306         return x.sumOfDeposits(_address);
307     }
308 
309     function getDividends(address _address) external view returns(uint) {
310         return x.dividends(_address);
311     }
312 
313     function getDividendsWithFee(address _address) external view returns(uint) {
314         return x.dividends(_address) * 24 / 25;
315     }
316 
317     function getDaysAfterStart() external view returns(uint) {
318         return (block.timestamp.sub(startTime)) / 1 days;
319     }
320 
321     function investorsCount() external view returns(uint) {
322         return x.investorsCount();
323     }
324 
325     function getInvestedAmount() external view returns(uint) {
326         return invested;
327     }
328 
329     function getPayedAmount() external view returns(uint) {
330         return payed;
331     }
332 
333     function nextWave() private {
334         x = new InvestorsStorage();
335         invested = 0;
336         payed = 0;
337         waveStartUp = block.timestamp + 7 days;
338         emit LogNewWave(waveStartUp);
339     }
340 }