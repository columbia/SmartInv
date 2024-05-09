1 /**
2  * @title The MORIART ROUND 2 contracts concept.
3  * @author www.grox.solutions
4  */
5 
6 pragma solidity 0.5.10;
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14 
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b > 0);
23         uint256 c = a / b;
24 
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         require(b <= a);
30         uint256 c = a - b;
31 
32         return c;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 }
42 
43 contract MORIART_2 {
44     using SafeMath for uint256;
45 
46     uint256 constant public ONE_HUNDRED   = 10000;
47     uint256 constant public ENTER_FEE     = 1000;
48     uint256 constant public FINAL_WAVE    = 1500;
49     uint256 constant public ONE_DAY       = 1 days;
50     uint256 constant public MINIMUM       = 0.1 ether;
51     uint16[5] public refPercent           = [400, 300, 200, 100, 0];
52     uint256 public EXIT_FEE_1             = 1000;
53     uint256 public EXIT_FEE_2             = 2000;
54 
55     uint256 constant public REF_TRIGGER   = 0 ether;
56     uint256 constant public REIN_TRIGGER  = 0.00000333 ether;
57     uint256 constant public EXIT_TRIGGER  = 0.00000777 ether;
58 
59     struct Deposit {
60         uint256 amount;
61         uint256 time;
62     }
63 
64     struct User {
65         Deposit[] deposits;
66         address referrer;
67         uint256 bonus;
68     }
69 
70     mapping (address => User) public users;
71 
72     address payable public admin = 0x9C14a7882f635acebbC7f0EfFC0E2b78B9Aa4858;
73 
74     uint256 public maxBalance;
75 
76     uint256 public start = 1584662400;
77 
78     mapping (uint256 => int256) week;
79     uint256 period = 7 days;
80 
81     bool public finalized;
82 
83     event InvestorAdded(address indexed investor);
84     event ReferrerAdded(address indexed investor, address indexed referrer);
85     event DepositAdded(address indexed investor, uint256 amount);
86     event Withdrawn(address indexed investor, uint256 amount);
87     event RefBonusAdded(address indexed investor, address indexed referrer, uint256 amount, uint256 indexed level);
88     event RefBonusPayed(address indexed investor, uint256 amount);
89     event Reinvested(address indexed investor, uint256 amount);
90     event Finalized(uint256 amount);
91     event GasRefund(uint256 amount);
92 
93     modifier notOnPause() {
94         require(block.timestamp >= start && !finalized);
95         _;
96     }
97 
98     function() external payable {
99         if (msg.value == REF_TRIGGER) {
100             withdrawBonus();
101         } else if (msg.value == EXIT_TRIGGER) {
102             msg.sender.transfer(msg.value);
103             exit();
104         } else if (msg.value == REIN_TRIGGER) {
105             msg.sender.transfer(msg.value);
106             reinvest();
107         } else {
108             invest();
109         }
110     }
111 
112     function invest() public payable notOnPause {
113         require(msg.value >= MINIMUM);
114         admin.transfer(msg.value * ENTER_FEE / ONE_HUNDRED);
115 
116         users[msg.sender].deposits.push(Deposit(msg.value, block.timestamp));
117 
118         if (users[msg.sender].referrer != address(0)) {
119             _refSystem(msg.sender);
120         } else if (msg.data.length == 20) {
121             _addReferrer(msg.sender, _bytesToAddress(bytes(msg.data)));
122         }
123 
124         if (users[msg.sender].deposits.length == 1) {
125             emit InvestorAdded(msg.sender);
126         }
127 
128         if (address(this).balance > maxBalance) {
129             maxBalance = address(this).balance;
130         }
131 
132         week[_getIndex()] += int256(msg.value);
133 
134         emit DepositAdded(msg.sender, msg.value);
135     }
136 
137     function reinvest() public notOnPause {
138 
139         uint256 deposit = getDeposits(msg.sender);
140         uint256 compensation = 70000 * tx.gasprice;
141         uint256 profit = getProfit(msg.sender).add(getRefBonus(msg.sender));
142         uint256 amount = profit.sub(compensation);
143 
144         delete users[msg.sender].deposits;
145         if (users[msg.sender].bonus > 0) {
146             users[msg.sender].bonus = 0;
147         }
148 
149         users[msg.sender].deposits.push(Deposit(deposit + amount, block.timestamp));
150 
151         emit Reinvested(msg.sender, amount);
152 
153         _refund(compensation);
154 
155     }
156 
157     function reinvestProfit() public notOnPause {
158 
159         uint256 deposit = getDeposits(msg.sender);
160         uint256 compensation = 70000 * tx.gasprice;
161         uint256 profit = getProfit(msg.sender);
162         uint256 amount = profit.sub(compensation);
163 
164         delete users[msg.sender].deposits;
165 
166         users[msg.sender].deposits.push(Deposit(deposit + amount, block.timestamp));
167 
168         emit Reinvested(msg.sender, amount);
169 
170         _refund(compensation);
171 
172     }
173 
174     function reinvestBonus() public notOnPause {
175 
176         uint256 compensation = 70000 * tx.gasprice;
177         uint256 bonus = getRefBonus(msg.sender);
178         uint256 amount = bonus.sub(compensation);
179 
180         users[msg.sender].bonus = 0;
181 
182         users[msg.sender].deposits.push(Deposit(amount, block.timestamp));
183 
184         emit Reinvested(msg.sender, amount);
185 
186         _refund(compensation);
187 
188     }
189 
190     function withdrawBonus() public {
191         uint256 payout = getRefBonus(msg.sender);
192 
193         require(payout > 0);
194 
195         users[msg.sender].bonus = 0;
196 
197         bool onFinalizing;
198         if (payout > _getFinalWave()) {
199             payout = _getFinalWave();
200             onFinalizing = true;
201         }
202 
203         msg.sender.transfer(payout);
204 
205         week[_getIndex()] -= int256(payout);
206 
207         emit RefBonusPayed(msg.sender, payout);
208 
209         if (onFinalizing) {
210             _finalize();
211         }
212 
213     }
214 
215     function withdrawProfit() public {
216         uint256 payout = getProfit(msg.sender);
217 
218         require(payout > 0);
219 
220         for (uint256 i = 0; i < users[msg.sender].deposits.length; i++) {
221             users[msg.sender].deposits[i].time = block.timestamp;
222         }
223 
224         bool onFinalizing;
225         if (payout > _getFinalWave()) {
226             payout = _getFinalWave();
227             onFinalizing = true;
228         }
229 
230         msg.sender.transfer(payout);
231 
232         week[_getIndex()] -= int256(payout);
233 
234         emit Withdrawn(msg.sender, payout);
235 
236         if (onFinalizing) {
237             _finalize();
238         }
239 
240     }
241 
242     function exit() public {
243         require(block.timestamp >= start + period);
244 
245         uint256 deposit = getDeposits(msg.sender);
246         uint256 fee = getFee(msg.sender);
247         uint256 sum = deposit.add(getProfit(msg.sender)).add(getRefBonus(msg.sender));
248         uint256 payout = sum.sub(fee);
249 
250         require(payout >= MINIMUM);
251 
252         bool onFinalizing;
253         if (sum > _getFinalWave()) {
254             payout = _getFinalWave();
255             onFinalizing = true;
256         } else {
257             admin.transfer(fee);
258         }
259 
260         delete users[msg.sender];
261 
262         msg.sender.transfer(payout);
263 
264         week[_getIndex()] -= int256(payout);
265 
266         emit Withdrawn(msg.sender, payout);
267 
268         if (onFinalizing) {
269             _finalize();
270         }
271     }
272 
273     function setRefPercent(uint16[5] memory newRefPercents) public {
274         require(msg.sender == admin);
275         for (uint256 i = 0; i < 5; i++) {
276             require(newRefPercents[i] <= 1000);
277         }
278         refPercent = newRefPercents;
279     }
280 
281     function setExitFee(uint256 fee_1, uint256 fee_2) public {
282         require(msg.sender == admin);
283         require(fee_1 <= 3000 && fee_2 <= 3000);
284         EXIT_FEE_1 = fee_1;
285         EXIT_FEE_2 = fee_2;
286     }
287 
288     function _bytesToAddress(bytes memory source) internal pure returns(address parsedReferrer) {
289         assembly {
290             parsedReferrer := mload(add(source,0x14))
291         }
292         return parsedReferrer;
293     }
294 
295     function _addReferrer(address addr, address refAddr) internal {
296         if (refAddr != addr) {
297             users[addr].referrer = refAddr;
298 
299             _refSystem(addr);
300             emit ReferrerAdded(addr, refAddr);
301         }
302     }
303 
304     function _refSystem(address addr) internal {
305         address referrer = users[addr].referrer;
306 
307         for (uint256 i = 0; i < 5; i++) {
308             if (referrer != address(0)) {
309                 uint256 amount = msg.value * refPercent[i] / ONE_HUNDRED;
310                 users[referrer].bonus += amount;
311                 emit RefBonusAdded(addr, referrer, amount, i + 1);
312                 referrer = users[referrer].referrer;
313             } else break;
314         }
315     }
316 
317     function _refund(uint256 amount) internal {
318         if (msg.sender.send(amount)) {
319             emit GasRefund(amount);
320         }
321     }
322 
323     function _finalize() internal {
324         emit Finalized(address(this).balance);
325         admin.transfer(address(this).balance);
326         finalized = true;
327     }
328 
329     function _getFinalWave() internal view returns(uint256) {
330         if (address(this).balance > maxBalance * FINAL_WAVE / ONE_HUNDRED) {
331             return address(this).balance.sub(maxBalance * FINAL_WAVE / ONE_HUNDRED);
332         }
333     }
334 
335     function _getIndex() internal view returns(uint256) {
336         if (block.timestamp >= start) {
337             return (block.timestamp.sub(start)).div(period);
338         }
339     }
340 
341     function getPercent() public view returns(uint256) {
342         if (block.timestamp >= start) {
343 
344             uint256 count;
345             uint256 idx = _getIndex();
346 
347             for (uint256 i = 0; i < idx; i++) {
348                 if (week[i] >= int256(2 ether * (15**count) / (10**count))) {
349                     count++;
350                 }
351             }
352 
353             return 50e18 + 10e18 * count + 10e18 * (block.timestamp - (start + period * idx)) / period;
354         }
355     }
356 
357     function getAvailable(address addr) public view returns(uint256) {
358         if (users[addr].deposits.length != 0) {
359             uint256 deposit = getDeposits(addr);
360 
361             uint256 fee = getFee(addr);
362 
363             uint256 payout = deposit - fee + getProfit(addr) + getRefBonus(addr);
364 
365             return payout;
366         }
367     }
368 
369     function getFee(address addr) public view returns(uint256) {
370         if (users[addr].deposits.length != 0) {
371             uint256 deposit = getDeposits(addr);
372 
373             uint256 fee;
374             if (block.timestamp - users[addr].deposits[users[addr].deposits.length - 1].time < 30 * ONE_DAY) {
375                 fee = deposit * EXIT_FEE_2 / ONE_HUNDRED;
376             } else {
377                 fee = deposit * EXIT_FEE_1 / ONE_HUNDRED;
378             }
379 
380             return fee;
381         }
382     }
383 
384     function getDeposits(address addr) public view returns(uint256) {
385         uint256 sum;
386 
387         for (uint256 i = 0; i < users[addr].deposits.length; i++) {
388             sum += users[addr].deposits[i].amount;
389         }
390 
391         return sum;
392     }
393 
394     function getDeposit(address addr, uint256 index) public view returns(uint256) {
395         return users[addr].deposits[index].amount;
396     }
397 
398     function getProfit(address addr) public view returns(uint256) {
399         if (users[addr].deposits.length != 0) {
400             uint256 payout;
401             uint256 percent = getPercent();
402 
403             for (uint256 i = 0; i < users[addr].deposits.length; i++) {
404                 payout += (users[addr].deposits[i].amount * percent / 1e22) * (block.timestamp - users[addr].deposits[i].time) / ONE_DAY;
405             }
406 
407             return payout;
408         }
409     }
410 
411     function getRefBonus(address addr) public view returns(uint256) {
412         return users[addr].bonus;
413     }
414 
415     function getNextDate() public view returns(uint256) {
416         return(start + ((_getIndex() + 1) * period));
417     }
418 
419     function getCurrentTurnover() public view returns(int256) {
420         return week[_getIndex()];
421     }
422 
423     function getTurnover(uint256 index) public view returns(int256) {
424         return week[index];
425     }
426 
427     function getCurrentGoal() public view returns(int256) {
428         if (block.timestamp >= start) {
429             uint256 count;
430             uint256 idx = _getIndex();
431 
432             for (uint256 i = 0; i < idx; i++) {
433                 if (week[i] >= int256(2 ether * (15**count) / (10**count))) {
434                     count++;
435                 }
436             }
437 
438             return int256(2 ether * (15**count) / (10**count));
439         }
440     }
441 
442     function getBalance() public view returns(uint256) {
443         return address(this).balance;
444     }
445 
446 }