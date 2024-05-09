1 pragma solidity ^0.4.24;
2 
3 /**
4  *  https://Smart-Pyramid.io
5  *
6  * Smart-Pyramid Contract
7  *  - GAIN 1.2% PER 24 HOURS (every 5900 blocks)
8  *  - Minimal contribution 0.01 eth
9  *  - Currency and payment - ETH
10  *  - Contribution allocation schemes:
11  *    -- 84% payments
12  *    -- 16% Marketing + Operating Expenses
13  *
14  * How to use:
15  *  1. Send any amount of ether to make an investment
16  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
17  *  OR
18  *  2b. Send more ether to reinvest AND get your profit at the same time
19  *
20  * RECOMMENDED GAS LIMIT: 200000
21  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
22  *
23  *Investors Contest rules
24  *
25  * Investor contest lasts a whole week
26  * The results of the competition are confirmed every MON not earlier than 13:00 MSK (10:00 UTC)
27  * According to the results, will be determined 3 winners, who during the week invested the maximum amounts
28  * in one payment.
29  * If two investors invest the same amount - the highest place in the competition is occupied by the one whose operation
30  *  was before
31  *
32  * Prizes:
33  * 1st place: 2 ETH
34  * 2nd place: 1 ETH
35  * 3rd place: 0.5 ETH
36  *
37  * On the offensive (10:00 UTC) on Monday, it is necessary to initiate the summing up of the competition.
38  * Until the results are announced - the competition is still on.
39  * To sum up the results, you need to call the PayDay function
40  *
41  *
42  * Contract reviewed and approved by experts!
43  *
44  */
45 
46 
47 library SafeMath {
48 
49     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
50         if (_a == 0) {
51             return 0;
52         }
53 
54         uint256 c = _a * _b;
55         require(c / _a == _b);
56 
57         return c;
58     }
59 
60     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
61         require(_b > 0);
62         uint256 c = _a / _b;
63 
64         return c;
65     }
66 
67     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
68         require(_b <= _a);
69         uint256 c = _a - _b;
70 
71         return c;
72     }
73 
74     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
75         uint256 c = _a + _b;
76         require(c >= _a);
77 
78         return c;
79     }
80 
81     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b != 0);
83         return a % b;
84     }
85 }
86 
87 contract InvestorsStorage {
88     address private owner;
89 
90     mapping (address => Investor) private investors;
91 
92     struct Investor {
93         uint deposit;
94         uint checkpoint;
95         address referrer;
96     }
97 
98     constructor() public {
99         owner = msg.sender;
100     }
101 
102     modifier onlyOwner() {
103         require(msg.sender == owner);
104         _;
105     }
106 
107     function updateInfo(address _address, uint _value) external onlyOwner {
108         investors[_address].deposit += _value;
109         investors[_address].checkpoint = block.timestamp;
110     }
111 
112     function updateCheckpoint(address _address) external onlyOwner {
113         investors[_address].checkpoint = block.timestamp;
114     }
115 
116     function addReferrer(address _referral, address _referrer) external onlyOwner {
117         investors[_referral].referrer = _referrer;
118     }
119 
120     function d(address _address) external view onlyOwner returns(uint) {
121         return investors[_address].deposit;
122     }
123 
124     function c(address _address) external view onlyOwner returns(uint) {
125         return investors[_address].checkpoint;
126     }
127 
128     function r(address _address) external view onlyOwner returns(address) {
129         return investors[_address].referrer;
130     }
131 }
132 
133 contract SmartPyramid {
134     using SafeMath for uint;
135 
136     address public owner;
137     address fee_address;
138     
139     uint waveStartUp;
140     uint nextPayDay;
141 
142     mapping (uint => Leader) top;
143 
144     event LogInvestment(address _addr, uint _value);
145     event LogPayment(address _addr, uint _value);
146     event LogNewReferrer(address _referral, address _referrer);
147     event LogReferralInvestment(address _referral, uint _value);
148     event LogGift(address _first, address _second, address _third);
149     event LogNewWave(uint _waveStartUp);
150 
151     InvestorsStorage private x;
152 
153     modifier notOnPause() {
154         require(waveStartUp <= block.timestamp);
155         _;
156     }
157 
158     struct Leader {
159         address addr;
160         uint deposit;
161     }
162 
163     function renounceOwnership() external {
164         require(msg.sender == owner);
165         owner = 0x0;
166     }
167 
168     function bytesToAddress(bytes _source) internal pure returns(address parsedReferrer) {
169         assembly {
170             parsedReferrer := mload(add(_source,0x14))
171         }
172         return parsedReferrer;
173     }
174 
175     function addReferrer(uint _value) internal {
176         address _referrer = bytesToAddress(bytes(msg.data));
177         if (_referrer != msg.sender) {
178             x.addReferrer(msg.sender, _referrer);
179             x.r(msg.sender).transfer(_value / 20);
180             emit LogNewReferrer(msg.sender, _referrer);
181             emit LogReferralInvestment(msg.sender, _value);
182         }
183     }
184 
185     constructor(address _fee_address) public {
186         owner = msg.sender;
187         fee_address = _fee_address;
188         x = new InvestorsStorage();
189     }
190 
191     function getInfo(address _address) external view returns(uint deposit, uint amountToWithdraw) {
192         deposit = x.d(_address);
193         if (block.timestamp >= x.c(_address) + 10 minutes) {
194             amountToWithdraw = (x.d(_address).mul(12).div(1000)).mul(block.timestamp.sub(x.c(_address))).div(1 days);
195         } else {
196             amountToWithdraw = 0;
197         }
198     }
199 
200     function getTop() external view returns(address, uint, address, uint, address, uint) {
201         return(top[1].addr, top[1].deposit, top[2].addr, top[2].deposit, top[3].addr, top[3].deposit);
202     }
203 
204     function() external payable {
205         if (msg.value == 0) {
206             withdraw();
207         } else {
208             invest();
209         }
210     }
211 
212     function invest() notOnPause public payable {
213 
214         fee_address.transfer(msg.value * 16 / 100);
215 
216         if (x.d(msg.sender) > 0) {
217             withdraw();
218         }
219 
220         x.updateInfo(msg.sender, msg.value);
221 
222         if (msg.value > top[3].deposit) {
223             toTheTop();
224         }
225 
226         if (x.r(msg.sender) != 0x0) {
227             x.r(msg.sender).transfer(msg.value / 20);
228             emit LogReferralInvestment(msg.sender, msg.value);
229         } else if (msg.data.length == 20) {
230             addReferrer(msg.value);
231         }
232 
233         emit LogInvestment(msg.sender, msg.value);
234     }
235 
236 
237     function withdraw() notOnPause public {
238 
239         if (block.timestamp >= x.c(msg.sender) + 10 minutes) {
240             uint _payout = (x.d(msg.sender).mul(12).div(1000)).mul(block.timestamp.sub(x.c(msg.sender))).div(1 days);
241             x.updateCheckpoint(msg.sender);
242         }
243 
244         if (_payout > 0) {
245 
246             if (_payout > address(this).balance) {
247                 nextWave();
248                 return;
249             }
250 
251             msg.sender.transfer(_payout);
252             emit LogPayment(msg.sender, _payout);
253         }
254     }
255 
256     function toTheTop() internal {
257         if (msg.value <= top[2].deposit) {
258             top[3] = Leader(msg.sender, msg.value);
259         } else {
260             if (msg.value <= top[1].deposit) {
261                 top[3] = top[2];
262                 top[2] = Leader(msg.sender, msg.value);
263             } else {
264                 top[3] = top[2];
265                 top[2] = top[1];
266                 top[1] = Leader(msg.sender, msg.value);
267             }
268         }
269     }
270 
271     function payDay() external {
272         require(block.timestamp >= nextPayDay);
273         nextPayDay = block.timestamp.sub((block.timestamp - 1538388000).mod(7 days)).add(7 days);
274         emit LogGift(top[1].addr, top[2].addr, top[3].addr);
275         for (uint i = 0; i <= 2; i++) {
276             top[i+1].addr.transfer(2 ether / 2 ** i);
277             top[i+1] = Leader(0x0, 0);
278         }
279     }
280 
281     function nextWave() private {
282         for (uint i = 0; i <= 2; i++) {
283             top[i+1] = Leader(0x0, 0);
284         }
285         x = new InvestorsStorage();
286         waveStartUp = block.timestamp + 7 days;
287         emit LogNewWave(waveStartUp);
288     }
289 }